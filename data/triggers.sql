-- Trigger to set status based on page reached
--     on the UI this is when user updates page number when adding process
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
        SET status = 'FINISHED'
        WHERE userid = NEW.userid AND bookID = NEW.bookID;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER set_status
    AFTER UPDATE OF page_reached ON userprogress
    FOR EACH ROW
        EXECUTE FUNCTION set_status();


-- Trigger to set page number based on status of insert
--     On UI this is when user adds a new book from the search of books
CREATE OR REPLACE FUNCTION set_page_num()
RETURNS trigger AS $$
BEGIN
    IF NEW.status = 'NOT STARTED' THEN
        UPDATE userprogress
        SET page_reached=0
        WHERE userid = NEW.userid AND bookID = NEW.bookID;
        
    ELSIF NEW.status = 'IN PROGRESS' and NEW.page_reached=0 THEN
        UPDATE userprogress
        SET page_reached = 1
        WHERE userid = NEW.userid AND bookID = NEW.bookID;

    ELSIF NEW.status = 'FINISHED' THEN
        UPDATE userprogress
        SET page_reached = (SELECT num_pages FROM books WHERE bookID=NEW.bookID)
        WHERE userid = NEW.userid AND bookID = NEW.bookID;
    END IF;

    INSERT INTO userlogs (userID, bookID, page_reached) VALUES 
        (NEW.userID, NEW.bookID, 
            (SELECT page_reached FROM userprogress WHERE userID=NEW.userID and bookID=NEW.bookID)
        );

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER set_page_num
    AFTER INSERT ON userprogress
    FOR EACH ROW
        EXECUTE FUNCTION set_page_num();
