SELECT b.bookID, b.title, COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors
FROM userprogress us1
JOIN userprogress us2 ON us1.bookID = us2.bookID
JOIN books b ON us1.bookID = b.bookID
LEFT JOIN book_authors ba ON b.bookID = ba.bookID
LEFT JOIN authors a ON ba.authorID = a.authorID
WHERE us1.userID = (SELECT userID FROM users WHERE name = 'Alex')
        AND us2.userID = (SELECT userID FROM users WHERE name = 'Bob')
GROUP BY b.bookID, b.title
LIMIT 15;
