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
        db.use_database("cs348_project")

        search_query = request.args.get('q', '')
        limit = request.args.get('limit', 10, type=int)
  
        if search_query:
            query = f"SELECT * FROM books WHERE title LIKE '%{search_query}%' LIMIT {limit};"
            db.run(query)
        else:
            db.select_rows("books", num_rows=5)
        
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
def author_counts():
    try:
        db = Database()
        db.use_database("cs348_project")
        
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

@app.route('/userlist', methods=['GET'])
def view_userlist():
    try:
        db = Database()
        db.use_database("cs348_project")

        username = request.args.get('username')
        status = request.args.get('status')
        print(status)
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

@app.route('/wishlist', methods=['POST'])
def add_to_wishlist():
    try:
        db = Database()
        db.use_database("cs348_project")

        data = request.get_json()
        username = data.get('username')
        bookID = data.get('bookID')

        query = f"INSERT INTO userprogress (userID, bookID) VALUES ((SELECT userID FROM users WHERE name = '{username}'), '{bookID}');"
        db.run(query)
        db.commit()
        
        return jsonify({"message": "Book added to wishlist", "username": username, "bookID": bookID}), 200
    except Exception as e:
        return jsonify({"message": "Error adding book to wishlist", "error": str(e)}), 500

@app.route('/top-books', methods=['GET'])
def top_books_by_rating():
    try:
        db = Database()
        db.use_database("cs348_project")

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
        db.use_database('cs348_project')

        user1 = request.args.get('u1name', type=str)
        user2 = request.args.get('u2name', type=str)
        limit = request.args.get('limit', 5, type=int)

        query = f"""
        SELECT b.bookID, b.title
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
            books.append({"bookID": book[0], "title": book[1]})

        return jsonify({"results": books}), 200
        
    except Exception as e:
        return jsonify({"message": f"Error finding common books between users: {e}"}), 500

if __name__ == "__main__":
    app.run(debug=True, port=PORT)
