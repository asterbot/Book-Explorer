if [ $# -ne 1 ]; then
    echo "Usage: ./setup.sh [user-name]"
    echo "Use the username used for mysql"
    exit 1
fi

echo "Setting up database..."
mysql -u $1 -p cs348_project < data/drop_tables.sql
mysql -u $1 -p cs348_project < data/books.sql
mysql -u $1 -p cs348_project < data/users.sql
mysql -u $1 -p cs348_project < data/userprogress.sql
mysql -u $1 -p cs348_project < data/tag.sql
mysql -u $1 -p cs348_project < data/book_tag.sql
mysql -u $1 -p cs348_project < data/user_book_tag.sql


echo "Database setup complete"
echo "Now set up .env as-per the README"
