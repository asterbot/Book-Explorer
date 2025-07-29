SELECT 
    b.bookID,
    b.title,
    b.num_pages,
    COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors,
    COUNT(DISTINCT up.userID) AS wishlist_count
FROM userprogress up NATURAL JOIN books b NATURAL JOIN book_authors ba NATURAL JOIN authors a
WHERE up.status = 'NOT STARTED'
GROUP BY b.bookID, b.title, b.num_pages
ORDER BY wishlist_count DESC, b.title 
LIMIT 15;