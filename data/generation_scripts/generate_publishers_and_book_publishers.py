import csv
import os
import re

# paths
script_dir = os.path.dirname(__file__)
csv_path = os.path.abspath(os.path.join(script_dir, os.pardir, 'books.csv'))
publishers_sql_path = os.path.abspath(os.path.join(script_dir, os.pardir, 'publishers', 'publishers.sql'))
book_publishers_sql_path = os.path.abspath(os.path.join(script_dir, os.pardir, 'publishers', 'book_publishers.sql'))

# data
publisher_to_id = {}
book_publisher_links = []
next_id = 1
row_count = 0
MAX_ROWS = 300

# read books.csv
with open(csv_path, 'r', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        if row_count >= MAX_ROWS:
            break

        bookID = row['bookID'].strip()
        publisher = row['publisher'].strip()
        pub_date = row['publication_date'].strip()

        if not publisher:
            continue

        # normalize whitespace
        publisher_cleaned = re.sub(r'\s+', ' ', publisher)

        if publisher_cleaned not in publisher_to_id:
            publisher_to_id[publisher_cleaned] = next_id
            next_id += 1

        publisherID = publisher_to_id[publisher_cleaned]
        book_publisher_links.append((bookID, publisherID, pub_date))
        row_count += 1

os.makedirs(os.path.dirname(publishers_sql_path), exist_ok=True)

# add to publishers.sql
with open(publishers_sql_path, 'a', encoding='utf-8') as f:
    f.write("INSERT INTO publishers (publisherID, name) VALUES\n")
    for i, (name, publisherID) in enumerate(publisher_to_id.items()):
        escaped_name = name.replace("'", "''")
        prefix = '' if i == 0 else ',\n'
        f.write(f"{prefix}({publisherID}, '{escaped_name}')")
    f.write(';\n')

# add to book_publishers.sql
with open(book_publishers_sql_path, 'a', encoding='utf-8') as f:
    f.write("INSERT INTO book_publishers (bookID, publisherID, publication_date) VALUES\n")
    for i, (bookID, publisherID, pub_date) in enumerate(book_publisher_links):
        escaped_date = pub_date.replace("'", "''")
        prefix = '' if i == 0 else ',\n'
        f.write(f"{prefix}({bookID}, {publisherID}, '{escaped_date}')")
    f.write(';\n')

print(f"Done: Processed {row_count} books, {len(publisher_to_id)} unique publishers.")
