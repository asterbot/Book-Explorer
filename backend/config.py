import os
from dotenv import dotenv_values
from typing import Optional

DOT_ENV_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".env")
config = dotenv_values(DOT_ENV_PATH)

def get_env_config(name: str) -> Optional[str]:
    if name in config:
        return config[name]
    else:
        # If the environment variable is not found
        return None


RELATION = get_env_config("relation") or "public"

## Tables
AUTHORS = f"{RELATION}.authors"
BOOK_AUTHORS = f"{RELATION}.book_authors"
BOOK_PUBLISHERS = f"{RELATION}.book_publishers"
BOOKCLUB_CREATORS = f"{RELATION}.bookclub_creators"
BOOKCLUB_MEMBERS = f"{RELATION}.bookclub_members"
BOOKCLUB_READS = f"{RELATION}.bookclub_reads"
BOOKCLUBS = f"{RELATION}.bookclubs"
BOOKGENRE = f"{RELATION}.bookgenre"
BOOKS = f"{RELATION}.books"
GENRE = f"{RELATION}.genre"
PUBLISHERS = f"{RELATION}.publishers"
TAG = f"{RELATION}.tag"
USER_BOOK_TAG = f"{RELATION}.user_book_tag"
USERPROGRESS = f"{RELATION}.userprogress"
USERRATING = f"{RELATION}.userrating"
USERS = f"{RELATION}.users"

## Views
V_USER_GENRE_SCORE = f"{RELATION}.v_user_genre_score"
V_CLUB_GENRE_SCORE = f"{RELATION}.v_club_genre_score"