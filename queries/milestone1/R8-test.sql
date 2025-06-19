-- Books common in the user lists of Alex and Bob
SELECT b.bookID, b.title, b.authors
FROM userprogress us1, userprogress us2, books b
WHERE us1.userID=(SELECT userID from users WHERE name='Alex') 
        AND us2.userID=(SELECT userID from users WHERE name='Bob') 
        AND us1.bookID=us2.bookID and us1.bookID=b.bookID;
