DROP TABLE IF EXISTS userlogs;

CREATE TABLE userlogs(
    logID SERIAL,
    userID INT,
    bookID INT,
    page_reached INT DEFAULT 0,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (logID),
    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (bookID) REFERENCES books(bookID) ON DELETE CASCADE
);

INSERT INTO userlogs (userID, bookID, page_reached)
    (SELECT userID, bookID, page_reached FROM userprogress);




