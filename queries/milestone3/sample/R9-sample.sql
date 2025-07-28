SELECT b.bookID, b.title, ROUND(AVG(ur.rating),2) as avg_rating, COALESCE(string_agg(a.name, ', '), '') AS authors, b.num_pages
FROM books b NATURAL JOIN userrating ur NATURAL JOIN authors a NATURAL JOIN book_authors ba
GROUP BY b.bookID, b.title, b.num_Pages
ORDER BY avg_rating DESC, b.title LIMIT 15;
