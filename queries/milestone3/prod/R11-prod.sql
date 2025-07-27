WITH current_user_tags AS ( -- get top 5 most frequently used user tags
    SELECT tagID
    FROM production.user_book_tag
    WHERE userID = 1
    GROUP BY tagID
    ORDER BY COUNT(*) DESC
    LIMIT 5  
),

similar_users AS ( -- get other users who have utilized at least one of the top 5 user tags
    SELECT DISTINCT ubt.userID
    FROM production.user_book_tag ubt
    JOIN current_user_tags cut ON ubt.tagID = cut.tagID
    WHERE ubt.userID != 1
),

books_read_by_similar_users AS ( -- get books that similar users have started or finished reading
    SELECT DISTINCT up.bookID
    FROM production.userprogress up
    JOIN similar_users su ON up.userID = su.userID
    WHERE up.status IN ('IN PROGRESS', 'FINISHED')
),

books_tagged_with_interest_tags AS ( -- get books that have been tagged with one of the current user's top 5 tags
    SELECT DISTINCT ubt.bookID
    FROM production.user_book_tag ubt
    WHERE ubt.tagID IN (SELECT tagID FROM current_user_tags)
),

hybrid_candidate_books AS ( -- union of both books read by similar users and books tagged with user's top tags
    SELECT bookID FROM books_tagged_with_interest_tags
    UNION
    SELECT bookID FROM books_read_by_similar_users
),

recommended_books AS ( -- filter out books the current user has already interacted with (started or finished)
    SELECT cb.bookID
    FROM hybrid_candidate_books cb
    WHERE NOT EXISTS (
        SELECT *
        FROM production.userprogress up
        WHERE up.userID = 1
          AND up.bookID = cb.bookID
    )
)

SELECT b.bookID, b.title -- get top 5 recommended books that are relevant and socially validated
FROM production.books b
JOIN recommended_books rb ON b.bookID = rb.bookID
LIMIT 5;
