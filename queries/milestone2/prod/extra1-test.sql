-- All the books that Alex has not started
--   i.e. all the books in Alex's wishlist
SELECT b.bookID, b.title
FROM production.userprogress u, production.books b 
WHERE userID = (SELECT userID FROM production.users WHERE name = 'Alex') 
        AND b.bookID=u.bookID
        AND u.status='NOT STARTED';
