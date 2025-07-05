# Run this script when there is a change to the data/ folder

echo "Setting up database..."
python runSQL.py data/drop_tables.sql
python runSQL.py data/books.sql
python runSQL.py data/users.sql
python runSQL.py data/userprogress.sql
python runSQL.py data/tag.sql
python runSQL.py data/book_tag.sql
python runSQL.py data/user_book_tag.sql

echo "Database setup complete, check tables on postgresSQL"
