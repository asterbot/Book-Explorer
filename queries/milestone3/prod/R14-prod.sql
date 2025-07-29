BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT userID FROM production.users
WHERE LOWER(name) = LOWER('Alex');

SELECT 1 FROM production.bookclub_members
WHERE clubID = 463 AND userID = 1
LIMIT 1;

SELECT COUNT(*) FROM production.bookclub_members WHERE clubID = 463;

SELECT max_members FROM production.bookclubs
WHERE clubID = 463;

INSERT INTO production.bookclub_members(clubID, userID, joined_at)
VALUES (463, 1, CURRENT_TIMESTAMP);

COMMIT;

-- ROLLBACK is performed if any of these steps fails through backend script
