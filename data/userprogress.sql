CREATE TYPE status AS ENUM('NOT STARTED', 'IN PROGRESS', 'FINISHED');

CREATE TABLE userprogress (
    userID INT,
    bookID INT,
    status status DEFAULT 'NOT STARTED',
    page_reached INT DEFAULT 0,
    -- last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (userID, bookID),
    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (bookID) REFERENCES books(bookID) ON DELETE CASCADE
);


CREATE OR REPLACE FUNCTION update_last_updated_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.last_updated = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_last_updated
BEFORE UPDATE ON userprogress
FOR EACH ROW
EXECUTE FUNCTION update_last_updated_column();

-- Trigger to set status based on page reached
CREATE OR REPLACE FUNCTION set_status()
RETURNS trigger AS $$
BEGIN
    IF NEW.page_reached = 0 THEN
        UPDATE userprogress
        SET status = 'NOT STARTED'
        WHERE userid = NEW.userid AND bookID = NEW.bookID;
        
    ELSIF NEW.page_reached < (SELECT num_pages FROM books WHERE bookID=NEW.bookID) THEN
        UPDATE userprogress
        SET status = 'IN PROGRESS'
        WHERE userid = NEW.userid AND bookID = NEW.bookID;

    ELSE
        UPDATE userprogress
        SET status = 'DONE'
        WHERE userid = NEW.userid AND bookID = NEW.bookID;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER set_status
    AFTER UPDATE OF page_reached ON userprogress
    FOR EACH ROW
        EXECUTE FUNCTION set_status();


INSERT INTO userprogress (userID, bookID, status, page_reached) VALUES
('1', '77', 'NOT STARTED', 0),
('1', '78', 'IN PROGRESS', 30),
('1', '81', 'FINISHED', 288),
('2', '79', 'NOT STARTED', 0),
('2', '78', 'NOT STARTED', 0),
('2', '77', 'IN PROGRESS', 23),
('43', '14', 'IN PROGRESS', 96),
('79', '23', 'NOT STARTED', 0),
('19', '91', 'NOT STARTED', 0),
('126', '972', 'NOT STARTED', 0),
('138', '597', 'FINISHED', 245),
('79', '998', 'IN PROGRESS', 173),
('151', '650', 'IN PROGRESS', 180),
('90', '435', 'FINISHED', 179),
('50', '37', 'IN PROGRESS', 71),
('142', '93', 'IN PROGRESS', 345),
('79', '151', 'FINISHED', 838),
('140', '168', 'NOT STARTED', 0),
('54', '1097', 'FINISHED', 399),
('68', '57', 'NOT STARTED', 0),
('146', '1078', 'NOT STARTED', 0),
('108', '935', 'NOT STARTED', 0),
('6', '1099', 'NOT STARTED', 0),
('112', '382', 'FINISHED', 72),
('55', '765', 'FINISHED', 533),
('14', '27', 'FINISHED', 254),
('66', '423', 'NOT STARTED', 0),
('148', '929', 'IN PROGRESS', 77),
('136', '931', 'NOT STARTED', 0),
('114', '81', 'IN PROGRESS', 200),
('26', '664', 'IN PROGRESS', 131),
('133', '291', 'NOT STARTED', 0),
('143', '787', 'NOT STARTED', 0),
('104', '484', 'FINISHED', 576),
('41', '477', 'IN PROGRESS', 165),
('92', '132', 'FINISHED', 336),
('52', '816', 'IN PROGRESS', 701),
('141', '872', 'IN PROGRESS', 118),
('35', '902', 'IN PROGRESS', 70),
('135', '835', 'IN PROGRESS', 205),
('147', '498', 'FINISHED', 100),
('20', '497', 'FINISHED', 144),
('141', '866', 'NOT STARTED', 0),
('97', '153', 'IN PROGRESS', 21),
('6', '165', 'IN PROGRESS', 132),
('50', '902', 'NOT STARTED', 0),
('31', '201', 'FINISHED', 205),
('30', '137', 'FINISHED', 384),
('109', '291', 'NOT STARTED', 0),
('8', '147', 'IN PROGRESS', 70),
('148', '132', 'FINISHED', 336),
('89', '771', 'NOT STARTED', 0),
('87', '987', 'IN PROGRESS', 50),
('58', '523', 'FINISHED', 112),
('62', '1014', 'FINISHED', 256),
('83', '421', 'NOT STARTED', 0),
('27', '24', 'IN PROGRESS', 242),
('93', '816', 'FINISHED', 1139),
('3', '249', 'IN PROGRESS', 130),
('6', '355', 'NOT STARTED', 0),
('94', '16', 'NOT STARTED', 0),
('78', '1097', 'NOT STARTED', 0),
('43', '160', 'IN PROGRESS', 19),
('77', '129', 'FINISHED', 256),
('25', '902', 'IN PROGRESS', 7),
('130', '171', 'IN PROGRESS', 160),
('23', '944', 'IN PROGRESS', 41),
('121', '399', 'IN PROGRESS', 675),
('113', '350', 'FINISHED', 528),
('114', '848', 'IN PROGRESS', 127),
('23', '619', 'FINISHED', 419),
('31', '524', 'NOT STARTED', 0),
('40', '96', 'NOT STARTED', 0),
('75', '269', 'FINISHED', 635),
('102', '965', 'NOT STARTED', 0),
('108', '762', 'FINISHED', 118),
('125', '1090', 'IN PROGRESS', 2),
('51', '50', 'IN PROGRESS', 91),
('44', '313', 'FINISHED', 270),
('10', '759', 'FINISHED', 352),
('5', '74', 'NOT STARTED', 0),
('52', '667', 'FINISHED', 105),
('41', '426', 'FINISHED', 1122),
('150', '356', 'IN PROGRESS', 195),
('7', '76', 'FINISHED', 128),
('80', '428', 'IN PROGRESS', 210),
('153', '245', 'NOT STARTED', 0),
('14', '826', 'NOT STARTED', 0),
('97', '531', 'IN PROGRESS', 352),
('28', '295', 'FINISHED', 311),
('68', '181', 'IN PROGRESS', 218),
('121', '78', 'FINISHED', 720),
('36', '214', 'NOT STARTED', 0),
('147', '207', 'FINISHED', 320),
('56', '412', 'NOT STARTED', 0),
('105', '36', 'IN PROGRESS', 79),
('143', '416', 'FINISHED', 193),
('147', '123', 'FINISHED', 291),
('24', '629', 'NOT STARTED', 0),
('101', '201', 'IN PROGRESS', 204),
('3', '423', 'FINISHED', 240),
('120', '873', 'FINISHED', 192),
('98', '5', 'FINISHED', 435),
('87', '208', 'FINISHED', 331),
('30', '493', 'IN PROGRESS', 55)
;