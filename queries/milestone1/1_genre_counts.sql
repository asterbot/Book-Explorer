-- Count of books by genre
SELECT genre, COUNT(*) as count FROM books GROUP BY genre;
