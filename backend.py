import mysql.connector
from dotenv import dotenv_values

config = dotenv_values(".env")  # config = {"USER": "foo", "EMAIL": "foo@example.org"}


# Connect to server
cnx = mysql.connector.connect(
    host="127.0.0.1",
    port=3306,
    user=config["USER"],
    password=config["PWD"]
    )

# Get a cursor
cur = cnx.cursor()

# Execute a query
cur.execute("use cs348_project;")
cur.execute("SELECT * from books;")

# Fetch one result
row = cur.fetchone()
print("Hello World! The first row:")
print(row)

# Close connection
cnx.close()
