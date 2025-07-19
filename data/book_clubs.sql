CREATE TABLE bookclubs (
    clubid      SERIAL PRIMARY KEY,
    name        VARCHAR(255),
    description TEXT,
    max_members INT NOT NULL
);

CREATE TABLE production.bookclubs (
    clubid      SERIAL PRIMARY KEY,
    name        VARCHAR(255),
    description TEXT,
    max_members INT NOT NULL
);

CREATE TABLE bookclub_creators (
    clubid    INT PRIMARY KEY,
    userid    INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (clubid) REFERENCES bookclubs(clubid) ON DELETE CASCADE,
    FOREIGN KEY (userid) REFERENCES users(userid)     ON DELETE CASCADE
);

CREATE TABLE production.bookclub_creators (
    clubid    INT PRIMARY KEY,
    userid    INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (clubid) REFERENCES bookclubs(clubid) ON DELETE CASCADE,
    FOREIGN KEY (userid) REFERENCES users(userid)     ON DELETE CASCADE
);

CREATE TABLE bookclub_members (
    clubid    INT,
    userid    INT,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (clubid, userid),
    FOREIGN KEY (clubid) REFERENCES bookclubs(clubid) ON DELETE CASCADE,
    FOREIGN KEY (userid) REFERENCES users(userid)     ON DELETE CASCADE
);

CREATE TABLE production.bookclub_members (
    clubid    INT,
    userid    INT,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (clubid, userid),
    FOREIGN KEY (clubid) REFERENCES bookclubs(clubid) ON DELETE CASCADE,
    FOREIGN KEY (userid) REFERENCES users(userid)     ON DELETE CASCADE
);

CREATE TABLE bookclub_reads (
    clubid     INT,
    bookid     INT,
    start_date DATE,
    end_date   DATE,
    is_current BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (clubid, bookid),
    FOREIGN KEY (clubid) REFERENCES bookclubs(clubid) ON DELETE CASCADE,
    FOREIGN KEY (bookid) REFERENCES books(bookid)     ON DELETE CASCADE
);

CREATE TABLE production.bookclub_reads (
    clubid     INT,
    bookid     INT,
    start_date DATE,
    end_date   DATE,
    is_current BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (clubid, bookid),
    FOREIGN KEY (clubid) REFERENCES bookclubs(clubid) ON DELETE CASCADE,
    FOREIGN KEY (bookid) REFERENCES books(bookid)     ON DELETE CASCADE
);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (1, 'Book Club 1', 'This is the description for Book Club 1.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (1, 42);
INSERT INTO bookclub_members (clubid, userid) VALUES (1, 112);
INSERT INTO bookclub_members (clubid, userid) VALUES (1, 42);
INSERT INTO bookclub_members (clubid, userid) VALUES (1, 124);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (1, 333, '2025-07-15', '2025-09-01', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (1, 249, '2025-07-11', '2025-08-24', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (1, 21, '2025-07-15', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (1, 669, '2025-02-18', '2025-03-20', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (1, 655, '2025-03-11', '2025-04-10', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (2, 'Book Club 2', 'This is the description for Book Club 2.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (2, 291);
INSERT INTO bookclub_members (clubid, userid) VALUES (2, 291);
INSERT INTO bookclub_members (clubid, userid) VALUES (2, 110);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (2, 119, '2025-06-24', '2025-08-05', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (2, 78, '2025-06-13', '2025-07-13', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (2, 763, '2025-05-17', '2025-06-16', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (2, 139, '2025-01-29', '2025-02-28', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (3, 'Book Club 3', 'This is the description for Book Club 3.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (3, 97);
INSERT INTO bookclub_members (clubid, userid) VALUES (3, 97);
INSERT INTO bookclub_members (clubid, userid) VALUES (3, 324);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (3, 168, '2025-06-30', '2025-08-20', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (3, 428, '2025-06-20', '2025-08-29', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (3, 156, '2025-07-13', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (3, 700, '2025-04-21', '2025-05-21', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (3, 5, '2025-01-08', '2025-02-07', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (3, 655, '2025-04-19', '2025-05-19', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (4, 'Book Club 4', 'This is the description for Book Club 4.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (4, 236);
INSERT INTO bookclub_members (clubid, userid) VALUES (4, 9);
INSERT INTO bookclub_members (clubid, userid) VALUES (4, 236);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (4, 932, '2025-06-23', '2025-08-08', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (4, 359, '2025-06-24', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (4, 629, '2025-07-12', '2025-08-28', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (4, 678, '2025-02-18', '2025-03-20', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (5, 'Book Club 5', 'This is the description for Book Club 5.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (5, 384);
INSERT INTO bookclub_members (clubid, userid) VALUES (5, 384);
INSERT INTO bookclub_members (clubid, userid) VALUES (5, 347);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (5, 698, '2025-06-24', '2025-08-24', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (5, 870, '2025-06-20', '2025-08-29', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (5, 662, '2025-07-17', '2025-08-06', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (5, 453, '2025-04-16', '2025-05-16', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (5, 10, '2025-04-20', '2025-05-20', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (5, 932, '2025-06-02', '2025-07-02', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (6, 'Book Club 6', 'This is the description for Book Club 6.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (6, 379);
INSERT INTO bookclub_members (clubid, userid) VALUES (6, 152);
INSERT INTO bookclub_members (clubid, userid) VALUES (6, 379);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (6, 523, '2025-06-28', '2025-08-28', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (6, 662, '2025-06-23', '2025-08-05', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (6, 313, '2025-05-11', '2025-06-10', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (7, 'Book Club 7', 'This is the description for Book Club 7.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (7, 263);
INSERT INTO bookclub_members (clubid, userid) VALUES (7, 241);
INSERT INTO bookclub_members (clubid, userid) VALUES (7, 263);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (7, 411, '2025-07-04', '2025-08-20', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (7, 288, '2025-02-28', '2025-03-30', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (7, 972, '2025-05-07', '2025-06-06', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (8, 'Book Club 8', 'This is the description for Book Club 8.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (8, 400);
INSERT INTO bookclub_members (clubid, userid) VALUES (8, 423);
INSERT INTO bookclub_members (clubid, userid) VALUES (8, 45);
INSERT INTO bookclub_members (clubid, userid) VALUES (8, 271);
INSERT INTO bookclub_members (clubid, userid) VALUES (8, 400);
INSERT INTO bookclub_members (clubid, userid) VALUES (8, 50);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (8, 297, '2025-07-06', '2025-08-22', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (8, 670, '2025-06-21', '2025-08-29', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (8, 397, '2025-03-21', '2025-04-20', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (8, 139, '2025-03-29', '2025-04-28', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (8, 702, '2025-01-01', '2025-01-31', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (9, 'Book Club 9', 'This is the description for Book Club 9.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (9, 51);
INSERT INTO bookclub_members (clubid, userid) VALUES (9, 51);
INSERT INTO bookclub_members (clubid, userid) VALUES (9, 388);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (9, 67, '2025-07-01', '2025-08-02', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (9, 426, '2025-04-04', '2025-05-04', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (9, 703, '2025-02-19', '2025-03-21', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (9, 78, '2025-03-25', '2025-04-24', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (10, 'Book Club 10', 'This is the description for Book Club 10.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (10, 188);
INSERT INTO bookclub_members (clubid, userid) VALUES (10, 169);
INSERT INTO bookclub_members (clubid, userid) VALUES (10, 184);
INSERT INTO bookclub_members (clubid, userid) VALUES (10, 24);
INSERT INTO bookclub_members (clubid, userid) VALUES (10, 411);
INSERT INTO bookclub_members (clubid, userid) VALUES (10, 188);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (10, 69, '2025-06-21', '2025-09-01', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (10, 870, '2025-03-04', '2025-04-03', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (10, 231, '2025-03-15', '2025-04-14', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (11, 'Book Club 11', 'This is the description for Book Club 11.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (11, 378);
INSERT INTO bookclub_members (clubid, userid) VALUES (11, 292);
INSERT INTO bookclub_members (clubid, userid) VALUES (11, 175);
INSERT INTO bookclub_members (clubid, userid) VALUES (11, 433);
INSERT INTO bookclub_members (clubid, userid) VALUES (11, 308);
INSERT INTO bookclub_members (clubid, userid) VALUES (11, 345);
INSERT INTO bookclub_members (clubid, userid) VALUES (11, 378);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (11, 94, '2025-07-01', '2025-08-14', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (11, 410, '2025-06-21', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (11, 463, '2025-02-23', '2025-03-25', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (11, 865, '2025-02-19', '2025-03-21', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (12, 'Book Club 12', 'This is the description for Book Club 12.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (12, 193);
INSERT INTO bookclub_members (clubid, userid) VALUES (12, 193);
INSERT INTO bookclub_members (clubid, userid) VALUES (12, 328);
INSERT INTO bookclub_members (clubid, userid) VALUES (12, 406);
INSERT INTO bookclub_members (clubid, userid) VALUES (12, 120);
INSERT INTO bookclub_members (clubid, userid) VALUES (12, 219);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (12, 16, '2025-06-23', '2025-08-26', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (12, 762, '2025-07-16', '2025-08-08', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (12, 79, '2025-07-14', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (12, 815, '2025-04-30', '2025-05-30', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (12, 66, '2025-03-26', '2025-04-25', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (13, 'Book Club 13', 'This is the description for Book Club 13.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (13, 78);
INSERT INTO bookclub_members (clubid, userid) VALUES (13, 228);
INSERT INTO bookclub_members (clubid, userid) VALUES (13, 78);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (13, 45, '2025-06-24', '2025-08-07', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (13, 162, '2025-06-18', '2025-08-06', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (13, 403, '2025-06-29', '2025-08-19', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (13, 685, '2025-03-16', '2025-04-15', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (13, 931, '2025-05-08', '2025-06-07', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (14, 'Book Club 14', 'This is the description for Book Club 14.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (14, 342);
INSERT INTO bookclub_members (clubid, userid) VALUES (14, 342);
INSERT INTO bookclub_members (clubid, userid) VALUES (14, 391);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (14, 16, '2025-06-22', '2025-08-22', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (14, 980, '2025-02-28', '2025-03-30', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (14, 420, '2025-02-10', '2025-03-12', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (14, 251, '2025-03-26', '2025-04-25', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (15, 'Book Club 15', 'This is the description for Book Club 15.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (15, 124);
INSERT INTO bookclub_members (clubid, userid) VALUES (15, 124);
INSERT INTO bookclub_members (clubid, userid) VALUES (15, 324);
INSERT INTO bookclub_members (clubid, userid) VALUES (15, 215);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (15, 21, '2025-06-18', '2025-08-24', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (15, 413, '2025-04-16', '2025-05-16', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (15, 324, '2024-12-23', '2025-01-22', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (15, 762, '2025-03-20', '2025-04-19', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (16, 'Book Club 16', 'This is the description for Book Club 16.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (16, 52);
INSERT INTO bookclub_members (clubid, userid) VALUES (16, 297);
INSERT INTO bookclub_members (clubid, userid) VALUES (16, 28);
INSERT INTO bookclub_members (clubid, userid) VALUES (16, 52);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (16, 1007, '2025-07-11', '2025-08-17', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (16, 297, '2025-02-04', '2025-03-06', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (17, 'Book Club 17', 'This is the description for Book Club 17.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (17, 299);
INSERT INTO bookclub_members (clubid, userid) VALUES (17, 299);
INSERT INTO bookclub_members (clubid, userid) VALUES (17, 310);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (17, 298, '2025-07-01', '2025-08-29', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (17, 147, '2025-06-22', '2025-08-02', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (17, 204, '2025-06-29', '2025-08-08', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (17, 969, '2025-02-07', '2025-03-09', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (17, 447, '2025-02-23', '2025-03-25', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (18, 'Book Club 18', 'This is the description for Book Club 18.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (18, 175);
INSERT INTO bookclub_members (clubid, userid) VALUES (18, 39);
INSERT INTO bookclub_members (clubid, userid) VALUES (18, 10);
INSERT INTO bookclub_members (clubid, userid) VALUES (18, 365);
INSERT INTO bookclub_members (clubid, userid) VALUES (18, 175);
INSERT INTO bookclub_members (clubid, userid) VALUES (18, 276);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (18, 337, '2025-07-04', '2025-09-01', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (18, 96, '2025-07-02', '2025-08-06', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (18, 181, '2025-07-05', '2025-08-29', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (18, 93, '2025-05-26', '2025-06-25', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (18, 85, '2025-03-21', '2025-04-20', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (19, 'Book Club 19', 'This is the description for Book Club 19.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (19, 120);
INSERT INTO bookclub_members (clubid, userid) VALUES (19, 392);
INSERT INTO bookclub_members (clubid, userid) VALUES (19, 120);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (19, 570, '2025-07-07', '2025-08-23', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (19, 685, '2025-07-16', '2025-08-27', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (19, 797, '2025-07-12', '2025-08-12', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (19, 763, '2025-05-18', '2025-06-17', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (19, 400, '2025-06-03', '2025-07-03', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (20, 'Book Club 20', 'This is the description for Book Club 20.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (20, 86);
INSERT INTO bookclub_members (clubid, userid) VALUES (20, 312);
INSERT INTO bookclub_members (clubid, userid) VALUES (20, 2);
INSERT INTO bookclub_members (clubid, userid) VALUES (20, 92);
INSERT INTO bookclub_members (clubid, userid) VALUES (20, 86);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (20, 147, '2025-06-18', '2025-08-20', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (20, 156, '2025-06-20', '2025-08-05', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (20, 98, '2025-06-30', '2025-08-20', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (20, 865, '2025-04-25', '2025-05-25', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (20, 1032, '2025-03-07', '2025-04-06', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (20, 100, '2025-02-20', '2025-03-22', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (21, 'Book Club 21', 'This is the description for Book Club 21.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (21, 422);
INSERT INTO bookclub_members (clubid, userid) VALUES (21, 422);
INSERT INTO bookclub_members (clubid, userid) VALUES (21, 311);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (21, 147, '2025-06-19', '2025-08-09', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (21, 413, '2025-07-13', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (21, 629, '2025-04-20', '2025-05-20', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (21, 866, '2025-03-05', '2025-04-04', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (22, 'Book Club 22', 'This is the description for Book Club 22.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (22, 197);
INSERT INTO bookclub_members (clubid, userid) VALUES (22, 197);
INSERT INTO bookclub_members (clubid, userid) VALUES (22, 277);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (22, 404, '2025-07-05', '2025-08-11', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (22, 763, '2025-07-11', '2025-08-20', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (22, 45, '2025-06-12', '2025-07-12', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (22, 1068, '2025-02-11', '2025-03-13', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (22, 787, '2025-04-14', '2025-05-14', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (23, 'Book Club 23', 'This is the description for Book Club 23.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (23, 187);
INSERT INTO bookclub_members (clubid, userid) VALUES (23, 187);
INSERT INTO bookclub_members (clubid, userid) VALUES (23, 277);
INSERT INTO bookclub_members (clubid, userid) VALUES (23, 391);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (23, 1007, '2025-06-29', '2025-08-13', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (23, 77, '2025-06-21', '2025-09-01', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (23, 669, '2025-06-25', '2025-08-21', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (23, 824, '2025-03-02', '2025-04-01', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (23, 702, '2025-03-30', '2025-04-29', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (23, 299, '2025-01-09', '2025-02-08', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (24, 'Book Club 24', 'This is the description for Book Club 24.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (24, 256);
INSERT INTO bookclub_members (clubid, userid) VALUES (24, 256);
INSERT INTO bookclub_members (clubid, userid) VALUES (24, 217);
INSERT INTO bookclub_members (clubid, userid) VALUES (24, 154);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (24, 2, '2025-07-08', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (24, 1052, '2025-06-22', '2025-08-06', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (24, 826, '2025-01-17', '2025-02-16', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (24, 935, '2025-05-11', '2025-06-10', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (24, 302, '2025-03-28', '2025-04-27', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (25, 'Book Club 25', 'This is the description for Book Club 25.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (25, 424);
INSERT INTO bookclub_members (clubid, userid) VALUES (25, 424);
INSERT INTO bookclub_members (clubid, userid) VALUES (25, 398);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (25, 110, '2025-07-15', '2025-08-26', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (25, 1068, '2025-06-24', '2025-09-01', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (25, 639, '2025-06-26', '2025-08-13', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (25, 413, '2025-05-21', '2025-06-20', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (26, 'Book Club 26', 'This is the description for Book Club 26.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (26, 127);
INSERT INTO bookclub_members (clubid, userid) VALUES (26, 389);
INSERT INTO bookclub_members (clubid, userid) VALUES (26, 127);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (26, 354, '2025-06-26', '2025-08-27', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (26, 824, '2025-06-19', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (26, 151, '2025-05-17', '2025-06-16', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (26, 249, '2025-06-15', '2025-07-15', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (26, 565, '2025-02-21', '2025-03-23', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (27, 'Book Club 27', 'This is the description for Book Club 27.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (27, 128);
INSERT INTO bookclub_members (clubid, userid) VALUES (27, 128);
INSERT INTO bookclub_members (clubid, userid) VALUES (27, 209);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (27, 944, '2025-06-20', '2025-08-26', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (27, 24, '2025-05-14', '2025-06-13', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (27, 288, '2025-03-07', '2025-04-06', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (28, 'Book Club 28', 'This is the description for Book Club 28.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (28, 239);
INSERT INTO bookclub_members (clubid, userid) VALUES (28, 328);
INSERT INTO bookclub_members (clubid, userid) VALUES (28, 239);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (28, 359, '2025-06-27', '2025-08-07', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (28, 1, '2025-03-31', '2025-04-30', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (29, 'Book Club 29', 'This is the description for Book Club 29.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (29, 39);
INSERT INTO bookclub_members (clubid, userid) VALUES (29, 257);
INSERT INTO bookclub_members (clubid, userid) VALUES (29, 39);
INSERT INTO bookclub_members (clubid, userid) VALUES (29, 119);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (29, 494, '2025-06-26', '2025-08-12', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (29, 394, '2025-04-28', '2025-05-28', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (30, 'Book Club 30', 'This is the description for Book Club 30.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (30, 411);
INSERT INTO bookclub_members (clubid, userid) VALUES (30, 411);
INSERT INTO bookclub_members (clubid, userid) VALUES (30, 84);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (30, 597, '2025-07-05', '2025-08-28', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (30, 1007, '2025-07-11', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (30, 131, '2025-06-22', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (30, 16, '2025-04-27', '2025-05-27', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (30, 835, '2025-02-22', '2025-03-24', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (31, 'Book Club 31', 'This is the description for Book Club 31.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (31, 268);
INSERT INTO bookclub_members (clubid, userid) VALUES (31, 268);
INSERT INTO bookclub_members (clubid, userid) VALUES (31, 151);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (31, 676, '2025-07-01', '2025-08-13', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (31, 180, '2025-07-14', '2025-08-09', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (31, 685, '2025-06-01', '2025-07-01', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (31, 410, '2025-04-08', '2025-05-08', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (31, 793, '2025-05-05', '2025-06-04', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (32, 'Book Club 32', 'This is the description for Book Club 32.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (32, 417);
INSERT INTO bookclub_members (clubid, userid) VALUES (32, 417);
INSERT INTO bookclub_members (clubid, userid) VALUES (32, 323);
INSERT INTO bookclub_members (clubid, userid) VALUES (32, 143);
INSERT INTO bookclub_members (clubid, userid) VALUES (32, 47);
INSERT INTO bookclub_members (clubid, userid) VALUES (32, 51);
INSERT INTO bookclub_members (clubid, userid) VALUES (32, 372);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (32, 484, '2025-07-09', '2025-08-02', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (32, 53, '2025-02-08', '2025-03-10', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (33, 'Book Club 33', 'This is the description for Book Club 33.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (33, 115);
INSERT INTO bookclub_members (clubid, userid) VALUES (33, 115);
INSERT INTO bookclub_members (clubid, userid) VALUES (33, 52);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (33, 466, '2025-06-30', '2025-08-26', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (33, 871, '2025-05-10', '2025-06-09', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (33, 515, '2025-04-03', '2025-05-03', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (34, 'Book Club 34', 'This is the description for Book Club 34.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (34, 227);
INSERT INTO bookclub_members (clubid, userid) VALUES (34, 354);
INSERT INTO bookclub_members (clubid, userid) VALUES (34, 227);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (34, 663, '2025-07-08', '2025-08-25', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (34, 426, '2025-07-11', '2025-08-25', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (34, 534, '2025-05-07', '2025-06-06', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (35, 'Book Club 35', 'This is the description for Book Club 35.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (35, 185);
INSERT INTO bookclub_members (clubid, userid) VALUES (35, 420);
INSERT INTO bookclub_members (clubid, userid) VALUES (35, 235);
INSERT INTO bookclub_members (clubid, userid) VALUES (35, 304);
INSERT INTO bookclub_members (clubid, userid) VALUES (35, 88);
INSERT INTO bookclub_members (clubid, userid) VALUES (35, 185);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (35, 295, '2025-06-28', '2025-08-27', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (35, 835, '2025-06-26', '2025-08-04', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (35, 79, '2025-05-16', '2025-06-15', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (35, 454, '2025-05-16', '2025-06-15', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (35, 966, '2025-05-17', '2025-06-16', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (36, 'Book Club 36', 'This is the description for Book Club 36.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (36, 178);
INSERT INTO bookclub_members (clubid, userid) VALUES (36, 178);
INSERT INTO bookclub_members (clubid, userid) VALUES (36, 113);
INSERT INTO bookclub_members (clubid, userid) VALUES (36, 154);
INSERT INTO bookclub_members (clubid, userid) VALUES (36, 253);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (36, 823, '2025-06-22', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (36, 36, '2025-07-06', '2025-08-22', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (36, 670, '2025-05-05', '2025-06-04', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (36, 842, '2024-12-30', '2025-01-29', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (37, 'Book Club 37', 'This is the description for Book Club 37.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (37, 45);
INSERT INTO bookclub_members (clubid, userid) VALUES (37, 225);
INSERT INTO bookclub_members (clubid, userid) VALUES (37, 45);
INSERT INTO bookclub_members (clubid, userid) VALUES (37, 269);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (37, 30, '2025-07-06', '2025-08-26', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (37, 54, '2025-06-23', '2025-08-14', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (37, 570, '2025-06-23', '2025-08-14', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (37, 797, '2025-03-11', '2025-04-10', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (37, 484, '2025-06-15', '2025-07-15', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (37, 421, '2025-04-26', '2025-05-26', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (38, 'Book Club 38', 'This is the description for Book Club 38.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (38, 192);
INSERT INTO bookclub_members (clubid, userid) VALUES (38, 192);
INSERT INTO bookclub_members (clubid, userid) VALUES (38, 347);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (38, 55, '2025-06-25', '2025-08-05', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (38, 821, '2025-07-15', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (38, 81, '2025-07-16', '2025-08-11', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (38, 141, '2025-05-02', '2025-06-01', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (39, 'Book Club 39', 'This is the description for Book Club 39.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (39, 412);
INSERT INTO bookclub_members (clubid, userid) VALUES (39, 265);
INSERT INTO bookclub_members (clubid, userid) VALUES (39, 412);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (39, 799, '2025-06-26', '2025-08-26', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (39, 432, '2025-07-08', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (39, 50, '2025-06-26', '2025-08-10', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (39, 821, '2025-01-08', '2025-02-07', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (39, 418, '2025-03-06', '2025-04-05', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (39, 277, '2025-02-19', '2025-03-21', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (40, 'Book Club 40', 'This is the description for Book Club 40.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (40, 202);
INSERT INTO bookclub_members (clubid, userid) VALUES (40, 202);
INSERT INTO bookclub_members (clubid, userid) VALUES (40, 125);
INSERT INTO bookclub_members (clubid, userid) VALUES (40, 381);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (40, 797, '2025-07-03', '2025-08-10', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (40, 63, '2025-07-04', '2025-08-04', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (40, 264, '2025-06-22', '2025-08-14', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (40, 92, '2025-05-19', '2025-06-18', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (41, 'Book Club 41', 'This is the description for Book Club 41.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (41, 202);
INSERT INTO bookclub_members (clubid, userid) VALUES (41, 202);
INSERT INTO bookclub_members (clubid, userid) VALUES (41, 410);
INSERT INTO bookclub_members (clubid, userid) VALUES (41, 76);
INSERT INTO bookclub_members (clubid, userid) VALUES (41, 93);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (41, 5, '2025-07-15', '2025-08-21', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (41, 415, '2025-07-01', '2025-08-09', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (41, 411, '2025-05-10', '2025-06-09', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (41, 230, '2025-01-29', '2025-02-28', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (42, 'Book Club 42', 'This is the description for Book Club 42.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (42, 232);
INSERT INTO bookclub_members (clubid, userid) VALUES (42, 360);
INSERT INTO bookclub_members (clubid, userid) VALUES (42, 425);
INSERT INTO bookclub_members (clubid, userid) VALUES (42, 232);
INSERT INTO bookclub_members (clubid, userid) VALUES (42, 80);
INSERT INTO bookclub_members (clubid, userid) VALUES (42, 337);
INSERT INTO bookclub_members (clubid, userid) VALUES (42, 304);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (42, 477, '2025-06-29', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (42, 1032, '2025-07-12', '2025-08-08', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (42, 250, '2025-07-11', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (42, 765, '2025-03-05', '2025-04-04', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (42, 80, '2025-06-14', '2025-07-14', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (42, 678, '2025-06-07', '2025-07-07', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (43, 'Book Club 43', 'This is the description for Book Club 43.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (43, 432);
INSERT INTO bookclub_members (clubid, userid) VALUES (43, 432);
INSERT INTO bookclub_members (clubid, userid) VALUES (43, 34);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (43, 251, '2025-06-28', '2025-08-10', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (43, 289, '2025-06-23', '2025-08-13', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (43, 498, '2025-06-29', '2025-08-07', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (43, 872, '2025-02-03', '2025-03-05', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (43, 969, '2025-05-28', '2025-06-27', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (44, 'Book Club 44', 'This is the description for Book Club 44.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (44, 377);
INSERT INTO bookclub_members (clubid, userid) VALUES (44, 377);
INSERT INTO bookclub_members (clubid, userid) VALUES (44, 167);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (44, 538, '2025-07-14', '2025-08-28', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (44, 766, '2025-01-12', '2025-02-11', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (44, 278, '2025-05-21', '2025-06-20', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (45, 'Book Club 45', 'This is the description for Book Club 45.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (45, 101);
INSERT INTO bookclub_members (clubid, userid) VALUES (45, 35);
INSERT INTO bookclub_members (clubid, userid) VALUES (45, 101);
INSERT INTO bookclub_members (clubid, userid) VALUES (45, 202);
INSERT INTO bookclub_members (clubid, userid) VALUES (45, 209);
INSERT INTO bookclub_members (clubid, userid) VALUES (45, 21);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (45, 570, '2025-06-28', '2025-08-12', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (45, 873, '2025-01-17', '2025-02-16', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (45, 935, '2025-04-03', '2025-05-03', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (45, 454, '2025-06-10', '2025-07-10', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (46, 'Book Club 46', 'This is the description for Book Club 46.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (46, 58);
INSERT INTO bookclub_members (clubid, userid) VALUES (46, 58);
INSERT INTO bookclub_members (clubid, userid) VALUES (46, 235);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (46, 50, '2025-06-21', '2025-08-20', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (46, 477, '2025-01-30', '2025-03-01', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (46, 133, '2025-01-05', '2025-02-04', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (47, 'Book Club 47', 'This is the description for Book Club 47.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (47, 82);
INSERT INTO bookclub_members (clubid, userid) VALUES (47, 257);
INSERT INTO bookclub_members (clubid, userid) VALUES (47, 82);
INSERT INTO bookclub_members (clubid, userid) VALUES (47, 117);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (47, 50, '2025-07-17', '2025-08-16', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (47, 868, '2025-07-16', '2025-08-22', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (47, 484, '2025-07-17', '2025-08-14', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (47, 296, '2025-04-06', '2025-05-06', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (48, 'Book Club 48', 'This is the description for Book Club 48.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (48, 85);
INSERT INTO bookclub_members (clubid, userid) VALUES (48, 441);
INSERT INTO bookclub_members (clubid, userid) VALUES (48, 36);
INSERT INTO bookclub_members (clubid, userid) VALUES (48, 85);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (48, 153, '2025-06-23', '2025-08-28', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (48, 35, '2025-02-25', '2025-03-27', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (48, 385, '2025-02-24', '2025-03-26', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (49, 'Book Club 49', 'This is the description for Book Club 49.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (49, 200);
INSERT INTO bookclub_members (clubid, userid) VALUES (49, 200);
INSERT INTO bookclub_members (clubid, userid) VALUES (49, 361);
INSERT INTO bookclub_members (clubid, userid) VALUES (49, 43);
INSERT INTO bookclub_members (clubid, userid) VALUES (49, 111);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (49, 289, '2025-07-17', '2025-08-08', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (49, 337, '2025-07-08', '2025-09-01', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (49, 765, '2025-06-18', '2025-08-06', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (49, 619, '2025-03-25', '2025-04-24', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (50, 'Book Club 50', 'This is the description for Book Club 50.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (50, 168);
INSERT INTO bookclub_members (clubid, userid) VALUES (50, 144);
INSERT INTO bookclub_members (clubid, userid) VALUES (50, 306);
INSERT INTO bookclub_members (clubid, userid) VALUES (50, 168);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (50, 1022, '2025-07-14', '2025-08-28', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (50, 650, '2024-12-28', '2025-01-27', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (50, 394, '2025-04-20', '2025-05-20', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (51, 'Book Club 51', 'This is the description for Book Club 51.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (51, 295);
INSERT INTO bookclub_members (clubid, userid) VALUES (51, 126);
INSERT INTO bookclub_members (clubid, userid) VALUES (51, 295);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (51, 35, '2025-06-28', '2025-08-15', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (51, 826, '2025-05-19', '2025-06-18', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (52, 'Book Club 52', 'This is the description for Book Club 52.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (52, 45);
INSERT INTO bookclub_members (clubid, userid) VALUES (52, 45);
INSERT INTO bookclub_members (clubid, userid) VALUES (52, 37);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (52, 142, '2025-06-23', '2025-08-13', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (52, 394, '2025-04-22', '2025-05-22', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (52, 998, '2025-04-22', '2025-05-22', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (52, 213, '2025-01-12', '2025-02-11', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (53, 'Book Club 53', 'This is the description for Book Club 53.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (53, 18);
INSERT INTO bookclub_members (clubid, userid) VALUES (53, 18);
INSERT INTO bookclub_members (clubid, userid) VALUES (53, 372);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (53, 99, '2025-06-26', '2025-08-19', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (53, 93, '2025-06-27', '2025-08-06', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (53, 933, '2025-04-29', '2025-05-29', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (53, 159, '2025-04-16', '2025-05-16', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (54, 'Book Club 54', 'This is the description for Book Club 54.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (54, 307);
INSERT INTO bookclub_members (clubid, userid) VALUES (54, 130);
INSERT INTO bookclub_members (clubid, userid) VALUES (54, 307);
INSERT INTO bookclub_members (clubid, userid) VALUES (54, 268);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (54, 81, '2025-07-18', '2025-08-05', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (54, 133, '2025-01-27', '2025-02-26', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (54, 2, '2025-03-09', '2025-04-08', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (55, 'Book Club 55', 'This is the description for Book Club 55.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (55, 342);
INSERT INTO bookclub_members (clubid, userid) VALUES (55, 342);
INSERT INTO bookclub_members (clubid, userid) VALUES (55, 102);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (55, 664, '2025-07-13', '2025-08-20', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (55, 36, '2025-07-18', '2025-08-02', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (55, 816, '2025-05-29', '2025-06-28', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (56, 'Book Club 56', 'This is the description for Book Club 56.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (56, 209);
INSERT INTO bookclub_members (clubid, userid) VALUES (56, 209);
INSERT INTO bookclub_members (clubid, userid) VALUES (56, 29);
INSERT INTO bookclub_members (clubid, userid) VALUES (56, 183);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (56, 565, '2025-06-28', '2025-08-07', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (56, 58, '2025-02-28', '2025-03-30', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (57, 'Book Club 57', 'This is the description for Book Club 57.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (57, 55);
INSERT INTO bookclub_members (clubid, userid) VALUES (57, 116);
INSERT INTO bookclub_members (clubid, userid) VALUES (57, 70);
INSERT INTO bookclub_members (clubid, userid) VALUES (57, 55);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (57, 1097, '2025-06-19', '2025-08-27', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (57, 54, '2025-07-05', '2025-08-14', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (57, 678, '2025-06-27', '2025-08-11', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (57, 511, '2025-06-13', '2025-07-13', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (57, 478, '2024-12-29', '2025-01-28', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (57, 639, '2025-01-27', '2025-02-26', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (58, 'Book Club 58', 'This is the description for Book Club 58.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (58, 123);
INSERT INTO bookclub_members (clubid, userid) VALUES (58, 262);
INSERT INTO bookclub_members (clubid, userid) VALUES (58, 170);
INSERT INTO bookclub_members (clubid, userid) VALUES (58, 242);
INSERT INTO bookclub_members (clubid, userid) VALUES (58, 123);
INSERT INTO bookclub_members (clubid, userid) VALUES (58, 317);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (58, 89, '2025-07-09', '2025-08-13', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (58, 130, '2025-06-18', '2025-08-20', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (58, 650, '2025-07-05', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (58, 576, '2025-02-13', '2025-03-15', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (59, 'Book Club 59', 'This is the description for Book Club 59.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (59, 363);
INSERT INTO bookclub_members (clubid, userid) VALUES (59, 118);
INSERT INTO bookclub_members (clubid, userid) VALUES (59, 363);
INSERT INTO bookclub_members (clubid, userid) VALUES (59, 150);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (59, 425, '2025-06-28', '2025-08-17', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (59, 511, '2025-05-26', '2025-06-25', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (59, 420, '2025-01-31', '2025-03-02', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (59, 4, '2025-01-15', '2025-02-14', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (60, 'Book Club 60', 'This is the description for Book Club 60.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (60, 121);
INSERT INTO bookclub_members (clubid, userid) VALUES (60, 121);
INSERT INTO bookclub_members (clubid, userid) VALUES (60, 133);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (60, 278, '2025-06-20', '2025-08-23', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (60, 133, '2025-05-24', '2025-06-23', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (60, 463, '2025-06-06', '2025-07-06', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (60, 524, '2025-04-23', '2025-05-23', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (61, 'Book Club 61', 'This is the description for Book Club 61.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (61, 330);
INSERT INTO bookclub_members (clubid, userid) VALUES (61, 272);
INSERT INTO bookclub_members (clubid, userid) VALUES (61, 273);
INSERT INTO bookclub_members (clubid, userid) VALUES (61, 330);
INSERT INTO bookclub_members (clubid, userid) VALUES (61, 406);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (61, 431, '2025-07-04', '2025-08-25', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (61, 534, '2025-05-04', '2025-06-03', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (61, 36, '2025-01-09', '2025-02-08', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (62, 'Book Club 62', 'This is the description for Book Club 62.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (62, 7);
INSERT INTO bookclub_members (clubid, userid) VALUES (62, 112);
INSERT INTO bookclub_members (clubid, userid) VALUES (62, 292);
INSERT INTO bookclub_members (clubid, userid) VALUES (62, 7);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (62, 26, '2025-07-07', '2025-08-09', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (62, 765, '2025-06-27', '2025-09-01', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (62, 77, '2025-01-01', '2025-01-31', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (62, 759, '2025-05-05', '2025-06-04', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (62, 1022, '2024-12-21', '2025-01-20', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (63, 'Book Club 63', 'This is the description for Book Club 63.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (63, 304);
INSERT INTO bookclub_members (clubid, userid) VALUES (63, 304);
INSERT INTO bookclub_members (clubid, userid) VALUES (63, 361);
INSERT INTO bookclub_members (clubid, userid) VALUES (63, 7);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (63, 435, '2025-07-11', '2025-08-06', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (63, 864, '2025-02-02', '2025-03-04', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (63, 251, '2025-01-14', '2025-02-13', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (63, 650, '2025-01-01', '2025-01-31', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (64, 'Book Club 64', 'This is the description for Book Club 64.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (64, 299);
INSERT INTO bookclub_members (clubid, userid) VALUES (64, 297);
INSERT INTO bookclub_members (clubid, userid) VALUES (64, 299);
INSERT INTO bookclub_members (clubid, userid) VALUES (64, 165);
INSERT INTO bookclub_members (clubid, userid) VALUES (64, 287);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (64, 841, '2025-06-29', '2025-08-02', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (64, 400, '2025-06-30', '2025-08-10', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (64, 164, '2025-07-13', '2025-08-08', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (64, 34, '2025-06-01', '2025-07-01', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (65, 'Book Club 65', 'This is the description for Book Club 65.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (65, 10);
INSERT INTO bookclub_members (clubid, userid) VALUES (65, 10);
INSERT INTO bookclub_members (clubid, userid) VALUES (65, 287);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (65, 888, '2025-07-08', '2025-08-29', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (65, 523, '2025-07-03', '2025-08-29', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (65, 119, '2025-04-08', '2025-05-08', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (65, 418, '2025-04-17', '2025-05-17', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (66, 'Book Club 66', 'This is the description for Book Club 66.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (66, 323);
INSERT INTO bookclub_members (clubid, userid) VALUES (66, 323);
INSERT INTO bookclub_members (clubid, userid) VALUES (66, 75);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (66, 53, '2025-07-18', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (66, 77, '2025-07-15', '2025-08-12', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (66, 230, '2025-03-30', '2025-04-29', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (66, 932, '2025-01-02', '2025-02-01', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (67, 'Book Club 67', 'This is the description for Book Club 67.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (67, 104);
INSERT INTO bookclub_members (clubid, userid) VALUES (67, 104);
INSERT INTO bookclub_members (clubid, userid) VALUES (67, 132);
INSERT INTO bookclub_members (clubid, userid) VALUES (67, 375);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (67, 478, '2025-06-29', '2025-09-01', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (67, 787, '2025-03-10', '2025-04-09', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (68, 'Book Club 68', 'This is the description for Book Club 68.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (68, 349);
INSERT INTO bookclub_members (clubid, userid) VALUES (68, 41);
INSERT INTO bookclub_members (clubid, userid) VALUES (68, 349);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (68, 269, '2025-07-05', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (68, 110, '2025-06-22', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (68, 524, '2025-06-11', '2025-07-11', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (69, 'Book Club 69', 'This is the description for Book Club 69.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (69, 399);
INSERT INTO bookclub_members (clubid, userid) VALUES (69, 399);
INSERT INTO bookclub_members (clubid, userid) VALUES (69, 9);
INSERT INTO bookclub_members (clubid, userid) VALUES (69, 386);
INSERT INTO bookclub_members (clubid, userid) VALUES (69, 327);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (69, 1005, '2025-07-10', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (69, 669, '2025-05-09', '2025-06-08', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (69, 408, '2025-04-22', '2025-05-22', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (69, 313, '2025-01-04', '2025-02-03', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (70, 'Book Club 70', 'This is the description for Book Club 70.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (70, 235);
INSERT INTO bookclub_members (clubid, userid) VALUES (70, 200);
INSERT INTO bookclub_members (clubid, userid) VALUES (70, 235);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (70, 36, '2025-07-02', '2025-08-16', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (70, 481, '2025-07-03', '2025-08-27', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (70, 658, '2025-07-06', '2025-08-28', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (70, 823, '2025-03-04', '2025-04-03', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (71, 'Book Club 71', 'This is the description for Book Club 71.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (71, 395);
INSERT INTO bookclub_members (clubid, userid) VALUES (71, 395);
INSERT INTO bookclub_members (clubid, userid) VALUES (71, 407);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (71, 497, '2025-06-25', '2025-08-24', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (71, 57, '2025-07-11', '2025-08-10', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (71, 931, '2025-07-15', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (71, 870, '2025-02-22', '2025-03-24', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (72, 'Book Club 72', 'This is the description for Book Club 72.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (72, 289);
INSERT INTO bookclub_members (clubid, userid) VALUES (72, 289);
INSERT INTO bookclub_members (clubid, userid) VALUES (72, 295);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (72, 534, '2025-07-15', '2025-08-29', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (72, 30, '2025-07-18', '2025-08-02', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (72, 669, '2025-06-19', '2025-08-22', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (72, 834, '2025-06-14', '2025-07-14', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (73, 'Book Club 73', 'This is the description for Book Club 73.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (73, 412);
INSERT INTO bookclub_members (clubid, userid) VALUES (73, 412);
INSERT INTO bookclub_members (clubid, userid) VALUES (73, 4);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (73, 873, '2025-06-19', '2025-08-20', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (73, 81, '2025-07-01', '2025-08-11', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (73, 18, '2025-07-01', '2025-08-16', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (73, 829, '2025-04-03', '2025-05-03', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (73, 664, '2025-01-08', '2025-02-07', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (73, 766, '2025-04-15', '2025-05-15', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (74, 'Book Club 74', 'This is the description for Book Club 74.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (74, 85);
INSERT INTO bookclub_members (clubid, userid) VALUES (74, 234);
INSERT INTO bookclub_members (clubid, userid) VALUES (74, 85);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (74, 10, '2025-06-22', '2025-08-09', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (74, 155, '2025-07-04', '2025-08-03', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (74, 356, '2025-06-23', '2025-08-21', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (74, 871, '2025-02-16', '2025-03-18', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (74, 18, '2025-01-23', '2025-02-22', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (75, 'Book Club 75', 'This is the description for Book Club 75.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (75, 19);
INSERT INTO bookclub_members (clubid, userid) VALUES (75, 19);
INSERT INTO bookclub_members (clubid, userid) VALUES (75, 51);
INSERT INTO bookclub_members (clubid, userid) VALUES (75, 29);
INSERT INTO bookclub_members (clubid, userid) VALUES (75, 375);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (75, 766, '2025-06-19', '2025-08-09', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (75, 76, '2025-06-19', '2025-08-14', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (75, 144, '2025-06-23', '2025-08-09', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (75, 290, '2025-02-10', '2025-03-12', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (75, 872, '2025-05-02', '2025-06-01', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (76, 'Book Club 76', 'This is the description for Book Club 76.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (76, 71);
INSERT INTO bookclub_members (clubid, userid) VALUES (76, 33);
INSERT INTO bookclub_members (clubid, userid) VALUES (76, 71);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (76, 110, '2025-07-18', '2025-08-08', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (76, 68, '2025-02-19', '2025-03-21', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (76, 420, '2024-12-30', '2025-01-29', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (77, 'Book Club 77', 'This is the description for Book Club 77.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (77, 113);
INSERT INTO bookclub_members (clubid, userid) VALUES (77, 113);
INSERT INTO bookclub_members (clubid, userid) VALUES (77, 77);
INSERT INTO bookclub_members (clubid, userid) VALUES (77, 207);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (77, 1, '2025-06-25', '2025-08-28', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (77, 930, '2025-02-13', '2025-03-15', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (78, 'Book Club 78', 'This is the description for Book Club 78.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (78, 227);
INSERT INTO bookclub_members (clubid, userid) VALUES (78, 139);
INSERT INTO bookclub_members (clubid, userid) VALUES (78, 227);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (78, 453, '2025-07-16', '2025-08-05', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (78, 71, '2025-05-21', '2025-06-20', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (79, 'Book Club 79', 'This is the description for Book Club 79.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (79, 30);
INSERT INTO bookclub_members (clubid, userid) VALUES (79, 39);
INSERT INTO bookclub_members (clubid, userid) VALUES (79, 242);
INSERT INTO bookclub_members (clubid, userid) VALUES (79, 405);
INSERT INTO bookclub_members (clubid, userid) VALUES (79, 216);
INSERT INTO bookclub_members (clubid, userid) VALUES (79, 30);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (79, 298, '2025-06-27', '2025-08-04', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (79, 1068, '2025-07-06', '2025-08-13', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (79, 74, '2025-01-25', '2025-02-24', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (79, 890, '2025-02-02', '2025-03-04', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (79, 208, '2025-06-14', '2025-07-14', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (80, 'Book Club 80', 'This is the description for Book Club 80.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (80, 308);
INSERT INTO bookclub_members (clubid, userid) VALUES (80, 228);
INSERT INTO bookclub_members (clubid, userid) VALUES (80, 73);
INSERT INTO bookclub_members (clubid, userid) VALUES (80, 243);
INSERT INTO bookclub_members (clubid, userid) VALUES (80, 244);
INSERT INTO bookclub_members (clubid, userid) VALUES (80, 308);
INSERT INTO bookclub_members (clubid, userid) VALUES (80, 63);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (80, 1053, '2025-06-26', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (80, 397, '2025-07-08', '2025-08-24', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (80, 152, '2025-06-07', '2025-07-07', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (80, 447, '2025-03-09', '2025-04-08', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (80, 386, '2025-01-19', '2025-02-18', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (81, 'Book Club 81', 'This is the description for Book Club 81.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (81, 335);
INSERT INTO bookclub_members (clubid, userid) VALUES (81, 400);
INSERT INTO bookclub_members (clubid, userid) VALUES (81, 335);
INSERT INTO bookclub_members (clubid, userid) VALUES (81, 343);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (81, 888, '2025-06-29', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (81, 75, '2025-01-16', '2025-02-15', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (81, 29, '2025-02-10', '2025-03-12', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (82, 'Book Club 82', 'This is the description for Book Club 82.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (82, 104);
INSERT INTO bookclub_members (clubid, userid) VALUES (82, 104);
INSERT INTO bookclub_members (clubid, userid) VALUES (82, 378);
INSERT INTO bookclub_members (clubid, userid) VALUES (82, 438);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (82, 157, '2025-06-23', '2025-08-03', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (82, 565, '2025-07-08', '2025-08-17', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (82, 130, '2025-01-17', '2025-02-16', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (82, 411, '2025-01-30', '2025-03-01', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (82, 117, '2025-02-02', '2025-03-04', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (83, 'Book Club 83', 'This is the description for Book Club 83.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (83, 207);
INSERT INTO bookclub_members (clubid, userid) VALUES (83, 326);
INSERT INTO bookclub_members (clubid, userid) VALUES (83, 328);
INSERT INTO bookclub_members (clubid, userid) VALUES (83, 424);
INSERT INTO bookclub_members (clubid, userid) VALUES (83, 207);
INSERT INTO bookclub_members (clubid, userid) VALUES (83, 350);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (83, 18, '2025-06-23', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (83, 231, '2025-03-04', '2025-04-03', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (84, 'Book Club 84', 'This is the description for Book Club 84.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (84, 123);
INSERT INTO bookclub_members (clubid, userid) VALUES (84, 89);
INSERT INTO bookclub_members (clubid, userid) VALUES (84, 123);
INSERT INTO bookclub_members (clubid, userid) VALUES (84, 220);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (84, 834, '2025-06-24', '2025-08-17', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (84, 423, '2025-05-06', '2025-06-05', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (85, 'Book Club 85', 'This is the description for Book Club 85.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (85, 183);
INSERT INTO bookclub_members (clubid, userid) VALUES (85, 96);
INSERT INTO bookclub_members (clubid, userid) VALUES (85, 183);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (85, 28, '2025-06-23', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (85, 382, '2025-06-26', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (85, 151, '2025-07-15', '2025-08-14', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (85, 297, '2025-01-06', '2025-02-05', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (85, 1005, '2025-01-20', '2025-02-19', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (86, 'Book Club 86', 'This is the description for Book Club 86.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (86, 195);
INSERT INTO bookclub_members (clubid, userid) VALUES (86, 195);
INSERT INTO bookclub_members (clubid, userid) VALUES (86, 134);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (86, 576, '2025-07-06', '2025-08-29', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (86, 497, '2025-06-24', '2025-08-12', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (86, 357, '2025-06-26', '2025-08-16', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (86, 929, '2024-12-20', '2025-01-19', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (87, 'Book Club 87', 'This is the description for Book Club 87.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (87, 331);
INSERT INTO bookclub_members (clubid, userid) VALUES (87, 16);
INSERT INTO bookclub_members (clubid, userid) VALUES (87, 331);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (87, 302, '2025-06-23', '2025-08-11', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (87, 932, '2025-06-30', '2025-08-26', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (87, 25, '2025-04-12', '2025-05-12', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (87, 941, '2024-12-27', '2025-01-26', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (87, 100, '2025-02-04', '2025-03-06', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (88, 'Book Club 88', 'This is the description for Book Club 88.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (88, 423);
INSERT INTO bookclub_members (clubid, userid) VALUES (88, 337);
INSERT INTO bookclub_members (clubid, userid) VALUES (88, 423);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (88, 515, '2025-06-22', '2025-08-02', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (88, 432, '2025-02-28', '2025-03-30', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (89, 'Book Club 89', 'This is the description for Book Club 89.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (89, 334);
INSERT INTO bookclub_members (clubid, userid) VALUES (89, 230);
INSERT INTO bookclub_members (clubid, userid) VALUES (89, 334);
INSERT INTO bookclub_members (clubid, userid) VALUES (89, 404);
INSERT INTO bookclub_members (clubid, userid) VALUES (89, 376);
INSERT INTO bookclub_members (clubid, userid) VALUES (89, 282);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (89, 1, '2025-07-09', '2025-08-25', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (89, 662, '2025-07-07', '2025-08-27', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (89, 416, '2025-01-02', '2025-02-01', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (89, 90, '2025-02-15', '2025-03-17', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (90, 'Book Club 90', 'This is the description for Book Club 90.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (90, 181);
INSERT INTO bookclub_members (clubid, userid) VALUES (90, 19);
INSERT INTO bookclub_members (clubid, userid) VALUES (90, 181);
INSERT INTO bookclub_members (clubid, userid) VALUES (90, 14);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (90, 416, '2025-07-14', '2025-09-01', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (90, 252, '2025-07-10', '2025-08-12', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (90, 21, '2025-04-10', '2025-05-10', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (90, 140, '2025-01-30', '2025-03-01', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (91, 'Book Club 91', 'This is the description for Book Club 91.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (91, 398);
INSERT INTO bookclub_members (clubid, userid) VALUES (91, 398);
INSERT INTO bookclub_members (clubid, userid) VALUES (91, 351);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (91, 524, '2025-07-14', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (91, 230, '2025-04-18', '2025-05-18', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (91, 355, '2025-02-22', '2025-03-24', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (92, 'Book Club 92', 'This is the description for Book Club 92.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (92, 138);
INSERT INTO bookclub_members (clubid, userid) VALUES (92, 138);
INSERT INTO bookclub_members (clubid, userid) VALUES (92, 268);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (92, 160, '2025-06-21', '2025-08-02', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (92, 166, '2025-06-28', '2025-08-17', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (92, 827, '2025-06-19', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (92, 823, '2025-01-08', '2025-02-07', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (92, 639, '2025-05-02', '2025-06-01', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (92, 22, '2025-03-02', '2025-04-01', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (93, 'Book Club 93', 'This is the description for Book Club 93.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (93, 10);
INSERT INTO bookclub_members (clubid, userid) VALUES (93, 242);
INSERT INTO bookclub_members (clubid, userid) VALUES (93, 10);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (93, 297, '2025-07-05', '2025-08-17', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (93, 264, '2025-07-02', '2025-08-13', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (93, 866, '2025-05-24', '2025-06-23', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (93, 10, '2025-04-21', '2025-05-21', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (93, 511, '2025-03-06', '2025-04-05', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (94, 'Book Club 94', 'This is the description for Book Club 94.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (94, 265);
INSERT INTO bookclub_members (clubid, userid) VALUES (94, 265);
INSERT INTO bookclub_members (clubid, userid) VALUES (94, 187);
INSERT INTO bookclub_members (clubid, userid) VALUES (94, 295);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (94, 66, '2025-07-06', '2025-08-17', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (94, 152, '2025-06-27', '2025-08-19', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (94, 456, '2025-07-11', '2025-08-13', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (94, 289, '2025-03-09', '2025-04-08', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (94, 793, '2025-06-06', '2025-07-06', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (94, 841, '2025-03-10', '2025-04-09', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (95, 'Book Club 95', 'This is the description for Book Club 95.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (95, 243);
INSERT INTO bookclub_members (clubid, userid) VALUES (95, 162);
INSERT INTO bookclub_members (clubid, userid) VALUES (95, 243);
INSERT INTO bookclub_members (clubid, userid) VALUES (95, 303);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (95, 655, '2025-07-05', '2025-08-29', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (95, 412, '2025-07-08', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (95, 290, '2025-05-17', '2025-06-16', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (96, 'Book Club 96', 'This is the description for Book Club 96.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (96, 299);
INSERT INTO bookclub_members (clubid, userid) VALUES (96, 299);
INSERT INTO bookclub_members (clubid, userid) VALUES (96, 279);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (96, 1014, '2025-06-21', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (96, 385, '2025-07-08', '2025-08-27', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (96, 435, '2025-01-10', '2025-02-09', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (96, 171, '2025-04-07', '2025-05-07', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (97, 'Book Club 97', 'This is the description for Book Club 97.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (97, 374);
INSERT INTO bookclub_members (clubid, userid) VALUES (97, 339);
INSERT INTO bookclub_members (clubid, userid) VALUES (97, 374);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (97, 337, '2025-07-02', '2025-08-07', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (97, 700, '2025-07-06', '2025-08-23', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (97, 523, '2025-04-30', '2025-05-30', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (97, 354, '2025-03-12', '2025-04-11', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (98, 'Book Club 98', 'This is the description for Book Club 98.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (98, 166);
INSERT INTO bookclub_members (clubid, userid) VALUES (98, 166);
INSERT INTO bookclub_members (clubid, userid) VALUES (98, 298);
INSERT INTO bookclub_members (clubid, userid) VALUES (98, 333);
INSERT INTO bookclub_members (clubid, userid) VALUES (98, 250);
INSERT INTO bookclub_members (clubid, userid) VALUES (98, 412);
INSERT INTO bookclub_members (clubid, userid) VALUES (98, 93);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (98, 766, '2025-06-21', '2025-08-03', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (98, 67, '2025-02-21', '2025-03-23', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (99, 'Book Club 99', 'This is the description for Book Club 99.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (99, 205);
INSERT INTO bookclub_members (clubid, userid) VALUES (99, 235);
INSERT INTO bookclub_members (clubid, userid) VALUES (99, 205);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (99, 51, '2025-07-10', '2025-08-08', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (99, 944, '2025-07-10', '2025-08-17', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (99, 207, '2025-03-05', '2025-04-04', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (99, 534, '2025-02-22', '2025-03-24', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (99, 597, '2025-05-11', '2025-06-10', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (100, 'Book Club 100', 'This is the description for Book Club 100.', 3);
INSERT INTO bookclub_creators (clubid, userid) VALUES (100, 67);
INSERT INTO bookclub_members (clubid, userid) VALUES (100, 67);
INSERT INTO bookclub_members (clubid, userid) VALUES (100, 365);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (100, 639, '2025-07-16', '2025-08-16', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (100, 409, '2025-07-07', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (100, 129, '2025-02-23', '2025-03-25', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (100, 842, '2025-03-24', '2025-04-23', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (101, 'Book Club 101', 'This is the description for Book Club 101.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (101, 399);
INSERT INTO bookclub_members (clubid, userid) VALUES (101, 286);
INSERT INTO bookclub_members (clubid, userid) VALUES (101, 399);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (101, 86, '2025-07-01', '2025-08-10', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (101, 662, '2025-07-02', '2025-08-17', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (101, 870, '2025-05-23', '2025-06-22', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (101, 142, '2025-04-27', '2025-05-27', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (102, 'Book Club 102', 'This is the description for Book Club 102.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (102, 218);
INSERT INTO bookclub_members (clubid, userid) VALUES (102, 218);
INSERT INTO bookclub_members (clubid, userid) VALUES (102, 194);
INSERT INTO bookclub_members (clubid, userid) VALUES (102, 387);
INSERT INTO bookclub_members (clubid, userid) VALUES (102, 158);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (102, 139, '2025-07-13', '2025-08-19', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (102, 155, '2025-07-09', '2025-08-19', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (102, 764, '2025-06-18', '2025-08-02', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (102, 1014, '2025-06-03', '2025-07-03', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (102, 14, '2025-03-29', '2025-04-28', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (102, 133, '2025-02-28', '2025-03-30', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (103, 'Book Club 103', 'This is the description for Book Club 103.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (103, 340);
INSERT INTO bookclub_members (clubid, userid) VALUES (103, 300);
INSERT INTO bookclub_members (clubid, userid) VALUES (103, 340);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (103, 759, '2025-07-05', '2025-09-01', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (103, 55, '2025-03-17', '2025-04-16', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (103, 944, '2025-02-27', '2025-03-29', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (103, 75, '2025-05-13', '2025-06-12', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (104, 'Book Club 104', 'This is the description for Book Club 104.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (104, 331);
INSERT INTO bookclub_members (clubid, userid) VALUES (104, 106);
INSERT INTO bookclub_members (clubid, userid) VALUES (104, 331);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (104, 400, '2025-07-07', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (104, 31, '2024-12-26', '2025-01-25', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (104, 511, '2025-01-02', '2025-02-01', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (105, 'Book Club 105', 'This is the description for Book Club 105.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (105, 242);
INSERT INTO bookclub_members (clubid, userid) VALUES (105, 242);
INSERT INTO bookclub_members (clubid, userid) VALUES (105, 340);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (105, 130, '2025-06-26', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (105, 702, '2025-02-24', '2025-03-26', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (105, 650, '2025-03-07', '2025-04-06', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (106, 'Book Club 106', 'This is the description for Book Club 106.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (106, 193);
INSERT INTO bookclub_members (clubid, userid) VALUES (106, 41);
INSERT INTO bookclub_members (clubid, userid) VALUES (106, 193);
INSERT INTO bookclub_members (clubid, userid) VALUES (106, 366);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (106, 667, '2025-06-26', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (106, 13, '2025-03-07', '2025-04-06', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (106, 292, '2025-03-26', '2025-04-25', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (106, 237, '2025-04-04', '2025-05-04', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (107, 'Book Club 107', 'This is the description for Book Club 107.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (107, 157);
INSERT INTO bookclub_members (clubid, userid) VALUES (107, 157);
INSERT INTO bookclub_members (clubid, userid) VALUES (107, 30);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (107, 931, '2025-06-24', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (107, 350, '2025-06-20', '2025-08-28', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (107, 842, '2025-06-13', '2025-07-13', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (107, 447, '2025-02-12', '2025-03-14', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (107, 18, '2025-03-07', '2025-04-06', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (108, 'Book Club 108', 'This is the description for Book Club 108.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (108, 437);
INSERT INTO bookclub_members (clubid, userid) VALUES (108, 437);
INSERT INTO bookclub_members (clubid, userid) VALUES (108, 87);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (108, 122, '2025-06-27', '2025-08-10', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (108, 66, '2025-02-10', '2025-03-12', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (108, 86, '2025-03-15', '2025-04-14', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (109, 'Book Club 109', 'This is the description for Book Club 109.', 2);
INSERT INTO bookclub_creators (clubid, userid) VALUES (109, 438);
INSERT INTO bookclub_members (clubid, userid) VALUES (109, 338);
INSERT INTO bookclub_members (clubid, userid) VALUES (109, 438);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (109, 162, '2025-06-18', '2025-08-22', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (109, 152, '2025-03-21', '2025-04-20', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (109, 903, '2025-02-07', '2025-03-09', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (110, 'Book Club 110', 'This is the description for Book Club 110.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (110, 430);
INSERT INTO bookclub_members (clubid, userid) VALUES (110, 82);
INSERT INTO bookclub_members (clubid, userid) VALUES (110, 430);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (110, 424, '2025-07-10', '2025-08-10', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (110, 54, '2025-01-05', '2025-02-04', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (110, 643, '2025-05-13', '2025-06-12', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (110, 71, '2025-06-01', '2025-07-01', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (111, 'Book Club 111', 'This is the description for Book Club 111.', 5);
INSERT INTO bookclub_creators (clubid, userid) VALUES (111, 371);
INSERT INTO bookclub_members (clubid, userid) VALUES (111, 142);
INSERT INTO bookclub_members (clubid, userid) VALUES (111, 16);
INSERT INTO bookclub_members (clubid, userid) VALUES (111, 371);
INSERT INTO bookclub_members (clubid, userid) VALUES (111, 243);
INSERT INTO bookclub_members (clubid, userid) VALUES (111, 215);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (111, 177, '2025-06-23', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (111, 793, '2025-03-24', '2025-04-23', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (112, 'Book Club 112', 'This is the description for Book Club 112.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (112, 199);
INSERT INTO bookclub_members (clubid, userid) VALUES (112, 361);
INSERT INTO bookclub_members (clubid, userid) VALUES (112, 199);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (112, 291, '2025-07-13', '2025-08-11', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (112, 59, '2025-06-30', '2025-08-26', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (112, 141, '2025-07-17', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (112, 698, '2025-06-16', '2025-07-16', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (113, 'Book Club 113', 'This is the description for Book Club 113.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (113, 153);
INSERT INTO bookclub_members (clubid, userid) VALUES (113, 97);
INSERT INTO bookclub_members (clubid, userid) VALUES (113, 393);
INSERT INTO bookclub_members (clubid, userid) VALUES (113, 239);
INSERT INTO bookclub_members (clubid, userid) VALUES (113, 24);
INSERT INTO bookclub_members (clubid, userid) VALUES (113, 153);
INSERT INTO bookclub_members (clubid, userid) VALUES (113, 186);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (113, 53, '2025-06-21', '2025-08-31', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (113, 1068, '2025-06-06', '2025-07-06', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (113, 414, '2025-06-03', '2025-07-03', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (113, 147, '2025-01-16', '2025-02-15', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (114, 'Book Club 114', 'This is the description for Book Club 114.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (114, 375);
INSERT INTO bookclub_members (clubid, userid) VALUES (114, 375);
INSERT INTO bookclub_members (clubid, userid) VALUES (114, 295);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (114, 129, '2025-06-27', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (114, 1053, '2025-05-25', '2025-06-24', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (114, 446, '2025-05-17', '2025-06-16', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (114, 122, '2025-02-08', '2025-03-10', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (115, 'Book Club 115', 'This is the description for Book Club 115.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (115, 84);
INSERT INTO bookclub_members (clubid, userid) VALUES (115, 263);
INSERT INTO bookclub_members (clubid, userid) VALUES (115, 424);
INSERT INTO bookclub_members (clubid, userid) VALUES (115, 329);
INSERT INTO bookclub_members (clubid, userid) VALUES (115, 135);
INSERT INTO bookclub_members (clubid, userid) VALUES (115, 84);
INSERT INTO bookclub_members (clubid, userid) VALUES (115, 347);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (115, 296, '2025-07-07', '2025-08-12', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (115, 177, '2025-07-05', '2025-08-19', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (115, 975, '2025-01-13', '2025-02-12', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (115, 411, '2025-01-13', '2025-02-12', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (115, 288, '2025-06-14', '2025-07-14', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (116, 'Book Club 116', 'This is the description for Book Club 116.', 4);
INSERT INTO bookclub_creators (clubid, userid) VALUES (116, 145);
INSERT INTO bookclub_members (clubid, userid) VALUES (116, 145);
INSERT INTO bookclub_members (clubid, userid) VALUES (116, 156);
INSERT INTO bookclub_members (clubid, userid) VALUES (116, 149);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (116, 497, '2025-06-18', '2025-08-20', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (116, 288, '2025-07-07', '2025-08-25', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (116, 965, '2025-03-24', '2025-04-23', FALSE);

INSERT INTO bookclubs (clubid, name, description, max_members) VALUES (117, 'Book Club 117', 'This is the description for Book Club 117.', 6);
INSERT INTO bookclub_creators (clubid, userid) VALUES (117, 439);
INSERT INTO bookclub_members (clubid, userid) VALUES (117, 439);
INSERT INTO bookclub_members (clubid, userid) VALUES (117, 23);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (117, 932, '2025-07-13', '2025-08-30', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (117, 872, '2025-07-06', '2025-08-18', TRUE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (117, 61, '2025-01-12', '2025-02-11', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (117, 515, '2025-04-06', '2025-05-06', FALSE);
INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) VALUES (117, 324, '2025-05-10', '2025-06-09', FALSE);

-- prod data
