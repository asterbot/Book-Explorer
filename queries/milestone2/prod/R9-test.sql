-- Top 100 books by rating 
SELECT b.bookID, b.title, AVG(ur.rating) as avg_rating
FROM production.books b, production.UserRating ur
WHERE b.bookID=ur.bookID
GROUP BY b.bookID, b.title
LIMIT 100;
