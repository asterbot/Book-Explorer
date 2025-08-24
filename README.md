<div align="center">
  <br>

  # Book Explorer
  <i> Discover, track and share books!</i> <br>

A full-stack web app with personalized recommendations, reading analytics, and book clubs

![Supabase][Supabase]
![PostgresSQL][PSQL]
![React][React.js]
![Python][Python]
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#book-explorer">Book Explorer</a>
      <ul>
        <li><a href="#tech-stack">Tech Stack</a></li>
      </ul>
    </li>
    <li>
      <a href="#setup-instructions">Setup Instructions</a>
      <ul>
        <li><a href="#db-access">DB Access</a></li>
        <li><a href="#running-locally">Running Locally</a></li>
      </ul>
    </li>
    <li><a href="#features-implemented">Features Implemented</a></li>
    <li><a href="#screenshots">Screenshots</a></li>
    <li><a href="#contributors">Contributors</a></li>
  </ol>
</details>



## Setup instructions

### DB access
The database is hosted on Supabase via PostgresSQL. \
To set up the database, you will first need to create a blank database on Supabase and enter your API credentials in `.env` in the root of the repository. \
It will have the following format:
```.env
user=...
password=...
host=...
port=...
dbname=...
```

Then, set up a virtual environment in the backend

```bash
cd backend
python -m venv venv/
source venv/bin/activate
pip install -r requirements.txt 
```

If you want to initialize the database, run `./setup.sh` in the root directory after setting up the virtual environment.
> This is the script that initializes the database schemas and loads sample data into them.

Then you should be able to run any SQL query with `python runSQL.py [name-of-sql-file].sql` and see the output on the terminal.

## Running locally

To run the app locally, do the following after the DB setup has been done:

### Backend
```bash
cd backend
source venv/bin/activate # if you are using a virtual env
python backend.py # use python3 instead if you have an older python version installed
```

This command starts the Flask development server with API endpoints

### Frontend

```bash
cd frontend
npm install
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
- **Tag-Based Book Recommendations (R11):** Suggests books based on tags you frequently use, by finding other readers with similar preferences.
- **Finding Book Clubs Based on Genre (R12):** Recommends book clubs that align with your reading history.
- **Book Completion Rate (R13):** Displays how many readers finish a book after starting it—useful for picking engaging reads.
- **Concurrent Club Join Limit (R14):** Trigger to ensure fairness when multiple users try to join the last available slot in a book club.
- **Reading Streak (R15):** Tracks consecutive reading days to keep you motivated.

---
## Screenshots
**Home page:** \
<img width="1903" height="924" alt="Screenshot from 2025-08-19 14-26-10" src="https://github.com/user-attachments/assets/164f9e19-6526-4d03-bb1f-e4344925df0c" /> 

**Recommendations page:**\
<img width="1903" height="924" alt="Screenshot from 2025-08-19 14-26-29" src="https://github.com/user-attachments/assets/80726dbe-40fb-42bb-b7d6-07a3d2fca27f" />


**Profile page:**\
<img width="1903" height="924" alt="Screenshot from 2025-08-19 14-26-41" src="https://github.com/user-attachments/assets/302e0dfa-e421-4d39-89b1-9719e5dfc7fa" />

# Tech stack

- **Frontend:** React with TypeScript
- **Backend:** Python (Flask REST API, Psycopg2 for PostgreSQL integration)
- **Database:** PostgreSQL (hosted on Supabase)


# Contributors

|Name|GitHub|
|-|-|
|Arjun | [asterbot](https://github.com/asterbot/) 
|Skylar | [Skylarrji](https://github.com/Skylarrji)
|Serena| [xuserena12](https://github.com/xuserena12)
|Gary| [garysu92](https://github.com/garysu92)
|Thanh | [lvthanh03](https://github.com/lvthanh03) |
---


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[Python]: https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54
[Supabase]: https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white
[PSQL]: https://img.shields.io/badge/postgresql-4169e1?style=for-the-badge&logo=postgresql&logoColor=white
