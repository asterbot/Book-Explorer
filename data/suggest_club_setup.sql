-- user stuff
-- build a genre vector for users based on what books they read and how they rated those books
-- if they are currently in progress, then assign it a neutral score of 5. if they did not rate it,
-- also assign a neutral score of 5. 
-- if they rated it but also in progress, it takes the rated score and not the neutral default 5
DROP MATERIALIZED VIEW IF EXISTS v_user_genre_score CASCADE;
CREATE MATERIALIZED VIEW v_user_genre_score AS
WITH base AS (
    -- rated
    SELECT ur.userid, bg.genreid, ur.rating AS raw_score
    FROM   userrating ur
    JOIN   bookgenre bg ON bg.bookid = ur.bookid

    UNION ALL

    -- not rated but has some progress (including finished reading)
    SELECT up.userid, bg.genreid, 5 AS raw_score
    FROM   userprogress up
    JOIN   bookgenre bg ON bg.bookid = up.bookid
    WHERE  NOT EXISTS (
        SELECT 1
        FROM   userrating ur
        WHERE  ur.userid = up.userid
        AND    ur.bookid = up.bookid
    )
)

-- calculate all users' avg score for every genre they read rounded to 2 decimals
SELECT userid,
       genreid,
       ROUND(AVG(raw_score), 2) AS score
FROM   base
GROUP  BY userid, genreid;

-- ensure uniqueness for each userid, genreid pair 
-- so that our calculations later are correct
CREATE UNIQUE INDEX v_user_genre_score_pk
  ON v_user_genre_score(userid, genreid);

-- club stuff

-- determine what genres a club has read and assigns it a score of 10 for each
-- it doesnt matter what score we give to each as long as it is same because clubs do not
-- have ratings. 10 is random number chosen but doesnt matter
DROP MATERIALIZED VIEW IF EXISTS v_club_genre_score CASCADE;
CREATE MATERIALIZED VIEW v_club_genre_score AS
SELECT bcr.clubid,
       bg.genreid,
       COUNT(*) * 10.0 AS score
FROM   bookclub_reads bcr
JOIN   bookgenre bg ON bg.bookid = bcr.bookid
GROUP BY bcr.clubid, bg.genreid;

CREATE UNIQUE INDEX v_club_genre_score_pk
  ON v_club_genre_score(clubid, genreid);

-- similarity calc function
DROP FUNCTION IF EXISTS suggest_club(INT);
-- argument is the user that we care about
-- this function suggests club based on cos similarity. 
CREATE FUNCTION suggest_club(p_user INT)
RETURNS TABLE (clubid INT)
LANGUAGE sql
AS $$
    WITH
    -- clubs that the user is in
    already_in AS (
        SELECT clubid
        FROM   bookclub_members
        WHERE  userid = p_user
    ),
    -- get the user's genre vector
    uv AS (
        SELECT genreid, score
        FROM   v_user_genre_score
        WHERE  userid = p_user
    ),
    -- for each club, calculate the dot product between user and club vector
    dot_and_norms AS (
        SELECT
            cgs.clubid,
            SUM(uv.score * cgs.score)        AS dot,
            SQRT(SUM(cgs.score * cgs.score)) AS c_norm -- magnitude of club vector
        FROM   v_club_genre_score cgs
        JOIN   uv USING (genreid)
        GROUP  BY cgs.clubid
    ),
    -- compute magnitude of user vector 
    u_norm AS (
        SELECT SQRT(SUM(score * score)) AS u_norm
        FROM   uv
    )
    SELECT d.clubid
    FROM   dot_and_norms d
    CROSS  JOIN u_norm u
    WHERE  d.clubid NOT IN (SELECT clubid FROM already_in)
    ORDER  BY COALESCE(d.dot / NULLIF(u.u_norm * d.c_norm, 0), 0) DESC -- this is the formula for cosine similarity 
    -- get the top most result
    LIMIT  1
$$;

DROP FUNCTION IF EXISTS refresh_reco_views();
CREATE FUNCTION refresh_reco_views()
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY v_user_genre_score;
    REFRESH MATERIALIZED VIEW CONCURRENTLY v_club_genre_score;
END $$;

-- refresh
SELECT refresh_reco_views();