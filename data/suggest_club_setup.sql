SET search_path = public;

WITH dupes AS (
    SELECT  clubid,
            bookid,
            ROW_NUMBER() OVER (
                PARTITION BY clubid
                ORDER BY end_date DESC NULLS LAST, start_date DESC NULLS LAST, bookid
            ) AS rn
    FROM    bookclub_reads
    WHERE   is_current = TRUE
)
UPDATE bookclub_reads b
SET    is_current = FALSE
FROM   dupes d
WHERE  b.clubid = d.clubid
  AND  b.bookid = d.bookid
  AND  d.rn > 1;

DROP INDEX IF EXISTS one_current_book_per_club;
CREATE UNIQUE INDEX one_current_book_per_club
  ON bookclub_reads (clubid)
  WHERE is_current = TRUE;

DROP MATERIALIZED VIEW IF EXISTS v_user_genre_score CASCADE;
CREATE MATERIALIZED VIEW v_user_genre_score AS
WITH base AS (
    SELECT ur.userid, bg.genreid, ur.rating AS raw_score
    FROM   userrating  ur
    JOIN   bookgenre   bg ON bg.bookid = ur.bookid

    UNION ALL

    SELECT up.userid, bg.genreid, 5 AS raw_score
    FROM   userprogress up
    JOIN   bookgenre   bg ON bg.bookid = up.bookid
    WHERE  NOT EXISTS (
        SELECT 1 FROM userrating ur
        WHERE  ur.userid = up.userid
          AND  ur.bookid = up.bookid
    )
)
SELECT userid,
       genreid,
       AVG(raw_score)::numeric(4,2) AS score
FROM   base
GROUP  BY userid, genreid;

CREATE UNIQUE INDEX v_user_genre_score_pk
  ON v_user_genre_score(userid, genreid);

DROP MATERIALIZED VIEW IF EXISTS v_club_genre_score CASCADE;
CREATE MATERIALIZED VIEW v_club_genre_score AS
SELECT bcr.clubid,
       bg.genreid,
       AVG(10)::numeric(4,2) AS score   -- simple +10 for every read
FROM   bookclub_reads bcr
JOIN   bookgenre      bg ON bg.bookid = bcr.bookid
GROUP  BY bcr.clubid, bg.genreid;

CREATE UNIQUE INDEX v_club_genre_score_pk
  ON v_club_genre_score(clubid, genreid);

DROP FUNCTION IF EXISTS suggest_club(INT);
CREATE FUNCTION suggest_club(p_user INT)
RETURNS TABLE (clubid INT)
LANGUAGE sql
AS $$
    WITH
    already_in AS (
        SELECT clubid
        FROM   bookclub_members
        WHERE  userid = p_user
    ),
    uv AS (
        SELECT genreid, score
        FROM   v_user_genre_score
        WHERE  userid = p_user
    ),
    dot_and_norms AS (
        SELECT
            cgs.clubid,
            SUM(uv.score * cgs.score)            AS dot,
            SQRT(SUM(cgs.score * cgs.score))     AS c_norm
        FROM   v_club_genre_score cgs
        JOIN   uv                 USING (genreid)
        GROUP  BY cgs.clubid
    ),
    u_norm AS (
        SELECT SQRT(SUM(score * score)) AS u_norm
        FROM   uv
    )
    SELECT d.clubid
    FROM   dot_and_norms d
    CROSS  JOIN u_norm u
    WHERE  d.clubid NOT IN (SELECT clubid FROM already_in)
    ORDER  BY COALESCE(d.dot / NULLIF(u.u_norm * d.c_norm, 0), 0) DESC
    LIMIT  1
$$;

DROP FUNCTION IF EXISTS refresh_reco_views();
CREATE FUNCTION refresh_reco_views()
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY v_user_genre_score;
    REFRESH MATERIALIZED VIEW CONCURRENTLY v_club_genre_score;
END $$;

SELECT refresh_reco_views();

COMMENT ON FUNCTION suggest_club(INT)
IS 'Returns the single best-match book-club for the given user, or zero rows if user already belongs to every club.';

