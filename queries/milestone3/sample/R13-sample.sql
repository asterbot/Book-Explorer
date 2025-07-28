SELECT 
b.bookID,
b.title,
COALESCE(string_agg(a.name, ', '), '') AS authors,
COUNT(up_all.userID) AS total_users,
SUM(CASE WHEN up_all.status = 'FINISHED' THEN 1 ELSE 0 END) AS completed_users,
ROUND(
    SUM(CASE WHEN up_all.status = 'FINISHED' THEN 1 ELSE 0 END) * 100.0 / COUNT(up_all.userID),
    1
) AS completion_rate
FROM userprogress up_mine
JOIN books b ON up_mine.bookID = b.bookID AND up_mine.status = 'IN PROGRESS'
LEFT JOIN book_authors ba ON b.bookID = ba.bookID
LEFT JOIN authors a ON ba.authorID = a.authorID
JOIN users u_mine ON up_mine.userID = u_mine.userID
JOIN userprogress up_all ON b.bookID = up_all.bookID
WHERE u_mine.name = 'Alex'
GROUP BY b.bookID, b.title
ORDER BY completion_rate DESC, total_users DESC;
