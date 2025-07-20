INSERT INTO userprogress (userID, bookID, status) 
VALUES ((SELECT userID FROM users WHERE name = 'Alex'), '244', 'NOT STARTED')
;
