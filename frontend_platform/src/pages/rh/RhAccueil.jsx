import { useNavigate } from "react-router-dom";
import { useTheme } from "../../components/layout/Layout";

const ICON_EQUIPE = (c) => (
  <svg width="36" height="36" viewBox="0 0 24 24" fill={c}>
    <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
  </svg>
);
const ICON_POINTAGE = (c) => (
  <svg width="36" height="36" viewBox="0 0 24 24" fill={c}>
    <path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
  </svg>
);
const ICON_HS = (c) => (
  <svg width="36" height="36" viewBox="0 0 24 24" fill={c}>
    <path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67V7z"/>
  </svg>
);

const ICON_EXPORT = (c) => (
  <svg width="36" height="36" viewBox="0 0 24 24" fill={c}>
    <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
  </svg>
);

const CARTES = [
  { route: "/pointage/equipes",     titre: "Gestion d'équipe",        desc: "Équipes et membres",                     color: "#10B981", bg: "rgba(16,185,129,0.08)", icon: ICON_EQUIPE },
  { route: "/pointage/saisie",      titre: "Pointage personnel",      desc: "Saisie des présences par quart",         color: "#DA291C", bg: "rgba(218,41,28,0.08)",  icon: ICON_POINTAGE },
  { route: "/pointage/heures-supp", titre: "Analyse heures supp.",    desc: "Quotas, prévisions et suggestions (IA)", color: "#F5A623", bg: "rgba(245,166,35,0.08)", icon: ICON_HS },
  { route: "/pointage/export",      titre: "Export Pointages",        desc: "Fiches Excel/PDF, rapport AB, heures supp.", color: "#3B82F6", bg: "rgba(59,130,246,0.08)", icon: ICON_EXPORT },
];

export default function RhAccueil() {
  const { T } = useTheme();
  const navigate = useNavigate();

  return (
    <div style={{ padding: "24px 16px", maxWidth: 600, margin: "0 auto" }}>
      <div style={{ marginBottom: 32 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 8 }}>
          <div style={{ width: 44, height: 44, borderRadius: 14, background: "rgba(218,41,28,0.1)", display: "flex", alignItems: "center", justifyContent: "center" }}>
            {ICON_EQUIPE("#DA291C")}
          </div>
          <div>
            <h1 style={{ fontSize: 22, fontWeight: 700, color: T.text, margin: 0 }}>RH</h1>
            <p style={{ fontSize: 13, color: T.textSoft, margin: 0 }}>Équipes, pointage, heures supplémentaires et exports</p>
          </div>
        </div>
      </div>

      <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
        {CARTES.map(c => (
          <button
            key={c.route}
            onClick={() => navigate(c.route)}
            style={{
              background: T.card, border: `1px solid ${T.border}`, borderRadius: 20,
              padding: "24px 20px", cursor: "pointer", textAlign: "left",
              display: "flex", alignItems: "center", gap: 18,
              transition: "all 0.2s", boxShadow: "0 2px 8px rgba(0,0,0,0.06)",
            }}
            onMouseEnter={e => (e.currentTarget.style.transform = "translateY(-2px)")}
            onMouseLeave={e => (e.currentTarget.style.transform = "translateY(0)")}
          >
            <div style={{ width: 64, height: 64, borderRadius: 18, background: c.bg, flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "center" }}>
              {c.icon(c.color)}
            </div>
            <div style={{ flex: 1 }}>
              <p style={{ fontSize: 18, fontWeight: 700, color: c.color, margin: "0 0 4px" }}>{c.titre}</p>
              <p style={{ fontSize: 14, color: T.textSoft, margin: 0 }}>{c.desc}</p>
            </div>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
              <path d="M9 18l6-6-6-6" stroke={T.textSoft} strokeWidth="2" strokeLinecap="round" />
            </svg>
          </button>
        ))}
      </div>
    </div>
  );
}
