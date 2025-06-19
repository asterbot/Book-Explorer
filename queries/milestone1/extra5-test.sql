-- Count of books by genre
SELECT genre, COUNT(*) as count FROM books GROUP BY genre;

-- Filter by genre
SELECT bookID, title, authors
FROM books
WHERE genre = 'Fantasy'
ORDER BY title ASC;
