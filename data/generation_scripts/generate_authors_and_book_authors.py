# NOT WORKING RIGHT NOW

import sys
import os

sys.path.append(os.path.join(os.pardir, os.pardir, 'backend'))
from database import Database  # type: ignore

db = Database()

# fetch first 300 books with their bookID and authors field for sample data
db.run('SELECT bookID, authors FROM books LIMIT 300;')
books = db.fetch_all()

author_to_id = {}
next_author_id = 1
book_author_pairs = []

for bookID, authors_str in books:
    author_names = [name.strip() for name in authors_str.split('/') if name.strip()]
    for author in author_names:
        if author not in author_to_id:
            author_to_id[author] = next_author_id
            next_author_id += 1
        book_author_pairs.append((bookID, author_to_id[author]))

# write authors to authors.sql
authors_sql_path = os.path.join(os.pardir, 'authors', 'authors.sql')
with open(authors_sql_path, 'w') as f:
    f.write("INSERT INTO authors (authorID, name) VALUES\n")
    for i, (author, authorID) in enumerate(author_to_id.items()):
        escaped_author = author.replace("'", "''")  # Escape single quotes
        line_end = ';\n' if i == len(author_to_id) - 1 else ',\n'
        f.write(f"({authorID}, '{escaped_author}'){line_end}")

# write book-author pairs to book_authors.sql
book_authors_sql_path = os.path.join(os.pardir, 'book_authors.sql')
with open(book_authors_sql_path, 'w') as f:
    f.write("INSERT INTO book_authors (bookID, authorID) VALUES\n")
    for i, (bookID, authorID) in enumerate(book_author_pairs):
        line_end = ';\n' if i == len(book_author_pairs) - 1 else ',\n'
        f.write(f"({bookID}, {authorID}){line_end}")
