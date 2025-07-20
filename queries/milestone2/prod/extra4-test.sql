-- Top 30 wishlisted books
SELECT b.bookID, b.title, COUNT(*) AS wishlist_count
FROM production.userprogress up
JOIN production.books b ON up.bookID = b.bookID
WHERE up.status = 'NOT STARTED'
GROUP BY b.bookID, b.title
ORDER BY wishlist_count DESC
LIMIT 30;
