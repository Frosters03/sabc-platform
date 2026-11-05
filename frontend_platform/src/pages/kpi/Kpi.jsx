import { useTheme } from "../../components/layout/Layout";

const IconKpi = ({ size = 40, color = "currentColor" }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill={color}>
    <path d="M3 3v18h18v-2H5V3H3zm4 10h3v5H7v-5zm5-6h3v11h-3V7zm5 3h3v8h-3v-8z" />
  </svg>
);

export default function Kpi() {
  const { T } = useTheme();
  return (
    <div style={{ padding: "24px 16px", maxWidth: 600, margin: "0 auto" }}>
      <div style={{
        background: T.card, border: `1px solid ${T.border}`, borderRadius: 20,
        padding: "40px 24px", textAlign: "center", boxShadow: "0 2px 8px rgba(0,0,0,0.06)",
      }}>
        <div style={{
          width: 72, height: 72, borderRadius: 20, margin: "0 auto 18px",
          background: "rgba(218,41,28,0.08)", display: "flex", alignItems: "center", justifyContent: "center",
        }}>
          <IconKpi color="#DA291C" />
        </div>
        <h1 style={{ fontSize: 22, fontWeight: 700, color: T.text, margin: "0 0 8px" }}>KPI</h1>
        <p style={{ fontSize: 14, color: T.textSoft, margin: "0 0 18px", lineHeight: 1.5 }}>
          Module de visualisation des indicateurs de performance de l'usine.
        </p>
        <span style={{
          display: "inline-block", fontSize: 12, fontWeight: 700, padding: "6px 14px", borderRadius: 20,
          background: "rgba(245,158,11,0.12)", color: "#F59E0B",
        }}>
          En cours de développement
        </span>
      </div>
    </div>
  );
}
