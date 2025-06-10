DROP TABLE IF EXISTS `books_read`;

CREATE TABLE `books_read` (
    `userID` VARCHAR(36),
    `bookID` VARCHAR(36),
    PRIMARY KEY (userID, bookID),
    FOREIGN KEY (userID) REFERENCES users(userID),
    FOREIGN KEY (bookID) REFERENCES books(bookID)
);

INSERT INTO `books_read` (`userID`, `bookID`) VALUES
('1', '1'),
('1', '2'),
('2', '4'),
('3', '5'),
('4', '8');