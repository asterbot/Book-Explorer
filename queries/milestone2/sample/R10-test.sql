SELECT books.bookID, books.title, COUNT(*) AS wishlist_count
FROM userprogress
JOIN books ON userprogress.bookID = books.bookID
WHERE userprogress.status = 'NOT STARTED'
GROUP BY books.bookID, books.title
ORDER BY wishlist_count DESC
LIMIT 5;
