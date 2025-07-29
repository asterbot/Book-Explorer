BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT userID FROM users
WHERE LOWER(name) = LOWER('Alex');

SELECT 1 FROM bookclub_members
WHERE clubID = 76 AND userID = 1
LIMIT 1;

SELECT COUNT(*) FROM bookclub_members WHERE clubID = 76;

SELECT max_members FROM bookclubs
WHERE clubID = 76;

INSERT INTO bookclub_members(clubID, userID, joined_at)
VALUES (76, 1, CURRENT_TIMESTAMP);

COMMIT;

-- ROLLBACK is performed if any of these steps fails through backend script