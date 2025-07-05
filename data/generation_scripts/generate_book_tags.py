import os
import random
import sys

sys.path.append(os.path.join(os.pardir, os.pardir, 'backend'))
from database import Database 

db = Database()
db.use_database('cs348_project')

db.run('SELECT bookID FROM books ORDER BY bookID LIMIT 100;')
books = [row[0] for row in db.fetch_all()]

num_tags = 100
min_tags_per_book, max_tags_per_book = 1, 5

entries = []


# Generate book-tag pairs
for book_id in books:
    tag_ids = random.sample(range(1, num_tags + 1), random.randint(min_tags_per_book, max_tags_per_book))
    for tag_id in tag_ids:
        entries.append(f"({book_id}, {tag_id})")

file_path = os.path.join(os.pardir, os.pardir, 'data', 'book_tag.sql')

with open(file_path, 'a', encoding='utf-8') as f:
    f.write("INSERT INTO `book_tag` (`bookID`, `tagID`) VALUES\n")
    for i, entry in enumerate(entries):
        if i < len(entries) - 1:
            f.write(entry + ",\n")
        else:
            f.write(entry + ";\n") # last line ends with semicolon

