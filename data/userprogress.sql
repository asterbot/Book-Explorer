CREATE TABLE `userprogress` (
    `userID` INT,
    `bookID` INT,
    `status` ENUM('NOT STARTED', 'IN PROGRESS', 'FINISHED') DEFAULT 'NOT STARTED',
    `page_reached` INT DEFAULT 0,
    PRIMARY KEY (userID, bookID),
    FOREIGN KEY (userID) REFERENCES users(userID),
    FOREIGN KEY (bookID) REFERENCES books(bookID)
    ON DELETE CASCADE
);



INSERT INTO `userprogress` (`userID`, `bookID`) VALUES
('1', '77'),
('1', '78'),
('1', '81'),
('2', '79'),
('2', '78'),
('2', '77'),
('3', '80'),
('3', '77'),
('3', '79'),
('4', '81');


UPDATE userprogress SET status='IN PROGRESS' where userID=1 AND bookID=78;
UPDATE userprogress SET status='FINISHED' where userID=1 AND bookID=81;

UPDATE userprogress SET status='IN PROGRESS' where userID=2 AND bookID=77;
UPDATE userprogress SET status='FINISHED' where userID=1 AND bookID=79;
