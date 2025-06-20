## Setup instructions

1. Download and setup MySQL from the document on LEARN
2. Create a `.env` file **at the root of the repository** with the following structure:

```
USER=<user>
PWD=<password>
```

Note: `<user>` and `<password>` is the username and password that you used when setting up MySQL.

3. To set up the database schema and sample data, run `./setup.sh` (Note: you may need to run `chmod +x setup.sh` first). Note that the script might prompt you to type in your password multiple times if you have a password associated with your MySQL account. 

### Setting up backend
Run the following to set up the backend:
```bash
cd backend
chmod +x setup_venv.sh
./setup_venv.sh
```
> **Note:** If you don't want to set up a virtual environment and prefer to install the packages globally, simply run `pip install -r requirements.txt` in the backend folder


### Setting up frontend
Run the following to set up the frontend:
```bash
cd frontend
npm install
```

## Running locally

Run the frontend and backend in separate terminal sessions

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
- `data/books.sql` – Inserts sample data (subset of production) into the `Books` table.  
- `data/users.sql` – Inserts sample entries into the `Users` table.  
- `data/userprogress.sql` – Inserts sample progress records into the `UserProgress` table.  
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

