from flask import Flask, jsonify, request
from database import Database

app = Flask(__name__)

db = Database()
db.use_database("cs348_project")

@app.route('/')
def hello():
    return jsonify({"message": "CS348 Project API"})

@app.route('/search', methods=['GET'])
def search_books():
    try:
        search_query = request.args.get('q', '')
        limit = request.args.get('limit', 10, type=int)
        
        if search_query:
            query = f"SELECT * FROM books WHERE title LIKE '%{search_query}%' LIMIT {limit};"
            db.run(query)
        else:
            db.select_rows("books", ["bookID", "title", "authors", "average_rating", "isbn", "isbn13", "language_code", "num_pages", "ratings_count", "text_reviews_count", "publication_date", "publisher"])
        
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

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)