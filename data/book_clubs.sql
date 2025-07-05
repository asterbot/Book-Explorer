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

-- Harry Potter Lovers
INSERT INTO bookclubs (name, description, creatorID)
VALUES ('Harry Potter Lovers', 'A club for fans of the Harry Potter universe.', 1);

INSERT INTO bookclub_members (clubID, userID)
VALUES 
(1, 1), (1, 5), (1, 8), (1, 23), (1, 44), (1, 46), (1, 50), (1, 56),
(1, 66), (1, 67), (1, 68), (1, 88), (1, 82), (1, 140), (1, 120), (1, 110), (1, 109);

INSERT INTO bookclub_reads (clubID, bookID, start_date, end_date, is_current)
VALUES 
(1, 1, '2025-07-01', '2025-07-31', TRUE),
(1, 2, '2025-07-15', '2025-08-15', FALSE),
(1, 4, '2025-08-01', '2025-08-31', TRUE),
(1, 5, '2025-08-15', '2025-09-15', FALSE),
(1, 8, '2025-09-01', '2025-09-30', FALSE),
(1, 9, '2025-09-10', '2025-09-25', FALSE),
(1, 10, '2025-09-20', '2025-10-10', TRUE);

-- Sci-Fi Saturdays
INSERT INTO bookclubs (clubID,name,description,creatorID)
VALUES (3,'Sci-Fi Saturdays','Exploring classic and modern science-fiction every month.',3);

INSERT INTO bookclub_members (clubID,userID) VALUES
(3,3),(3,6),(3,12),(3,15),(3,19),
(3,24),(3,30),(3,34),(3,40),(3,45),
(3,53),(3,58),(3,62),(3,70),(3,81),
(3,102),(3,137);

INSERT INTO bookclub_reads (clubID,bookID,start_date,end_date,is_current) VALUES
(3,103,'2025-07-01','2025-07-31',TRUE),
(3,105,'2025-08-01','2025-08-31',FALSE),
(3,106,'2025-09-01','2025-09-30',TRUE),
(3,107,'2025-10-01','2025-10-31',TRUE),
(3,109,'2025-11-01','2025-11-30',FALSE),
(3,110,'2025-12-01','2025-12-31',TRUE);

-- Non-Fiction Nation
INSERT INTO bookclubs (clubID,name,description,creatorID)
VALUES (4,'Non-Fiction Nation','Biographies, science, and ideas that change the world.',9);

INSERT INTO bookclub_members (clubID,userID) VALUES
(4,9),(4,13),(4,17),(4,26),(4,29),
(4,33),(4,37),(4,43),(4,48),(4,55),
(4,63),(4,71),(4,90),(4,107),(4,118),
(4,121);

INSERT INTO bookclub_reads (clubID,bookID,start_date,end_date,is_current) VALUES
(4,45,'2025-07-01','2025-07-31',FALSE),
(4,89,'2025-08-01','2025-08-31',TRUE),
(4,92,'2025-09-01','2025-09-30',TRUE),
(4,94,'2025-10-01','2025-10-31',FALSE),
(4,141,'2025-11-01','2025-11-30',FALSE),
(4,147,'2025-12-01','2025-12-31',TRUE),
(4,663,'2026-01-01','2026-01-31',TRUE);

-- Romance Corner
INSERT INTO bookclubs (clubID,name,description,creatorID)
VALUES (5,'Romance Corner','Heart-warming, heart-wrenching, always swoon-worthy reads.',16);

INSERT INTO bookclub_members (clubID,userID) VALUES
(5,16),(5,20),(5,28),(5,31),(5,38),
(5,47),(5,54),(5,57),(5,65),(5,72),
(5,80),(5,86),(5,92),(5,100),(5,112),
(5,125);

INSERT INTO bookclub_reads (clubID, bookID, start_date, end_date, is_current) VALUES
(5, 675, '2025-07-01','2025-07-31', FALSE),
(5, 678, '2025-08-01','2025-08-31', TRUE),
(5, 204, '2025-09-01','2025-09-30', FALSE),
(5, 205, '2025-10-01','2025-10-31', TRUE),
(5, 207, '2025-11-01','2025-11-30', FALSE),
(5, 208, '2025-12-01','2025-12-31', FALSE);

-- Classic Must-Reads
INSERT INTO bookclubs (clubID, name, description, creatorID)
VALUES (9, 'Classic Must-Reads', 'Timeless literature that shaped generations.', 7);

INSERT INTO bookclub_members (clubID, userID) VALUES
(9, 7), (9, 12), (9, 15), (9, 21), (9, 27),
(9, 33), (9, 36), (9, 42), (9, 49), (9, 51),
(9, 60), (9, 72), (9, 85), (9, 99), (9, 108);

INSERT INTO bookclub_reads (clubID, bookID, start_date, end_date, is_current) VALUES
(9, 675, '2025-07-01', '2025-07-31', FALSE),
(9, 103, '2025-08-01', '2025-08-31', FALSE),
(9, 1, '2025-09-01', '2025-09-30', FALSE),
(9, 105, '2025-10-01', '2025-10-31', FALSE),
(9, 92, '2025-11-01', '2025-11-30', TRUE);

-- Thrillers
INSERT INTO bookclubs (clubID, name, description, creatorID)
VALUES (10, 'Page-Turner Thrillers', 'Gripping stories full of suspense and surprise.', 14);

INSERT INTO bookclub_members (clubID, userID) VALUES
(10, 14), (10, 18), (10, 22), (10, 25), (10, 31),
(10, 35), (10, 41), (10, 47), (10, 52), (10, 58),
(10, 64), (10, 70), (10, 76), (10, 83), (10, 91);

INSERT INTO bookclub_reads (clubID, bookID, start_date, end_date, is_current) VALUES
(10, 109, '2025-07-01', '2025-07-31', FALSE),
(10, 106, '2025-08-01', '2025-08-31', FALSE),
(10, 208, '2025-09-01', '2025-09-30', TRUE),
(10, 141, '2025-10-01', '2025-10-31', TRUE),
(10, 107, '2025-11-01', '2025-11-30', TRUE);

-- Global Voices
INSERT INTO bookclubs (clubID, name, description, creatorID)
VALUES (11, 'Global Voices', 'Stories and perspectives from around the world.', 11);

INSERT INTO bookclub_members (clubID, userID) VALUES
(11, 11), (11, 17), (11, 20), (11, 28), (11, 32),
(11, 37), (11, 40), (11, 44), (11, 55), (11, 61),
(11, 66), (11, 69), (11, 74), (11, 78), (11, 95);

INSERT INTO bookclub_reads (clubID, bookID, start_date, end_date, is_current) VALUES
(11, 204, '2025-07-01', '2025-07-31', TRUE),
(11, 94, '2025-08-01', '2025-08-31', FALSE),
(11, 2, '2025-09-01', '2025-09-30', FALSE),
(11, 89, '2025-10-01', '2025-10-31', FALSE),
(11, 45, '2025-11-01', '2025-11-30', TRUE);

-- Epic Fantasy Questers
INSERT INTO bookclubs (clubID, name, description, creatorID)
VALUES (12, 'Epic Fantasy Questers', 'Journey through high-fantasy epics and classic quests.', 30);

INSERT INTO bookclub_members (clubID, userID) VALUES
(12, 30), (12, 3), (12, 7), (12, 12), (12, 18),
(12, 27), (12, 33), (12, 42), (12, 55), (12, 63),
(12, 79), (12, 88), (12, 97), (12, 104), (12, 133);

INSERT INTO bookclub_reads (clubID, bookID, start_date, end_date, is_current) VALUES
(12, 30, '2025-07-01','2025-07-31', TRUE),
(12, 31, '2025-08-01','2025-08-31', TRUE),
(12, 34, '2025-09-01','2025-09-30', TRUE),
(12, 35, '2025-10-01','2025-10-31', TRUE),
(12, 36, '2025-11-01','2025-11-30', TRUE);

-- Money Masters
INSERT INTO bookclubs (clubID, name, description, creatorID)
VALUES (13, 'Money Masters', 'Building wealth and financial wisdom together.', 45);

INSERT INTO bookclub_members (clubID, userID) VALUES
(13, 45), (13, 11), (13, 22), (13, 28), (13, 38),
(13, 49), (13, 58), (13, 67), (13, 72), (13, 84),
(13, 93), (13, 101), (13, 117), (13, 126), (13, 142);

INSERT INTO bookclub_reads (clubID, bookID, start_date, end_date, is_current) VALUES
(13, 998, '2025-07-01','2025-07-31', TRUE),
(13, 1005, '2025-08-01','2025-08-31', TRUE),
(13, 1007, '2025-09-01','2025-09-30', TRUE),
(13, 1052, '2025-10-01','2025-10-31', TRUE),
(13, 1053, '2025-11-01','2025-11-30', TRUE);
