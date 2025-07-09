INSERT INTO production.userprogress (userID, bookID, status) 
VALUES ((SELECT userID FROM users WHERE name = 'Alex'), '139', 'NOT STARTED')
;
