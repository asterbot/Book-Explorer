import { useState, useEffect } from "react";
import { User, BookOpen, Clock, CheckCircle, Flame, History } from "lucide-react";
import { ProgressCard } from "../components/ProgressCard";
import type { BookProgress, UserLogs } from "../types";

interface UserPageProps {
  username: string;
}

type BookStatus = "NOT STARTED" | "IN PROGRESS" | "FINISHED";


async function viewProgress(username: string, status: BookStatus) {
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
    return [];
  }
}

async function getStreak(username: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/streak?username=${encodeURIComponent(username)}`);
    const data = await response.json();
    return data.streak;
  } catch (error) {
    console.error(`Error finding streak for ${username}: ${error}`);
    return 0;
  }
}

async function getUserLogs(username: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/userlogs?username=${encodeURIComponent(username)}`);
    const data = await response.json();
    return data.results.map((book: any) => ({
      book_title: book.book_title,
      authors: book.authors,
      timestamp: new Date(book.timestamp),
      page_reached: book.page_reached,
    }));
  } catch (error) {
    console.error(`Error: ${error}`);
    return [];
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

export function UserPage({ username }: UserPageProps) {
  const [wishlist, setWishlist] = useState<BookProgress[]>([]);
  const [inProgress, setInProgress] = useState<BookProgress[]>([]);
  const [finished, setFinished] = useState<BookProgress[]>([]);
  const [streak, setStreak] = useState<number>(0);
  const [userLogs, setUserLogs] = useState<UserLogs[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [activeTab, setActiveTab] = useState<'wishlist' | 'in-progress' | 'finished' | 'history'>('wishlist');


  useEffect(() => {
    if (username) {
      loadUserData();
    }
  }, [username]);

  const loadUserData = async () => {
    setIsLoading(true);
    
    const [wishlistData, inProgressData, finishedData, streakData, logsData] = await Promise.all([
      viewProgress(username, "NOT STARTED"),
      viewProgress(username, "IN PROGRESS"),
      viewProgress(username, "FINISHED"),
      getStreak(username),
      getUserLogs(username)
    ]);
    
    setWishlist(wishlistData);
    setInProgress(inProgressData);
    setFinished(finishedData);
    setStreak(streakData);
    setUserLogs(logsData);
    setIsLoading(false);
  };

  const handleProgressUpdate = (bookId: number, newDate: Date, newPage: number) => {
    updateProgress(username, bookId, newPage, newDate.toUTCString());
    // Reload data after update
    setTimeout(loadUserData, 1000);
  };

  const renderBookList = (books: BookProgress[], emptyMessage: string) => {
    if (books.length === 0) {
      return (
        <div className="empty-state">
          <BookOpen className="empty-icon" size={48} />
          <p>{emptyMessage}</p>
        </div>
      );
    }

    return (
      <div className="books-list">
        {books.map((book) => (
          <div key={book.bookID}>
            <ProgressCard book={book} onUpdateProgress={handleProgressUpdate} />
          </div>
        ))}
      </div>
    );
  };

  return (
    <div className="user-page">
      <div className="user-header">
        <div className="user-profile">
          <div className="user-avatar">
            <User size={48} />
          </div>
          <div className="user-info">
            <h1>{username}</h1>
            <p>Casual Reader</p>
          </div>
        </div>
        
        <div className="user-stats">
          <div className="stat-card">
            <BookOpen className="stat-icon" size={24} />
            <div className="stat-content">
              <span className="stat-number">{wishlist.length + inProgress.length + finished.length}</span>
              <span className="stat-label">Total Books</span>
            </div>
          </div>
          
          <div className="stat-card">
            <Clock className="stat-icon" size={24} />
            <div className="stat-content">
              <span className="stat-number">{inProgress.length}</span>
              <span className="stat-label">In Progress</span>
            </div>
          </div>
          
          <div className="stat-card">
            <CheckCircle className="stat-icon" size={24} />
            <div className="stat-content">
              <span className="stat-number">{finished.length}</span>
              <span className="stat-label">Completed</span>
            </div>
          </div>
          
          <div className="stat-card streak">
            <Flame className="stat-icon" size={24} />
            <div className="stat-content">
              <span className="stat-number">{streak}</span>
              <span className="stat-label">Day Streak</span>
            </div>
          </div>
        </div>
      </div>

      <div className="user-content">
        <div className="content-tabs">
          <button 
            className={`tab ${activeTab === 'wishlist' ? 'active' : ''}`}
            onClick={() => setActiveTab('wishlist')}
          >
            <BookOpen size={16} />
            Wishlist ({wishlist.length})
          </button>
          <button 
            className={`tab ${activeTab === 'in-progress' ? 'active' : ''}`}
            onClick={() => setActiveTab('in-progress')}
          >
            <Clock size={16} />
            In Progress ({inProgress.length})
          </button>
          <button 
            className={`tab ${activeTab === 'finished' ? 'active' : ''}`}
            onClick={() => setActiveTab('finished')}
          >
            <CheckCircle size={16} />
            Finished ({finished.length})
          </button>
          <button 
            className={`tab ${activeTab === 'history' ? 'active' : ''}`}
            onClick={() => setActiveTab('history')}
          >
            <History size={16} />
            Reading History
          </button>
        </div>

        <div className="tab-content">
          {isLoading ? (
            <div className="loading">
              <BookOpen className="loading-icon" size={48} />
              <p>Loading your data...</p>
            </div>
          ) : (
            <>
              {activeTab === 'wishlist' && (
                <div className="tab-panel">
                  <h2>My Wishlist</h2>
                  {renderBookList(wishlist, "Your wishlist is empty. Start adding books you want to read!")}
                </div>
              )}

              {activeTab === 'in-progress' && (
                <div className="tab-panel">
                  <h2>Books In Progress</h2>
                  {renderBookList(inProgress, "You don't have any books in progress. Start reading a book!")}
                </div>
              )}

              {activeTab === 'finished' && (
                <div className="tab-panel">
                  <h2>Books I've Read</h2>
                  {renderBookList(finished, "You haven't finished any books yet. Keep reading!")}
                </div>
              )}

              {activeTab === 'history' && (
                <div className="tab-panel">
                  <h2>Reading History</h2>
                  {userLogs.length > 0 ? (
                    <div className="history-table">
                      <table>
                        <thead>
                          <tr>
                            <th>Book</th>
                            <th>Author(s)</th>
                            <th>Page Reached</th>
                            <th>Date</th>
                          </tr>
                        </thead>
                        <tbody>
                          {userLogs.map((log, index) => (
                            <tr key={index}>
                              <td>{log.book_title}</td>
                              <td>{log.authors}</td>
                              <td>{log.page_reached}</td>
                              <td>{log.timestamp.toLocaleDateString()}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  ) : (
                    <div className="empty-state">
                      <History className="empty-icon" size={48} />
                      <p>No reading history available yet.</p>
                    </div>
                  )}
                </div>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
} 