import os
import random
import sys

sys.path.append(os.path.join(os.pardir, os.pardir, 'backend'))
from database import Database 

db = Database()
db.use_database('cs348_project')

db.run('SELECT bookID FROM books LIMIT 100;')
books = [row[0] for row in db.fetch_all()]

num_users = 50
num_tags = 100

entries = set()

for user_id in range(1, num_users + 1):
    books_tagged = random.sample(books, random.randint(1, 5))
    for book_id in books_tagged:
        tag_ids = random.sample(range(1, num_tags + 1), random.randint(1, 3)) # 1–3 tags per book
        for tag_id in tag_ids:
            entries.add((user_id, book_id, tag_id))


file_path = os.path.join(os.pardir, os.pardir, 'data', 'user_book_tag.sql')

with open(file_path, 'a', encoding='utf-8') as f:
    f.write("INSERT INTO `user_book_tag` (`userID`, `bookID`, `tagID`) VALUES\n")
    for i, (user_id, book_id, tag_id) in enumerate(entries):
        line = f"({user_id}, {book_id}, {tag_id})"
        if i < len(entries) - 1:
            f.write(line + ",\n")
        else:
            f.write(line + ";\n") # last line with semicolon

