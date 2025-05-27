from database import Database

if __name__=="__main__":
    print("Hello World Program")
    db = Database()

    db.use_database("cs348_project")
    db.select_rows("books")
    print(db.fetch_rows(1))

    db.select_rows("books",["bookID","title"])
    print(db.fetch_rows(1))

