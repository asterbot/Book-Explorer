-- Books common in the user lists of user 112 and user 1097
SELECT b.bookID, b.title
FROM production.userprogress us1, production.userprogress us2, production.books b
WHERE us1.userID=362 
AND us2.userID=242
AND us1.bookID=us2.bookID and us1.bookID=b.bookID
;
