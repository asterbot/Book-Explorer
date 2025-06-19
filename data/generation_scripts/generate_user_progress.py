import sys
import os

sys.path.append(os.path.join(os.pardir, os.pardir, 'backend'))
from database import Database # type: ignore
from random import randint, choice

db = Database()
db.use_database('cs348_project')

states = ['NOT STARTED', 'IN PROGRESS', 'FINISHED']

done = []

db.run('SELECT bookID from books;')
bookIDs = list(map(lambda x: x[0], db.fetch_all())) # all bookID's

db.run('SELECT userID from users;')
userIDs = list(map(lambda x: x[0], db.fetch_all()))

with open(os.path.join(os.pardir,'userprogress.sql'),'a') as f:
    for _ in range(100):
        bookID = choice(bookIDs)
        userID = choice(userIDs)
        state = choice(states)

        db.run(f'SELECT num_pages FROM books WHERE bookID={bookID}')
        num_pages = db.fetch_all()[0][0]

        page=0
        if state=='NOT STARTED': page=0
        elif state=='IN PROGRESS': page = randint(1,num_pages-1)
        else: page=num_pages
    
        if not (userID, bookID) in done:
            f.write(f"('{userID}', '{bookID}', '{state}', {page}),\n")

            done.append((userID, bookID))
