-- First 15 books whose titles contain "Harry Potter"
SELECT * FROM production.books WHERE title LIKE '%Harry Potter%' LIMIT 15;
