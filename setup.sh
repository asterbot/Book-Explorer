# Run this script when there is a change to the data/ folder

echo "Setting up database..."

FILES=""

# Drop existing tables
python runSQL.py data/drop_tables.sql

# Books/users/userprogress
python runSQL.py data/books.sql
python runSQL.py data/users.sql
python runSQL.py data/userprogress.sql
python runSQL.py data/user_rating.sql

# Tags
python runSQL.py data/tags/tag.sql
python runSQL.py data/tags/book_tag.sql
python runSQL.py data/tags/user_book_tag.sql

# Authors
python runSQL.py data/authors/authors.sql
python runSQL.py data/authors/book_authors.sql

# Publishers
python runSQL.py data/publishers/publishers.sql
python runSQL.py data/publishers/book_publishers.sql

# Genre
python runSQL.py data/genres/genre.sql
python runSQL.py data/genres/bookgenre.sql

# Book Club
python runSQL.py data/book_clubs.sql

echo "Database setup complete, check tables on postgresSQL"
