mysql -u $1 -p cs348_project < data/drop_tables.sql
mysql -u $1 -p cs348_project < data/books.sql
mysql -u $1 -p cs348_project < data/users.sql
mysql -u $1 -p cs348_project < data/books_read.sql
mysql -u $1 -p cs348_project < data/wishlists.sql

echo "Database setup complete"