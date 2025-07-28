SELECT b.bookID, b.title, b.isbn, b.language_code, b.num_pages, 
    COALESCE(string_agg(a.name, ', '), '') AS authors
FROM books b
LEFT JOIN production.book_authors ba ON b.bookID = ba.bookID
LEFT JOIN production.authors a ON ba.authorID = a.authorID
WHERE LOWER(b.title) LIKE LOWER('%Harry Potter%')
GROUP BY b.bookID
LIMIT 10;
