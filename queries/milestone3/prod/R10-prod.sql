SELECT 
    b.bookID,
    b.title,
    b.num_pages,
    COALESCE(string_agg(a.name, ', '), '') AS authors,
    COUNT(DISTINCT up.userID) AS wishlist_count
FROM production.userprogress up NATURAL JOIN production.books b NATURAL JOIN production.book_authors ba NATURAL JOIN production.authors a
WHERE up.status = 'NOT STARTED'
GROUP BY b.bookID, b.title, b.num_pages
ORDER BY wishlist_count DESC, b.title 
LIMIT 100;