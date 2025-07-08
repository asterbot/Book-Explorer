with open("books.sql", "r") as f:
    content = f.read()
    
lines = content.split("\n")

insert_statement = "INSERT INTO books (bookID, title, average_rating, isbn, language_code, num_pages) VALUES "
n = len(insert_statement)

for line in lines:
    if line.startswith("INSERT INTO"):
        x = line[n:].split(',')
        with open("tmp.sql","a") as f:
            f.write(f"{insert_statement}{x[0]}, {x[1]}, {x[3]}, {x[4]}, {x[6]}, {x[7]});\n")
