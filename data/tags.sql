CREATE TABLE `tag` (
    `tagID` INT AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    PRIMARY KEY (tagID)
);

-- global tag for books
CREATE TABLE `book_tag` (
    `bookID` INT NOT NULL,
    `tagID` INT NOT NULL,
    PRIMARY KEY (bookID, tagID),
    FOREIGN KEY (bookID) REFERENCES books(bookID) ON DELETE CASCADE,
    FOREIGN KEY (tagID) REFERENCES tag(tagID) ON DELETE CASCADE
);

CREATE TABLE `user_book_tag` (
    `userID` INT NOT NULL,
    `bookID` INT NOT NULL,
    `tagID` INT NOT NULL,
    PRIMARY KEY (userID, bookID, tagID),
    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (bookID) REFERENCES books(bookID) ON DELETE CASCADE,
    FOREIGN KEY (tagID) REFERENCES tag(tagID) ON DELETE CASCADE
);

INSERT INTO `tag` (`name`) VALUES
('cozy'),
('book club'),
('slow burn'),
('light read'),
('dark'),
('sad'),
('page turner'),
('summer read'),
('holiday gift'),
('funny'),
('classic');

-- Harry Potter books (bookIDs: 1, 2, 4, 5, 8, 9, 10)
INSERT INTO `book_tag` (`bookID`, `tagID`) VALUES
(1, 1),   -- cozy
(1, 7),   -- page turner
(1, 9),   -- holiday gift
(2, 5),   -- dark
(2, 3),   -- slow burn
(2, 6),   -- sad
(4, 1),   -- cozy
(4, 4),   -- light read
(5, 7),   -- page turner
(5, 10),  -- funny
(8, 9),   -- holiday gift
(10, 11); -- classic

-- Hitchhiker’s Guide books (bookIDs: 12, 13, 14, 16, 18)
INSERT INTO `book_tag` (`bookID`, `tagID`) VALUES
(12, 10), -- funny
(12, 3),  -- slow burn
(13, 10), -- funny
(14, 10), -- funny
(16, 10), -- funny
(18, 10); -- funny

-- Tolkien books (bookIDs: 30, 31, 34, 35)
INSERT INTO `book_tag` (`bookID`, `tagID`) VALUES
(30, 1),  -- cozy
(30, 11), -- classic
(31, 5),  -- dark
(31, 11), -- classic
(34, 7),  -- page turner
(35, 11); -- classic

-- Bill Bryson books (bookIDs: 21–29)
INSERT INTO `book_tag` (`bookID`, `tagID`) VALUES
(21, 2),  -- book club
(21, 10), -- funny
(22, 4),  -- light read
(23, 2),  -- book club
(24, 8),  -- summer read
(24, 10), -- funny
(25, 10), -- funny
(26, 10), -- funny
(27, 8),  -- summer read
(28, 1),  -- cozy
(29, 2);  -- book club

-- Alex (userID 1)
INSERT INTO `user_book_tag` (`userID`, `bookID`, `tagID`) VALUES
(1, 1, 7),   -- Harry Potter 6: page turner
(1, 1, 9),   -- Harry Potter 6: holiday gift
(1, 13, 10), -- Hitchhiker's: funny
(1, 21, 2),  -- A Short History: book club
(1, 30, 1);  -- Tolkien box set: cozy

-- Bob (userID 2)
INSERT INTO `user_book_tag` (`userID`, `bookID`, `tagID`) VALUES
(2, 2, 6),   -- HP Order of Phoenix: sad
(2, 5, 10),  -- HP Azkaban: funny
(2, 18, 3),  -- Ultimate Hitchhiker: slow burn
(2, 27, 8),  -- Neither Here Nor There: summer read
(2, 28, 1);  -- Notes from Small Island: cozy

-- Charlie (userID 3)
INSERT INTO `user_book_tag` (`userID`, `bookID`, `tagID`) VALUES
(3, 12, 10), -- Hitchhiker’s Ultimate: funny
(3, 21, 10), -- A Short History: funny
(3, 24, 8),  -- Sunburned Country: summer read
(3, 30, 11), -- Tolkien Boxed Set: classic
(3, 35, 5);  -- LOTR illustrated: dark





