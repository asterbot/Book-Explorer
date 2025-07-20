import { useState, useEffect } from "react";
import { Users, UserCheck, X } from "lucide-react";
import { FindCommonBooks } from "../components/FindCommonBooks";

interface CommunityPageProps {
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

export function CommunityPage({ username }: CommunityPageProps) {
  const [userClubs, setUserClubs] = useState<BookClub[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [joinMessage, setJoinMessage] = useState<{ text: string; type: 'success' | 'error' } | null>(null);
  const [joinClubId, setJoinClubId] = useState<string>("");
  const [showJoinSuccess, setShowJoinSuccess] = useState(false);
  const [joinSuccessMsg, setJoinSuccessMsg] = useState("");

  useEffect(() => {
    if (username) {
      loadBookClubs();
    }
  }, [username]);

  const loadBookClubs = async () => {
    setIsLoading(true);
    const [userClubsData] = await Promise.all([
      getUserBookClubs(username),
    ]);
    
    setUserClubs(userClubsData);
    setIsLoading(false);
  };

  const handleJoinClub = async (clubID: number) => {
    const result = await joinBookClub(username, clubID);
    
    if (result?.success) {
      setJoinMessage(null);
      setShowJoinSuccess(true);
      setJoinSuccessMsg(result.message);
      setTimeout(() => setShowJoinSuccess(false), 2500);
      setTimeout(() => setJoinSuccessMsg(""), 2500);
      setTimeout(() => loadBookClubs(), 1000);
    } else {
      setJoinMessage({ 
        text: result?.error || "Failed to join the club", 
        type: 'error' 
      });
      setTimeout(() => setJoinMessage(null), 3000);
    }
  };

  return (
    <div className="community-page">
      <div className="page-header">
        <h1>Community</h1>
        <p>Connect with fellow readers and discover new books together</p>
      </div>

      {joinMessage && ( 
        <div style={{
          position: 'fixed',
          top: '30px',
          left: 0,
          right: 0,
          margin: '0 auto',
          zIndex: 1000,
          display: 'flex',
          justifyContent: 'center',
        }}>
          <div style={{
            background: '#fee2e2',
            color: '#991b1b',
            border: '1px solid #ef4444',
            borderRadius: '8px',
            padding: '1rem 2rem',
            fontWeight: 600,
            boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
            display: 'flex',
            alignItems: 'center',
            gap: '1rem',
          }}>
            <span>{joinMessage.text}</span>
            <button style={{ background: 'none', border: 'none', color: '#991b1b', cursor: 'pointer' }} onClick={() => setJoinMessage(null)}><X size={18} /></button>
          </div>
        </div>
      )}

      {showJoinSuccess && (
        <div style={{
          position: 'fixed',
          top: '30px',
          left: 0,
          right: 0,
          margin: '0 auto',
          zIndex: 1000,
          display: 'flex',
          justifyContent: 'center',
        }}>
          <div style={{
            background: '#d1fae5',
            color: '#065f46',
            border: '1px solid #10b981',
            borderRadius: '8px',
            padding: '1rem 2rem',
            fontWeight: 600,
            boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
            display: 'flex',
            alignItems: 'center',
            gap: '1rem',
          }}>
            <span>{joinSuccessMsg}</span>
            <button style={{ background: 'none', border: 'none', color: '#065f46', cursor: 'pointer' }} onClick={() => setShowJoinSuccess(false)}><X size={18} /></button>
          </div>
        </div>
      )}


      <div style={{ marginBottom: '2rem', display: 'flex', gap: '1rem', alignItems: 'center' }}>
        <input
          type="number"
          min={0}
          placeholder="Enter club ID"
          value={joinClubId}
          onChange={e => setJoinClubId(e.target.value)}
          style={{ padding: '0.5rem', borderRadius: '6px', border: '1px solid #e2e8f0', fontSize: '1rem', width: '200px' }}
        />
        <button
          className="primary-btn"
          onClick={() => joinClubId && handleJoinClub(Number(joinClubId))}
          disabled={!joinClubId}
        >
          Join Book Club by ID
        </button>
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
                  <div key={club.clubID} className="club-card">
                    <div className="club-header">
                      <h3>{club.clubName}</h3>
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
              </div>
            )}
          </section>
          
          <FindCommonBooks currentUsername={username} />
        </div>
      )}
    </div>
  );
} 