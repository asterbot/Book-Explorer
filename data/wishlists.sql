DROP TABLE IF EXISTS `wishlists`;

CREATE TABLE `wishlists` (
    `userID` VARCHAR(36),
    `bookID` VARCHAR(36),
    PRIMARY KEY (userID, bookID),
    FOREIGN KEY (userID) REFERENCES users(userID),
    FOREIGN KEY (bookID) REFERENCES books(bookID)
);

INSERT INTO `wishlists` (`userID`, `bookID`) VALUES
('1', '77'),
('1', '78'),
('2', '79'),
('3', '80'),
('4', '81');