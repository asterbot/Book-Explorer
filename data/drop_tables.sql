DROP MATERIALIZED VIEW IF EXISTS v_club_genre_score CASCADE;
DROP MATERIALIZED VIEW IF EXISTS v_user_genre_score CASCADE;

DROP TABLE IF EXISTS bookclub_members;
DROP TABLE IF EXISTS bookclub_reads;
DROP TABLE IF EXISTS bookclub_creators;
DROP TABLE IF EXISTS bookclubs;

DROP TABLE IF EXISTS user_book_tag;
DROP TABLE IF EXISTS tag;

DROP TABLE IF EXISTS BookGenre;
DROP TABLE IF EXISTS Genre;

DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS authors;

DROP TABLE IF EXISTS book_publishers;
DROP TABLE IF EXISTS publishers;

DROP TABLE IF EXISTS UserRating;
DROP TABLE IF EXISTS userprogress;

DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS users;

/* ---------- recommendation helpers ---------- */
DROP FUNCTION IF EXISTS refresh_reco_views() CASCADE;
DROP FUNCTION IF EXISTS suggest_club(INT)   CASCADE;


DROP INDEX IF EXISTS one_current_book_per_club;

-- optional enum/type drops (only drop if *nothing* else uses them)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'reading_status') THEN
        DROP TYPE reading_status;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'interaction_kind') THEN
        DROP TYPE interaction_kind;
    END IF;
END $$;
