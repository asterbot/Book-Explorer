import { useState, useEffect } from "react";
import { BookOpen, Users, Target, Star } from "lucide-react";
import { BookCard } from "../components/BookCard";
import type { Book } from "../types";

interface RecommendationsPageProps {
  username: string;
}

async function getRecommendations(username: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/recommendations?username=${encodeURIComponent(username)}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error fetching recommendations: ${error}`);
    return [];
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

async function getBookCompletionRates(username: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/book-completion-rates?username=${username}`);
    const data = await response.json();
    return data.results;
  } catch (error) {
    console.error(`Error when connecting to DB: ${error}`);
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
    return { error: "Failed to join book club" };
  }
}

export function RecommendationsPage({ username }: RecommendationsPageProps) {
  const [recommendedBooks, setRecommendedBooks] = useState<Book[]>([]);
  const [clubSuggestion, setClubSuggestion] = useState<any>(null);
  const [completionRates, setCompletionRates] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [joinClubMessage, setJoinClubMessage] = useState<string | null>(null);
  const [joinClubError, setJoinClubError] = useState<boolean>(false);
  const [joinedClubId, setJoinedClubId] = useState<number | null>(null);

  const [addedBooks, setAddedBooks] = useState<{[id: number]: string}>({});

  useEffect(() => {
    if (username) {
      loadRecommendations();
    }
  }, [username]);

  const loadRecommendations = async () => {
    setIsLoading(true);
    
    // Load all recommendations in parallel
    const [books, club, rates] = await Promise.all([
      getRecommendations(username),
      getClubSuggestion(username),
      getBookCompletionRates(username)
    ]);
    
    setRecommendedBooks(books);
    setClubSuggestion(club);
    setCompletionRates(rates);
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

  const handleJoinRecommendedClub = async (clubID: number) => {
    if (!username) return;
    const result = await joinBookClub(username, clubID);
    if (result?.success) {
      setJoinClubMessage(result.message);
      setJoinClubError(false);
      setJoinedClubId(clubID);
    } else {
      setJoinClubMessage(result?.error || "Failed to join the club.");
      setJoinClubError(true);
    }
  };

  return (
    <div className="recommendations-page">
      <div className="page-header">
        <h1>Recommendations</h1>
        <p>Personalized suggestions just for you</p>
      </div>

      {isLoading ? (
        <div className="loading">
          <BookOpen className="loading-icon" size={48} />
          <p>Loading your recommendations...</p>
        </div>
      ) : (
        <div className="recommendations-content">
          <section className="recommendation-section">
            <div className="section-header">
              <Target className="section-icon" size={24} />
              <h2>Which Book Should You Finish First?</h2>
            </div>
            <div className="completion-recommendations">
              {completionRates.length > 0 ? (
                <div className="completion-list">
                  {completionRates.map((book, index) => (
                    <div key={book.bookID} className="completion-item">
                      <div className="completion-rank">
                        <span className="rank-number">{index + 1}</span>
                      </div>
                      <div className="completion-info">
                        <h4 className="book-title">{book.title}</h4>
                        <p className="book-author">by {book.authors}</p>
                        <div className="completion-stats">
                          <span className="completion-rate">
                            {book.completion_rate}% completion rate
                          </span>
                          <span className="completion-users">
                            {book.completed_users} out of {book.total_users} users finished
                          </span>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="empty-state">
                  <Target className="empty-icon" size={48} />
                  <p>No books currently in progress. Start reading some books to get completion recommendations!</p>
                </div>
              )}
            </div>
          </section>



          <section className="recommendation-section">
            <div className="section-header">
              <Star className="section-icon" size={24} />
              <h2>Recommended Books</h2>
            </div>
            {recommendedBooks.length > 0 ? (
              <div className="books-grid">
                {recommendedBooks.map((book) => (
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
                <BookOpen className="empty-icon" size={48} />
                <p>No book recommendations available yet. Start reading more books to get personalized suggestions!</p>
              </div>
            )}
          </section>


          <section className="recommendation-section">
            <div className="section-header">
              <Users className="section-icon" size={24} />
              <h2>Book Club Recommendations</h2>
            </div>
            <div className="club-recommendation">
              {clubSuggestion && "clubName" in clubSuggestion ? (
                <div className="club-card">
                  <div className="club-info">
                    <h3>{clubSuggestion.clubName}</h3>
                    <p className="club-reason">{clubSuggestion.reason}</p>
                    {joinClubMessage && (
                      <p style={{ color: joinClubError ? "red" : "green", marginTop: "0.5rem" }}>
                        {joinClubMessage}
                      </p>
                    )}
                  </div>
                  
                  <button
                    className="join-club-btn"
                    onClick={() => handleJoinRecommendedClub(clubSuggestion.clubID)}
                    disabled={joinedClubId === clubSuggestion.clubID}
                  >
                    {joinedClubId === clubSuggestion.clubID ? "Joined" : "Join Club"}
                  </button>
                </div>
              ) : clubSuggestion && "message" in clubSuggestion ? (
                <div className="club-message">
                  <p>{clubSuggestion.message}</p>
                </div>
              ) : (
                <div className="empty-state">
                  <Users className="empty-icon" size={48} />
                  <p>No book club recommendations available at the moment.</p>
                </div>
              )}
            </div>
          </section>
        </div>
      )}
    </div>
  );
} 