import psycopg2
from dotenv import load_dotenv
from config import get_env_config

class Database:

    def __init__(self, show_logs=True):
        """Initialize connection and cursor"""
        
        self.show_logs = show_logs
        
        load_dotenv()

        self.cnx = psycopg2.connect(
            user = get_env_config("user"),
            password = get_env_config("password"),
            host = get_env_config("host"),
            port = get_env_config("port"),
            dbname = get_env_config("dbname")
        )

        self.cursor = self.cnx.cursor()
        if self.show_logs:
            print("Connection to database successful")


    def __del__(self):
        """Disconnect upon object deletion"""
        self.cnx.close()
        if self.show_logs:
            print("Disconnected from database")

    ## ------------------------------ Query commands -------------------------------------

    def select_rows(self, table:str, rows=["*"], condition = "", num_rows=5) -> None:
        """
        Selects the provided rows of a given table
        By default selects all rows (*)

        Args:
            table (str): Table name
            rows (list[str], optional): The rows to select. Defaults to ["*"].
        """
        rows_as_strings = ", ".join(rows)
        self.cursor.execute(f"""SELECT {rows_as_strings} 
                            FROM {table} 
                            {f"WHERE {condition}" if condition else ""}
                            LIMIT {num_rows};""")

    def run(self,query: str) -> None:
        """
        Runs a general SQL query
        Use this if there is no existing function for the query and/or no need for an abstraction

        Args:
            query (str): Query to run
        """
        self.cursor.execute(query)

    def commit(self) -> None:
        """
        Commits the current transaction to persist changes
        """
        self.cnx.commit()


    ## ------------------------------ Fetch commands -------------------------------------

    def fetch_rows(self,num_rows=1):
        """
        Fetched a specified number of rows from the result run before

        Args:
            num_rows (int, optional): The number of rows to fetch. Defaults to 1.

        Returns:
            list[str]: The list of rows returned by previous command
        """
        return self.cursor.fetchmany(num_rows)
            

    def fetch_all(self):
        """
        Fetch all rows from previously executed query

        Returns:
            list[str]: List of rows returned by previous command
        """
        return self.cursor.fetchall()
