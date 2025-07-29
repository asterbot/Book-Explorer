SELECT b.bookID, b.title, ROUND(AVG(ur.rating),2) as avg_rating, COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors, b.num_pages
FROM production.books b NATURAL JOIN production.userrating ur NATURAL JOIN production.authors a NATURAL JOIN production.book_authors ba
GROUP BY b.bookID, b.title, b.num_Pages
ORDER BY avg_rating DESC, b.title LIMIT 100;
