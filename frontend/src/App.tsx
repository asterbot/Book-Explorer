import { useState, useEffect} from 'react';

import { BookCard } from './components/BookCard';

import { mockBooks } from './mockData';
import type { Book } from './types';
import './App.css';

function App() {
  const [books, setBooks] = useState<Book[]>(mockBooks);

  // Fetch book data from backend endpoint API
  useEffect(()=>{
    fetch(`http://localhost:5000/search`)
    .then(response => {
      return response.json();
    })
    .then(data => {
      setBooks(data.results);
    })
    .catch(error => {
      console.error(`Error when connecting to DB: ${error}`);
      console.log("Using mock data instead.");
    })
  }, []);

  return (
    <div className="app">
      <header className="app-header">
        <div className="container">
          <h1>Book Discovery & Tracking</h1>
          <p>Discover new books, manage your reading list, and track your literary journey</p>
        </div>
      </header>

      <main className="app-main">
        <div className="container">
          <div className="books-grid">
            {books.map(book => (
              <BookCard
                key={book.bookID}
                book={book}
              />
            ))}
          </div>

        </div>
      </main>

    </div>
  );
}

export default App;
