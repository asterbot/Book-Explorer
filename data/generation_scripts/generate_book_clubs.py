import sys
import os
from random import randint, sample, choice
from datetime import datetime, timedelta

sys.path.append(os.path.join(os.pardir, os.pardir, "backend"))
from database import Database  # type: ignore

db = Database()

OUT_FILE   = os.path.join(os.pardir, "book_clubs.sql")
NUM_CLUBS  = 117

# Fetch required data
db.run("SELECT userid FROM users;")
user_ids = [row[0] for row in db.fetch_all()]

db.run("SELECT bookid FROM books;")
book_ids = [row[0] for row in db.fetch_all()]

next_club_id = 1

# Generate SQL
with open(OUT_FILE, "a", encoding="utf-8") as f:
    for i in range(NUM_CLUBS):
        clubid      = next_club_id + i
        name        = f"Book Club {i + 1}"
        description = f"This is the description for {name}."
        creatorid   = choice(user_ids)
        max_members = randint(2, 12)

        # Insert into bookclubs
        f.write(
            "INSERT INTO production.bookclubs (clubid, name, description, max_members) "
            f"VALUES ({clubid}, '{name}', '{description}', {max_members});\n"
        )

        # Insert into bookclub_creators (new table)
        f.write(
            "INSERT INTO production.bookclub_creators (clubid, userid) "
            f"VALUES ({clubid}, {creatorid});\n"
        )

        # Insert members (creator is included)
        num_members = randint(1, max_members - 1)
        members = set(sample([uid for uid in user_ids if uid != creatorid], num_members))
        members.add(creatorid)
        for uid in members:
            f.write(
                f"INSERT INTO production.bookclub_members (clubid, userid) "
                f"VALUES ({clubid}, {uid});\n"
            )

        # Insert bookclub_reads (1–3 current + 1-3 past)
        used_books = set()
        today = datetime.today().date()

        # Current reads (is_current = TRUE)
        for _ in range(randint(1, 3)):
            bookid = choice([b for b in book_ids if b not in used_books])
            used_books.add(bookid)

            start = today - timedelta(days=randint(0, 30))
            end   = today + timedelta(days=randint(15, 45))

            f.write(
                "INSERT INTO production.bookclub_reads (clubid, bookid, start_date, end_date, is_current) "
                f"VALUES ({clubid}, {bookid}, '{start}', '{end}', TRUE);\n"
            )

        # Past reads (is_current = FALSE)
        for _ in range(randint(1, 3)):
            bookid = choice([b for b in book_ids if b not in used_books])
            used_books.add(bookid)

            end = today - timedelta(days=randint(1, 180))
            start = end - timedelta(days=30)

            f.write(
                "INSERT INTO production.bookclub_reads (clubid, bookid, start_date, end_date, is_current) "
                f"VALUES ({clubid}, {bookid}, '{start}', '{end}', FALSE);\n"
            )

        f.write("\n")

print(f"Generated {NUM_CLUBS} book clubs with creators, members, and reading history.")
