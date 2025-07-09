SELECT b.bookID, b.title
FROM books b, BookGenre bg, Genre g
WHERE g.genreID=bg.genreID AND b.bookID=bg.bookID AND
        LOWER(g.name) = LOWER('Crime')
ORDER BY title ASC;