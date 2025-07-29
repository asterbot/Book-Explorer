--362 242
SELECT 
        b.bookID,
        b.title,
        COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors
FROM production.userprogress us1
JOIN production.userprogress us2 ON us1.bookID = us2.bookID
JOIN production.books b ON us1.bookID = b.bookID
LEFT JOIN production.book_authors ba ON b.bookID = ba.bookID
LEFT JOIN authors a ON ba.authorID = a.authorID
WHERE us1.userID = 362
        AND us2.userID = 242
GROUP BY b.bookID, b.title
LIMIT 5;
