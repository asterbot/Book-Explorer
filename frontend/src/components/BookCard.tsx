import React from "react";
import type { Book } from "../types";
import "./BookCard.css";

interface BookCardProps {
  book: Book;
}

export const BookCard: React.FC<BookCardProps> = ({ book }) => {
  return (
    <div className="book-card">
      <div className="book-header">
        <h3 className="book-title">{book.title}</h3>
      </div>

      <div className="book-info">
        <p className="book-author">by {book.authors}</p>
        <div className="book-meta">
          <span className="book-date">{book.publication_date}</span>
          <span className="book-pages">{book.num_pages} pages</span>
        </div>
      </div>
    </div>
  );
};
