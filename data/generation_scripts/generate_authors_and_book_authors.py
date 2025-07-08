import csv
import os
import re

script_dir = os.path.dirname(__file__)
csv_path = os.path.abspath(os.path.join(script_dir, os.pardir, 'books.csv'))
authors_sql_path = os.path.abspath(os.path.join(script_dir, os.pardir, 'authors', 'authors.sql'))
book_authors_sql_path = os.path.abspath(os.path.join(script_dir, os.pardir, 'authors', 'book_authors.sql'))

author_to_id = {}
book_author_pairs = []
next_author_id = 1
row_count = 0
MAX_ROWS = 300

with open(csv_path, 'r', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        if row_count >= MAX_ROWS:
            break

        bookID = int(row['bookID'])
        authors_str = row['authors'].strip()
        if not authors_str:
            continue

        author_names = [name.strip() for name in authors_str.split('/') if name.strip()]
        for author in author_names:
            cleaned_author = re.sub(r'\s+', ' ', author).strip()

            if cleaned_author not in author_to_id:
                author_to_id[cleaned_author] = next_author_id
                next_author_id += 1

            book_author_pairs.append((bookID, author_to_id[cleaned_author]))

        row_count += 1


os.makedirs(os.path.dirname(authors_sql_path), exist_ok=True)

# add to authors.sql
with open(authors_sql_path, 'a', encoding='utf-8') as f:
    f.write("INSERT INTO authors (authorID, name) VALUES\n")
    for i, (author, authorID) in enumerate(author_to_id.items()):
        escaped_author = author.replace("'", "''")
        line_end = ';\n' if i == len(author_to_id) - 1 else ',\n'
        f.write(f"({authorID}, '{escaped_author}'){line_end}")

# add to book_authors.sql
with open(book_authors_sql_path, 'a', encoding='utf-8') as f:
    f.write("INSERT INTO book_authors (bookID, authorID) VALUES\n")
    for i, (bookID, authorID) in enumerate(book_author_pairs):
        line_end = ';\n' if i == len(book_author_pairs) - 1 else ',\n'
        f.write(f"({bookID}, {authorID}){line_end}")

print(f"Done: Processed {row_count} rows, created {len(author_to_id)} authors and {len(book_author_pairs)} book-author links.")
