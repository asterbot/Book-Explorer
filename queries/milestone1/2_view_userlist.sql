-- All the books that Alex has not started
SELECT b.bookID, b.title, b.authors
FROM userprogress u, books b 
WHERE userID = (SELECT userID FROM users WHERE name = 'Alex') 
        AND b.bookID=u.bookID
        AND STATUS='NOT STARTED';
