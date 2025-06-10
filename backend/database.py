import mysql.connector
from dotenv import dotenv_values
import os


class Database:
    # Get the directory where this file is located, then go up one level to project root
    DOT_ENV_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".env")
    config = dotenv_values(DOT_ENV_PATH)

    LOCALHOST_IP="127.0.0.1"
    LOCALHOST_PORT=3306

    def __init__(self):
        """Initialize connection and cursor"""
        try:
            self.cnx = mysql.connector.connect(
                    host=self.LOCALHOST_IP,
                    port=self.LOCALHOST_PORT,
                    user=self.config["USER"],
                    password=self.config["PWD"]
            )
            self.cursor = self.cnx.cursor(buffered=True)
            print("Connection successful")
        except Exception:
            print("Your connection failed, please check that your .env file is in the root of the repository")


    def __del__(self):
        """Disconnect upon object deletion"""
        self.cnx.close()
        print("Disconnected from database")


    def use_database(self,database: str) -> None:
        """
        Switches to provided database

        Args:
            database (str): Database name
        """
        self.cursor.execute(f"use {database};")
        print(f"Switched to {database}")
    


    ## ------------------------------ Query commands -------------------------------------

    def select_rows(self, table:str, rows=["*"], condition = "") -> None:
        """
        Selects the provided rows of a given table
        By default selects all rows (*)

        Args:
            table (str): Table name
            rows (list[str], optional): The rows to select. Defaults to ["*"].
        """
        rows_as_strings = ", ".join(rows)
        self.cursor.execute(f"SELECT {rows_as_strings} FROM {table};")

    def run(self,query: str) -> None:
        """
        Runs a general SQL query
        Use this if there is no existing function for the query and/or no need for an abstraction

        Args:
            query (str): Query to run
        """
        self.cursor.execute(query)


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
