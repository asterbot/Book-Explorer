import sys
import os
from random import randint, sample, choice

# Importing library from another directory
sys.path.append(os.path.join(os.pardir, os.pardir, 'backend'))
from database import Database # type: ignore

db =  Database()

## bookIDs
db.run('SELECT bookID from books;')
bookIDs = list(map(lambda x: x[0], db.fetch_all())) # all bookID's

## userIDs
db.run('SELECT userID from users;')
userIDs = list(map(lambda x: x[0], db.fetch_all()))

done = [] # all (userID, bookID) pairs that are done

review_phrases = [
    "Couldnt put it down",
    "A real page-turner",
    "Beautifully written prose",
    "Deeply moving story",
    "Highly recommend this book",
    "Characters felt so real",
    "Incredibly thought-provoking",
    "Packed with emotion",
    "Fast-paced and exciting",
    "An instant favorite",
    "Brilliantly crafted narrative",
    "Left me speechless",
    "Full of surprises",
    "Heartwarming and honest",
    "A true masterpiece",
    "Engaging from the start",
    "Fresh and original",
    "Emotionally resonant journey",
    "Made me cry",
    "Unexpected plot twists",
    "Lacked character development",
    "Too predictable for me",
    "Dragged in the middle",
    "Not my cup of tea",
    "Fell flat for me",
    "Confusing at times",
    "Ending felt rushed",
    "Well-researched and detailed",
    "Insightful and inspiring",
    "Will reread for sure",
    ""
]

for _ in range(250):
    userID = choice(userIDs)
    bookID = choice(bookIDs)
    
    review_text = choice(review_phrases)
    rating = randint(1,10)
    
    with open(os.path.join(os.pardir,'user_rating.sql'),'a') as f:
        f.write(f"('{userID}','{bookID}', {rating}, '{review_text}'),\n")

