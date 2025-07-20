-- Count of books by genre
SELECT g.name, COUNT(*) as count 
FROM BookGenre bg, Genre g
WHERE bg.genreID=g.genreID 
GROUP BY g.name;
