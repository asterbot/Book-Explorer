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

if __name__ == "__main__":
    app.run(debug=True, port=PORT)