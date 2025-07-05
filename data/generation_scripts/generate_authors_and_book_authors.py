import sys
import os

sys.path.append(os.path.join(os.pardir, os.pardir, 'backend'))
from database import Database # type: ignore

db = Database()
db.use_database('cs348_project')

# fetch first 300 books with their bookID and authors field for sample data
db.run('SELECT bookID, authors FROM books LIMIT 300;')
books = db.fetch_all()

author_to_id = {}
next_author_id = 1
book_author_pairs = []

for bookID, authors_str in books:
    author_names = [name.strip() for name in authors_str.split('/')]
    for author in author_names:
        if author not in author_to_id:
            author_to_id[author] = next_author_id
            next_author_id += 1
        book_author_pairs.append((bookID, author_to_id[author]))

# write authors to authors.sql
authors_sql_path = os.path.join(os.pardir, 'authors' ,'authors.sql')
with open(authors_sql_path, 'a') as f:
    f.write("INSERT INTO authors (authorID, name) VALUES\n")
    for author, authorID in author_to_id.items():
        f.write(f"('{authorID}', '{author}'),\n")

# write book-author links to book_authors.sql
book_authors_sql_path = os.path.join(os.pardir, 'book_authors.sql')
with open(book_authors_sql_path, 'a') as f:
    f.write("INSERT INTO book_authors (bookID, authorID) VALUES\n")
    for bookID, authorID in book_author_pairs:
        f.write(f"('{bookID}', '{authorID}'),\n")
