from flask import Flask, jsonify, request
from flask_cors import CORS

from database import Database
from config import *
from psycopg2.extensions import adapt

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
                    COALESCE(string_agg(a.name, ', '), '') AS authors
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
            SELECT b.bookID, b.title
            FROM {BOOKS} b, {BOOKGENRE} bg, {GENRE} g
            WHERE g.genreID=bg.genreID AND b.bookID=bg.bookID AND
                    LOWER(g.name) = LOWER('{genre}')
            ORDER BY title ASC;
        """
        db.run(query)
        results = db.fetch_all()

        books = []
        for row in results:
            books.append({
                "bookID": row[0],
                "title": row[1],
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
                COALESCE(string_agg(a.name, ', '), '') AS authors
            FROM {USERPROGRESS} u
            JOIN {BOOKS} b ON u.bookID = b.bookID
            LEFT JOIN {BOOK_AUTHORS} ba ON b.bookID = ba.bookID
            LEFT JOIN {AUTHORS} a ON ba.authorID = a.authorID
            WHERE u.userID = (SELECT userID FROM {USERS} WHERE name = '{username}')
                AND u.status = '{status}'
            GROUP BY b.bookID, b.title;
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
            COALESCE(string_agg(a.name, ', '), '') AS authors
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
            COALESCE(string_agg(a.name, ', '), '') AS authors,
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

        db.run(f"SELECT name FROM {BOOKCLUBS} WHERE clubid = {club_id};")
        club_name = db.fetch_one()[0]

        return jsonify({
            "clubName": club_name,
            "reason":   reason
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, port=PORT)
