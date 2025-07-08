import sys
import os
import random
import csv

# import from books.csv
with open(os.path.join(os.pardir, 'books.csv'), 'r') as f:
    reader = csv.reader(f)
    books = list(reader)
# sample line from books.csv
# 1,Harry Potter and the Half-Blood Prince (Harry Potter #6),J.K. Rowling/Mary GrandPré,4.57,0439785960,9780439785969,eng,652,2095690,27591,9/16/2006,Scholastic Inc.

author_to_id = {}
next_author_id = 155
book_author_pairs = []

for book in books:
    bookID = book[0]
    author_name = [name.strip() for name in book[2].split('/')][0]
    if author_name not in author_to_id:
        author_to_id[author_name] = next_author_id
        next_author_id += 1
    book_author_pairs.append((bookID, author_name))
    
# write authors to users.sql
users_sql_path = os.path.join(os.pardir, 'users.sql')
with open(users_sql_path, 'a') as f:
    for author, authorID in author_to_id.items():
        f.write(f"('{authorID}', '{author}', '{author.lower().replace(' ', '')}@example.com'),\n")

# write authors to authors.sql
authors_sql_path = os.path.join(os.pardir, 'authors', 'authors.sql')
with open(authors_sql_path, 'a') as f:
    f.write("INSERT INTO authors (authorID, year_of_birth) VALUES\n")
    for author, authorID in author_to_id.items():
        f.write(f"('{authorID}', '{random.randint(1900, 1980)}'),\n")

# write book-author links to book_authors.sql
book_authors_sql_path = os.path.join(os.pardir, 'authors', 'book_authors.sql')
with open(book_authors_sql_path, 'a') as f:
    f.write("INSERT INTO book_authors (bookID, authorID) VALUES\n")
    for bookID, author_name in book_author_pairs:
        f.write(f"('{bookID}', '{author_to_id[author_name]}'),\n")
