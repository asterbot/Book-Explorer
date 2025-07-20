from flask import Flask, jsonify, request
from flask_cors import CORS

from database import Database
from config import *
from psycopg2.extensions import adapt
import psycopg2

from datetime import datetime

# Initialize flask app
app = Flask(__name__)
CORS(app)

PORT = get_env_config("VITE_BACKEND_PORT") or 5000

@app.route('/')
def hello():
    return jsonify({"message": "CS348 Project API"})

@app.route('/search', methods=['GET'])
def search_books():
    try:
        db = Database()

        search_query = request.args.get('q', '')
        limit = request.args.get('limit', 10, type=int)
        
        if search_query:
            query = f"""
                SELECT b.bookID, b.title, b.isbn, b.language_code, b.num_pages, 
                    COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors
                FROM {BOOKS} b
                LEFT JOIN {BOOK_AUTHORS} ba ON b.bookID = ba.bookID
                LEFT JOIN {AUTHORS} a ON ba.authorID = a.authorID
                WHERE LOWER(b.title) LIKE LOWER('%{search_query}%')
                GROUP BY b.bookID
                LIMIT {limit};
            """
            db.run(query)
        else:
            db.select_rows("books", num_rows=limit)
        
        results = db.fetch_all()
        
        books = []
        for row in results:
            books.append({
                "bookID": row[0],
                "title": row[1],
                "isbn": row[2],
                "language_code": row[3],
                "num_pages": row[4],
                "authors": row[5]
            })

        return jsonify({
            "results": books,
            "count": len(books)
        })
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/genrecounts', methods=['GET'])
def genre_counts():
    try:
        db = Database()
        
        query = f"""
                SELECT g.name, COUNT(*) as count 
                FROM {BOOKGENRE} bg, {GENRE} g
                WHERE bg.genreID=g.genreID 
                GROUP BY g.name;
        """
        db.run(query)
        results = db.fetch_all()

        author_count_map = {}
        for row in results:
            author = row[0]
            count = row[1]
            author_count_map[author] = count

        return jsonify({
            "genre_counts": author_count_map,
            "unique_genres": len(author_count_map)
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/genre', methods=['GET'])
def books_by_genre():
    try:
        db = Database()

        genre = request.args.get("genre")
        if not genre:
            return jsonify({"error": "Missing 'genre' parameter"}), 400

        query = f"""
            SELECT b.bookID, b.title, 
                   COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors,
                   b.num_pages
            FROM {BOOKS} b
            JOIN {BOOKGENRE} bg ON b.bookID = bg.bookID
            JOIN {GENRE} g ON bg.genreID = g.genreID
            LEFT JOIN {BOOK_AUTHORS} ba ON b.bookID = ba.bookID
            LEFT JOIN {AUTHORS} a ON ba.authorID = a.authorID
            WHERE LOWER(g.name) = LOWER('{genre}')
            GROUP BY b.bookID, b.title
            ORDER BY b.title ASC;
        """
        db.run(query)
        results = db.fetch_all()

        books = []
        for row in results:
            books.append({
                "bookID": row[0],
                "title": row[1],
                "authors": row[2],
                "num_pages": row[3]
            })

        return jsonify({"results": books, "count": len(books)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/userlist', methods=['GET'])
def view_userlist():
    try:
        db = Database()

        username = request.args.get('username')
        status = request.args.get('status')
        query = f"""
            SELECT 
                b.bookID,
                b.title,
                COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors,
                u.page_reached,
                b.num_pages
            FROM {USERPROGRESS} u
            JOIN {BOOKS} b ON u.bookID = b.bookID
            LEFT JOIN {BOOK_AUTHORS} ba ON b.bookID = ba.bookID
            LEFT JOIN {AUTHORS} a ON ba.authorID = a.authorID
            WHERE u.userID = (SELECT userID FROM {USERS} WHERE name = '{username}')
                AND u.status = '{status}'
            GROUP BY b.bookID, b.title, u.page_reached;
            """
        db.run(query)
        results = db.fetch_all()

        books = []
        for book in results:
            books.append({
                "bookID": book[0],
                "title": book[1],
                "authors": book[2],
                "page_reached": book[3],
                "num_pages": book[4],
            })
        
        return jsonify({"results": books}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/userprogress', methods=['POST'])
def add_to_userprogress():
    try:
        db = Database()

        data = request.get_json()
        username = data.get('username')
        bookID = data.get('bookID')
        status = data.get('status')

        query = f"""
            INSERT INTO {USERPROGRESS} (userID, bookID, status) 
            VALUES ((SELECT userID FROM {USERS} WHERE name = '{username}'), '{bookID}', '{status}')
            ON CONFLICT (userID, bookID) DO UPDATE SET status = EXCLUDED.status
        """
        db.run(query)
        db.commit()
        
        return jsonify({"message": "Book added to userprogress", "username": username, "bookID": bookID}), 200
    except Exception as e:
        return jsonify({"message": "Error adding book to userprogress", "error": str(e)}), 500

@app.route('/top-books', methods=['GET'])
def top_books_by_rating():
    try:
        db = Database()

        limit = request.args.get('limit', 5, type=int)

        query = f"""
            SELECT b.bookID, b.title, AVG(ur.rating) as avg_rating
            FROM {BOOKS} b, {USERRATING} ur
            WHERE b.bookID=ur.bookID
            GROUP BY b.bookID, b.title
            ORDER BY avg_rating DESC LIMIT {limit};"""
        db.run(query)
        results = db.fetch_all()
        return jsonify({"results": results}), 200

    except Exception as e:
        return jsonify({"message": f"Error finding top 5 books by rating: {e}"}), 500
    

@app.route('/common-books', methods=['GET'])
def common_books():
    try:
        db = Database()

        user1 = request.args.get('u1name', type=str)
        user2 = request.args.get('u2name', type=str)
        limit = request.args.get('limit', 5, type=int)

        query = f"""
        SELECT 
            b.bookID,
            b.title,
            COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors
        FROM {USERPROGRESS} us1
        JOIN {USERPROGRESS} us2 ON us1.bookID = us2.bookID
        JOIN {BOOKS} b ON us1.bookID = b.bookID
        LEFT JOIN {BOOK_AUTHORS} ba ON b.bookID = ba.bookID
        LEFT JOIN {AUTHORS} a ON ba.authorID = a.authorID
        WHERE us1.userID = (SELECT userID FROM {USERS} WHERE name = '{user1}')
            AND us2.userID = (SELECT userID FROM {USERS} WHERE name = '{user2}')
        GROUP BY b.bookID, b.title
        LIMIT {limit};
        """
        db.run(query)
        results = db.fetch_all()

        books = []
        for book in results:
            books.append({
                "bookID": book[0],
                "title": book[1],
                "authors": book[2]
            })

        return jsonify({"results": books}), 200
        
    except Exception as e:
        return jsonify({"message": f"Error finding common books between users: {e}"}), 500

@app.route('/book-completion-rates', methods=['GET'])
def book_completion_rates():
    try:
        db = Database()
        
        username = request.args.get('username', type=str)

        query = f"""
        SELECT 
            b.bookID,
            b.title,
            COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors,
            COUNT(up_all.userID) AS total_users,
            SUM(CASE WHEN up_all.status = 'FINISHED' THEN 1 ELSE 0 END) AS completed_users,
            ROUND(
                SUM(CASE WHEN up_all.status = 'FINISHED' THEN 1 ELSE 0 END) * 100.0 / COUNT(up_all.userID),
                1
            ) AS completion_rate
        FROM {USERPROGRESS} up_mine
        JOIN {BOOKS} b ON up_mine.bookID = b.bookID AND up_mine.status = 'IN PROGRESS'
        LEFT JOIN {BOOK_AUTHORS} ba ON b.bookID = ba.bookID
        LEFT JOIN {AUTHORS} a ON ba.authorID = a.authorID
        JOIN {USERS} u_mine ON up_mine.userID = u_mine.userID
        JOIN {USERPROGRESS} up_all ON b.bookID = up_all.bookID
        WHERE u_mine.name = '{username}'
        GROUP BY b.bookID, b.title
        ORDER BY completion_rate DESC, total_users DESC;
        """
        
        db.run(query)
        results = db.fetch_all()

        completion_data = []
        for row in results:
            completion_data.append({
                "bookID": row[0],
                "title": row[1],
                "authors": row[2],
                "total_users": row[3],
                "completed_users": row[4],
                "completion_rate": row[5]
            })

        return jsonify({"results": completion_data}), 200
        
    except Exception as e:
        return jsonify({"error": f"Error getting book completion rates: {str(e)}"}), 500

@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    try:
        db = Database()

        data = request.get_json()
        name = data.get("name")
        email = data.get("email")

        updates = []

        if name:
            updates.append(f"name = '{name}'")
        if email:
            updates.append(f"email = '{email}'")

        if not updates:
            return jsonify({"error": "No valid fields to update"}), 400

        query = f"UPDATE {USERS} SET {', '.join(updates)} WHERE userID = {user_id};"
        db.run(query)

        return jsonify({"message": "User updated successfully."}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/books/top-wishlists', methods=['GET'])
def top_wishlist_books():
    try:
        db = Database()

        query = f"""
        SELECT {BOOKS}.bookID, {BOOKS}.title, COUNT(*) AS wishlist_count
        FROM {USERPROGRESS}
        JOIN {BOOKS} ON {USERPROGRESS}.bookID = {BOOKS}.bookID
        WHERE {USERPROGRESS}.status = 'NOT STARTED'
        GROUP BY {BOOKS}.bookID, {BOOKS}.title
        ORDER BY wishlist_count DESC
        LIMIT 5;
        """

        db.run(query)
        results = db.fetch_all()

        top_books = []
        for row in results:
            top_books.append({
                "bookID": row[0],
                "title": row[1],
                "wishlist_count": row[2]
            })

        return jsonify(top_books), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/suggest-club/<string:username>', methods=['GET'])
def suggest_club(username):
    try:
        db = Database()

        safe_name = adapt(username).getquoted().decode()
        db.run(
            f"SELECT userID                         "
            f"FROM   {USERS}                          "
            f"WHERE  LOWER(name) = LOWER({safe_name}) "
            f"LIMIT  1;"
        )
        row = db.fetch_one()
        if row is None:
            return jsonify({"error": f"username '{username}' does not exist"}), 404
        user_id = row[0]

        db.run(f"SELECT clubid FROM suggest_club({user_id});")
        rec = db.fetch_one()
        if rec is None:
            return jsonify({
                "message": "You are already in every book club :/  No new clubs to join!"
            }), 200
        club_id = rec[0]

        db.run(
            f"""
            WITH u AS (
                SELECT genreid, score
                FROM   {V_USER_GENRE_SCORE}
                WHERE  userid = {user_id}
            ),
            c AS (
                SELECT genreid, score
                FROM   {V_CLUB_GENRE_SCORE}
                WHERE  clubid = {club_id}
            )
            SELECT g.name
            FROM   u JOIN c USING (genreid)
            JOIN   {GENRE} g USING (genreid)
            ORDER  BY (u.score * c.score) DESC
            LIMIT  2;
            """
        )
        top_genres = [r[0] for r in db.fetch_all()]
        if top_genres:
            reason = (
                "Based on your interest in "
                + (", ".join(top_genres) if len(top_genres) > 1 else top_genres[0])
                + ", we think this club is a great fit."
            )
        else:
            reason = (
                "This club's reading history best matches your ratings and books in progress."
            )

        db.run(f"SELECT name, clubid FROM {BOOKCLUBS} WHERE clubid = {club_id};")
        club_row = db.fetch_one()
        club_name = club_row[0]
        club_id = club_row[1]

        return jsonify({
            "clubName": club_name,
            "clubID": club_id,
            "reason":   reason
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    

@app.route('/recommendations', methods=['GET'])
def recommend_books():
    try:
        db = Database()
        username = request.args.get('username')

        if not username:
            return jsonify({"error": "Missing 'username' parameter"}), 400

        safe_name = adapt(username).getquoted().decode()

        # Get userID from USERS table
        db.run(f"""
            SELECT userID
            FROM {USERS}
            WHERE LOWER(name) = LOWER({safe_name})
            LIMIT 1;
        """)
        row = db.fetch_one()

        if not row:
            return jsonify({"error": f"Username '{username}' not found."}), 404

        user_id = row[0]

        query = f"""
        WITH current_user_tags AS (
            SELECT tagID
            FROM {USER_BOOK_TAG}
            WHERE userID = {user_id}
            GROUP BY tagID
            ORDER BY COUNT(*) DESC
            LIMIT 5
        ),
        similar_users AS (
            SELECT DISTINCT ubt.userID
            FROM {USER_BOOK_TAG} ubt
            JOIN current_user_tags cut ON ubt.tagID = cut.tagID
            WHERE ubt.userID != {user_id}
        ),
        books_read_by_similar_users AS (
            SELECT DISTINCT up.bookID
            FROM {USERPROGRESS} up
            JOIN similar_users su ON up.userID = su.userID
            WHERE up.status IN ('IN PROGRESS', 'FINISHED')
        ),
        books_tagged_with_interest_tags AS (
            SELECT DISTINCT ubt.bookID
            FROM {USER_BOOK_TAG} ubt
            WHERE ubt.tagID IN (SELECT tagID FROM current_user_tags)
        ),
        hybrid_candidate_books AS (
            SELECT bookID FROM books_tagged_with_interest_tags
            UNION
            SELECT bookID FROM books_read_by_similar_users
        ),
        recommended_books AS (
            SELECT cb.bookID
            FROM hybrid_candidate_books cb
            WHERE NOT EXISTS (
                SELECT 1
                FROM {USERPROGRESS} up
                WHERE up.userID = {user_id}
                AND up.bookID = cb.bookID
            )
            LIMIT 5
        )
        SELECT b.bookID, b.title, COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors, b.num_pages
        FROM recommended_books rb
        JOIN {BOOKS} b ON b.bookID = rb.bookID
        LEFT JOIN {BOOK_AUTHORS} ba ON b.bookID = ba.bookID
        LEFT JOIN {AUTHORS} a ON ba.authorID = a.authorID
        GROUP BY b.bookID, b.title;
        """

        db.run(query)
        results = db.fetch_all()

        books = [
            {
                "bookID": row[0],
                "title": row[1],
                "authors": row[2],
                "num_pages": row[3]
            }
            for row in results
        ]

        return jsonify({"results": books, "count": len(books)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/join_book_club', methods=['POST'])
def join_book_club():
    try:
        db = Database()

        username = request.args.get('username')
        club_id = request.args.get('clubID')

        if not username or not club_id:
            return jsonify({"error": "Missing 'username' or 'clubID' parameter"}), 400

        # Start transaction with SERIALIZABLE isolation level
        db.run("BEGIN;")
        db.run("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;")

        # Get userID
        db.run(f"""
            SELECT userID FROM {USERS}
            WHERE LOWER(name) = LOWER('{username}');
        """)
        row = db.fetch_one()
        if not row:
            db.run("ROLLBACK;")
            return jsonify({"error": f"User '{username}' not found"}), 404
        user_id = row[0]

        # Check current count of members in club
        db.run(f"""
            SELECT COUNT(*) FROM {BOOKCLUB_MEMBERS}
            WHERE clubID = {club_id};
        """)
        current_count = db.fetch_one()[0]

        # Check max_members
        db.run(f"""
            SELECT max_members FROM {BOOKCLUBS}
            WHERE clubID = {club_id};
        """)
        max_members_row = db.fetch_one()
        if not max_members_row:
            db.run("ROLLBACK;")
            return jsonify({"error": f"Book club ID {club_id} not found"}), 404
        max_members = max_members_row[0]

        if current_count >= max_members:
            db.run("ROLLBACK;")
            return jsonify({"error": "Book club is full"}), 403

        # Check if user already in club
        db.run(f"""
            SELECT 1 FROM {BOOKCLUB_MEMBERS}
            WHERE clubID = {club_id} AND userID = {user_id}
            LIMIT 1;
        """)
        if db.fetch_one():
            db.run("ROLLBACK;")
            return jsonify({"error": "User already joined this club"}), 409

        # Join the book club
        db.run(f"""
            INSERT INTO {BOOKCLUB_MEMBERS}(clubID, userID, joined_at)
            VALUES ({club_id}, {user_id}, CURRENT_TIMESTAMP);
        """)
        db.commit()

        return jsonify({"success": True, "message": f"{username} successfully joined book club {club_id}!"}), 200

    except psycopg2.errors.SerializationFailure:
        return jsonify({"error": "Too many concurrent requests. Please try again."}), 409

    except Exception as e:
        try:
            db.run("ROLLBACK;")
        except:
            pass


@app.route('/userlogs', methods=['GET'])
def get_userlogs():
    try:
        username = request.args.get('username')
        
        db = Database()
        
        query = f"""
        SELECT b.title, COALESCE(string_agg(DISTINCT a.name, ', '), '') AS authors, u.update_time, u.page_reached
        FROM {BOOKS} b, {USERLOGS} u, {BOOK_AUTHORS} ba, {AUTHORS} a
        WHERE u.bookID = b.bookID AND ba.bookID=b.bookID AND ba.authorID=a.authorID
            AND u.userid = (SELECT userid FROM users WHERE name='{username}')
        GROUP BY b.title, u.update_time, u.page_reached
        ORDER BY update_time DESC;
        """
        
        db.run(query)
        results = db.fetch_all()
        
        ret = [
            {
                "book_title": row[0],
                "authors": row[1],
                "timestamp": row[2],
                "page_reached": row[3],
            }
            for row in results
        ]
        
        return jsonify({"results": ret}), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/streak', methods=['GET'])
def get_streak():
    try:
        username = request.args.get('username')
        
        db = Database()
        
        query = f"""
        WITH RECURSIVE streak_books(userid, bookid, update_time) AS(
            -- base case
            SELECT * FROM(
                SELECT userid, bookid, update_time 
                FROM {USERLOGS} 
                WHERE userid=(SELECT userid FROM users WHERE name='{username}')
                ORDER BY update_time DESC -- get latest update_time
                LIMIT 1
            ) as base

            UNION 

            -- recursive case
            SELECT * FROM(
                SELECT t.userid, t.bookid, t.update_time 
                FROM {USERLOGS} t
                JOIN streak_books s ON t.userid=s.userid
                WHERE ABS(t.update_time::date - s.update_time::date) = 1 -- time differs by EXACTLY one day
                ORDER BY t.update_time
                LIMIT 1
            ) as recurse
        )
        SELECT COUNT(*) as streak FROM streak_books;
        """
        
        db.run(query)
        results = db.fetch_all()
        
        streak_count = results[0][0]
        
        return jsonify({"streak": streak_count})
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/updateprogress', methods=['POST'])
def update_progress():
    try:
        db = Database()

        data = request.get_json()
        username = data.get('username')
        bookID = data.get('bookId')
        newpage = data.get('newpage')
        date:str = data.get('newdate')
        
        print(data)

        date_parsed = datetime.strptime(date, "%a, %d %b %Y %H:%M:%S %Z")

        query = f"""
            INSERT INTO {USERLOGS} (userID, bookID, update_time, page_reached)
            VALUES (
                (SELECT userID FROM {USERS} WHERE name='{username}'),
                {bookID},
                '{date_parsed}',
                {newpage}
            );
        """
        db.run(query)
        db.commit()
        
        query = f"""
            UPDATE {USERPROGRESS} SET page_reached = {newpage} 
            WHERE userID = (SELECT userID FROM {USERS} WHERE name='{username}')
                AND bookID = {bookID};  
        """
        db.run(query)
        db.commit()
                
        return jsonify({"message": "Updated progress", "username": username, "bookID": bookID}), 200
    except Exception as e:
        return jsonify({"message": "Error adding book to userprogress", "error": str(e)}), 500


@app.route('/user-book-clubs', methods=['GET'])
def user_book_clubs():
    try:
        db = Database()

        username = request.args.get('username')
        if not username:
            return jsonify({"error": "Missing 'username' parameter"}), 400

        query_user = f"""
            SELECT userID
            FROM {USERS}
            WHERE LOWER(name) = LOWER('{username}')
            LIMIT 1;
        """
        db.run(query_user)
        user_row = db.fetch_one()

        if not user_row:
            return jsonify({"error": f"User '{username}' not found"}), 404

        user_id = user_row[0]

        query_clubs = f"""
            SELECT 
                bc.clubID, 
                bc.name, 
                bc.description,
                COUNT(bcm2.userID) AS memberCount
            FROM {BOOKCLUB_MEMBERS} bcm
            JOIN {BOOKCLUBS} bc ON bcm.clubID = bc.clubID
            LEFT JOIN {BOOKCLUB_MEMBERS} bcm2 ON bc.clubID = bcm2.clubID
            WHERE bcm.userID = {user_id}
            GROUP BY bc.clubID, bc.name, bc.description
            ORDER BY bc.name;
        """
        db.run(query_clubs)
        results = db.fetch_all()

        clubs = []
        for row in results:
            clubs.append({
                "clubID": row[0],
                "clubName": row[1],
                "description": row[2],
                "memberCount": row[3]
            })

        return jsonify({"results": clubs, "count": len(clubs)}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True, port=PORT)
