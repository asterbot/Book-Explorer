import { useState } from "react";
import { Users, Search, BookOpen } from "lucide-react";
import { BookCard } from "./BookCard";
import type { Book } from "../types";

async function findCommonBooks(username1: string, username2: string): Promise<Book[]> {
  try {
    const response = await fetch(`http://127.0.0.1:5000/common-books?u1name=${encodeURIComponent(username1)}&u2name=${encodeURIComponent(username2)}`);
    const data = await response.json();
    return data.results || [];
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
    return [];
  }
}

interface FindCommonBooksProps {
  currentUsername: string;
}

export function FindCommonBooks({ currentUsername }: FindCommonBooksProps) {
  const [otherUsername, setOtherUsername] = useState("");
  const [commonBooks, setCommonBooks] = useState<Book[]>([]);
  const [commonLoading, setCommonLoading] = useState(false);
  const [commonError, setCommonError] = useState<string | null>(null);
  const [commonSearched, setCommonSearched] = useState(false);

  const handleFindCommonBooks = async () => {
    setCommonError(null);
    setCommonBooks([]);
    setCommonSearched(false);
    if (!otherUsername.trim()) {
      setCommonError("Please enter another username.");
      return;
    }
    setCommonLoading(true);
    try {
      const results = await findCommonBooks(currentUsername, otherUsername);
      setCommonBooks(results);
      setCommonSearched(true);
      if (results.length === 0) {
        setCommonError("No common books found.");
      }
    } catch (e) {
      setCommonError("Error finding common books.");
    }
    setCommonLoading(false);
  };

  return (
    <div className="common-books-section">
      <div style={{
        background: '#fff',
        border: '1px solid #e2e8f0',
        borderRadius: '12px',
        padding: '2rem',
        margin: '0 auto',
      }}>
        <div className="section-header">
          <Users size={24} className="section-icon" />
          <h2>Find Common Books with Another User</h2>
        </div>
        <p style={{ color: '#64748b', marginBottom: '1rem' }}>
          Enter another username to see which books you both have in common!
        </p>
        <div style={{ display: 'flex', gap: '1rem', alignItems: 'center', marginBottom: '1rem' }}>
          <input
            type="text"
            placeholder="Enter another username"
            value={otherUsername}
            onChange={e => setOtherUsername(e.target.value)}
            style={{ padding: '0.5rem', borderRadius: '6px', border: '1px solid #e2e8f0', fontSize: '1rem', flex: 1 }}
            onKeyDown={e => { if (e.key === 'Enter') handleFindCommonBooks(); }}
            disabled={commonLoading}
          />
          <button className="primary-btn" onClick={handleFindCommonBooks} disabled={commonLoading} style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <Search size={16} />
            {commonLoading ? 'Searching...' : 'Find'}
          </button>
        </div>
        {commonError && <div style={{ color: 'red', marginBottom: '1rem' }}>{commonError}</div>}
        {commonLoading && (
          <div className="loading" style={{ padding: '1rem 0' }}>
            <BookOpen className="loading-icon" size={32} />
            <span>Searching for common books...</span>
          </div>
        )}
        {commonBooks.length > 0 && !commonLoading && (
          <div style={{ marginTop: '1rem' }}>
            <h3 style={{ color: '#1e293b', fontWeight: 600, marginBottom: '0.5rem' }}>Common Books:</h3>
            <div className="books-list">
              {commonBooks.map((book) => (
                <div key={book.bookID} className="book-item">
                  <BookCard book={book} />
                </div>
              ))}
            </div>
          </div>
        )}
        {commonSearched && !commonLoading && commonBooks.length === 0 && !commonError && (
          <div style={{ color: '#64748b', marginTop: '1rem' }}>No common books found.</div>
        )}
      </div>
    </div>
  );
} 