import React from "react";
import "./BookCard.css";

interface StreakCardProps {
  username: string,
  streak: number;
}

export const StreakCounter: React.FC<StreakCardProps> = ({ username, streak }) => {
  return (
    <div className="streak">
        <h1 style={{ marginBottom: "1rem" }}>Current reading streak for {username}:</h1>
        <div>
        <p style={{ fontSize: "2rem" }}>
          {streak} day
            {streak > 1 ? "s" : ""} 
        </p>
        <p style={{ fontSize: "4rem", marginTop: "2rem", marginBottom: "0" }}>
            <span aria-label="fire emoji" role="img">
            🔥
            </span>
            
        </p>
        </div>
    </div>
  );
};