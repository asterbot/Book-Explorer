-- First 15 books whose titles contain "Harry Potter"
SELECT * FROM production.books WHERE LOWER(title) LIKE LOWER('%Harry Potter%') LIMIT 15;
