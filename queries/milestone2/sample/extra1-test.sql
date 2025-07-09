SELECT b.bookID, b.title
FROM userprogress u, books b 
WHERE userID = (SELECT userID FROM users WHERE name = 'Alex') 
        AND b.bookID=u.bookID
        AND u.status='NOT STARTED';
