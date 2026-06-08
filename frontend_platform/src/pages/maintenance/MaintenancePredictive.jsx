import { useState, useEffect, useCallback } from 'react';
import { useTheme } from '../../components/layout/Layout';
import { maintenanceAPI } from '../../services/api';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, Cell, LineChart, Line, Area,
  AreaChart, Legend, ReferenceLine
} from 'recharts';

// ── HOOK MOBILE ───────────────────────────────────────────
function useIsMobile() {
  const [isMobile, setIsMobile] = useState(
    () => window.innerWidth < 768 || /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent)
  );
  useEffect(() => {
    const h = () => setIsMobile(window.innerWidth < 768);
    window.addEventListener('resize', h);
    return () => window.removeEventListener('resize', h);
  }, []);
  return isMobile;
}

// ── CONSTANTES ────────────────────────────────────────────
const ATELIERS = ['Chaîne 8', 'Chaîne 14', 'Chaîne 15', 'Chaîne 16'];

// ── ICÔNES SVG INLINE ─────────────────────────────────────
const IconBrain    = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M13 3c-4.97 0-9 4.03-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42C8.27 19.99 10.51 21 13 21c4.97 0 9-4.03 9-9s-4.03-9-9-9zm-1 5v5l4.28 2.54.72-1.21-3.5-2.08V8H12z"/></svg>;
const IconWarn     = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>;
const IconCheck    = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>;
const IconRefresh  = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/></svg>;
const IconChart    = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/></svg>;
const IconAlert    = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>;
const IconForecast = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>;
const IconOEE      = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 14.5v-9l6 4.5-6 4.5z"/></svg>;
const IconXAI      = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-7 12l-1-2-1 2-2-1 2-1-2-1 2-1 1 2 1-2 2 1-2 1 2 1-2 1z"/></svg>;

// ── GAUGE SVG CIRCULAIRE ──────────────────────────────────
function ScoreGauge({ score, niveau, atelier, T, size = 110 }) {
  const r       = 42;
  const cx      = size / 2;
  const cy      = size / 2;
  const circum  = 2 * Math.PI * r;
  const offset  = score != null ? circum - (score / 100) * circum : circum;
  const color   = niveau === 'vert'   ? '#22C55E'
                : niveau === 'orange' ? '#F59E0B'
                : niveau === 'rouge'  ? '#EF4444'
                : T.textSoft;
  const label   = niveau === 'vert'   ? 'Bon'
                : niveau === 'orange' ? 'Attention'
                : niveau === 'rouge'  ? 'Critique'
                : '—';

  return (
    <div style={{ textAlign: 'center' }}>
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
        {/* Fond */}
        <circle cx={cx} cy={cy} r={r} fill="none"
          stroke={T.border} strokeWidth="9"/>
        {/* Arc coloré */}
        <circle cx={cx} cy={cy} r={r} fill="none"
          stroke={color} strokeWidth="9"
          strokeDasharray={circum}
          strokeDashoffset={offset}
          strokeLinecap="round"
          transform={`rotate(-90 ${cx} ${cy})`}
          style={{ transition: 'stroke-dashoffset 1.2s ease' }}
        />
        {/* Score */}
        <text x={cx} y={cy - 5} textAnchor="middle"
          dominantBaseline="middle"
          fill={score != null ? T.text : T.textSoft}
          fontSize="20" fontWeight="700" fontFamily="Arial">
          {score != null ? score : '—'}
        </text>
        {/* /100 */}
        <text x={cx} y={cy + 14} textAnchor="middle"
          fill={T.textSoft} fontSize="10" fontFamily="Arial">
          /100
        </text>
      </svg>
      {/* Niveau badge */}
      <div style={{
        display: 'inline-block', fontSize: 10, fontWeight: 700,
        color, background: `${color}18`,
        padding: '2px 10px', borderRadius: 20, marginTop: 2,
      }}>{label}</div>
      <div style={{ fontSize: 11, color: T.textSoft, marginTop: 4, fontWeight: 500 }}>
        {atelier}
      </div>
    </div>
  );
}

// ── CARD WRAPPER ──────────────────────────────────────────
function Card({ children, T, style = {} }) {
  return (
    <div style={{
      background: T.card, borderRadius: 14,
      padding: '20px', boxSizing: 'border-box',
      boxShadow: '0 1px 8px rgba(0,0,0,0.06)',
      border: `1px solid ${T.border}`,
      ...style,
    }}>
      {children}
    </div>
  );
}

function CardHeader({ icon, iconColor, title, subtitle, badge, T }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between',
      alignItems: 'flex-start', marginBottom: 16, flexWrap: 'wrap', gap: 8 }}>
      <div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
          <div style={{
            width: 28, height: 28, borderRadius: 8,
            background: `${iconColor}18`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>{icon}</div>
          <h3 style={{ margin: 0, fontSize: 13, fontWeight: 700, color: T.text }}>{title}</h3>
        </div>
        {subtitle && <p style={{ margin: 0, fontSize: 11, color: T.textSoft }}>{subtitle}</p>}
      </div>
      {badge && (
        <span style={{
          fontSize: 10, color: T.textSoft, background: T.bg,
          padding: '4px 10px', borderRadius: 8,
          border: `1px solid ${T.border}`, fontWeight: 600,
        }}>{badge}</span>
      )}
    </div>
  );
}

function CustomTooltip({ active, payload, label, T }) {
  if (!active || !payload?.length) return null;
  return (
    <div style={{
      background: T.card, border: `1px solid ${T.border}`,
      borderRadius: 10, padding: '10px 14px', fontSize: 12,
    }}>
      <div style={{ fontWeight: 600, color: T.text, marginBottom: 6 }}>{label}</div>
      {payload.map((p, i) => (
        <div key={i} style={{ color: p.color, marginBottom: 2 }}>
          {p.name} : <strong>{typeof p.value === 'number' ? p.value.toFixed(1) : p.value}</strong>
          {p.name.includes('%') || p.name.includes('OEE') || p.name.includes('Dispo') ? '%' : ''}
        </div>
      ))}
    </div>
  );
}

// ── COMPOSANT ANOMALIE ITEM ───────────────────────────────
function AnomalieItem({ item, T }) {
  const [expanded, setExpanded] = useState(false);
  const color = item.est_anomalie ? '#EF4444' : '#22C55E';
  const bgColor = item.est_anomalie ? '#FEF2F2' : '#F0FDF4';

  return (
    <div style={{
      borderRadius: 10, border: `1px solid ${item.est_anomalie ? '#FECACA' : T.border}`,
      background: item.est_anomalie ? bgColor : T.card,
      padding: '10px 14px', marginBottom: 8, cursor: 'pointer',
    }} onClick={() => setExpanded(!expanded)}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
        <div style={{
          width: 30, height: 30, borderRadius: 8,
          background: `${color}18`,
          display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
        }}>
          {item.est_anomalie
            ? <IconWarn s={15} c={color}/>
            : <IconCheck s={15} c={color}/>}
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
            <span style={{ fontSize: 12, fontWeight: 700, color: T.text }}>{item.atelier}</span>
            <span style={{
              fontSize: 10, color, background: `${color}18`,
              padding: '1px 7px', borderRadius: 20, fontWeight: 600,
            }}>
              {item.est_anomalie ? 'ANOMALIE' : 'Normal'}
            </span>
          </div>
          <div style={{ fontSize: 10, color: T.textSoft, marginTop: 1 }}>
            {item.date} · Score : {item.score?.toFixed(3)}
            {item.production_hl != null && ` · Prod : ${Math.round(item.production_hl)} hl`}
          </div>
        </div>
        <span style={{ fontSize: 11, color: T.textSoft }}>{expanded ? '▲' : '▼'}</span>
      </div>

      {expanded && item.message_xai && (
        <div style={{
          marginTop: 10, padding: '10px 12px', borderRadius: 8,
          background: T.bg, border: `1px solid ${T.border}`,
          fontSize: 11, color: T.text, lineHeight: 1.6,
        }}>
          <div style={{ display: 'flex', gap: 6, alignItems: 'flex-start' }}>
            <IconXAI s={14} c={T.primary}/>
            <span>{item.message_xai}</span>
          </div>
          {item.ecart_elec_pct != null && Math.abs(item.ecart_elec_pct) > 10 && (
            <div style={{ marginTop: 6, display: 'flex', gap: 6, flexWrap: 'wrap' }}>
              {[
                { label: 'Élec', val: item.ecart_elec_pct },
                { label: 'Pasteur', val: item.ecart_pasteur_pct },
                { label: 'Bain', val: item.ecart_bain_pct },
                { label: 'Prod', val: item.ecart_production_pct },
              ].filter(e => e.val != null && Math.abs(e.val) > 5).map((e, i) => (
                <span key={i} style={{
                  fontSize: 10, padding: '2px 8px', borderRadius: 20,
                  background: e.val > 0 ? '#FEF2F2' : '#F0FDF4',
                  color: e.val > 0 ? '#EF4444' : '#22C55E',
                  fontWeight: 600,
                }}>
                  {e.label} {e.val > 0 ? '+' : ''}{e.val?.toFixed(1)}%
                </span>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

// ══════════════════════════════════════════════════════════
// PAGE PRINCIPALE
// ══════════════════════════════════════════════════════════
export default function MaintenancePredictive() {
  const { T }    = useTheme();
  const isMobile = useIsMobile();

  const [loading,     setLoading]     = useState(true);
  const [analysing,   setAnalysing]   = useState(false);
  const [scores,      setScores]      = useState({});
  const [anomalies,   setAnomalies]   = useState([]);
  const [oeeData,     setOeeData]     = useState([]);
  const [previsions,  setPrevisions]  = useState([]);
  const [filtreAtelier, setFiltreAtelier] = useState('Tous');
  const [onlyAnomalies, setOnlyAnomalies] = useState(false);
  const [activeTab,   setActiveTab]   = useState('anomalies'); // anomalies | oee | previsions
  const [lastUpdate,  setLastUpdate]  = useState(null);
  const [erreur,      setErreur]      = useState(null);

  // ── CHARGEMENT DONNÉES ─────────────────────────────────
  const chargerDonnees = useCallback(async () => {
    setLoading(true);
    setErreur(null);
    try {
      const [scoresRes, anomRes, oeeRes, prevRes] = await Promise.all([
        maintenanceAPI.getScoresSante(),
        maintenanceAPI.getAnomalies({ nb_jours: 30 }),
        maintenanceAPI.getOEE({ nb_jours: 30 }),
        maintenanceAPI.getPrevisions(),
      ]);
      setScores(scoresRes.data || {});
      setAnomalies(anomRes.data || []);

      // Prépare données OEE pour le graphique groupé par atelier
      const oeeParAtelier = {};
      (oeeRes.data || []).forEach(r => {
        if (!oeeParAtelier[r.atelier]) {
          oeeParAtelier[r.atelier] = { vals: [], dispo: [], perf: [], qual: [], trs:[], taux_util:[] };
        }
        oeeParAtelier[r.atelier].vals.push(r.oee_pct);
        oeeParAtelier[r.atelier].dispo.push(r.disponibilite_pct);
        oeeParAtelier[r.atelier].perf.push(r.performance_pct);
        oeeParAtelier[r.atelier].qual.push(r.qualite_pct);
        oeeParAtelier[r.atelier].trs.push(r.trs_pct || 0);
        oeeParAtelier[r.atelier].taux_util.push(r.taux_utilisation_pct || 0);
      });

      const oeeChart = ATELIERS.map(a => {
        const d = oeeParAtelier[a];
        const avg = arr => arr?.length ? +(arr.reduce((s,v)=>s+v,0)/arr.length).toFixed(1) : 0;
        return {
          atelier: a.replace('Chaîne ', 'Ch.'),
          OEE: avg(d?.vals),
          TRS: avg(d?.trs),
          TRG: avg(d?.vals),
          Disponibilité: avg(d?.dispo),
          Performance: avg(d?.perf),
          Qualité: avg(d?.qual),
          TauxUtil: avg(d?.taux_util),
        };
      });
      setOeeData(oeeChart);

      // Prévisions Prophet — groupées par atelier
      const prevMap = {};
      (prevRes.data || []).forEach(r => {
        if (!prevMap[r.date_prevision]) prevMap[r.date_prevision] = { date: r.date_prevision };
        prevMap[r.date_prevision][r.atelier.replace('Chaîne ', 'Ch.')] = r.valeur_predite;
        prevMap[r.date_prevision][`${r.atelier.replace('Chaîne ', 'Ch.')}_inf`] = r.borne_inf;
        prevMap[r.date_prevision][`${r.atelier.replace('Chaîne ', 'Ch.')}_sup`] = r.borne_sup;
      });
      setPrevisions(Object.values(prevMap).sort((a,b) => a.date.localeCompare(b.date)));
      setLastUpdate(new Date().toLocaleTimeString('fr-FR', {hour:'2-digit', minute:'2-digit'}));
    } catch(e) {
      console.error(e);
      setErreur("Erreur de chargement. Lance d'abord l'analyse.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { chargerDonnees(); }, [chargerDonnees]);

  // ── LANCER ANALYSE ─────────────────────────────────────
  const lancerAnalyse = async () => {
    setAnalysing(true);
    setErreur(null);
    try {
      await maintenanceAPI.lancerAnalyseTous();
      await chargerDonnees();
    } catch(e) {
      setErreur("Erreur lors de l'analyse. Vérifier le backend.");
      console.error(e);
    } finally {
      setAnalysing(false);
    }
  };

  // ── FILTRES ANOMALIES ──────────────────────────────────
  const anomaliesFiltrees = anomalies.filter(a => {
    if (filtreAtelier !== 'Tous' && a.atelier !== filtreAtelier) return false;
    if (onlyAnomalies && !a.est_anomalie) return false;
    return true;
  });

  const nbAnomalies = anomalies.filter(a => a.est_anomalie).length;
  const scoresMoyen = Object.values(scores)
    .filter(s => s.score != null)
    .reduce((sum, s, _, arr) => sum + s.score / arr.length, 0);

  const chaineCritique = Object.entries(scores)
    .filter(([,s]) => s.niveau === 'rouge')
    .map(([a]) => a);

  // ── COULEURS OEE ───────────────────────────────────────
  const OEE_COLORS = {
    OEE: T.primary, Disponibilité: '#3B82F6',
    Performance: '#F59E0B', Qualité: '#22C55E',
  };

  // ── PREV COLORS ────────────────────────────────────────
  const PREV_COLORS = ['#3B82F6','#F59E0B','#22C55E','#EF4444'];

  if (loading) return (
    <div style={{ display:'flex', alignItems:'center', justifyContent:'center',
      height:'80vh', flexDirection:'column', gap:12 }}>
      <div style={{ width:36, height:36, border:`3px solid ${T.border}`,
        borderTop:`3px solid ${T.primary}`, borderRadius:'50%',
        animation:'spin 0.8s linear infinite'}}/>
      <span style={{ fontSize:13, color:T.textSoft }}>Chargement des données IA...</span>
    </div>
  );


  const exporterRapportPDF = () => {
    const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
    const today = new Date().toLocaleDateString('fr-FR', {
      weekday:'long', day:'numeric', month:'long', year:'numeric'
    });
    const pageW = doc.internal.pageSize.getWidth();

    // ── EN-TÊTE ──────────────────────────────────────────
    doc.setFillColor(218, 41, 28);
    doc.rect(0, 0, pageW, 28, 'F');
    doc.setTextColor(255, 255, 255);
    doc.setFontSize(16);
    doc.setFont('helvetica', 'bold');
    doc.text('BRASSERIES DU CAMEROUN — SABC NDOKOTI', pageW/2, 11, { align:'center' });
    doc.setFontSize(11);
    doc.setFont('helvetica', 'normal');
    doc.text('Rapport IA — Maintenance Prédictive · Ligne de Packaging', pageW/2, 19, { align:'center' });
    doc.setFontSize(9);
    doc.text(today, pageW/2, 25, { align:'center' });

    // ── SOUS-TITRE ───────────────────────────────────────
    doc.setTextColor(30, 58, 95);
    doc.setFontSize(13);
    doc.setFont('helvetica', 'bold');
    doc.text('Résumé Santé des Chaînes', 14, 38);

    // ── SCORES SANTÉ ─────────────────────────────────────
    const scoresRows = ['Chaîne 8','Chaîne 14','Chaîne 15','Chaîne 16'].map(a => {
      const s = scores[a];
      const score  = s?.score != null ? Math.round(s.score) : '—';
      const niveau = s?.niveau === 'vert'   ? 'BON'
                   : s?.niveau === 'orange' ? 'ATTENTION'
                   : s?.niveau === 'rouge'  ? 'CRITIQUE' : '—';
      return [
        a,
        score + (score !== '—' ? '/100' : ''),
        niveau,
        s?.taux_anomalies != null ? s.taux_anomalies + '%' : '—',
        s?.ecart_baseline != null ? s.ecart_baseline + '%' : '—',
        s?.taux_qualite   != null ? s.taux_qualite   + '%' : '—',
      ];
    });

    autoTable(doc, {
      startY: 42,
      head: [['Chaîne', 'Score', 'Statut', 'Taux anomalies', 'Écart énergie', 'Qualité']],
      body: scoresRows,
      styles: { fontSize:9, cellPadding:3 },
      headStyles: { fillColor:[30,58,95], textColor:255, fontStyle:'bold' },
      alternateRowStyles: { fillColor:[235,243,251] },
      columnStyles: {
        1: { halign:'center', fontStyle:'bold' },
        2: { halign:'center' },
      },
      didDrawCell: (data) => {
        if (data.section === 'body' && data.column.index === 2) {
          const val = data.cell.raw;
          if (val === 'BON')       doc.setTextColor(34,197,94);
          else if (val === 'ATTENTION') doc.setTextColor(245,158,11);
          else if (val === 'CRITIQUE')  doc.setTextColor(239,68,68);
          doc.setFontSize(8);
          doc.setFont('helvetica','bold');
          doc.text(val, data.cell.x + data.cell.width/2,
            data.cell.y + data.cell.height/2, { align:'center', baseline:'middle' });
          doc.setTextColor(0,0,0);
        }
      },
    });

    // ── ANOMALIES ─────────────────────────────────────────
    const anomaliesDetectees = anomalies.filter(a => a.est_anomalie).slice(0, 15);
    const y2 = doc.lastAutoTable.finalY + 12;

    doc.setTextColor(30, 58, 95);
    doc.setFontSize(13);
    doc.setFont('helvetica', 'bold');
    doc.text(`Anomalies Détectées (${anomaliesDetectees.length})`, 14, y2);

    if (anomaliesDetectees.length > 0) {
      autoTable(doc, {
        startY: y2 + 4,
        head: [['Date', 'Chaîne', 'Score', 'Prod (hl)', 'Cause probable']],
        body: anomaliesDetectees.map(a => [
          a.date,
          a.atelier,
          a.score?.toFixed(3) ?? '—',
          a.production_hl ? Math.round(a.production_hl) : '—',
          (a.message_xai || '—')
            .replace(/⚠/g, '!')
            .replace(/→/g, '->')
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, ''),
        ]),
        styles: { fontSize:8, cellPadding:2 },
        headStyles: { fillColor:[218,41,28], textColor:255, fontStyle:'bold' },
        alternateRowStyles: { fillColor:[255,242,242] },
        columnStyles: { 4: { cellWidth:70 } },
      });
    } else {
      doc.setTextColor(100,116,139);
      doc.setFontSize(9);
      doc.setFont('helvetica', 'normal');
      doc.text('Aucune anomalie détectée sur la période.', 14, y2 + 10);
    }

    // ── OEE ───────────────────────────────────────────────
    const y3 = (doc.lastAutoTable?.finalY ?? y2 + 10) + 12;
    doc.setTextColor(30, 58, 95);
    doc.setFontSize(13);
    doc.setFont('helvetica', 'bold');
    doc.text('OEE — Taux de Rendement Global (30 jours)', 14, y3);

    autoTable(doc, {
      startY: y3 + 4,
      head: [['Chaîne', 'Disponibilité', 'Performance', 'Qualité', 'OEE Moyen', 'Statut']],
      body: oeeData.map(r => [
        r.atelier,
        r.Disponibilité + '%',
        r.Performance   + '%',
        r.Qualité        + '%',
        r.OEE            + '%',
        r.OEE >= 85 ? 'Classe mondiale' : r.OEE >= 70 ? 'À améliorer' : 'Critique',
      ]),
      styles: { fontSize:9, cellPadding:3 },
      headStyles: { fillColor:[30,58,95], textColor:255, fontStyle:'bold' },
      alternateRowStyles: { fillColor:[235,243,251] },
      columnStyles: { 4: { halign:'center', fontStyle:'bold' } },
    });

    // ── PRÉVISIONS ────────────────────────────────────────
    if (previsions.length > 0) {
      const y4 = doc.lastAutoTable.finalY + 12;
      doc.setTextColor(30, 58, 95);
      doc.setFontSize(13);
      doc.setFont('helvetica', 'bold');
      doc.text('Prévisions Énergie — 7 prochains jours (Prophet)', 14, y4);

      autoTable(doc, {
        startY: y4 + 4,
        head: [['Date', 'Ch.8 (kWh)', 'Ch.14 (kWh)', 'Ch.15 (kWh)', 'Ch.16 (kWh)']],
        body: previsions.map(r => [
          r.date,
          r['Ch.8']  != null ? r['Ch.8'].toFixed(0)  : '—',
          r['Ch.14'] != null ? r['Ch.14'].toFixed(0) : '—',
          r['Ch.15'] != null ? r['Ch.15'].toFixed(0) : '—',
          r['Ch.16'] != null ? r['Ch.16'].toFixed(0) : '—',
        ]),
        styles: { fontSize:9, cellPadding:3 },
        headStyles: { fillColor:[59,130,246], textColor:255, fontStyle:'bold' },
        alternateRowStyles: { fillColor:[239,246,255] },
      });
    }

    // ── PIED DE PAGE ──────────────────────────────────────
    const pageCount = doc.internal.getNumberOfPages();
    for (let i = 1; i <= pageCount; i++) {
      doc.setPage(i);
      doc.setFontSize(8);
      doc.setTextColor(148,163,184);
      doc.text(
        `SABC Ndokoti — Plateforme IA Packaging · Page ${i}/${pageCount} · Généré le ${new Date().toLocaleDateString('fr-FR')}`,
        pageW/2,
        doc.internal.pageSize.getHeight() - 8,
        { align:'center' }
      );
    }

    // ── TÉLÉCHARGEMENT ────────────────────────────────────
    doc.save(`Rapport_IA_SABC_${new Date().toISOString().split('T')[0]}.pdf`);
  };

  return (
    <div style={{
      padding: isMobile ? '16px 14px 90px' : '24px 28px',
      background: T.bg, minHeight: '100vh',
      boxSizing: 'border-box', overflowX: 'hidden',
    }}>

      {/* ── EN-TÊTE ── */}
      <div style={{ display:'flex', justifyContent:'space-between',
        alignItems: isMobile ? 'flex-start' : 'center',
        marginBottom: 20, flexWrap:'wrap', gap:12 }}>
        <div>
          <div style={{ display:'flex', alignItems:'center', gap:10, marginBottom:4 }}>
            <div style={{
              width:38, height:38, borderRadius:10,
              background:`${T.primary}18`,
              display:'flex', alignItems:'center', justifyContent:'center',
            }}>
              <IconBrain s={22} c={T.primary}/>
            </div>
            <div>
              <h1 style={{ margin:0, fontSize: isMobile?17:21,
                fontWeight:700, color:T.text, letterSpacing:-0.3 }}>
                Maintenance Prédictive IA
              </h1>
              <p style={{ margin:0, fontSize:11, color:T.textSoft }}>
                Isolation Forest · Prophet · OEE · XAI
                {lastUpdate && ` · Mis à jour à ${lastUpdate}`}
              </p>
            </div>
          </div>
        </div>

        
        <div style={{ display:'flex', gap:10, flexWrap:'wrap' }}>
          {/* Bouton PDF */}
          <button onClick={exporterRapportPDF} style={{
            display:'flex', alignItems:'center', gap:8,
            background: T.card, color: T.text,
            border:`1px solid ${T.border}`,
            borderRadius:10, padding:'10px 18px',
            fontSize:13, fontWeight:600, cursor:'pointer',
          }}>
            <svg width="15" height="15" viewBox="0 0 24 24" fill={T.primary}>
              <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
            </svg>
            Exporter PDF
          </button>

          <button onClick={lancerAnalyse} disabled={analysing} style={{
            display:'flex', alignItems:'center', gap:8,
            background: analysing ? T.border : T.primary,
            color:'#fff', border:'none', borderRadius:10,
            padding:'10px 18px', fontSize:13, fontWeight:600,
            cursor: analysing ? 'not-allowed' : 'pointer',
            transition:'all 0.2s',
          }}>
            <div style={{
              width:14, height:14,
              border:'2px solid #fff',
              borderTop:'2px solid transparent',
              borderRadius:'50%',
              animation:'spin 0.8s linear infinite',
              flexShrink:0,
              visibility: analysing ? 'visible' : 'hidden',
              position: analysing ? 'static' : 'absolute',
              opacity: analysing ? 1 : 0,
            }}/>
            {analysing ? 'Analyse en cours...' : "Lancer l'analyse"}
          </button>
        </div>
      </div>

      {/* ── ERREUR ── */}
      {erreur && (
        <div style={{
          background:'#FEF2F2', border:'1px solid #FECACA',
          borderRadius:10, padding:'12px 16px', marginBottom:16,
          fontSize:12, color:'#EF4444', display:'flex', gap:8, alignItems:'center',
        }}>
          <IconWarn s={15} c="#EF4444"/> {erreur}
        </div>
      )}

      {/* ── LOADING ANALYSE ── */}
      {analysing && (
        <div style={{
          background:'#EFF6FF', border:'1px solid #BFDBFE',
          borderRadius:10, padding:'12px 16px', marginBottom:16,
          fontSize:12, color:'#2563EB', display:'flex', gap:8, alignItems:'center',
        }}>
          <IconBrain s={15} c="#2563EB"/>
          Isolation Forest + Prophet en cours sur les 4 chaînes...
          Durée estimée : 1–2 minutes. Ne fermez pas la page.
        </div>
      )}

      {/* ── KPI RÉSUMÉ ── */}
      <div style={{
        display:'grid',
        gridTemplateColumns: isMobile ? '1fr 1fr' : 'repeat(3, 1fr)',
        gap: isMobile ? 10 : 16, marginBottom: 20,
      }}>
        {[
          { label:'Score santé moyen', value: scoresMoyen > 0 ? scoresMoyen.toFixed(0) : '—',
            unit:'/100', color: scoresMoyen >= 80 ? '#22C55E' : scoresMoyen >= 50 ? '#F59E0B' : '#EF4444',
            icon: <IconChart s={20} c={T.primary}/> },
          { label:`Anomalies (30 jours)`, value: nbAnomalies, unit:'détectées',
            color: nbAnomalies === 0 ? '#22C55E' : nbAnomalies < 5 ? '#F59E0B' : '#EF4444',
            icon: <IconWarn s={20} c="#EF4444"/> },
          { label:'Chaînes critiques', value: chaineCritique.length,
            unit: chaineCritique.length > 0 ? chaineCritique.join(', ') : 'aucune',
            color: chaineCritique.length > 0 ? '#EF4444' : '#22C55E',
            icon: <IconAlert s={20} c="#EF4444"/> },
        ].map((k, i) => (
          <Card T={T} key={i}>
            <div style={{ display:'flex', alignItems:'center',
              justifyContent:'space-between', marginBottom:10 }}>
              <div style={{ width:36, height:36, borderRadius:9,
                background:`${k.color}18`,
                display:'flex', alignItems:'center', justifyContent:'center' }}>
                {k.icon}
              </div>
              <span style={{
                fontSize:10, fontWeight:700, color:k.color,
                background:`${k.color}18`, padding:'3px 9px', borderRadius:20,
              }}>IA</span>
            </div>
            <div style={{ fontSize: isMobile?22:28, fontWeight:700,
              color:T.text, lineHeight:1, letterSpacing:-0.5 }}>
              {k.value}
              <span style={{ fontSize:11, color:T.textSoft, marginLeft:4, fontWeight:400 }}>
                {k.unit}
              </span>
            </div>
            <div style={{ fontSize:11, color:T.textSoft, marginTop:4 }}>{k.label}</div>
          </Card>
        ))}
      </div>

      {/* ── SCORES SANTÉ ── */}
      <Card T={T} style={{ marginBottom: 20 }}>
        <CardHeader
          icon={<IconChart s={15} c={T.primary}/>} iconColor={T.primary}
          title="Score de Santé par Chaîne"
          subtitle="Indicateur composite : anomalies + énergie + qualité + régularité"
          badge="Mise à jour aujourd'hui" T={T}
        />
        <div style={{
          display:'grid',
          gridTemplateColumns: `repeat(${isMobile ? 2 : 4}, 1fr)`,
          gap: isMobile ? 16 : 24, justifyItems:'center',
        }}>
          {ATELIERS.map(a => (
            <ScoreGauge
              key={a} atelier={a}
              score={scores[a]?.score ?? null}
              niveau={scores[a]?.niveau ?? 'inconnu'}
              T={T} size={isMobile ? 100 : 120}
            />
          ))}
        </div>

        {/* Légende */}
        <div style={{
          display:'flex', gap:16, justifyContent:'center',
          marginTop:16, flexWrap:'wrap',
        }}>
          {[['#22C55E','80–100 : Bon'],['#F59E0B','50–79 : Attention'],['#EF4444','0–49 : Critique']].map(([c,l]) => (
            <div key={l} style={{ display:'flex', alignItems:'center', gap:5, fontSize:10, color:T.textSoft }}>
              <div style={{ width:10, height:10, borderRadius:'50%', background:c }}/>
              {l}
            </div>
          ))}
        </div>

        {/* Détails scores */}
        {Object.keys(scores).length > 0 && (
          <div style={{
            display:'grid', gridTemplateColumns: isMobile?'1fr':'repeat(2,1fr)',
            gap:8, marginTop:16,
          }}>
            {ATELIERS.filter(a => scores[a]?.score != null).map(a => {
              const s = scores[a];
              return (
                <div key={a} style={{
                  display:'flex', alignItems:'center', justifyContent:'space-between',
                  padding:'8px 12px', borderRadius:8,
                  background:T.bg, border:`1px solid ${T.border}`,
                }}>
                  <span style={{ fontSize:11, color:T.text, fontWeight:600 }}>{a}</span>
                  <div style={{ display:'flex', gap:12, fontSize:10, color:T.textSoft }}>
                    <span>Anomalies : {s.taux_anomalies}%</span>
                    <span>Qualité : {s.taux_qualite}%</span>
                    <span>Écart élec : {s.ecart_baseline}%</span>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </Card>

      {/* ── ONGLETS ── */}
      <div style={{ display:'flex', gap:4, marginBottom:16, flexWrap:'wrap' }}>
        {[
          { key:'anomalies', label:'Anomalies', icon:<IconWarn s={13} c="currentColor"/> },
          { key:'oee',       label:'OEE',       icon:<IconOEE s={13} c="currentColor"/> },
          { key:'previsions',label:'Prévisions', icon:<IconForecast s={13} c="currentColor"/> },
        ].map(t => (
          <button key={t.key} onClick={() => setActiveTab(t.key)} style={{
            display:'flex', alignItems:'center', gap:6,
            padding:'8px 16px', borderRadius:10, border:'none', cursor:'pointer',
            fontSize:12, fontWeight:600,
            background: activeTab === t.key ? T.primary : T.card,
            color:       activeTab === t.key ? '#fff'     : T.textSoft,
            border: `1px solid ${activeTab === t.key ? T.primary : T.border}`,
            transition:'all 0.2s',
          }}>
            {t.icon} {t.label}
          </button>
        ))}
      </div>

      {/* ── ONGLET ANOMALIES ── */}
      {activeTab === 'anomalies' && (
        <Card T={T}>
          <CardHeader
            icon={<IconWarn s={15} c="#EF4444"/>} iconColor="#EF4444"
            title="Détection d'Anomalies — Isolation Forest"
            subtitle="Algorithme ML non supervisé · 9 features · contamination=8%"
            badge={`${anomaliesFiltrees.length} relevés`} T={T}
          />

          {/* Filtres */}
          <div style={{ display:'flex', gap:8, marginBottom:14, flexWrap:'wrap', alignItems:'center' }}>
            <select value={filtreAtelier} onChange={e => setFiltreAtelier(e.target.value)}
              style={{
                padding:'6px 10px', borderRadius:8,
                border:`1px solid ${T.border}`,
                background:T.card, color:T.text,
                fontSize:12, cursor:'pointer',
              }}>
              <option value="Tous">Toutes les chaînes</option>
              {ATELIERS.map(a => <option key={a} value={a}>{a}</option>)}
            </select>
            <label style={{ display:'flex', alignItems:'center', gap:6,
              fontSize:12, color:T.textSoft, cursor:'pointer' }}>
              <input type="checkbox" checked={onlyAnomalies}
                onChange={e => setOnlyAnomalies(e.target.checked)}/>
              Anomalies seulement
            </label>
            <span style={{
              fontSize:10, padding:'3px 10px', borderRadius:20,
              background:'#FEF2F2', color:'#EF4444', fontWeight:700,
            }}>
              {anomaliesFiltrees.filter(a => a.est_anomalie).length} anomalies
            </span>
          </div>

          {/* Liste */}
          <div style={{ maxHeight:420, overflowY:'auto', paddingRight:4 }}>
            {anomaliesFiltrees.length === 0 ? (
              <div style={{ textAlign:'center', padding:'30px 0',
                color:T.textSoft, fontSize:13, display:'flex',
                alignItems:'center', justifyContent:'center', gap:8 }}>
                <IconCheck s={18} c={T.success}/>
                {anomalies.length === 0
                  ? "Lance l'analyse pour voir les résultats."
                  : 'Aucune anomalie détectée sur la période.'}
              </div>
            ) : (
              anomaliesFiltrees.map((item, i) => (
                <AnomalieItem key={i} item={item} T={T}/>
              ))
            )}
          </div>
        </Card>
      )}

      {/* ── ONGLET OEE ── */}
      {activeTab === 'oee' && (
        <Card T={T}>
          <CardHeader
            icon={<IconOEE s={15} c={T.primary}/>} iconColor={T.primary}
            title="TRS / TRG — Taux de Rendement"
            subtitle="TRG = [Bonnes bouteilles / (Cadence × Temps d'ouverture)] × 100 · TRS = Dispo × Perf × Qualité"
            badge="30 derniers jours" T={T}
          />

          {oeeData.length > 0 ? (
            <>
              <ResponsiveContainer width="100%" height={280}>
                <BarChart data={oeeData} barCategoryGap="20%" barGap={3}>
                  <CartesianGrid strokeDasharray="3 3" stroke={T.border} vertical={false}/>
                  <XAxis dataKey="atelier" tick={{ fontSize:11, fill:T.textSoft }}
                    axisLine={false} tickLine={false}/>
                  <YAxis domain={[0, 100]} tick={{ fontSize:10, fill:T.textSoft }}
                    axisLine={false} tickLine={false}
                    tickFormatter={v => `${v}%`}/>
                  <Tooltip content={(p) => <CustomTooltip {...p} T={T}/>}
                    cursor={{ fill:`${T.border}40` }}/>
                  <Legend wrapperStyle={{ fontSize:11, color:T.textSoft }}/>
                  <ReferenceLine y={85} stroke="#F59E0B" strokeDasharray="6 3"
                    strokeWidth={1.5} label={{ value:'Obj. TRS 85%', fontSize:9, fill:'#F59E0B', position:'right' }}/>
                  <ReferenceLine y={75} stroke="#EF4444" strokeDasharray="6 3"
                    strokeWidth={1.5} label={{ value:'Obj. TRG 75%', fontSize:9, fill:'#EF4444', position:'right' }}/>
                  {['OEE','Disponibilité','Performance','Qualité'].map(k => (
                    <Bar key={k} dataKey={k} fill={OEE_COLORS[k]} radius={[4,4,0,0]}/>
                  ))}
                </BarChart>
              </ResponsiveContainer>

              {/* Tableau récap OEE */}
              <div style={{ marginTop:16, overflowX:'auto' }}>
                <table style={{ width:'100%', borderCollapse:'collapse', fontSize:11 }}>
                  <thead>
                    <tr>
                      {['Chaîne','Disponibilité','Performance','Qualité','TRS','TRG','Taux Utilisation','Statut'].map(h => (
                        <th key={h} style={{ padding:'8px 12px', textAlign:'center',
                          background:T.bg, color:T.textSoft, fontWeight:600,
                          borderBottom:`2px solid ${T.border}` }}>{h}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {oeeData.map((row, i) => {
                      const trsColor = row.TRS >= 85 ? '#22C55E' : row.TRS >= 70 ? '#F59E0B' : '#EF4444';
                      const trgColor = row.TRG >= 75 ? '#22C55E' : row.TRG >= 60 ? '#F59E0B' : '#EF4444';
                      return (
                        <tr key={i} style={{ background: i%2===0 ? T.bg : T.card }}>
                          <td style={{ padding:'8px 12px', textAlign:'center',
                            fontWeight:600, color:T.text }}>{row.atelier}</td>
                          <td style={{ padding:'8px 12px', textAlign:'center',
                            color:T.text }}>{row.Disponibilité}%</td>
                          <td style={{ padding:'8px 12px', textAlign:'center',
                            color:T.text }}>{row.Performance}%</td>
                          <td style={{ padding:'8px 12px', textAlign:'center',
                            color:T.text }}>{row.Qualité}%</td>
                          <td style={{ padding:'8px 12px', textAlign:'center' }}>
                            <span style={{ fontWeight:700, color:trsColor }}>{row.TRS}%</span>
                          </td>
                          <td style={{ padding:'8px 12px', textAlign:'center' }}>
                            <span style={{ fontWeight:700, color:trgColor }}>{row.TRG}%</span>
                          </td>
                          <td style={{ padding:'8px 12px', textAlign:'center',
                            color:T.textSoft }}>{row.TauxUtil}%</td>
                          <td style={{ padding:'8px 12px', textAlign:'center' }}>
                            <span style={{
                              fontSize:10, fontWeight:700, color:trgColor,
                              background:`${trgColor}18`,
                              padding:'2px 8px', borderRadius:20,
                            }}>
                              {row.TRG >= 75 ? '✓ Bon' : row.TRG >= 60 ? '⚠ À améliorer' : '✗ Critique'}
                            </span>
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>

            <div style={{ padding:'10px 14px', borderRadius:8,
              background:T.bg, border:`1px solid ${T.border}`,
              fontSize:11, color:T.textSoft, marginTop:12, lineHeight:1.8 }}>
              <strong style={{ color:T.text }}>Formule TRG :</strong>{' '}
              [Bonnes bouteilles (hl) / (Cadence nominale × Temps d'ouverture 24h)] × 100<br/>
              <strong style={{ color:T.text }}>Cadence nominale :</strong>{' '}
              Ch.8 = 153 hl/h · Ch.14 = 135 hl/h · Ch.15 = 123 hl/h · Ch.16 = 151 hl/h<br/>
              <strong style={{ color:T.text }}>Bonnes bouteilles :</strong>{' '}
              Production réelle × Conformité qualité × Conformité sertissage<br/>
              <strong style={{ color:T.text }}>Objectifs :</strong>{' '}
              TRS ≥ 85% · TRG ≥ 75%
            </div>


            </>
          ) : (
            <div style={{ textAlign:'center', padding:'40px 0',
              color:T.textSoft, fontSize:13 }}>
              Lance l'analyse pour calculer l'OEE.
            </div>
          )}
        </Card>
      )}

      {/* ── ONGLET PRÉVISIONS ── */}
      {activeTab === 'previsions' && (
        <Card T={T}>
          <CardHeader
            icon={<IconForecast s={15} c="#3B82F6"/>} iconColor="#3B82F6"
            title="Prévisions Énergie — Prophet (Meta)"
            subtitle="Prédiction consommation électrique · 7 jours · Intervalle de confiance 80%"
            badge="Prochains 7 jours" T={T}
          />

          {previsions.length > 0 ? (
            <>
              <ResponsiveContainer width="100%" height={280}>
                <LineChart data={previsions}>
                  <CartesianGrid strokeDasharray="3 3" stroke={T.border} vertical={false}/>
                  <XAxis dataKey="date" tick={{ fontSize:10, fill:T.textSoft }}
                    axisLine={false} tickLine={false}
                    tickFormatter={d => d?.slice(5) || d}/>
                  <YAxis tick={{ fontSize:10, fill:T.textSoft }}
                    axisLine={false} tickLine={false}/>
                  <Tooltip content={(p) => <CustomTooltip {...p} T={T}/>}
                    cursor={{ stroke:T.border }}/>
                  <Legend wrapperStyle={{ fontSize:11, color:T.textSoft }}/>
                  {['Ch.8','Ch.14','Ch.15','Ch.16'].map((a, i) => (
                    <Line key={a} type="monotone" dataKey={a}
                      stroke={PREV_COLORS[i]} strokeWidth={2.5}
                      dot={{ r:3, fill:PREV_COLORS[i] }}
                      activeDot={{ r:5 }}/>
                  ))}
                </LineChart>
              </ResponsiveContainer>

              {/* Tableau prévisions */}
              <div style={{ marginTop:16, overflowX:'auto' }}>
                <table style={{ width:'100%', borderCollapse:'collapse', fontSize:11 }}>
                  <thead>
                    <tr>
                      {['Date', 'Ch.8 (kWh)', 'Ch.14 (kWh)', 'Ch.15 (kWh)', 'Ch.16 (kWh)'].map(h => (
                        <th key={h} style={{ padding:'8px 12px', textAlign:'center',
                          background:T.bg, color:T.textSoft, fontWeight:600,
                          borderBottom:`2px solid ${T.border}` }}>{h}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {previsions.map((row, i) => (
                      <tr key={i} style={{ background: i%2===0 ? T.bg : T.card }}>
                        <td style={{ padding:'8px 12px', textAlign:'center',
                          fontWeight:600, color:T.text }}>{row.date}</td>
                        {['Ch.8','Ch.14','Ch.15','Ch.16'].map(a => (
                          <td key={a} style={{ padding:'8px 12px', textAlign:'center',
                            color:T.text }}>
                            {row[a] != null ? `${row[a].toFixed(0)} kWh` : '—'}
                          </td>
                        ))}
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              <div style={{ marginTop:12, padding:'10px 14px', borderRadius:8,
                background:T.bg, border:`1px solid ${T.border}`,
                fontSize:11, color:T.textSoft, lineHeight:1.6 }}>
                <strong style={{ color:T.text }}>Prophet (Meta) :</strong> modèle additif décomposant
                la série temporelle en tendance + saisonnalité hebdomadaire.
                Entraîné sur 90 jours de relevés (hors arrêts entretien).
                Ces prévisions permettent d'anticiper une surconsommation avant qu'elle devienne une panne.
              </div>
            </>
          ) : (
            <div style={{ textAlign:'center', padding:'40px 0',
              color:T.textSoft, fontSize:13 }}>
              Lance l'analyse pour générer les prévisions Prophet.
            </div>
          )}
        </Card>
      )}
    </div>
  );
}