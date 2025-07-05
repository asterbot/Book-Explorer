import sys
import os
from random import randint, sample

# Importing library from another directory
sys.path.append(os.path.join(os.pardir, os.pardir, 'backend'))
from database import Database # type: ignore

db =  Database()

## bookIDs
db.run('SELECT bookID from books;')
bookIDs = list(map(lambda x: x[0], db.fetch_all())) # all bookID's

## genreIDs
genreIDs = [i for i in range(1,9)]


with open(os.path.join(os.pardir, 'genre.sql'), 'a') as f:
    for bookID in bookIDs:
        num_genres = randint(1,3)
        genres = sample(genreIDs, num_genres)
        
        for genreID in genres:
            f.write(f"({bookID}, {genreID}),\n")
        
