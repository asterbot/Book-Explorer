import sys
import os
from random import randint, sample, choice
from datetime import datetime, timedelta

sys.path.append(os.path.join(os.pardir, os.pardir, "backend"))
from database import Database

db = Database()

OUT_FILE   = os.path.join(os.pardir, "book_clubs.sql")
NUM_CLUBS  = 117


db.run("SELECT userid FROM users;")
user_ids = [row[0] for row in db.fetch_all()]

db.run("SELECT bookid FROM books;")
book_ids = [row[0] for row in db.fetch_all()]

db.run("SELECT COALESCE(MAX(clubid), 0) FROM bookclubs;")
next_club_id = db.fetch_all()[0][0] + 1

with open(OUT_FILE, "a") as f:
    for i in range(NUM_CLUBS):
        clubid      = next_club_id + i
        name        = f"Book Club {i + 1}"
        description = f"This is the description for {name}."
        creatorid   = choice(user_ids)

        f.write(
            "INSERT INTO bookclubs (clubid, name, description) "
            f"VALUES ({clubid}, '{name}', '{description}');\n"
        )

        members = set(sample(user_ids, randint(5, 20) - 1))
        members.add(creatorid)

        for uid in members:
            f.write(
                f"INSERT INTO bookclub_members (clubid, userid) "
                f"VALUES ({clubid}, {uid});\n"
            )

        used_books = set()
        today      = datetime.today().date()

        for _ in range(randint(1, 3)):
            bookid = choice([b for b in book_ids if b not in used_books])
            used_books.add(bookid)

            start = today - timedelta(days=randint(0, 30))
            end   = today + timedelta(days=randint(15, 45))

            f.write(
                "INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) "
                f"VALUES ({clubid}, {bookid}, '{start}', '{end}', TRUE);\n"
            )

        for _ in range(randint(5, 15)):
            bookid = choice([b for b in book_ids if b not in used_books])
            used_books.add(bookid)

            end   = today - timedelta(days=randint(1, 180))
            start = end - timedelta(days=30)

            f.write(
                "INSERT INTO bookclub_reads (clubid, bookid, start_date, end_date, is_current) "
                f"VALUES ({clubid}, {bookid}, '{start}', '{end}', FALSE);\n"
            )

        f.write("\n")

