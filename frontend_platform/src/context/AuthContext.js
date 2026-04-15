import { createContext, useContext, useState, useEffect } from 'react';
import { authAPI } from '../services/api';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser]       = useState(null);
  const [loading, setLoading] = useState(true);

  // Au démarrage — vérifie si un token existe déjà
  useEffect(() => {
    const token = localStorage.getItem('token');
    const saved = localStorage.getItem('user');
    if (token && saved) {
      setUser(JSON.parse(saved));
    }
    setLoading(false);
  }, []);

  // ── CONNEXION ────────────────────────────────────────
  const login = async (username, password) => {
    const res = await authAPI.login(username, password);
    const token = res.data.access_token;

    // Sauvegarde le token
    localStorage.setItem('token', token);

    // Récupère les infos de l'utilisateur connecté
    const meRes = await authAPI.me();
    const userData = meRes.data;
    localStorage.setItem('user', JSON.stringify(userData));
    setUser(userData);

    return userData;
  };

  // ── DÉCONNEXION ──────────────────────────────────────
  const logout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    setUser(null);
  };

  // ── VÉRIFICATION DU RÔLE ─────────────────────────────
  const hasRole = (...roles) => {
    return user && roles.includes(user.role);
  };

  // Ex: hasRole('admin', 'chef_atelier') → true si l'un des deux

  return (
    <AuthContext.Provider value={{ user, login, logout, hasRole, loading }}>
      {children}
    </AuthContext.Provider>
  );
}

// Hook pour utiliser le contexte dans n'importe quelle page
export function useAuth() {
  return useContext(AuthContext);
}