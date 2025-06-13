# CS 348 Project
Our project is built using MySQL for the database, Python for the backend, and React/TypeScript for the frontend.

## Setup instructions

1. Download and setup MySQL from the document on LEARN
2. Create a `.env` file **at the root of the repository** with the following structure:

```
USER=<user>
PWD=<password>
```

Note: `<user>` and `<password>` is the username and password that you used when setting up MySQL.

3. To set up the database schema and sample data, run `./setup.sh` (Note: you may need to run `chmod +x setup.sh` first)

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
source venv/bin/activate # if you are using a virtual env
cd backend
python backend.py
```


### Frontend

```bash
cd frontend
npm run dev
```

