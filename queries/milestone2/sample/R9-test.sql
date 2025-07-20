SELECT b.bookID, b.title, AVG(ur.rating) as avg_rating
FROM books b, UserRating ur
WHERE b.bookID=ur.bookID
GROUP BY b.bookID, b.title
ORDER BY avg_rating DESC LIMIT 5;
