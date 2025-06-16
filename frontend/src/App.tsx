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

async function viewWishlist(username: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/wishlist?username=${username}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function addToWishlist(username: string, bookID: number) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/wishlist`, {
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

function App() {
  const [books, setBooks] = useState<Book[]>();
  const [searchQuery, setSearchQuery] = useState("");
  const [username, setUsername] = useState("");
  const [wishlist, setWishlist] = useState<Book[]>();

  const handleSearch = async () => {
    if (searchQuery.trim() !== "") {
      const results = await searchBooks(searchQuery);
      setBooks(results);
    }
  };

  const handleViewWishlist = async () => {
    if (username.trim() !== "") {
      const results = await viewWishlist(username);
      setWishlist(results);
    }
  };

  // Fetch book data from backend endpoint API
  useEffect(() => {
    setSearchQuery("harry potter");
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

      <div className="search-container">
        <input
          type="text"
          placeholder="Search for books"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
        />
        <button
          onClick={() => {
            handleSearch();
          }}
        >
          Search
        </button>
      </div>

      <div className="username-container">
        <input
          type="text"
          placeholder="Enter your username"
          onChange={(e) => setUsername(e.target.value)}
        />
      </div>

      <div className="wishlist-container">
        <button onClick={() => {
          handleViewWishlist();
        }}>View Wishlist</button>
        {wishlist && (
          <div className="wishlist-grid">
            {wishlist.map((bookID) => (
              <div key={bookID}>
                <p>{bookID}</p>
              </div>
            ))} 
          </div>
        )}
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
              {books?.map((book) => (
                <div key={book.bookID}>
                  <BookCard book={book} />
                  {username && (
                    <button onClick={() => {
                      addToWishlist(username, book.bookID);
                    }}>Add to Wishlist</button>
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
  );
}

export default App;
