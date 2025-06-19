INSERT INTO userprogress (userID, bookID, status) 
VALUES ((SELECT userID FROM users WHERE name = 'Alex'), '244', 'NOT STARTED')
ON DUPLICATE KEY UPDATE status = 'NOT STARTED';
