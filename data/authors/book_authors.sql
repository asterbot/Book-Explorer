CREATE TABLE book_authors (
    bookID INT,
    authorID INT,
    PRIMARY KEY (bookID, authorID),
    FOREIGN KEY (bookID) REFERENCES books(bookID) ON DELETE CASCADE,
    FOREIGN KEY (authorID) REFERENCES authors(authorID) ON DELETE CASCADE
);

INSERT INTO book_authors (bookID, authorID) VALUES
