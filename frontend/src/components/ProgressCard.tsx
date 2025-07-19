import React, { useState } from "react";
import type { BookProgress } from "../types";
import "./ProgressCard.css";

interface BookCardProps {
    book: BookProgress;
    onUpdateProgress?: (bookId: number, newDate: Date, newPage: number) => void;
  }
  
  export const ProgressCard: React.FC<BookCardProps> = ({ book, onUpdateProgress }) => {
    const [showDatePicker, setShowDatePicker] = useState(false);
    const [selectedDate, setSelectedDate] = useState(new Date().toISOString().split('T')[0]);
    const [newPage, setNewPage] = useState(book.page_reached);
  
    const handleAddProgress = () => {
      if (onUpdateProgress) {
        onUpdateProgress(book.bookID, new Date(selectedDate), newPage);
      }
      setShowDatePicker(false);
    };
  
    return (
      <div className="prog-card">
        <table className="progress-table">
          <tbody>
            <tr>
              <td><strong>Title:</strong></td>
              <td>{book.title}</td>
            </tr>
            <tr>
              <td><strong>Authors:</strong></td>
              <td>{book.authors}</td>
            </tr>
            <tr>
              <td><strong>Page Reached:</strong></td>
              <td>{book.page_reached}</td>
            </tr>
            <tr>
              <td><strong>Last Update:</strong></td>
              <td>{book.last_update.toUTCString()}</td>
            </tr>
          </tbody>
        </table>
        
        <div className="progress-actions">
          {!showDatePicker ? (
            <button 
              className="add-progress-btn"
              onClick={() => setShowDatePicker(true)}
            >
              Add New Progress
            </button>
          ) : (
            <div className="date-picker-section">
              <div className="input-group">
                <label htmlFor="progress-date">Date:</label>
                <input
                  id="progress-date"
                  type="date"
                  value={selectedDate}
                  onChange={(e) => setSelectedDate(e.target.value)}
                />
              </div>
              <div className="input-group">
                <label htmlFor="progress-page">Page:</label>
                <input
                  id="progress-page"
                  type="number"
                  value={newPage}
                  onChange={(e) => setNewPage(parseInt(e.target.value))}
                />
              </div>
              <div className="action-buttons">
                <button onClick={handleAddProgress}>Save</button>
                <button onClick={() => setShowDatePicker(false)}>Cancel</button>
              </div>
            </div>
          )}
        </div>
      </div>
    );
  };
