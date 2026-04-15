import { useState } from 'react';
import { useAuth } from '../../context/AuthContext';

// ── ICÔNES SVG ────────────────────────────────────────────
const IconUser = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 12c2.7 0 4.8-2.1 4.8-4.8S14.7 2.4 12 2.4 7.2 4.5 7.2 7.2 9.3 12 12 12zm0 2.4c-3.2 0-9.6 1.6-9.6 4.8v2.4h19.2v-2.4c0-3.2-6.4-4.8-9.6-4.8z"/></svg>;
const IconLock = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg>;
const IconEye = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>;
const IconEyeOff = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 7c2.76 0 5 2.24 5 5 0 .65-.13 1.26-.36 1.83l2.92 2.92c1.51-1.26 2.7-2.89 3.43-4.75-1.73-4.39-6-7.5-11-7.5-1.4 0-2.74.25-3.98.7l2.16 2.16C10.74 7.13 11.35 7 12 7zM2 4.27l2.28 2.28.46.46C3.08 8.3 1.78 10.02 1 12c1.73 4.39 6 7.5 11 7.5 1.55 0 3.03-.3 4.38-.84l.42.42L19.73 22 21 20.73 3.27 3 2 4.27zM7.53 9.8l1.55 1.55c-.05.21-.08.43-.08.65 0 1.66 1.34 3 3 3 .22 0 .44-.03.65-.08l1.55 1.55c-.67.33-1.41.53-2.2.53-2.76 0-5-2.24-5-5 0-.79.2-1.53.53-2.2zm4.31-.78l3.15 3.15.02-.16c0-1.66-1.34-3-3-3l-.17.01z"/></svg>;

export default function Login() {
  const { login } = useAuth();

  const dark = localStorage.getItem('sabc_dark') === 'true';
  const T = {
    bg:          dark ? '#0F172A' : '#F1F5F9',
    card:        dark ? '#1E293B' : '#FFFFFF',
    text:        dark ? '#F1F5F9' : '#1E293B',
    textSoft:    dark ? '#94A3B8' : '#64748B',
    textMuted:   dark ? '#475569' : '#94A3B8',
    border:      dark ? '#334155' : '#E2E8F0',
    borderSoft:  dark ? '#1E293B' : '#F8FAFC',
    primary:     '#DA291C',
    primaryDark: '#B91C1C',
    danger:      '#EF4444',
    success:     '#10B981',
    gold:        '#F5A623',
  };

  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPass, setShowPass] = useState(false);
  const [loading,  setLoading]  = useState(false);
  const [error,    setError]    = useState('');
  const [focusU,   setFocusU]   = useState(false);
  const [focusP,   setFocusP]   = useState(false);

  const handleSubmit = async () => {
    if (!username.trim() || !password.trim()) {
      setError('Veuillez remplir tous les champs');
      return;
    }
    setLoading(true);
    setError('');
    try {
      await login(username.trim(), password);
    } catch (e) {
      setError('Identifiants incorrects. Veuillez réessayer.');
    } finally {
      setLoading(false);
    }
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter') handleSubmit();
  };

  return (
    <div style={{
      position: 'fixed',
      top: 0, left: 0, right: 0, bottom: 0,
      background: T.bg,
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      overflow: 'hidden',
    }}>

      {/* Card login */}
      <div style={{
        width: '90%',
        maxWidth: 420,
        background: T.card,
        borderRadius: 24,
        boxShadow: '0 8px 48px rgba(0,0,0,0.10)',
        border: `1px solid ${T.border}`,
        padding: '40px 40px 36px',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
      }}>

        {/* Logo */}
        <div style={{
          width: 80, height: 80,
          marginBottom: 20,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}>
          <img
            src="/images/logo_sabc.png"
            alt="SABC"
            style={{ width: '100%', height: '100%', objectFit: 'contain' }}
            onError={(e) => {
              e.target.style.display = 'none';
              e.target.nextSibling.style.display = 'flex';
            }}
          />
          <div style={{
            display: 'none',
            width: 64, height: 64,
            borderRadius: 16,
            background: T.primary,
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: 28,
          }}>
            🍺
          </div>
        </div>

        {/* Titre */}
        <h1 style={{
          fontSize: 22,
          fontWeight: 800,
          color: T.primary,
          margin: '0 0 4px',
          letterSpacing: 0.5,
        }}>
          Packaging Manager
        </h1>
        <p style={{
          fontSize: 12,
          color: T.textSoft,
          margin: '0 0 28px',
          textAlign: 'center',
          textTransform: 'uppercase',
          letterSpacing: 0.8,
          fontWeight: 500,
        }}>
          Plateforme de monitoring
        </p>

        {/* Message erreur */}
        {error && (
          <div style={{
            width: '100%',
            padding: '10px 14px',
            background: '#FEF2F2',
            border: '1px solid #FECACA',
            borderRadius: 10,
            color: T.danger,
            fontSize: 13,
            fontWeight: 500,
            marginBottom: 16,
            textAlign: 'center',
            boxSizing: 'border-box',
          }}>
            {error}
          </div>
        )}

        {/* Champ username */}
        <div style={{ width: '100%', marginBottom: 14 }}>
          <label style={{
            display: 'block',
            fontSize: 12,
            fontWeight: 600,
            color: T.textSoft,
            marginBottom: 6,
            textTransform: 'uppercase',
            letterSpacing: 0.5,
          }}>
            Identifiant
          </label>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            background: T.bg,
            border: `1.5px solid ${focusU ? T.primary : T.border}`,
            borderRadius: 10,
            overflow: 'hidden',
            transition: 'border 0.2s',
          }}>
            <span style={{
              padding: '0 12px',
              color: focusU ? T.primary : T.textSoft,
              display: 'flex',
              alignItems: 'center',
              transition: 'color 0.2s',
            }}>
              <IconUser size={17} color={focusU ? T.primary : T.textSoft} />
            </span>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              onFocus={() => setFocusU(true)}
              onBlur={() => setFocusU(false)}
              onKeyDown={handleKeyDown}
              placeholder="Votre identifiant"
              autoComplete="username"
              style={{
                flex: 1,
                padding: '12px 14px 12px 0',
                background: 'transparent',
                border: 'none',
                outline: 'none',
                fontSize: 14,
                color: T.text,
                fontWeight: 500,
              }}
            />
          </div>
        </div>

        {/* Champ password */}
        <div style={{ width: '100%', marginBottom: 24 }}>
          <label style={{
            display: 'block',
            fontSize: 12,
            fontWeight: 600,
            color: T.textSoft,
            marginBottom: 6,
            textTransform: 'uppercase',
            letterSpacing: 0.5,
          }}>
            Mot de passe
          </label>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            background: T.bg,
            border: `1.5px solid ${focusP ? T.primary : T.border}`,
            borderRadius: 10,
            overflow: 'hidden',
            transition: 'border 0.2s',
          }}>
            <span style={{
              padding: '0 12px',
              display: 'flex',
              alignItems: 'center',
            }}>
              <IconLock size={17} color={focusP ? T.primary : T.textSoft} />
            </span>
            <input
              type={showPass ? 'text' : 'password'}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              onFocus={() => setFocusP(true)}
              onBlur={() => setFocusP(false)}
              onKeyDown={handleKeyDown}
              placeholder="Votre mot de passe"
              autoComplete="current-password"
              style={{
                flex: 1,
                padding: '12px 0',
                background: 'transparent',
                border: 'none',
                outline: 'none',
                fontSize: 14,
                color: T.text,
                fontWeight: 500,
              }}
            />
            <button
              onClick={() => setShowPass(!showPass)}
              style={{
                padding: '0 14px',
                background: 'transparent',
                border: 'none',
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                color: T.textSoft,
              }}
            >
              {showPass
                ? <IconEyeOff size={17} color={T.textSoft} />
                : <IconEye    size={17} color={T.textSoft} />
              }
            </button>
          </div>
        </div>

        {/* Bouton connexion */}
        <button
          onClick={handleSubmit}
          disabled={loading}
          style={{
            width: '100%',
            padding: '13px',
            background: loading ? T.textMuted : T.primary,
            color: '#fff',
            border: 'none',
            borderRadius: 12,
            fontSize: 15,
            fontWeight: 700,
            cursor: loading ? 'not-allowed' : 'pointer',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 10,
            transition: 'background 0.2s',
            letterSpacing: 0.3,
          }}
          onMouseEnter={(e) => {
            if (!loading) e.currentTarget.style.background = T.primaryDark;
          }}
          onMouseLeave={(e) => {
            if (!loading) e.currentTarget.style.background = T.primary;
          }}
        >
          {loading ? (
            <>
              <div style={{
                width: 16, height: 16,
                border: '2px solid rgba(255,255,255,0.3)',
                borderTop: '2px solid #fff',
                borderRadius: '50%',
                animation: 'spin 0.8s linear infinite',
              }} />
              Connexion...
            </>
          ) : (
            'Se connecter'
          )}
        </button>

        <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
      </div>

      {/* Footer */}
      <p style={{
        position: 'absolute',
        bottom: 20,
        fontSize: 11,
        color: T.textMuted,
        margin: 0,
        textAlign: 'center',
      }}>
        © 2026 SABC Ndokoti — Tous droits réservés
      </p>
    </div>
  );
}