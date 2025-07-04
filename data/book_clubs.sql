CREATE TABLE `bookclubs` (
    `clubID` INT AUTO_INCREMENT,
    `name` VARCHAR(255),
    `description` TEXT,
    `creatorID` INT,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (clubID),
    FOREIGN KEY (creatorID) REFERENCES users(userID)
);

CREATE TABLE `bookclub_members` (
    `clubID` INT,
    `userID` INT,
    `joined_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (clubID, userID),
    FOREIGN KEY (clubID) REFERENCES bookclubs(clubID) ON DELETE CASCADE,
    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE
);

CREATE TABLE `bookclub_reads` (
    `clubID` INT,
    `bookID` INT,
    `start_date` DATE,
    `end_date` DATE,
    `is_current` BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (clubID, bookID),
    FOREIGN KEY (clubID) REFERENCES bookclubs(clubID) ON DELETE CASCADE,
    FOREIGN KEY (bookID) REFERENCES books(bookID) ON DELETE CASCADE
);

INSERT INTO bookclubs (name, description, creatorID)
VALUES 
('Fantasy Fanatics', 'A club for lovers of all things fantasy.', 1),
('Sci-Fi Saturdays', 'We read and discuss a new science fiction book every month.', 3);

INSERT INTO bookclub_members (clubID, userID)
VALUES 
(1, 1),
(1, 2),
(1, 4);

INSERT INTO bookclub_members (clubID, userID)
VALUES 
(2, 3),
(2, 2);

INSERT INTO bookclub_reads (clubID, bookID, start_date, end_date, is_current)
VALUES 
(1, 34, '2025-07-01', '2025-07-31', TRUE);

INSERT INTO bookclub_reads (clubID, bookID, start_date, end_date, is_current)
VALUES 
(2, 13, '2025-07-01', '2025-08-01', TRUE);
