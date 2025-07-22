import { Home, Star, Users, User } from "lucide-react";

interface SidebarProps {
  username: string;
  activePage: string;
  onPageChange: (page: string) => void;
}

export function Sidebar({ username, activePage, onPageChange }: SidebarProps) {
  const navItems = [
    {
      id: 'home',
      label: 'Home',
      icon: Home,
      description: 'Search and discover books'
    },
    {
      id: 'recommendations',
      label: 'Recommendations',
      icon: Star,
      description: 'Personalized suggestions'
    },
    {
      id: 'community',
      label: 'Community',
      icon: Users,
      description: 'Connect with other readers'
    },
    {
      id: 'profile',
      label: 'My Profile',
      icon: User,
      description: 'Your reading journey'
    }
  ];

  return (
    <div className="sidebar">
      <div className="sidebar-header">
        <h2>Book Explorer</h2>
        {username && (
          <div className="user-welcome">
            <span>Welcome back, {username}!</span>          
          </div>
        )}
      </div>

      <nav className="sidebar-nav">
        {navItems.map((item) => {
          const Icon = item.icon;
          return (
            <button
              key={item.id}
              className={`nav-item ${activePage === item.id ? 'active' : ''}`}
              onClick={() => onPageChange(item.id)}
            >
              <Icon size={20} />
              <div className="nav-content">
                <span className="nav-label">{item.label}</span>
                <span className="nav-description">{item.description}</span>
              </div>
            </button>
          );
        })}
      </nav>

      <div className="sidebar-footer">
        <p>Track your reading journey</p>
      </div>
    </div>
  );
} 