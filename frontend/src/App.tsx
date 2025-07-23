import { useState, useEffect } from "react";
import { Sidebar } from "./components/Sidebar";
import { HomePage } from "./pages/HomePage";
import { RecommendationsPage } from "./pages/RecommendationsPage";
import { CommunityPage } from "./pages/CommunityPage";
import { UserPage } from "./pages/UserPage";
import "./App.css";

function App() {
  const [username, setUsername] = useState("");
  const [activePage, setActivePage] = useState("home");
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");

  useEffect(() => {
    setUsername("Alex");
    setIsLoggedIn(true);
  }, []);

  async function checkUserExists(username: string) {
    try {
      const response = await fetch(`http://127.0.0.1:5000/user-exists?username=${encodeURIComponent(username)}`);
      const data = await response.json();
      return data.exists;
    } catch (error) {
      console.error("Error checking user:", error);
      return false;
    }
  }

  const handleLogin = async () => {
    const trimmed = username.trim();
    if (!trimmed) {
      setErrorMessage("Please enter a username.");
      return;
    }

    const exists = await checkUserExists(trimmed);
    if (exists) {
      setIsLoggedIn(true);
      setErrorMessage("");
    } else {
      setErrorMessage("Username not found. Please try again.");
    }
  };

  const handleLogout = () => {
    setIsLoggedIn(false);
    setUsername("");
    setActivePage("home");
    setErrorMessage("");
  };

  const renderPage = () => {
    if (!isLoggedIn) {
      return (
        <div className="login-page">
          <div className="login-container">
            <h1>Welcome to Book Explorer</h1>
            <p>Track your reading journey and discover new books!</p>

            <div className="login-form">
              <input
                type="text"
                placeholder="Enter your username"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && handleLogin()}
                className="login-input"
              />
              <button onClick={handleLogin} className="login-button">
                Get Started
              </button>
              {errorMessage && <p style={{color: 'red', marginBottom: 0}}>{errorMessage}</p>}
            </div>
          </div>
        </div>
      );
    }

    switch (activePage) {
      case "home":
        return <HomePage username={username} />;
      case "recommendations":
        return <RecommendationsPage username={username} />;
      case "community":
        return <CommunityPage username={username} />;
      case "profile":
        return <UserPage username={username} />;
      default:
        return <HomePage username={username} />;
    }
  };

  if (!isLoggedIn) {
    return <div className="app">{renderPage()}</div>;
  }

  return (
    <div className="app">
      <Sidebar
        username={username}
        activePage={activePage}
        onPageChange={setActivePage}
      />
      <main className="main-content">
        <div className="top-bar">
          <div className="user-controls">
            <span className="username-display">{username}</span>
            <button onClick={handleLogout} className="logout-button">
              Logout
            </button>
          </div>
        </div>
        <div className="page-content">{renderPage()}</div>
      </main>
    </div>
  );
}

export default App;
