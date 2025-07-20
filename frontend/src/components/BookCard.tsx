import React from "react";
import type { Book } from "../types";
import "./BookCard.css";

interface BookCardProps {
  book: Book;
  currentStatus?: "NOT STARTED" | "IN PROGRESS" | "FINISHED";
  onStatusChange?: (bookID: number, newStatus: string) => void;
}

export const BookCard: React.FC<BookCardProps> = ({ book, currentStatus, onStatusChange }) => {
  const handleClick = (status: string) => {
    if (!onStatusChange) return;
    if (currentStatus === status) {
      onStatusChange(book.bookID, "NONE");
    } else {
      onStatusChange(book.bookID, status);
    }
  };

  return (
    <div className="book-card">
      <div className="book-header">
        <h3 className="book-title">{book.title}</h3>
      </div>
      <div className="book-info">
        <p className="book-author">by {book.authors.length === 0 ? 'Unknown' : book.authors}</p>
        <div className="book-meta">
          {book.publication_date && <span className="book-date">{book.publication_date}</span>}
          {book.num_pages && <span className="book-pages">{book.num_pages} pages</span>}
        </div>
      </div>
      {onStatusChange && (
        <div className="book-actions" style={{ display: 'flex', gap: '0.5rem', marginTop: '1rem' }}>
          <button
            className={`action-btn wishlist-btn${currentStatus === 'NOT STARTED' ? ' active' : ''}`}
            onClick={() => handleClick("NOT STARTED")}
          >
            {currentStatus === 'NOT STARTED' ? 'In Wishlist' : 'Add to Wishlist'}
          </button>
          <button
            className={`action-btn reading-btn${currentStatus === 'IN PROGRESS' ? ' active' : ''}`}
            onClick={() => handleClick("IN PROGRESS")}
          >
            {currentStatus === 'IN PROGRESS' ? 'Reading' : 'Start Reading'}
          </button>
          <button
            className={`action-btn reading-btn${currentStatus === 'FINISHED' ? ' active' : ''}`}
            onClick={() => handleClick("FINISHED")}
          >
            {currentStatus === 'FINISHED' ? 'Read' : 'Already Read'}
          </button>
        </div>
      )}
    </div>
  );
};
