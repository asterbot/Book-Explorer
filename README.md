## Setup instructions

## DB access
The PostgreSQL database is already deployed on Supabase with all schema and data loaded.
No setup is required unless you are making changes to the database.

However, you should still set up the virtual environment to run the backend:

```bash
cd backend
python -m venv venv/
source venv/bin/activate
pip install -r requirements.txt 
```

If you want to reinitialize the database, run `./setup.sh` in the root directory after setting up the virtual environment

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

The application supports the following features (linked to SQL queries in `queries/milestone3/`):

### Basic Features
- Search for books by title (R6)  
- Add books to a wishlist (R7)  
- View common books between two users (R8)  
- View top 5 highest-rated books (R9)  
- View top 5 most wishlisted books (R10)

### Fancy Features
- Tag-Based Book Recommendations (R11)
- Finding Book Clubs Based on Genre (R12)
- Book Completion Rate (R13)
- Book Club Limit (R14)
- Reading Streak (R15)

---

## Project Components

### C2. SQL Schema Files
All schema files are located in `data/`

### C3. Sample Queries   
All sample queries and outputs are located in `queries/milestone3/sample`

### C4. Production Queries   
All production queries and outputs are located in `queries/milestone3/prod`

### C5. Application Code  
- `frontend/`: React + TypeScript client  
- `backend/`: Python Flask server with REST API for SQL execution  
- `setup.sh`: Script to load the database with schema and data (do not run unless anything in `data/` has changed) 

---

