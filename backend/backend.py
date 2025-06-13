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
            # Fetch that specific query from the db
            query = f"SELECT * FROM books WHERE title LIKE '%{search_query}%' LIMIT {limit};"
            db.run(query)
        else:
            # Fetch all books
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

@app.route('/wishlist', methods=['GET'])
def view_wishlist():
    try:
        db = Database()
        db.use_database("cs348_project")

        username = request.args.get('username')
        query = f"SELECT bookID FROM wishlists WHERE userID = (SELECT userID FROM users WHERE name = '{username}');"
        db.run(query)
        results = db.fetch_all()
        return jsonify({"results": results}), 200
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
        
        query = f"INSERT INTO wishlists (userID, bookID) VALUES ((SELECT userID FROM users WHERE name = '{username}'), '{bookID}');"
        db.run(query)
        db.commit()
        
        return jsonify({"message": "Book added to wishlist", "username": username, "bookID": bookID}), 200
    except Exception as e:
        return jsonify({"message": "Error adding book to wishlist", "error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, port=PORT)