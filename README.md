## Setup instructions

## DB access

To set up the db, first set up the virtual environment:

```bash
cd backend
python -m venv venv/
source venv/bin/active
pip install -r requirements.txt 
```

Then you should be able to run any SQL query with `python runSQL.py [name-of-sql-file].sql` (even if it is in another directory) and see the output

## Running locally

### Backend
```bash
cd backend
source venv/bin/activate # if you are using a virtual env
python backend.py # use python3 instead if you have an older python version installed
```


### Frontend

```bash
cd frontend
npm run dev
```


---

## Features Implemented

The current application supports the following features (linked to SQL queries in `queries/milestone1/`):

- Search for books by title (R6)  
- Add books to a wishlist (R7)  
- View common books between users (R8)  
- Browse top 5 highest-rated books (R9)  

---

## Project Components

### C2. SQL Schema Files (located in `data/`)  
- `data/books.csv` – Full production dataset for the `Books` table.  
- `data/books.sql` – Inserts sample data (approx. the first 300 entries of the production dataset) into the `Books` table.  
- `data/users.sql` – Inserts sample entries into the `Users` table, generated using `data/generation_scripts/generate_users.py`.  
- `data/userprogress.sql` – Inserts sample progress records into the `UserProgress` table, generated using `data/generation_scripts/generate_user_progress.py`.  
- `data/drop_tables.sql` – Resets all tables by dropping existing schema objects.

### Sample Queries   
- `queries/milestone1/R6-test.sql` – Search book titles  
- `queries/milestone1/R7-test.sql` – Add to wishlist  
- `queries/milestone1/R8-test.sql` – Find common books  
- `queries/milestone1/R9-test.sql` – Top 5 books by rating  

**Output Files** (in `queries/milestone1/`):  
`R6-test.out`, `R7-test.out`, `R8-test.out`, `R9-test.out` contain the expected output from running the queries on the sample database (not the full dataset).

### C5. Application Code  
- `frontend/`: React + TypeScript client  
- `backend/`: Python Flask server with REST API for SQL execution  
- `setup.sh`: Script to initialize the database with schema and data  

---

