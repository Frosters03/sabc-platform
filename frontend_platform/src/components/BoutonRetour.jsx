import { useNavigate } from 'react-router-dom';
import { useTheme } from './layout/Layout';

export default function BoutonRetour({ vers, titre }) {
  const navigate = useNavigate();
  const { T }    = useTheme();

  return (
    <div style={{
      display:'flex', alignItems:'center', gap:12,
      marginBottom:20, paddingBottom:16,
      borderBottom:`1px solid ${T.border}`,
    }}>
      <button
        onClick={() => vers ? navigate(vers) : navigate(-1)}
        style={{
          background: T.borderSoft,
          border: `1px solid ${T.border}`,
          borderRadius: 10,
          width: 36, height: 36,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          cursor: 'pointer', flexShrink: 0,
          transition: 'all 0.15s',
        }}
        onMouseEnter={e => {
          e.currentTarget.style.background = T.border;
        }}
        onMouseLeave={e => {
          e.currentTarget.style.background = T.borderSoft;
        }}
      >
        <svg width="18" height="18" viewBox="0 0 24 24" fill={T.textSoft}>
          <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/>
        </svg>
      </button>
      {titre && (
        <p style={{ fontSize:16, fontWeight:700, color:T.text, margin:0 }}>
          {titre}
        </p>
      )}
    </div>
  );
}