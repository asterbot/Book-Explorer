import re

with open("books.sql", "r") as f:
    lines = f.readlines()

insert_statement = "INSERT INTO books (bookID, title, isbn, language_code, num_pages) VALUES "

with open("tmp.sql", "w") as out_f:
    for line in lines:
        if line.startswith("INSERT INTO"):
            match = re.search(r"VALUES\s*\((.*)\);", line, re.IGNORECASE)
            if match:
                values_str = match.group(1)

                import csv
                reader = csv.reader([values_str], skipinitialspace=True)
                values = next(reader)

                bookID = values[0]
                title = values[1]
                isbn = values[3]
                language_code = values[4]
                num_pages = values[5]

                out_f.write(f"{insert_statement}({bookID}, {title}, {isbn}, {language_code}, {num_pages});\n")
