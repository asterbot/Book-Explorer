import { useState, useEffect } from "react";
import { Search, Filter, BookOpen, ScrollText, Tally5 } from "lucide-react";
import { BookCard } from "../components/BookCard";
import type { Book } from "../types";

interface HomePageProps {
  username: string;
}

async function searchBooks(query: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/search?q=${query}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
    return [];
  }
}

async function getGenreCounts() {
  try {
    const response = await fetch("http://127.0.0.1:5000/genrecounts");
    const data = await response.json();
    return data.genre_counts;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
    return {};
  }
}

async function getBooksByGenre(genre: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/genre?genre=${genre}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error fetching books by genre: ${error}`);
    return [];
  }
}

async function addBook(username: string, bookID: number, status: string) {
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

async function viewTopWishlists(count: number) {
  try {
    const response = await fetch(
      `http://127.0.0.1:5000/top-wishlists?n=${count}`
    );
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
  }
}

async function viewTopBooks(count: number){
  try{
    const response = await fetch(
      `http://127.0.0.1:5000/top-books?limit=${count}`
    )
    const data = await response.json();
    return data.results;
  }
  catch(error){
    console.error(`Error when connecting to DB: ${error}`);
  }
}



export function HomePage({ username }: HomePageProps) {
  const [books, setBooks] = useState<Book[]>([]);
  const [searchQuery, setSearchQuery] = useState("");
  const [genreCounts, setGenreCounts] = useState<{ [genre: string]: number }>({});
  const [showGenreDropdown, setShowGenreDropdown] = useState(false);
  const [selectedGenre, setSelectedGenre] = useState<string>("");
  const [isLoading, setIsLoading] = useState(false);

  const [topN, setTopN] = useState(5);  // used for top n wishlisted/rated books

  const [addedBooks, setAddedBooks] = useState<{[id: number]: string}>({});

  useEffect(() => {
    loadGenreCounts();
  }, []);

  const loadGenreCounts = async () => {
    const counts = await getGenreCounts();
    setGenreCounts(counts);
  };

  const handleSearch = async () => {
    if (searchQuery.trim() !== "") {
      setIsLoading(true);
      const results = await searchBooks(searchQuery);
      setBooks(results);
      setIsLoading(false);
    }
  };

  const handleGenreClick = async (genre: string) => {
    setIsLoading(true);
    setSelectedGenre(genre);
    const results = await getBooksByGenre(genre);
    setBooks(results);
    setShowGenreDropdown(false);
    setIsLoading(false);
  };

  const handleStatusChange = async (bookID: number, status: string) => {
    if (username) {
      if (status === "NONE") {
        await addBook(username, bookID, "NOT STARTED");
      } else {
        await addBook(username, bookID, status);
        setAddedBooks(prev => ({ ...prev, [bookID]: status }));
      }
    }
  };

  const handleViewTopWishlist = async () => {
    const results = await viewTopWishlists(topN);
    console.log(results);
    setBooks(results);
  };

  const handleTopRated = async () => {
    const results = await viewTopBooks(topN);
    setBooks(results);
  }


  return (
    <div className="home-page">
      <div className="welcome-section">
        <h1>Hello, {username}!</h1>
        <p>Discover your next favorite book</p>
      </div>

      <div className="search-section">
        <div className="search-container">
          <div className="search-input-wrapper">
            <Search className="search-icon" size={20} />
            <input
              type="text"
              placeholder="Search for books..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && handleSearch()}
              className="search-input"
            />
          </div>
          <button onClick={handleSearch} className="search-button">
            Search
          </button>
        </div>

        <div className="filter-wrapper">

          <div className="filter-section">
            <button
              className="filter-button"
              onClick={() => setShowGenreDropdown(!showGenreDropdown)}
            >
              <Filter size={16} />
              {selectedGenre ? `Genre: ${selectedGenre}` : "Filter by Genre"}
            </button>
            
            {showGenreDropdown && (
              <div className="genre-dropdown">
                <div className="genre-header">
                  <h4>Select Genre</h4>
                  <button
                    onClick={() => {setShowGenreDropdown(false); setSelectedGenre(""); setBooks([])}}
                    className="close-button"
                  >
                    ×
                  </button>
                </div>
                <div className="genre-list">
                  {Object.entries(genreCounts).map(([genre, count]) => (
                    <div
                      key={genre}
                      className="genre-option"
                      onClick={() => handleGenreClick(genre)}
                    >
                      <span className="genre-name">{genre}</span>
                      <span className="genre-count">({count} books)</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>

          <div className="top-n-section">

          <label style = {{marginRight: '8px'}}>
                  Top <input
                    type="number"
                    min="1"
                    max="100"
                    value={topN}
                    onChange={(e) => setTopN(Number(e.target.value))}
                  />
              </label> books by

            <br />
            <div className="top-n-buttons">
                <button
                  className="filter-button"
                  onClick={() => handleTopRated()}
                  style={{ marginRight: '5px' }}
                >
                <Tally5 size={16} /> Rating
                </button>
                <button
                  className="filter-button"
                  onClick={() => handleViewTopWishlist()}
                >
                <ScrollText size={16} />  Wishlist count
                </button>
            </div>
            
        </div>

        </div>

      </div>

      <div className="books-section">
        {isLoading ? (
          <div className="loading">
            <BookOpen className="loading-icon" size={48} />
            <p>Searching for books...</p>
          </div>
        ) : books.length > 0 ? (
          <div className="books-grid">
            {books.map((book) => (
              <div key={book.bookID} className="book-item">
                <BookCard
                  book={book}
                  currentStatus={addedBooks[book.bookID] as any}
                  onStatusChange={handleStatusChange}
                />
              </div>
            ))}
          </div>
        ) : (
          <div className="empty-state">
            <BookOpen className="empty-icon" size={64} />
            <h3>No books found</h3>
            <p>Try searching for a book or selecting a genre to get started</p>
          </div>
        )}
      </div>
    </div>
  );
} 