WITH RECURSIVE streak_books(userid, bookid, update_time) AS(
    -- base case
    SELECT * FROM(
        SELECT userid, bookid, update_time 
        FROM production.userlogs 
        WHERE userid=(SELECT userid FROM production.users WHERE name='Alex')
        ORDER BY update_time DESC -- get latest update_time
        LIMIT 1
    ) as base

    UNION 

    -- recursive case
    SELECT * FROM(
        SELECT t.userid, t.bookid, t.update_time 
        FROM production.userlogs t
        JOIN streak_books s ON t.userid=s.userid
        WHERE s.update_time::date - t.update_time::date = 1 -- time differs by EXACTLY one day
        ORDER BY t.update_time
        LIMIT 1
    ) as recurse
)
SELECT COUNT(*) as streak FROM streak_books;
