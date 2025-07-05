import os
import sys

# Import your database interface
sys.path.append(os.path.join(os.pardir, os.pardir, 'backend'))
from database import Database  # type: ignore

db = Database()
db.use_database('cs348_project')

# get first 300 books and publishers
db.run("SELECT bookID, publisher FROM books LIMIT 300;")
rows = db.fetch_all()

# extract unique publishers and map to IDs
publisher_to_id = {}
book_publisher_links = []
next_id = 1

for bookID, publisher in rows:
    if not publisher:
        continue
    publisher = publisher.strip()
    if publisher not in publisher_to_id:
        publisher_to_id[publisher] = next_id
        next_id += 1
    publisherID = publisher_to_id[publisher]
    book_publisher_links.append((bookID, publisherID))

# write to publishers.sql
with open(os.path.join(os.pardir, 'publishers.sql'), 'w') as f:
    f.write("INSERT INTO publishers (publisherID, name) VALUES\n")
    for i, (name, publisherID) in enumerate(publisher_to_id.items()):
        escaped_name = name.replace("'", "''")
        comma = ',' if i < len(publisher_to_id) - 1 else ';'
        f.write(f"('{publisherID}', '{escaped_name}'){comma}\n")

# write to book_publishers.sql
with open(os.path.join(os.pardir, 'book_publishers.sql'), 'w') as f:
    f.write("INSERT INTO book_publishers (bookID, publisherID) VALUES\n")
    for i, (bookID, publisherID) in enumerate(book_publisher_links):
        comma = ',' if i < len(book_publisher_links) - 1 else ';'
        f.write(f"('{bookID}', '{publisherID}'){comma}\n")

print("Generated publishers.sql and book_publishers.sql")
