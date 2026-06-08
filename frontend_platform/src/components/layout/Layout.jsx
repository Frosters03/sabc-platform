import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { useState, useEffect, createContext, useContext } from 'react';

// ── ICÔNES SVG INLINE ─────────────────────────────────────
const IconDashboard = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>;
const IconBolt      = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M7 2v11h3v9l7-12h-4l4-8z"/></svg>;
const IconScience   = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M7 2v2h1v9.26l-5 6.74V22h18v-2.74l-5-6.74V4h1V2H7zm5 14c-.55 0-1-.45-1-1s.45-1 1-1 1 .45 1 1-.45 1-1 1zm3-4H9V4h6v8z"/></svg>;
const IconBell      = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>;
const IconPerson    = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>;
const IconLogout    = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5-5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>;
const IconDarkMode  = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9c0-.46-.04-.92-.1-1.36-.98 1.37-2.58 2.26-4.4 2.26-2.98 0-5.4-2.42-5.4-5.4 0-1.81.89-3.42 2.26-4.4-.44-.06-.9-.1-1.36-.1z"/></svg>;
const IconLightMode = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-12.37l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06c.39-.39.39-1.03 0-1.41s-1.03-.39-1.41 0zM7.05 18.36l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06c.39-.39.39-1.03 0-1.41s-1.03-.39-1.41 0z"/></svg>;
const IconAdmin     = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 4l5 2.18V11c0 3.5-2.33 6.79-5 7.93-2.67-1.14-5-4.43-5-7.93V7.18L12 5z"/></svg>;
const IconFactory   = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M4 18v-3.31L8 12v2.5l4-2.5v2.5l4-2.5V18H4zm0-5.5V4h16v8.5l-4 2.5V13l-4 2.5V13l-4 2.5z"/></svg>;
const IconClipboard = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>;
const IconBrain = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M13 3c-4.97 0-9 4.03-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42C8.27 19.99 10.51 21 13 21c4.97 0 9-4.03 9-9s-4.03-9-9-9zm-1 5v5l4.28 2.54.72-1.21-3.5-2.08V8H12z"/></svg>;

// ── CONTEXTE THEME ────────────────────────────────────────
export const ThemeContext = createContext({ dark: false, toggle: () => {} });
export const useTheme = () => useContext(ThemeContext);

// ── THÈME ─────────────────────────────────────────────────
export const getTheme = (dark) => ({
  primary:     '#DA291C',
  primaryDark: '#A01E14',
  gold:        '#F5A623',
  success:     '#10B981',
  warning:     '#F59E0B',
  danger:      '#EF4444',
  bg:          dark ? '#0F172A' : '#F1F5F9',
  bgSecond:    dark ? '#1E293B' : '#FFFFFF',
  card:        dark ? '#1E293B' : '#FFFFFF',
  cardHover:   dark ? '#273449' : '#F8FAFC',
  sidebar:     dark ? '#0D1117' : '#FFFFFF',
  header:      dark ? '#161B22' : '#FFFFFF',
  text:        dark ? '#F1F5F9' : '#1A1A2E',
  textSoft:    dark ? '#94A3B8' : '#64748B',
  textMuted:   dark ? '#475569' : '#94A3B8',
  border:      dark ? '#21262D' : '#E2E8F0',
  borderSoft:  dark ? '#161B22' : '#F8FAFC',
  sidebarActiveBg: dark
    ? 'rgba(218,41,28,0.15)'
    : 'rgba(218,41,28,0.07)',
});

// ── DETECTION MOBILE ──────────────────────────────────────
function useIsMobile() {
  const [isMobile, setIsMobile] = useState(() => {
    return window.innerWidth < 768 || 
           /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent);
  });
  
  useEffect(() => {
    const handle = () => setIsMobile(
      window.innerWidth < 768 || 
      /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent)
    );
    window.addEventListener('resize', handle);
    return () => window.removeEventListener('resize', handle);
  }, []);
  
  
  return isMobile;
}

// ── NAV ITEMS ─────────────────────────────────────────────
function useNavItems() {
  const { hasRole } = useAuth();
  const items = [];
  items.push({ path:'/dashboard', icon:IconDashboard, label:'Tableau de bord' });
  if (hasRole('contremaitre', 'chef_atelier', 'manager')) {
    items.push({ path:'/energie',  icon:IconBolt,      label:'Énergie' });
    items.push({ path:'/qualite',  icon:IconScience,   label:'Qualité' });
    items.push({ path:'/pointage', icon:IconClipboard, label:'Pointage' });
    items.push({ path:'/alertes',  icon:IconBell,      label:'Alertes' });
    items.push({ path:'/maintenance', icon:IconBrain,  label:'Maintenance IA' });
  }
  if (hasRole('manager')) {
    items.push({ path:'/admin/users', icon:IconAdmin,  label:'Administration' });
  }
  return items;
}

// ── SIDEBAR PC ────────────────────────────────────────────
function Sidebar({ items, T }) {
  const navigate        = useNavigate();
  const location        = useLocation();
  const { logout, user } = useAuth();

  const roleLabel = {
    manager:      'Manager',
    chef_atelier: "Chef d'atelier",
    contremaitre: 'Contremaître',
  };

  return (
    <div style={{
      width: 240,
      height: '100vh',
      background: T.sidebar,
      borderRight: `1px solid ${T.border}`,
      display: 'flex',
      flexDirection: 'column',
      position: 'fixed',
      left: 0, top: 0,
      zIndex: 100,
      transition: 'background 0.3s',
    }}>

      {/* Logo */}
      <div style={{
        padding: '22px 20px',
        borderBottom: `1px solid ${T.border}`,
        display: 'flex',
        alignItems: 'center',
        gap: 12,
      }}>
        <img
          src="/images/logo_sabc.png"
          alt="SABC"
          style={{
            width: 100, height: 100,
            objectFit: 'contain',
            flexShrink: 0,
          }}
          onError={(e) => {
            e.target.style.display = 'none';
            e.target.nextSibling.style.display = 'flex';
          }}
        />
        <div style={{
          width: 38, height: 38,
          borderRadius: 10,
          background: T.primary,
          display: 'none',
          alignItems: 'center',
          justifyContent: 'center',
          flexShrink: 0,
        }}>
          <IconFactory size={22} color="#fff" />
        </div>

        <div>
          <div style={{
            fontSize: 15,
            fontWeight: 700,
            color: T.text,
            letterSpacing: 0.5,
          }}>
            SABC
          </div>
          <div style={{
            fontSize: 10,
            color: T.textSoft,
            marginTop: 1,
          }}>
            Packaging Platform
          </div>
        </div>
      </div>

      {/* Nav */}
      <nav style={{
        flex: 1,
        padding: '20px 12px',
        overflowY: 'auto',
      }}>
        <div style={{
          fontSize: 10,
          color: T.textMuted,
          fontWeight: 700,
          letterSpacing: 1.2,
          padding: '0 10px 10px',
          textTransform: 'uppercase',
        }}>
          Navigation
        </div>

        {items.map((item) => {
          const active  = location.pathname === item.path;
          const NavIcon = item.icon;
          return (
            <button
              key={item.path}
              onClick={() => navigate(item.path)}
              style={{
                width: '100%',
                display: 'flex',
                alignItems: 'center',
                gap: 12,
                padding: '10px 12px',
                marginBottom: 3,
                background: active ? T.sidebarActiveBg : 'transparent',
                border: active
                  ? '1px solid rgba(218,41,28,0.2)'
                  : '1px solid transparent',
                borderRadius: 10,
                cursor: 'pointer',
                textAlign: 'left',
                transition: 'all 0.15s',
                color: active ? T.primary : T.textSoft,
              }}
              onMouseEnter={(e) => {
                if (!active) {
                  e.currentTarget.style.background = T.borderSoft;
                  e.currentTarget.style.color = T.text;
                }
              }}
              onMouseLeave={(e) => {
                if (!active) {
                  e.currentTarget.style.background = 'transparent';
                  e.currentTarget.style.color = T.textSoft;
                }
              }}
            >
              <div style={{
                width: 32, height: 32,
                borderRadius: 8,
                background: active ? 'rgba(218,41,28,0.12)' : T.borderSoft,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                flexShrink: 0,
                color: active ? T.primary : T.textSoft,
              }}>
                <NavIcon size={18} color={active ? T.primary : T.textSoft} />
              </div>
              <span style={{
                fontSize: 13,
                fontWeight: active ? 600 : 400,
                color: active ? T.primary : T.textSoft,
              }}>
                {item.label}
              </span>
              {active && (
                <div style={{
                  marginLeft: 'auto',
                  width: 6, height: 6,
                  borderRadius: '50%',
                  background: T.primary,
                  flexShrink: 0,
                }} />
              )}
            </button>
          );
        })}
      </nav>

      {/* Profil + Déco */}
      <div style={{
        padding: '12px',
        borderTop: `1px solid ${T.border}`,
      }}>
        <div style={{
          display: 'flex',
          alignItems: 'center',
          gap: 10,
          padding: '10px 12px',
          borderRadius: 10,
          background: T.borderSoft,
          marginBottom: 8,
        }}>
          <div style={{
            width: 34, height: 34,
            borderRadius: '50%',
            background: 'rgba(218,41,28,0.1)',
            border: '2px solid rgba(218,41,28,0.2)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            flexShrink: 0,
          }}>
            <IconPerson size={18} color={T.primary} />
          </div>
          <div style={{ overflow: 'hidden' }}>
            <div style={{
              fontSize: 12,
              fontWeight: 700,
              color: T.text,
              whiteSpace: 'nowrap',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
            }}>
              {user?.username}
            </div>
            <div style={{ fontSize: 10, color: T.textSoft }}>
              {roleLabel[user?.role] || user?.role}
            </div>
          </div>
        </div>

        <button
          onClick={() => { if (window.confirm('Se déconnecter ?')) logout(); }}
          style={{
            width: '100%',
            padding: '9px 12px',
            background: 'transparent',
            border: `1px solid ${T.border}`,
            borderRadius: 10,
            color: T.danger,
            fontSize: 12,
            fontWeight: 600,
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
            transition: 'all 0.15s',
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.background = '#FEF2F2';
            e.currentTarget.style.borderColor = T.danger;
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.background = 'transparent';
            e.currentTarget.style.borderColor = T.border;
          }}
        >
          <IconLogout size={16} color={T.danger} />
          Déconnexion
        </button>
      </div>
    </div>
  );
}

// ── HEADER PC ─────────────────────────────────────────────
function Header({ T, dark, toggleDark, title }) {
  const { user } = useAuth();
  const now      = new Date();
  const dateStr  = now.toLocaleDateString('fr-FR', {
    weekday: 'long', day: 'numeric',
    month: 'long', year: 'numeric',
  });
  const roleLabel = {
    manager:      'Manager',
    chef_atelier: "Chef d'atelier",
    contremaitre: 'Contremaître',
  };

  return (
    <div style={{
      height: 64,
      background: T.header,
      borderBottom: `1px solid ${T.border}`,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 28px',
      position: 'sticky',
      top: 0,
      zIndex: 50,
      transition: 'background 0.3s',
    }}>
      <div>
        <h2 style={{
          fontSize: 16,
          fontWeight: 700,
          color: T.text,
          margin: 0,
          letterSpacing: 0.3,
        }}>
          {title}
        </h2>
        <p style={{
          fontSize: 11,
          color: T.textSoft,
          margin: 0,
          textTransform: 'capitalize',
        }}>
          {dateStr}
        </p>
      </div>

      <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>

        {/* Toggle dark */}
        <button
          onClick={toggleDark}
          title={dark ? 'Mode clair' : 'Mode sombre'}
          style={{
            width: 36, height: 36,
            borderRadius: 10,
            background: T.borderSoft,
            border: `1px solid ${T.border}`,
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: T.textSoft,
            transition: 'all 0.2s',
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.background = T.border;
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.background = T.borderSoft;
          }}
        >
          {dark
            ? <IconLightMode size={18} color={T.textSoft} />
            : <IconDarkMode  size={18} color={T.textSoft} />
          }
        </button>

        <div style={{ width: 1, height: 28, background: T.border }} />

        {/* Profil */}
        <div style={{
          display: 'flex',
          alignItems: 'center',
          gap: 10,
          padding: '6px 12px',
          borderRadius: 10,
          background: T.borderSoft,
          border: `1px solid ${T.border}`,
        }}>
          <div style={{
            width: 30, height: 30,
            borderRadius: '50%',
            background: 'rgba(218,41,28,0.1)',
            border: '2px solid rgba(218,41,28,0.25)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}>
            <IconPerson size={16} color={T.primary} />
          </div>
          <div>
            <div style={{
              fontSize: 12,
              fontWeight: 700,
              color: T.text,
              lineHeight: 1.2,
            }}>
              {user?.username}
            </div>
            <div style={{ fontSize: 10, color: T.textSoft }}>
              {roleLabel[user?.role] || user?.role}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

// ── BOTTOM NAVBAR MOBILE ──────────────────────────────────
function BottomNavbar({ items, T }) {
  const navigate        = useNavigate();
  const location        = useLocation();
  const { logout, user } = useAuth();
  const { dark, toggle } = useTheme();

  return (
    <div style={{
      position: 'fixed',
      bottom: 0, left: 0, right: 0,
      background: T.card,
      borderTop: `1px solid ${T.border}`,
      display: 'flex',
      justifyContent: 'space-around',
      alignItems: 'center',
      padding: '6px 0 12px',
      zIndex: 1000,
      boxShadow: '0 -4px 24px rgba(0,0,0,0.07)',
    }}>
      {items.map((item) => {
        const active  = location.pathname === item.path;
        const NavIcon = item.icon;
        return (
          <button
            key={item.path}
            onClick={() => navigate(item.path)}
            style={{
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              background: 'none',
              border: 'none',
              cursor: 'pointer',
              padding: '4px 12px',
              color: active ? T.primary : T.textSoft,
              position: 'relative',
            }}
          >
            {active && (
              <div style={{
                position: 'absolute',
                top: -6, left: '50%',
                transform: 'translateX(-50%)',
                width: 28, height: 3,
                background: T.primary,
                borderRadius: '0 0 4px 4px',
              }} />
            )}
            <NavIcon
              size={22}
              color={active ? T.primary : T.textSoft}
            />
            <span style={{
              fontSize: 10,
              fontWeight: active ? 700 : 400,
              marginTop: 3,
              color: active ? T.primary : T.textSoft,
            }}>
              {item.label}
            </span>
          </button>
        );
      })}

      {/* Toggle mode */}
      <button
        onClick={toggle}
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          background: 'none',
          border: 'none',
          cursor: 'pointer',
          padding: '4px 12px',
          color: T.textSoft,
        }}
      >
        {dark
          ? <IconLightMode size={22} color={T.textSoft} />
          : <IconDarkMode  size={22} color={T.textSoft} />
        }
        <span style={{ fontSize: 10, marginTop: 3, color: T.textSoft }}>
          {dark ? 'Clair' : 'Sombre'}
        </span>
      </button>

    
    </div>
  );
}

// ── PAGE TITLES ───────────────────────────────────────────
const pageTitles = {
  '/dashboard':           'Tableau de bord',
  '/energie':             'Énergie',
  '/energie/releves':     'Relevés Énergie',
  '/energie/analyse':     'Analyse Énergie',
  '/qualite':             'Qualité',
  '/qualite/data':        'Data — Saisie Qualité',       // ← ajouter
  '/qualite/affichage':   'Affichage — Cartes SPC',      // ← ajouter
  '/qualite/analyse':     'Analyse Qualité', 
  '/alertes':             'Alertes',
  '/maintenance': 'Maintenance Prédictive IA',
  '/admin/users':         'Administration',
  '/pointage': 'Pointage Personnel',
};

function MobileHeader({ T, dark, toggleDark, title }) {
  const { logout, user } = useAuth();
  const [menuOpen, setMenuOpen] = useState(false);

  const roleLabel = {
    manager:      'Manager',
    chef_atelier: "Chef d'atelier",
    contremaitre: 'Contremaître',
  };

  return (
    <>
      <div style={{
        position: 'sticky', top: 0, zIndex: 50,
        background: T.header, borderBottom: `1px solid ${T.border}`,
        padding: '10px 16px',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      }}>
        {/* Logo + titre */}
        <div style={{ display:'flex', alignItems:'center', gap:10 }}>
          <img
            src="/images/logo_sabc.png"
            alt="SABC"
            style={{ width:32, height:32, objectFit:'contain' }}
            onError={e => e.target.style.display='none'}
          />
          <div>
            <h2 style={{ fontSize:15, fontWeight:700, color:T.text, margin:0 }}>{title}</h2>
            <p style={{ fontSize:10, color:T.textSoft, margin:0, textTransform:'capitalize' }}>
              {new Date().toLocaleDateString('fr-FR', { weekday:'long', day:'numeric', month:'long' })}
            </p>
          </div>
        </div>

        {/* Boutons droite */}
        <div style={{ display:'flex', alignItems:'center', gap:8 }}>
          {/* Toggle dark */}
          <button onClick={toggleDark} style={{
            width:34, height:34, borderRadius:10,
            background:T.borderSoft, border:`1px solid ${T.border}`,
            cursor:'pointer', display:'flex', alignItems:'center', justifyContent:'center',
          }}>
            {dark
              ? <IconLightMode size={17} color={T.textSoft}/>
              : <IconDarkMode  size={17} color={T.textSoft}/>
            }
          </button>

          {/* Avatar — ouvre menu profil */}
          <button onClick={() => setMenuOpen(o => !o)} style={{
            width:34, height:34, borderRadius:'50%',
            background:'rgba(218,41,28,0.1)',
            border:'2px solid rgba(218,41,28,0.25)',
            cursor:'pointer', display:'flex', alignItems:'center', justifyContent:'center',
            fontSize:14, fontWeight:700, color:'#DA291C',
          }}>
            {user?.username?.[0]?.toUpperCase()}
          </button>
        </div>
      </div>

      {/* Menu profil déroulant */}
      {menuOpen && (
        <>
          {/* Overlay */}
          <div
            onClick={() => setMenuOpen(false)}
            style={{ position:'fixed', inset:0, zIndex:98 }}
          />
          {/* Menu */}
          <div style={{
            position:'fixed', top:64, right:12,
            background:T.card, border:`1px solid ${T.border}`,
            borderRadius:14, padding:16, zIndex:99,
            minWidth:200, boxShadow:'0 8px 24px rgba(0,0,0,0.12)',
          }}>
            {/* Infos utilisateur */}
            <div style={{
              display:'flex', alignItems:'center', gap:10,
              paddingBottom:12, borderBottom:`1px solid ${T.border}`,
              marginBottom:12,
            }}>
              <div style={{
                width:38, height:38, borderRadius:'50%',
                background:'rgba(218,41,28,0.1)',
                border:'2px solid rgba(218,41,28,0.25)',
                display:'flex', alignItems:'center', justifyContent:'center',
                fontSize:16, fontWeight:700, color:'#DA291C',
              }}>
                {user?.username?.[0]?.toUpperCase()}
              </div>
              <div>
                <div style={{ fontSize:13, fontWeight:700, color:T.text }}>{user?.username}</div>
                <div style={{ fontSize:11, color:T.textSoft }}>{roleLabel[user?.role] || user?.role}</div>
              </div>
            </div>

            {/* Bouton déconnexion */}
            <button
              onClick={() => { if(window.confirm('Se déconnecter ?')) logout(); }}
              style={{
                width:'100%', padding:'9px 12px',
                background:'#FEF2F2', border:'1px solid #FECACA',
                borderRadius:10, color:'#B91C1C',
                fontSize:13, fontWeight:600, cursor:'pointer',
                display:'flex', alignItems:'center', justifyContent:'center', gap:8,
              }}
            >
              <IconLogout size={16} color="#B91C1C"/>
              Déconnexion
            </button>
          </div>
        </>
      )}
    </>
  );
}

// ── LAYOUT PRINCIPAL ──────────────────────────────────────
export default function Layout() {
  const isMobile = useIsMobile();
  const items    = useNavItems();
  const location = useLocation();
  const [dark, setDark] = useState(
    () => localStorage.getItem('sabc_dark') === 'true'
  );
  useEffect(() => {
    document.body.style.background = dark ? '#0F172A' : '#F1F5F9';
    document.documentElement.style.background = dark ? '#0F172A' : '#F1F5F9';
  }, [dark]);

  const T = getTheme(dark);

  const toggleDark = () => {
    setDark(prev => {
      localStorage.setItem('sabc_dark', String(!prev));
      return !prev;
    });
  };

  const title = pageTitles[location.pathname] || 'SABC Platform';

  return (
    <ThemeContext.Provider value={{ dark, toggle: toggleDark, T }}>
      <div style={{
        background: T.bg,
        minHeight: '100vh',
        transition: 'background 0.3s',
        overflowX: 'hidden',
        maxWidth: '100vw',
      }}>
        {!isMobile && <Sidebar items={items} T={T} />}
        {/* Header mobile */}
        {isMobile && (
          <div style={{
            position: 'sticky',
            top: 0,
            zIndex: 50,
            background: T.header,
            borderBottom: `1px solid ${T.border}`,
            padding: '10px 16px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
          }}>
          <div>
            <h2 style={{
              fontSize: 16,
              fontWeight: 700,
              color: T.text,
              margin: 0,
            }}>
              {title}
            </h2>
            <p style={{
              fontSize: 10,
              color: T.textSoft,
              margin: 0,
              textTransform: 'capitalize',
            }}>
              {new Date().toLocaleDateString('fr-FR', {
                weekday: 'long', day: 'numeric', month: 'long',
              })}
            </p>
          </div>

          {/* Toggle dark mode */}
          <button
            onClick={toggleDark}
            style={{
              width: 34, height: 34,
              borderRadius: 10,
              background: T.borderSoft,
              border: `1px solid ${T.border}`,
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: T.textSoft,
            }}
          >
            {dark
              ? <IconLightMode size={17} color={T.textSoft} />
              : <IconDarkMode  size={17} color={T.textSoft} />
            }
          </button>
        </div>
      )}

        <div style={{
          marginLeft: isMobile ? 0 : 240,
          paddingBottom: isMobile ? 80 : 0,
          minHeight: '100vh',
          display: 'flex',
          flexDirection: 'column',
        }}>
          {!isMobile && (
            <Header
              T={T}
              dark={dark}
              toggleDark={toggleDark}
              title={title}
            />
          )}
          <div style={{ flex: 1 }}>
            <Outlet />
          </div>
        </div>

        {isMobile && <BottomNavbar items={items} T={T} />}
      </div>
    </ThemeContext.Provider>
  );
}