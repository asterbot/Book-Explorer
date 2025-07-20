import { useState, useEffect } from "react";
import { Users, Plus, UserCheck, UserPlus } from "lucide-react";

interface BookClubsPageProps {
  username: string;
}

async function getUserBookClubs(username: string) {
  try {
    const response = await fetch(`http://127.0.0.1:5000/user-book-clubs?username=${encodeURIComponent(username)}`);
    const data = await response.json();
    return data.results || [];
  } catch (error) {
    console.error(`Error fetching user book clubs: ${error}`);
    return [];
  }
}

async function getAllBookClubs() {
  try {
    const response = await fetch(`http://127.0.0.1:5000/all-book-clubs`);
    const data = await response.json();
    return data.results || [];
  } catch (error) {
    console.error(`Error fetching all book clubs: ${error}`);
    return [];
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

interface BookClub {
  clubID: number;
  clubName: string;
  description?: string;
  memberCount?: number;
  isMember?: boolean;
}

export function BookClubsPage({ username }: BookClubsPageProps) {
  const [userClubs, setUserClubs] = useState<BookClub[]>([]);
  const [allClubs, setAllClubs] = useState<BookClub[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [joinMessage, setJoinMessage] = useState<{ text: string; type: 'success' | 'error' } | null>(null);
  const [showJoinSection, setShowJoinSection] = useState(false);

  useEffect(() => {
    if (username) {
      loadBookClubs();
    }
  }, [username]);

  const loadBookClubs = async () => {
    setIsLoading(true);
    const [userClubsData, allClubsData] = await Promise.all([
      getUserBookClubs(username),
      getAllBookClubs()
    ]);
    
    setUserClubs(userClubsData);
    setAllClubs(allClubsData);
    setIsLoading(false);
  };

  const handleJoinClub = async (clubID: number) => {
    const result = await joinBookClub(username, clubID);
    
    if (result?.success) {
      setJoinMessage({ text: result.message, type: 'success' });
      setTimeout(() => {
        loadBookClubs();
        setJoinMessage(null);
      }, 2000);
    } else {
      setJoinMessage({ 
        text: result?.error || "Failed to join the club", 
        type: 'error' 
      });
      setTimeout(() => setJoinMessage(null), 3000);
    }
  };

  const availableClubs = allClubs.filter(club => 
    !userClubs.some(userClub => userClub.clubID === club.clubID)
  );

  return (
    <div className="book-clubs-page">
      <div className="page-header">
        <h1>Book Clubs</h1>
        <p>Connect with fellow readers and discover new books together</p>
      </div>

      {isLoading ? (
        <div className="loading">
          <Users className="loading-icon" size={48} />
          <p>Loading book clubs...</p>
        </div>
      ) : (
        <div className="clubs-content">
          {/* User's Book Clubs */}
          <section className="clubs-section">
            <div className="section-header">
              <UserCheck className="section-icon" size={24} />
              <h2>My Book Clubs</h2>
            </div>
            
            {userClubs.length > 0 ? (
              <div className="clubs-grid">
                {userClubs.map((club) => (
                  <div key={club.clubID} className="club-card member">
                    <div className="club-header">
                      <h3>{club.clubName}</h3>
                      <span className="member-badge">Member</span>
                    </div>
                    {club.description && (
                      <p className="club-description">{club.description}</p>
                    )}
                    {club.memberCount && (
                      <p className="member-count">
                        <Users size={16} />
                        {club.memberCount} members
                      </p>
                    )}
                  </div>
                ))}
              </div>
            ) : (
              <div className="empty-state">
                <Users className="empty-icon" size={48} />
                <h3>You're not in any book clubs yet</h3>
                <p>Join a book club to connect with other readers and discover new books!</p>
                <button 
                  className="primary-btn"
                  onClick={() => setShowJoinSection(true)}
                >
                  <Plus size={16} />
                  Join a Book Club
                </button>
              </div>
            )}
          </section>

          {/* Join Book Clubs */}
          <section className="clubs-section">
            <div className="section-header">
              <UserPlus className="section-icon" size={24} />
              <h2>Available Book Clubs</h2>
              <button 
                className="toggle-btn"
                onClick={() => setShowJoinSection(!showJoinSection)}
              >
                {showJoinSection ? 'Hide' : 'Show'} Available Clubs
              </button>
            </div>

            {showJoinSection && (
              <div className="join-section">
                {availableClubs.length > 0 ? (
                  <div className="clubs-grid">
                    {availableClubs.map((club) => (
                      <div key={club.clubID} className="club-card available">
                        <div className="club-header">
                          <h3>{club.clubName}</h3>
                          <span className="available-badge">Available</span>
                        </div>
                        {club.description && (
                          <p className="club-description">{club.description}</p>
                        )}
                        {club.memberCount && (
                          <p className="member-count">
                            <Users size={16} />
                            {club.memberCount} members
                          </p>
                        )}
                        <button 
                          className="join-btn"
                          onClick={() => handleJoinClub(club.clubID)}
                        >
                          <Plus size={16} />
                          Join Club
                        </button>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="empty-state">
                    <p>No available book clubs at the moment.</p>
                  </div>
                )}
              </div>
            )}
          </section>

          {/* Join Message */}
          {joinMessage && (
            <div className={`message ${joinMessage.type}`}>
              {joinMessage.text}
            </div>
          )}
        </div>
      )}
    </div>
  );
} 