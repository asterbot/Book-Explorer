import os
import sys

sys.path.append(os.path.join(os.pardir, os.pardir, 'backend'))
from database import Database  # type: ignore

db = Database()

# get first 300 books and their publisher and publication_date
db.run("SELECT bookID, publisher, publication_date FROM books LIMIT 300;")
rows = db.fetch_all()

# extract unique publishers and map to IDs
publisher_to_id = {}
book_publisher_links = []
next_id = 1

for bookID, publisher, pub_date in rows:
    if not publisher:
        continue
    publisher = publisher.strip()
    if publisher not in publisher_to_id:
        publisher_to_id[publisher] = next_id
        next_id += 1
    publisherID = publisher_to_id[publisher]
    book_publisher_links.append((bookID, publisherID, pub_date))

# write to publishers.sql
with open(os.path.join(os.pardir, 'publishers', 'publishers.sql'), 'a') as f:
    f.write("INSERT INTO publishers (publisherID, name) VALUES\n")
    for i, (name, publisherID) in enumerate(publisher_to_id.items()):
        escaped_name = name.replace("'", "''")
        comma = ',' if i < len(publisher_to_id) - 1 else ';'
        f.write(f"('{publisherID}', '{escaped_name}'){comma}\n")

# write to book_publishers.sql 
with open(os.path.join(os.pardir, 'publishers', 'book_publishers.sql'), 'a') as f:
    f.write("INSERT INTO book_publishers (bookID, publisherID, publication_date) VALUES\n")
    for i, (bookID, publisherID, pub_date) in enumerate(book_publisher_links):
        escaped_date = pub_date.replace("'", "''") if pub_date else ''
        comma = ',' if i < len(book_publisher_links) - 1 else ';'
        f.write(f"('{bookID}', '{publisherID}', '{escaped_date}'){comma}\n")

print("Generated publishers.sql and book_publishers.sql with publication_date")
