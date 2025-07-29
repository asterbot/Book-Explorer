INSERT INTO production.userprogress (userID, bookID, status) 
VALUES ((SELECT userID FROM production.users WHERE name = 'Alex'), '139', 'NOT STARTED')
ON CONFLICT (userID, bookID) DO UPDATE SET status = 'NOT STARTED';
