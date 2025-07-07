import { useState, useEffect } from "react";

import { BookCard } from "./components/BookCard";

import type { Book, BookClub, ClubDetails } from "./types";

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
enum bookStatus {
  NOT_STARTED = "NOT STARTED",
  IN_PROGRESS = "IN PROGRESS",
  FINISHED = "FINISHED",
}

async function viewWishlist(
  username: string,
  status: bookStatus = bookStatus.NOT_STARTED
) {
  try {
    const response = await fetch(
      `http://127.0.0.1:5000/userlist?username=${username}&status=${status}`
    );
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function addBook(username: string, bookID: number, status: bookStatus) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/userprogress`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        username: username,
        bookID: bookID,
        status: status,
      }),
    });
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function findCommonBooks(username1: string, username2: string) {
  try {
    const response = await fetch(
      `http://127.0.0.1:5000/common-books?u1name=${username1}&u2name=${username2}`
    );
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function getBookCompletionRates(username: string) {
  try {
    const response = await fetch(
      `http://127.0.0.1:5000/book-completion-rates?username=${username}`
    );
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function getGenreCounts() {
  try {
    const response = await fetch("http://127.0.0.1:5000/genrecounts");
    const data = await response.json();
    return data.genre_counts;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function getBookClubs(): Promise<BookClub[] | undefined> {
  try {
    const response = await fetch("http://127.0.0.1:5000/bookclubs");
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error fetching book clubs: ${error}`);
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

  // Book completion rates
  const [completionRates, setCompletionRates] = useState<any[]>();

  // Genre
  const [genreCounts, setGenreCounts] = useState<{ [genre: string]: number }>();
  const [showGenreDropdown, setShowGenreDropdown] = useState(false);

  // Clubs
const [bookClubs, setBookClubs] = useState<BookClub[]>();
const [showBookClubs, setShowBookClubs] = useState(false);
const [viewMode, setViewMode] = useState<"books" | "clubs">("books");
const [selectedClub, setSelectedClub] = useState<ClubDetails | null>(null);


  const handleSearch = async () => {
    if (searchQuery.trim() !== "") {
      const results = await searchBooks(searchQuery);
      setBooks(results);
    }
  };

  const handleViewList = async (status: bookStatus) => {
    if (username.trim() != "") {
      const results = await viewWishlist(username, status);
      if (status == bookStatus.NOT_STARTED) setWishlist(results);
      else if (status == bookStatus.IN_PROGRESS) setInProgress(results);
      else if (status == bookStatus.FINISHED) setFinished(results);
    }
  };

  const handleCommonBooks = async () => {
    if (username.trim() != "" && otherUsername.trim() != "") {
      const results = await findCommonBooks(username, otherUsername);
      console.log(results);
      setCommonBooks(results);
    }
  };

  const handleCompletionRates = async () => {
    const results = await getBookCompletionRates(username);
    setCompletionRates(results);
  };

  const handleGenreCounts = async () => {
    if (!genreCounts) {
      const counts = await getGenreCounts();
      setGenreCounts(counts);
    }
    setShowGenreDropdown((prev) => !prev);
  };

  const handleGenreClick = async (genre: string) => {
    const results = await getBooksByGenre(genre);
    setBooks(results);
    setShowGenreDropdown(false);
    setViewMode("books"); 
  };

  const handleViewBookClubs = async () => {
    if (!bookClubs) {
      const results = await getBookClubs();
      setBookClubs(results);
    }
    setShowBookClubs((prev) => !prev);
  };


  async function getBooksByGenre(genre: string) {
    try {
      const response = await fetch(`http://127.0.0.1:5000/genre?genre=${genre}`);
      const data = await response.json();
      return data.results;
    } catch (error) {
      console.error(`Error fetching books by genre: ${error}`);
    }
  }

  async function getClubDetails(clubID: number): Promise<ClubDetails | null> {
    try {
      const response = await fetch(`http://127.0.0.1:5000/bookclubs/${clubID}`);
      const data = await response.json();

      if (!response.ok) {
        console.error("Backend error:", data.error);
        return null;
      }

      return data;
    } catch (error) {
      console.error(`Error fetching club details: ${error}`);
      return null;
    }
  }

  const collapseLists = () => {
    setWishlist(undefined);
    setInProgress(undefined);
    setFinished(undefined);
    setCommonBooks(undefined);
    setCompletionRates(undefined);
    setShowBookClubs(false);
  };

  // Fetch book data from backend endpoint API
  useEffect(() => {
    setSearchQuery("Harry Potter");
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
          <div className="sidebar-left">
            <div>
              Your Username: <br />
              <input
                type="text"
                placeholder="Enter your username"
                value={username}
                onChange={(e) => {
                  setUsername(e.target.value);
                  collapseLists();
                }}
              />
            </div>

            <div className="list-container">
              <button
                className="list-button"
                onClick={() => handleViewList(bookStatus.NOT_STARTED)}
              >
                Wishlist
              </button>
              {wishlist && (
                <div className="list-grid">
                  {wishlist.map((book) => (
                    <div key={book.bookID}>
                      <p>
                        <span className="book-title">{book.title}</span>
                        <span className="book-author"> by {book.authors}</span>
                      </p>
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div className="list-container">
              <button
                className="list-button"
                onClick={() => handleViewList(bookStatus.IN_PROGRESS)}
              >
                Books In Progress
              </button>
              {inProgress && (
                <div className="list-grid">
                  {inProgress.map((book) => (
                    <div key={book.bookID}>
                      <p>
                        <span className="book-title">{book.title}</span>
                        <span className="book-author"> by {book.authors}</span>
                      </p>
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div className="list-container">
              <button
                className="list-button"
                onClick={() => handleViewList(bookStatus.FINISHED)}
              >
                Books Read
              </button>
              {finished && (
                <div className="list-grid">
                  {finished.map((book) => (
                    <div key={book.bookID}>
                      <p>
                        <span className="book-title">{book.title}</span>
                        <span className="book-author"> by {book.authors}</span>
                      </p>
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div className="list-container">
              <p
                style={{
                  marginBottom: "1rem",
                  color: "#666",
                  textDecoration: "underline",
                  cursor: "pointer",
                }}
                onClick={() => handleCompletionRates()}
              >
                Which of my current books should I finish first?
              </p>
              {completionRates && (
                <div className="completion-rates">
                  {completionRates.length > 0 ? (
                    completionRates.map((book) => (
                      <div key={book.bookID} className="completion-item">
                        <div className="book-info">
                          <span className="book-title">{book.title}</span>
                          <span className="book-author">by {book.authors}</span>
                        </div>
                        <div className="completion-stats">
                          <span className="completion-rate">
                            {book.completion_rate}%
                          </span>
                          <span className="completion-details">
                            {book.completed_users}/{book.total_users} users
                            finished
                          </span>
                        </div>
                      </div>
                    ))
                  ) : (
                    <p
                      style={{
                        fontSize: "12px",
                        color: "#999",
                        fontStyle: "italic",
                      }}
                    >
                      No books currently in progress.
                    </p>
                  )}
                </div>
              )}
            </div>
            <div className="list-container">
              <button className="list-button" onClick={handleGenreCounts}>
                Genres
              </button>
              {showGenreDropdown && genreCounts && (
                <div className="genre-dropdown">
                  {Object.entries(genreCounts).map(([genre, count]) => (
                    <div
                      key={genre}
                      className="genre-option"
                      onClick={() => handleGenreClick(genre)}
                    >
                      <strong>{genre}</strong>: {count}
                    </div>
                  ))}
                </div>
              )}
            </div>
            <div className="list-container">
              <button
                className="list-button"
                onClick={async () => {
                  if (!bookClubs) {
                    const results = await getBookClubs();
                    setBookClubs(results);
                  }
                  setViewMode("clubs");
                }}
              >
                Book Clubs
              </button>
              {showBookClubs && bookClubs && (
                <div className="list-grid">
                  {bookClubs.map((club) => (
                    <div key={club.clubID}>
                      <p className="book-title">{club.name}</p>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>

          <div className="sidebar-right">
            <div>
              Other Username: <br />
              <input
                type="text"
                placeholder="Enter other username"
                value={otherUsername}
                onChange={(e) => setOtherUserName(e.target.value)}
              />
            </div>

            <div className="list-container">
              <button
                className="list-button"
                onClick={() => handleCommonBooks()}
              >
                Find Common Books
              </button>
              {commonBooks && (
                <div className="list-grid">
                  {commonBooks.map((book) => (
                    <div key={book.bookID}>
                      <p>
                        <span className="book-title">{book.title}</span>
                        <span className="book-author"> by {book.authors}</span>
                      </p>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>

        <div className="main-content">
          <div className="search-container">
            <input
              type="text"
              placeholder="Search for books"
              value={searchQuery}
              className="search-input"
              onChange={(e) => setSearchQuery(e.target.value)}
            />
            <button
              onClick={async () => {
                await handleSearch();
                setViewMode("books");
              }}
            >
              Search
            </button>
          </div>

          <main className="app-main">
            <div className="container">
              {username && (
                <div className="username-container">
                  <p>Hello, {username}!</p>
                </div>
              )}
              {viewMode === "books" && (
                <>
                  {books ? (
                    <div className="books-grid">
                      {books.map((book) => (
                        <div key={book.bookID} className="book-item">
                          <BookCard book={book} />
                          {username && (
                            <>
                              <button
                                className="wishlist-btn"
                                onClick={() =>
                                  addBook(username, book.bookID, bookStatus.NOT_STARTED)
                                }
                              >
                                Add to wishlist
                              </button>
                              <button
                                className="reading-btn"
                                onClick={() =>
                                  addBook(username, book.bookID, bookStatus.IN_PROGRESS)
                                }
                              >
                                I'm reading this book
                              </button>
                              <button
                                className="read-btn"
                                onClick={() =>
                                  addBook(username, book.bookID, bookStatus.FINISHED)
                                }
                              >
                                I've read this book
                              </button>
                            </>
                          )}
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div className="books-grid">
                      <p>Click "Search" to see books.</p>
                    </div>
                  )}
                </>
              )}

              {viewMode === "clubs" && (
                <div className="books-grid">
                  {bookClubs?.map((club) => (
                    <div
                      key={club.clubID}
                      className="book-item"
                      style={{ cursor: "pointer" }}
                      onClick={async () => {
                        const details = await getClubDetails(club.clubID);
                        if (details) setSelectedClub(details);
                      }}
                    >
                      <p className="book-title">{club.name}</p>
                      <p style={{ fontSize: "12px", color: "#888" }}>
                        {club.member_count} members
                      </p>
                      <p className="book-author">{club.description}</p>
                    </div>
                  ))}
                </div>
              )}
              {selectedClub && (
                <div className="modal-overlay" onClick={() => setSelectedClub(null)}>
                  <div
                    className="modal-content"
                    onClick={(e) => e.stopPropagation()}
                    style={{
                      background: "#fff",
                      padding: "1.5rem",
                      borderRadius: "12px",
                      maxWidth: "600px",
                      width: "90%",
                      maxHeight: "80vh",
                      overflowY: "auto",
                    }}
                  >
                    <h2>{selectedClub.name}</h2>
                    <p style={{ fontSize: "14px", color: "#666" }}>{selectedClub.description}</p>
                    <p style={{ fontSize: "13px", marginBottom: "1rem" }}>
                      👥 {selectedClub.member_count} members
                    </p>

                    <h3>📖 Currently Reading</h3>
                    <ul>
                      {selectedClub.current_books.length > 0 ? (
                        selectedClub.current_books.map((book) => (
                          <li key={book.bookID}>
                            {book.title} by {book.authors}
                          </li>
                        ))
                      ) : (
                        <li><em>No current books</em></li>
                      )}
                    </ul>

                    <h3>✔️ Already Finished</h3>
                    <ul>
                      {selectedClub.past_books.length > 0 ? (
                        selectedClub.past_books.map((book) => (
                          <li key={book.bookID}>
                            {book.title} (finished {book.end_date})
                          </li>
                        ))
                      ) : (
                        <li><em>No finished books</em></li>
                      )}
                    </ul>

                    <h3>👥 Members</h3>
                    <ul>
                      {selectedClub.members.map((m) => (
                        <li key={m.userID}>{m.name}</li>
                      ))}
                    </ul>
                  </div>
                </div>
              )}
              {!books && (
                <div className="books-grid">
                  <p>Click "Search" to see books.</p>
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
