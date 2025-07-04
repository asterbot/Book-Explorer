import sys
from tabulate import tabulate

import os
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'backend'))
from database import Database # type: ignore



if len(sys.argv) <= 1:
    raise ValueError("Enter name of SQL file to run. Usage: python runSQL.py [file].sql")


if __name__ == "__main__":
    FILE = sys.argv[1]

    with open(FILE) as f:
        query = f.read()

    db = Database(show_logs=False)
    db.run(query)
    
    db.commit()
    
    try:
        rows=db.fetch_all()
        column_names = [desc[0] for desc in db.cursor.description]
        
        print(tabulate(rows, headers=column_names, tablefmt="psql"))

    except Exception:
        exit(0)