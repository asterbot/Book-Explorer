# CS 348 Project
Our project is built using MySQL for the database, Python for the backend, and React/TypeScript for the frontend.

## Setup instructions

1. Download and setup MySQL from the document on LEARN.
2. Create a `.env` file with the following structure:

```
USER=<user>
PWD=<password>
```

Note: `<user>` and `<password>` is the username and password that you used when setting up MySQL.

3. To load the database into mysql, run `mysql -u <user> -p cs348_project < books.sql`
4. Run `pip install -r requirements.txt`
5. Try running `python backend.py` and see that the first row of the database gets printed to the console. The expected output is:
```
Hello World! The first row:
(1, 'Harry Potter and the Half-Blood Prince (Harry Potter  #6)', 'J.K. Rowling/Mary GrandPré', 4.57, '0439785960', 9780439785969, 'eng', 652, 2095690, 27591, '9/16/2006', 'Scholastic Inc.')
```

