import { useState, useEffect } from "react";

import { BookCard } from "./components/BookCard";

import type { Book } from "./types";
import "./App.css";

async function searchBooks(query: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/search?q=${query}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}


// Status of book
enum bookStatus{
  NOT_STARTED = "NOT STARTED",
  IN_PROGRESS = "IN PROGRESS",
  FINISHED = "FINISHED"
}

async function viewWishlist(username: string, status: bookStatus = bookStatus.NOT_STARTED) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/userlist?username=${username}&status=${status}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function addToWishlist(username: string, bookID: number) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/userlist`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({username: username, bookID: bookID}),
    });
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function findCommonBooks(username1: string, username2: string){
  try {
    const response = await fetch(`http://127.0.0.1:5000/common-books?u1name=${username1}&u2name=${username2}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

function App() {
  const [books, setBooks] = useState<Book[]>();
  const [searchQuery, setSearchQuery] = useState("");

  // Usernames
  const [username, setUsername] = useState("");
  const [otherUsername, setOtherUserName] = useState("");

  // User status lists
  const [wishlist, setWishlist] = useState<Book[]>();
  const [inProgress, setInProgress] = useState<Book[]>();
  const [finished, setFinished] = useState<Book[]>();
  
  // Common books between 2 users
  const [commonBooks, setCommonBooks] = useState<Book[]>();

  const handleSearch = async () => {
    if (searchQuery.trim() !== "") {
      const results = await searchBooks(searchQuery);
      setBooks(results);
    }
  };

  const handleViewList = async(status: bookStatus) =>{
    if (username.trim()!=""){
      const results = await viewWishlist(username, status)
      if (status==bookStatus.NOT_STARTED) setWishlist(results)
      else if (status==bookStatus.IN_PROGRESS) setInProgress(results)
      else if (status==bookStatus.FINISHED) setFinished(results)
    }
  }

  const handleCommonBooks = async() =>{
    if (username.trim()!="" && otherUsername.trim()!=""){
      const results = await findCommonBooks(username, otherUsername);
      console.log(results)
      setCommonBooks(results);
    }
  }


  // Fetch book data from backend endpoint API
  useEffect(() => {
    setSearchQuery("harry potter");
    setUsername("Alex");
    setOtherUserName("Bob");
  }, []);

  return (
    <div className="app">
      <header className="app-header">
        <div className="container">
          <h1>Book Discovery & Tracking</h1>
          <p>
            Discover new books, manage your reading list, and track your
            literary journey
          </p>
        </div>
      </header>

      <div className="app-content">
        <div className="sidebar">
          <div className="username-container">
            Your Username: <br />
            <input
              type="text"
              placeholder="Enter your username"
              value = {username}
              onChange={(e) => setUsername(e.target.value)}
            />
          </div>

          <br />

          <div className="list-container">
            <button onClick={() => handleViewList(bookStatus.NOT_STARTED)}>View Wishlist</button>
            {wishlist && (
              <div className="list-grid">
                {wishlist.map((book) => (
                  <div key={book.bookID}>
                    <p>{book.title} by {book.authors}</p>
                  </div>
                ))}
              </div>
            )}
          </div>

          <br />

          <div className="list-container">
            <button onClick={() => handleViewList(bookStatus.IN_PROGRESS)}>View Books in progress</button>
            {inProgress && (
              <div className="list-grid">
                {inProgress.map((book) => (
                  <div key={book.bookID}>
                    <p>{book.title}</p>
                  </div>
                ))}
              </div>
            )}
          </div>

          <br />

          <div className="list-container">
            <button onClick={() => handleViewList(bookStatus.FINISHED)}>View Books Read</button>
            {finished && (
              <div className="list-grid">
                {finished.map((book) => (
                  <div key={book.bookID}>
                    <p>{book.title}</p>
                  </div>
                ))}
              </div>
            )}
          </div>

          <br /><br />
          <div className="username-container">
            Other Username: <br />
            <input
              type="text"
              placeholder="Enter other username"
              value={otherUsername}
              onChange={(e) => setOtherUserName(e.target.value)}
            />
          </div>

          <br />

          <div className="list-container">
            <button onClick={() => handleCommonBooks()}>Find Common Books</button>
            {commonBooks && (
              <div className="list-grid">
                {commonBooks.map((book) => (
                  <div key={book.bookID}>
                    <p>{book.title}</p>
                  </div>
                ))}
              </div>
            )}
          </div>

        </div>

        <div className="main-content">
          <div className="search-container">
            <input
              type="text"
              placeholder="Search for books"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
            <button onClick={handleSearch}>Search</button>
          </div>

          <main className="app-main">
            <div className="container">
              {username && (
                <div className="username-container">
                  <p>Hello, {username}!</p>
                </div>
              )}
              {books && (
                <div className="books-grid">
                  {books.map((book) => (
                    <div key={book.bookID}>
                      <BookCard book={book} />
                      {username && (
                        <button onClick={() => addToWishlist(username, book.bookID)}>Add to Wishlist</button>
                      )}
                    </div>
                  ))}
                </div>
              )}
              {!books && (
                <div className="books-grid">
                  <p>Click "Search" to see books</p>
                </div>
              )}
            </div>
          </main>
        </div>
      </div>
    </div>
  );
}

export default App;
