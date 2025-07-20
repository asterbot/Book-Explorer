import { useState, useEffect } from "react";

import { BookCard } from "./components/BookCard";

import { type UserLogs, type Book, type BookProgress } from "./types";
import "./App.css";
import { ProgressCard } from "./components/ProgressCard";
import { StreakCounter } from "./components/StreakCounter";

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

async function viewWishlist(username: string, status: bookStatus = bookStatus.NOT_STARTED) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/userlist?username=${username}&status=${status}`);
    const data = await response.json();
    return data.results.map((book: any) => ({
      bookID: book.bookID,
      title: book.title,
      authors: book.authors,
      page_reached: book.page_reached,
      num_pages: book.num_pages,
    }));

  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function addBook(username: string, bookID: number, status: bookStatus) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/userprogress`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, bookID, status }),
    });
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function findCommonBooks(username1: string, username2: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/common-books?u1name=${username1}&u2name=${username2}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function getBookCompletionRates(username: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/book-completion-rates?username=${username}`);
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

async function getBooksByGenre(genre: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/genre?genre=${genre}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error fetching books by genre: ${error}`);
  }
}


async function viewTopWishlists(count: number) {
  try {
    const response = await fetch(
      `http://127.0.0.1:5000/top-wishlists?n=${count}`
    );
    const data = await response.json();
    return data;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function getClubSuggestion(username: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/suggest-club/${encodeURIComponent(username)}`);
    return await response.json();
  } catch (error) {
    console.error(`Error getting suggestion: ${error}`);
    return { error: "Could not connect to backend" };
  }
}

async function getRecommendations(username: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/recommendations?username=${encodeURIComponent(username)}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error fetching recommendations: ${error}`);
  }
}

async function joinBookClub(username: string, clubID: number) {
  try {
    const response = await fetch(
      `http://127.0.0.1:5000/join_book_club?username=${encodeURIComponent(username)}&clubID=${clubID}`,
      {
        method: "POST",
      }
    );
    const data = await response.json();
    return data;
  } catch (error) {
    console.error(`Error joining book club: ${error}`);
  }
}

async function getStreak(username: string){
  try{
    const response = await fetch(
      `http://127.0.0.1:5000/streak?username=${encodeURIComponent(username)}`,
    )
    const data = await response.json();
    return data.streak
  }
  catch (error){
    console.error(`Error finding streak for ${username}: ${error}`)
  }
}


async function getUserLogs(username: string){
  try{
    const response = await fetch(
      `http://127.0.0.1:5000/userlogs?username=${encodeURIComponent(username)}`,
    )
    const data = await response.json()
    return data.results.map((book: any) => ({
      book_title: book.book_title,
      authors: book.authors,
      timestamp: new Date(book.timestamp),  // make it a date object
      page_reached: book.page_reached,
    }));
  }
  catch (error){
    console.error(`Error: ${error}`)
  }
}

async function updateProgress(username: string, bookId: number, newpage: number, newdate: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/updateprogress`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        username,
        bookId,
        newpage,
        newdate,
      }),
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
  const [otherUsername, setOtherUserName] = useState("");

  const [wishlist, setWishlist] = useState<BookProgress[]>();
  const [inProgress, setInProgress] = useState<BookProgress[]>();
  const [finished, setFinished] = useState<BookProgress[]>();
  const [commonBooks, setCommonBooks] = useState<Book[]>();
  const [completionRates, setCompletionRates] = useState<any[]>();
  const [genreCounts, setGenreCounts] = useState<{ [genre: string]: number }>();
  const [showGenreDropdown, setShowGenreDropdown] = useState(false);

  const [topWishlists, setTopWishlists] = useState<Book[]>();
  const [topN, setTopN] = useState(5);  

  const [suggestion, setSuggestion] = useState<any>(null);
  const [recommendedBooks, setRecommendedBooks] = useState<Book[]>();

  const [clubID, setClubID] = useState<number|"">("");
  const [joinClubMessage, setJoinClubMessage] = useState<string | null>(null);
  const [joinClubError, setJoinClubError] = useState<boolean>(false);

  const [streak, setStreak] = useState<number>(0);

  const [userlogs, setUserLogs] = useState<UserLogs[]>();


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
    if (username.trim() && otherUsername.trim()) {
      const results = await findCommonBooks(username, otherUsername);
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
  };

  const handleSuggestClub = async () => {
    if (!username.trim()) return;
    const res = await getClubSuggestion(username.trim());
    setSuggestion(res);
  };

  const handleRecommendations = async () => {
    if (!username.trim()) return;
    const results = await getRecommendations(username);
    setRecommendedBooks(results);
  };

  const findStreak = async () => {
    if (!username.trim()) return;
    const result = await getStreak(username);
    setStreak(result)
  }

  const findUserLogs = async () => {
    if (!username.trim()) return;
    const result = await getUserLogs(username);
    setUserLogs(result);
  }


  const handleViewTopWishlist = async () => {
    setTopWishlists(undefined);
    const results = await viewTopWishlists(topN);
    setTopWishlists(results);
  };

  const collapseLists = () => {
    setWishlist(undefined);
    setInProgress(undefined);
    setFinished(undefined);
    setCommonBooks(undefined);
    setCompletionRates(undefined);
    setTopWishlists(undefined);
    setRecommendedBooks(undefined);
  };

  const handleProgressUpdate = (bookId: number,newDate: Date, newPage: number) => {
    updateProgress(username, bookId, newPage, newDate.toUTCString())
  }

  useEffect(() => {
    setSearchQuery("Harry Potter");
    setUsername("Alex");
    setOtherUserName("Bob");
  }, []);


  useEffect(() => {
    if (username.trim()) {
      findStreak();
    }
  }, [username, wishlist, inProgress, finished]);

  useEffect(()=>{
    if (username.trim()){
      findUserLogs();
    }
  }, [username, wishlist, inProgress, finished]);

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
                    <div className="progress-card">
                      <ProgressCard book={book} onUpdateProgress={handleProgressUpdate} />
                      <br />
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
                    <div className="progress-card">
                      <ProgressCard book={book} onUpdateProgress={handleProgressUpdate} />
                      <br />
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
                    <div className="progress-card">
                      <ProgressCard book={book} onUpdateProgress={handleProgressUpdate} />
                    <br />
                  </div>
                  ))}
                </div>
              )}
            </div>
            <div className="list-container">
            <label>
              Enter number of top wishlists to fetch:
              <input
                type="number"
                min="1"
                max="100"
                value={topN}
                onChange={(e) => setTopN(Number(e.target.value))}
              />
            </label>
              <button
                className="list-button"
                onClick={() => handleViewTopWishlist()}
              >
                Top Current Wishlists
              </button>
              {topWishlists && (
                <div className="list-grid">
                  {topWishlists.map((book) => (
                    <div key={book.bookID}>
                      <p>
                        <span className="book-title">{book.title}</span>
                        <span className="book-wishlist-count">Count: {book.wishlist_count}</span>
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
            <div className="list-container" style={{ marginTop: "1rem" }}>
              <button className="list-button" onClick={handleSuggestClub}>
                Suggest a Book Club
              </button>
              {suggestion && (
                <div style={{ marginTop: "0.5rem", fontSize: "14px" }}>
                  {"clubName" in suggestion && (
                    <>
                      <strong>Recommended Club:</strong>{" "}
                      <span style={{ color: "#0066cc" }}>
                        {suggestion.clubName}
                      </span>
                      <br />
                      <em>{suggestion.reason}</em>
                    </>
                  )}
                  {"message" in suggestion && (
                    <span>{suggestion.message}</span>
                  )}
                  {"error" in suggestion && (
                    <span style={{ color: "red" }}>{suggestion.error}</span>
                  )}
                </div>
              )}
            </div>

            <div className="list-container">
              <button className="list-button" onClick={handleRecommendations}>
                Book Recommendations
              </button>
              {recommendedBooks && (
                <div className="list-grid">
                  {recommendedBooks.map((book) => (
                    <div key={book.bookID}>
                      <p>
                        <span className="book-title">{book.title}</span>
                        {book.authors && <span className="book-author"> by {book.authors}</span>}
                      </p>
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div className="list-container">
              <div>
                <h3>Join a Book Club</h3>
                <input
                  type="number"
                  placeholder="Enter Club ID"
                  value={clubID}
                  onChange={(e) => setClubID(e.target.value === "" ? "" : Number(e.target.value))}
                  style={{ width: "100%", marginBottom: "0.5rem" }}
                />
                <button
                  onClick={async () => {
                    if (!username.trim()) {
                      setJoinClubMessage("Please enter your username first.");
                      setJoinClubError(true);
                      return;
                    }
                    if (!clubID) {
                      setJoinClubMessage("Please enter a valid club ID.");
                      setJoinClubError(true);
                      return;
                    }
                    const result = await joinBookClub(username.trim(), clubID);
                    if (result?.success) {
                      setJoinClubMessage(result.message);
                      setJoinClubError(false);
                    } else {
                      setJoinClubMessage(result?.error || "Failed to join the club.");
                      setJoinClubError(true);
                    }
                  }}
                >
                  Join Book Club
                </button>
                {joinClubMessage && (
                  <p style={{ color: joinClubError ? "red" : "green", marginTop: "0.5rem" }}>
                    {joinClubMessage}
                  </p>
                )}
              </div>
            </div>
            
          </div>

          <div className="sidebar-right" style={{ marginLeft: "5rem" }}>
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
                      </p>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>

        <div className="main-content" style={{ marginLeft: "5rem" }}>
          <div className="search-container">
            <input
              type="text"
              placeholder="Search for books"
              value={searchQuery}
              className="search-input"
              onChange={(e) => setSearchQuery(e.target.value)}
            />
            <button onClick={handleSearch}>Search</button>
          </div>

          <main className="app-main">
            <div className="container">
              {username && (
                <div className="username-container" style={{ marginLeft: "5rem" }}>
                  <p>Hello, {username}!</p>
                </div>
              )}
              {books && (
                <div className="books-grid" style={{ marginLeft: "5rem" }}>
                  {books.map((book) => (
                    <div key={book.bookID} className="book-item">
                      <BookCard book={book} />
                      {username && (
                        <button
                          className="wishlist-btn"
                          onClick={() =>
                            addBook(
                              username,
                              book.bookID,
                              bookStatus.NOT_STARTED
                            )
                          }
                        >
                          Add to wishlist
                        </button>
                      )}
                      {username && (
                        <button
                          className="reading-btn"
                          onClick={() =>
                            addBook(
                              username,
                              book.bookID,
                              bookStatus.IN_PROGRESS
                            )
                          }
                        >
                          I'm reading this book
                        </button>
                      )}
                      {username && (
                        <button
                          className="read-btn"
                          onClick={() =>
                            addBook(username, book.bookID, bookStatus.FINISHED)
                          }
                        >
                          I've read this book
                        </button>
                      )}
                    </div>
                  ))}
                </div>
              )}
              {!books && (
                <div className="books-grid" style={{ marginLeft: "5rem" }}>
                  <p>Click "Search" to see books.</p>
                </div>
              )}
            </div>
          </main>
        </div>
        
        <div style={{ float: "right", maxWidth: "400px", marginRight: "2rem" }}>
          <center><StreakCounter username={username} streak={streak} /> </center>
          <h2 style={{ textAlign: "left" }}>Reading history</h2>
          <br />
          <table className="userlog-table">
            <thead>
              <tr>
                <th>Book</th>
                <th>Authors</th>
                <th>Page reached</th>
                <th>Timestamp</th>
              </tr>
            </thead>
            <tbody>
              {userlogs?.map((userlog, index) => (
                <tr key={index}>
                  <td>{userlog.book_title}</td>
                  <td>{userlog.authors}</td>
                  <td>{userlog.page_reached}</td>
                  <td>{userlog.timestamp.toUTCString()}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

      </div>
      
    </div>
  );
}

export default App;
