from flask import Flask, jsonify, request
from flask_cors import CORS

from database import Database
from config import get_env_config

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
        
        search_query = "Harry Potter"
  
        if search_query:
            query = f"SELECT * FROM books WHERE LOWER(title) LIKE LOWER('%{search_query}%') LIMIT {limit};"
            db.run(query)
        else:
            db.select_rows("books", num_rows=limit)
        
        results = db.fetch_all()
        
        books = []
        for row in results:
            books.append({
                "bookID": row[0],
                "title": row[1],
                "authors": row[2],
                "average_rating": row[3],
                "isbn": row[4],
                "isbn13": row[5],
                "language_code": row[6],
                "num_pages": row[7],
                "ratings_count": row[8],
                "text_reviews_count": row[9],
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
        
        query = "SELECT genre, COUNT(*) as count FROM books GROUP BY genre;"
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
            SELECT bookID, title, authors
            FROM books
            WHERE LOWER(genre) = LOWER('{genre}')
            ORDER BY title ASC;
        """
        db.run(query)
        results = db.fetch_all()

        books = []
        for row in results:
            books.append({
                "bookID": row[0],
                "title": row[1],
                "authors": row[2],
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
            SELECT b.bookID, b.title, b.authors
            FROM userprogress u, books b 
            WHERE userID = (SELECT userID FROM users WHERE name = '{username}') 
                    AND b.bookID=u.bookID
                    AND STATUS='{status}';"""

        db.run(query)
        results = db.fetch_all()

        books = []
        for book in results:
            books.append({"bookID": book[0], "title": book[1], "authors": book[2]})
        
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
            INSERT INTO userprogress (userID, bookID, status) 
            VALUES ((SELECT userID FROM users WHERE name = '{username}'), '{bookID}', '{status}')
            ON DUPLICATE KEY UPDATE status = '{status}';
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

        query = f"SELECT title, average_rating FROM books ORDER BY average_rating DESC LIMIT {limit};"
        db.run(query)
        results = db.fetch_all()
        return jsonify({"results": results}), 200

    except Exception as e:
        return jsonify({"message": "Error finding top 5 books by rating"}), 500
    

@app.route('/common-books', methods=['GET'])
def common_books():
    try:
        db = Database()

        user1 = request.args.get('u1name', type=str)
        user2 = request.args.get('u2name', type=str)
        limit = request.args.get('limit', 5, type=int)

        query = f"""
        SELECT b.bookID, b.title, b.authors
        FROM userprogress us1, userprogress us2, books b
        WHERE us1.userID=(SELECT userID from users WHERE name='{user1}') 
                AND us2.userID=(SELECT userID from users WHERE name='{user2}') 
                AND us1.bookID=us2.bookID and us1.bookID=b.bookID
        LIMIT {limit}
        """
        db.run(query)
        results = db.fetch_all()

        books = []
        for book in results:
            books.append({"bookID": book[0], "title": book[1], "authors": book[2]})

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
            b.authors,
            COUNT(up_all.userID) as total_users,
            SUM(CASE WHEN up_all.status = 'FINISHED' THEN 1 ELSE 0 END) as completed_users,
            ROUND(
                (SUM(CASE WHEN up_all.status = 'FINISHED' THEN 1 ELSE 0 END) * 100.0 / COUNT(up_all.userID)), 1
            ) as completion_rate
        FROM userprogress up_mine
        JOIN books b ON up_mine.bookID = b.bookID AND up_mine.status = 'IN PROGRESS'
        JOIN users u_mine ON up_mine.userID = u_mine.userID
        JOIN userprogress up_all ON b.bookID = up_all.bookID
        WHERE up_mine.status = 'IN PROGRESS' and u_mine.name = '{username}'
        GROUP BY b.bookID, b.title, b.authors
        ORDER BY completion_rate DESC, total_users DESC
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

        query = f"UPDATE users SET {', '.join(updates)} WHERE userID = {user_id};"
        db.run(query)

        return jsonify({"message": "User updated successfully."}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/books/top-wishlists', methods=['GET'])
def top_wishlist_books():
    try:
        db = Database()

        query = """
        SELECT books.bookID, books.title, COUNT(*) AS wishlist_count
        FROM userprogress
        JOIN books ON userprogress.bookID = books.bookID
        WHERE userprogress.status = 'NOT STARTED'
        GROUP BY books.bookID, books.title
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


if __name__ == "__main__":
    app.run(debug=True, port=PORT)
