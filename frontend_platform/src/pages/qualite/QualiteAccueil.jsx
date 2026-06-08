import { useNavigate } from 'react-router-dom';
import { useTheme } from '../../components/layout/Layout';
import { useAuth } from '../../context/AuthContext';

export default function QualiteAccueil() {
  const { T }    = useTheme();
  const { user } = useAuth();
  const navigate = useNavigate();

  const cards = [
    {
      icon: (
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none">
          <path d="M12 2L2 7l10 5 10-5-10-5z" stroke="#10B981" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
          <path d="M2 17l10 5 10-5M2 12l10 5 10-5" stroke="#10B981" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
        </svg>
      ),
      title: 'Data',
      desc:  'Saisie des relevés — Volet A, AM, BRSA',
      route: '/qualite/data',
      color: '#10B981',
      bg:    'rgba(16,185,129,0.1)',
    },
    {
      icon: (
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none">
          <path d="M3 3v18h18" stroke="#3B82F6" strokeWidth="2" strokeLinecap="round"/>
          <path d="M7 12h2v5H7zM11 8h2v9h-2zM15 5h2v12h-2z" fill="#3B82F6"/>
          <path d="M7 8l4-3 4 4 4-5" stroke="#EF4444" strokeWidth="1.5" strokeLinecap="round" strokeDasharray="2 1"/>
        </svg>
      ),
      title: 'Affichage',
      desc:  'Cartes de contrôle SPC — évolution des paramètres',
      route: '/qualite/affichage',
      color: '#3B82F6',
      bg:    'rgba(59,130,246,0.1)',
    },
    {
      icon: (
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none">
          <path d="M3 3v18h18" stroke="#F5A623" strokeWidth="2" strokeLinecap="round"/>
          <path d="M7 16l4-4 4 4 4-6" stroke="#F5A623" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
        </svg>
      ),
      title: 'Analyse',
      desc:  'Statistiques, tendances et indicateurs qualité',
      route: '/qualite/analyse',
      color: '#F5A623',
      bg:    'rgba(245,166,35,0.08)',
    },
  ];

  return (
    <div style={{ padding: '24px 16px', maxWidth: 600, margin: '0 auto' }}>
      {/* En-tête */}
      <div style={{ marginBottom: 32 }}>
        <div style={{ display:'flex', alignItems:'center', gap:12, marginBottom:8 }}>
          <div style={{
            width:44, height:44, borderRadius:14,
            background:'rgba(16,185,129,0.1)',
            display:'flex', alignItems:'center', justifyContent:'center',
          }}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
              <path d="M9 12l2 2 4-4M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"
                stroke="#10B981" strokeWidth="2" strokeLinecap="round"/>
            </svg>
          </div>
          <div>
            <h1 style={{ fontSize:22, fontWeight:700, color:T.text, margin:0 }}>
              Qualité
            </h1>
            <p style={{ fontSize:13, color:T.textSoft, margin:0 }}>
              Contrôle qualité — Ligne de Packaging
            </p>
          </div>
        </div>
      </div>

      {/* Cards */}
      <div style={{ display:'flex', flexDirection:'column', gap:16 }}>
        {cards.map(card => (
          <button
            key={card.route}
            onClick={() => navigate(card.route)}
            style={{
              background: T.card,
              border: `1px solid ${T.border}`,
              borderRadius: 20,
              padding: '24px 20px',
              cursor: 'pointer',
              textAlign: 'left',
              display: 'flex',
              alignItems: 'center',
              gap: 18,
              transition: 'all 0.2s',
              boxShadow: '0 2px 8px rgba(0,0,0,0.06)',
            }}
            onMouseEnter={e => {
              e.currentTarget.style.transform = 'translateY(-2px)';
              e.currentTarget.style.borderColor = card.color;
            }}
            onMouseLeave={e => {
              e.currentTarget.style.transform = 'translateY(0)';
              e.currentTarget.style.borderColor = T.border;
            }}
          >
            <div style={{
              width:64, height:64, borderRadius:18,
              background: card.bg, flexShrink:0,
              display:'flex', alignItems:'center', justifyContent:'center',
            }}>
              {card.icon}
            </div>
            <div style={{ flex:1 }}>
              <p style={{ fontSize:18, fontWeight:700, color:card.color, margin:'0 0 4px' }}>
                {card.title}
              </p>
              <p style={{ fontSize:14, color:T.textSoft, margin:0 }}>
                {card.desc}
              </p>
            </div>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
              <path d="M9 18l6-6-6-6" stroke={T.textSoft} strokeWidth="2" strokeLinecap="round"/>
            </svg>
          </button>
        ))}
      </div>
    </div>
  );
}