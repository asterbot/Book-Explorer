CREATE TABLE `users` (
    `userID` INT,
    `name` VARCHAR(255),
    `email` VARCHAR(255),
    PRIMARY KEY (userID)
);

INSERT INTO `users` (`userID`, `name`, `email`) VALUES
('1', 'Alex', 'alex@example.com'),
('2', 'Bob', 'bob@example.com'),
('3', 'Charlie', 'charlie@example.com'),
('4', 'David', 'david@example.com');