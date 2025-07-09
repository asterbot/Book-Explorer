SELECT 
    b.bookID,
    b.title,
    COUNT(up_all.userID) as total_users,
    SUM(CASE WHEN up_all.status = 'FINISHED' THEN 1 ELSE 0 END) as completed_users,
    ROUND(
        (SUM(CASE WHEN up_all.status = 'FINISHED' THEN 1 ELSE 0 END) * 100.0 / COUNT(up_all.userID)), 1
    ) as completion_rate
FROM userprogress up_mine
JOIN books b ON up_mine.bookID = b.bookID AND up_mine.status = 'IN PROGRESS'
JOIN users u_mine ON up_mine.userID = u_mine.userID
JOIN userprogress up_all ON b.bookID = up_all.bookID
WHERE up_mine.status = 'IN PROGRESS' and u_mine.name = 'ALEX'
GROUP BY b.bookID, b.title
ORDER BY completion_rate DESC, total_users DESC
