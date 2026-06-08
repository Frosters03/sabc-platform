import { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { useTheme } from '../../components/layout/Layout';
import { alertesAPI, energieAPI, maintenanceAPI } from '../../services/api';
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, Cell, LabelList
} from 'recharts';

function useIsMobile() {
  const [isMobile, setIsMobile] = useState(
    () => window.innerWidth < 768 || /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent)
  );
  useEffect(() => {
    const handle = () => setIsMobile(
      window.innerWidth < 768 || /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent)
    );
    window.addEventListener('resize', handle);
    return () => window.removeEventListener('resize', handle);
  }, []);
  return isMobile;
}

// ── CONSTANTES ────────────────────────────────────────────
const ATELIERS = ['Chaîne 8','Chaîne 13','Chaîne 14','Chaîne 15','Chaîne 16'];
const OBJECTIFS = {
  'Chaîne 8':  3500,
  'Chaîne 13': 1000,
  'Chaîne 14': 2500,
  'Chaîne 15': 3500,
  'Chaîne 16': 3000,
};
const OBJECTIF_TOTAL = 13500;
const ORDRE_QUART = { '6h-14h':1, '14h-22h':2, '22h-6h':3 };

function getJMoins1() {
  const d = new Date();
  d.setDate(d.getDate() - 1);
  return d.toISOString().split('T')[0];
}

// ── ICÔNES ────────────────────────────────────────────────
const IconWater     = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 2c-5.33 4.55-8 8.48-8 11.8 0 4.98 3.8 8.2 8 8.2s8-3.22 8-8.2c0-3.32-2.67-7.25-8-11.8z"/></svg>;
const IconBolt      = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M7 2v11h3v9l7-12h-4l4-8z"/></svg>;
const IconBell      = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>;
const IconBottle    = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M15 3V1H9v2H7.5C6.7 3 6 3.7 6 4.5v1C6 6.9 7 8 7 9.5V20c0 1.1.9 2 2 2h6c1.1 0 2-.9 2-2V9.5c0-1.5 1-2.6 1-4V4.5C18 3.7 17.3 3 16.5 3H15zm-3 4.5c-.8 0-1.5-.7-1.5-1.5S11.2 4.5 12 4.5s1.5.7 1.5 1.5S12.8 7.5 12 7.5z"/></svg>;
const IconClipboard = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>;
const IconFactory   = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M4 18v-3.31L8 12v2.5l4-2.5v2.5l4-2.5V18H4zm0-5.5V4h16v8.5l-4 2.5V13l-4 2.5V13l-4 2.5z"/></svg>;
const IconWarning   = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>;
const IconCheck     = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>;
const IconTrendUp   = ({size=13,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M16 6l2.29 2.29-4.88 4.88-4-4L2 16.59 3.41 18l6-6 4 4 6.3-6.29L22 12V6z"/></svg>;
const IconTrendDown = ({size=13,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M16 18l2.29-2.29-4.88-4.88-4 4L2 7.41 3.41 6l6 6 4-4 6.3 6.29L22 12v6z"/></svg>;
const IconDot       = ({size=10,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><circle cx="12" cy="12" r="8"/></svg>;
const IconBrain = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M13 3c-4.97 0-9 4.03-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42C8.27 19.99 10.51 21 13 21c4.97 0 9-4.03 9-9s-4.03-9-9-9zm-1 5v5l4.28 2.54.72-1.21-3.5-2.08V8H12z"/></svg>;

// ── KPI CARD ──────────────────────────────────────────────
function KpiCard({ icon, label, value, unit, color, trend, trendVal, progress, T, isMobile }) {
  return (
    <div style={{
      background: T.card, borderRadius: 14,
      padding: isMobile ? '14px' : '20px 22px',
      boxShadow: '0 1px 8px rgba(0,0,0,0.06)',
      border: `1px solid ${T.border}`, boxSizing: 'border-box',
    }}>
      <div style={{ display:'flex', alignItems:'center', justifyContent:'space-between', marginBottom:10 }}>
        <div style={{
          width: isMobile?32:38, height: isMobile?32:38, borderRadius:10,
          background:`${color}18`, display:'flex', alignItems:'center', justifyContent:'center',
        }}>
          {icon}
        </div>
        {trendVal !== undefined && (
          <div style={{
            display:'flex', alignItems:'center', gap:3,
            fontSize:10, fontWeight:600,
            color: trend==='up' ? T.danger : T.success,
            background: trend==='up' ? '#FEF2F2' : '#F0FDF4',
            padding:'3px 7px', borderRadius:20,
          }}>
            {trend==='up' ? <IconTrendUp size={11} color={T.danger}/> : <IconTrendDown size={11} color={T.success}/>}
            {trendVal}%
          </div>
        )}
      </div>
      <div style={{ fontSize:isMobile?20:26, fontWeight:700, color:T.text, lineHeight:1, letterSpacing:-0.5 }}>
        {value}
        <span style={{ fontSize:11, color:T.textSoft, marginLeft:4, fontWeight:400 }}>{unit}</span>
      </div>
      <div style={{ fontSize:isMobile?11:12, color:T.textSoft, marginTop:4 }}>{label}</div>
      <div style={{ marginTop:10, height:3, borderRadius:2, background:T.border, overflow:'hidden' }}>
        <div style={{ height:'100%', width:`${progress||65}%`, background:color, borderRadius:2 }}/>
      </div>
    </div>
  );
}

// ── STATUT CHAÎNE ─────────────────────────────────────────
function StatutChaine({ nom, statut, prod, objectif, T }) {
  const color = statut==='normal' ? T.success : statut==='warning' ? T.warning : statut==='inactif' ? T.textMuted : T.danger;
  const label = statut==='normal' ? 'Normal' : statut==='warning' ? 'Attention' : statut==='inactif' ? 'Inactif' : 'Critique';
  const pct   = objectif && prod ? Math.min(100, Math.round(prod/objectif*100)) : null;
  return (
    <div style={{ display:'flex', alignItems:'center', justifyContent:'space-between', padding:'9px 0', borderBottom:`1px solid ${T.border}` }}>
      <div style={{ display:'flex', alignItems:'center', gap:8 }}>
        <IconDot size={10} color={color}/>
        <span style={{ fontSize:12, color:T.text, fontWeight:500 }}>{nom}</span>
      </div>
      <div style={{ display:'flex', alignItems:'center', gap:8 }}>
        {pct !== null && <span style={{ fontSize:10, color:T.textSoft }}>{prod} hl ({pct}%)</span>}
        <span style={{ fontSize:10, color, background:`${color}18`, padding:'2px 8px', borderRadius:20, fontWeight:600 }}>{label}</span>
      </div>
    </div>
  );
}

// ── ALERTE ITEM ───────────────────────────────────────────
function AlerteItem({ alerte, T }) {
  const color = alerte.niveau==='critique' ? T.danger : T.warning;
  return (
    <div style={{ display:'flex', alignItems:'flex-start', gap:12, padding:'12px 0', borderBottom:`1px solid ${T.border}` }}>
      <div style={{ width:34, height:34, borderRadius:9, background:`${color}18`, display:'flex', alignItems:'center', justifyContent:'center', flexShrink:0 }}>
        <IconWarning size={17} color={color}/>
      </div>
      <div style={{ flex:1, minWidth:0 }}>
        <div style={{ fontSize:13, fontWeight:600, color:T.text, whiteSpace:'nowrap', overflow:'hidden', textOverflow:'ellipsis' }}>{alerte.atelier}</div>
        <div style={{ fontSize:11, color:T.textSoft, marginTop:2, whiteSpace:'nowrap', overflow:'hidden', textOverflow:'ellipsis' }}>{alerte.message}</div>
      </div>
      <div style={{ fontSize:10, color:T.textMuted, flexShrink:0, marginTop:2 }}>
        {new Date(alerte.created_at).toLocaleTimeString('fr-FR',{hour:'2-digit',minute:'2-digit'})}
      </div>
    </div>
  );
}

function CustomTooltip({ active, payload, label, T }) {
  if (!active || !payload?.length) return null;
  return (
    <div style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:10, padding:'10px 14px', fontSize:12 }}>
      <div style={{ fontWeight:600, color:T.text, marginBottom:6 }}>{label}</div>
      {payload.map((p,i) => <div key={i} style={{ color:p.color, marginBottom:2 }}>{p.name} : <strong>{p.value}</strong></div>)}
    </div>
  );
}

function ChartCard({ title, subtitle, icon, iconColor, badge, children, T }) {
  return (
    <div style={{ background:T.card, borderRadius:14, padding:'20px', boxShadow:'0 1px 8px rgba(0,0,0,0.06)', border:`1px solid ${T.border}`, boxSizing:'border-box', width:'100%' }}>
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'flex-start', marginBottom:16, flexWrap:'wrap', gap:8 }}>
        <div>
          <div style={{ display:'flex', alignItems:'center', gap:8, marginBottom:4 }}>
            <div style={{ width:28, height:28, borderRadius:8, background:`${iconColor}18`, display:'flex', alignItems:'center', justifyContent:'center' }}>{icon}</div>
            <h3 style={{ margin:0, fontSize:13, fontWeight:700, color:T.text }}>{title}</h3>
          </div>
          <p style={{ margin:0, fontSize:11, color:T.textSoft }}>{subtitle}</p>
        </div>
        <span style={{ fontSize:10, color:T.textSoft, background:T.bg, padding:'4px 10px', borderRadius:8, border:`1px solid ${T.border}`, fontWeight:600, whiteSpace:'nowrap' }}>{badge}</span>
      </div>
      {children}
    </div>
  );
}

// ── DASHBOARD PRINCIPAL ───────────────────────────────────
export default function Dashboard() {
  const { user }  = useAuth();
  const { T }     = useTheme();
  const isMobile  = useIsMobile();
  const navigate = useNavigate();

  const [alertes,      setAlertes]      = useState([]);
  const [nbAlertes,    setNbAlertes]    = useState(0);
  const [relevesC8,    setRelevesC8]    = useState([]);
  const [scoresSante, setScoresSante] = useState({});
  const [relevesJm1,   setRelevesJm1]   = useState([]);  // tous ateliers J-1
  const [loading,      setLoading]      = useState(true);
  const [activeBar,    setActiveBar]    = useState(null);

  const jm1 = getJMoins1();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [alertesRes, countRes, relevesC8Res, relevesJm1Res, scoresRes] = await Promise.all([
          alertesAPI.lister({ lu: false }),
          alertesAPI.compter(),
          energieAPI.lister({ atelier: 'Chaîne 8' }),
          energieAPI.lister({ date_debut: jm1, date_fin: jm1, limit: 500 }),
          maintenanceAPI.getScoresSante().catch(() => ({ data: {} })),
        ]);
        setAlertes(alertesRes.data.slice(0, 6));
        setNbAlertes(countRes.data.total || 0);
        setRelevesC8(relevesC8Res.data);
        setRelevesJm1(relevesJm1Res.data);
        setScoresSante(scoresRes.data || {});
      } catch(e) {
        console.error(e);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  // ── CALCULS J-1 ─────────────────────────────────────────

  // Production totale J-1 (somme de tous les relevés de la veille)
  const productionJm1 = relevesJm1.reduce((s, r) => s + (parseFloat(r.production_hl) || 0), 0);
  const pctObjectif   = Math.round(productionJm1 / OBJECTIF_TOTAL * 100);

  // Relevés attendus J-1 : 5 chaînes × 3 quarts = 15
  const RELEVES_ATTENDUS = 15;
  const nbRelevesJm1     = relevesJm1.length;
  const pctSaisie        = Math.round(nbRelevesJm1 / RELEVES_ATTENDUS * 100);

  // Production par chaîne J-1
  const prodParChaine = {};
  ATELIERS.forEach(a => { prodParChaine[a] = 0; });
  relevesJm1.forEach(r => {
    if(prodParChaine[r.atelier] !== undefined)
      prodParChaine[r.atelier] += parseFloat(r.production_hl) || 0;
  });

  // Chaînes actives = ayant au moins 1 relevé J-1
  const chainesActives = ATELIERS.filter(a => prodParChaine[a] > 0).length;

  // Statut chaîne : basé sur production vs objectif
  function statutChaine(atelier) {
    const prod = prodParChaine[atelier];
    const obj  = OBJECTIFS[atelier];
    if(prod === 0) return 'inactif';
    const pct = prod / obj;
    if(pct >= 0.9)  return 'normal';
    if(pct >= 0.7)  return 'warning';
    return 'danger';
  }

  // ── GRAPHIQUES Chaîne 8 ──────────────────────────────────
  const ordreQuart = { '6h-14h':1, '14h-22h':2, '22h-6h':3 };
  const relevesTries = [...relevesC8].sort((a,b) => {
    const dd = new Date(a.date)-new Date(b.date);
    return dd!==0 ? dd : (ordreQuart[a.quart]||0)-(ordreQuart[b.quart]||0);
  });

  // Regroupement par jour pour les graphiques
  const parJourC8 = {};
  for(let i=1; i<relevesTries.length; i++){
    const c=relevesTries[i], p=relevesTries[i-1];
    let jourCle = c.date;
    if(c.quart==='22h-6h'){
      const d=new Date(c.date); d.setDate(d.getDate()-1);
      jourCle=d.toISOString().split('T')[0];
    }
    if(!parJourC8[jourCle]) parJourC8[jourCle]={eau:0, elec:0};
    const eau  = (parseFloat(c.index_eau_rincage)-parseFloat(p.index_eau_rincage))
               + (parseFloat(c.index_eau_bain)   -parseFloat(p.index_eau_bain));
    const elec =  parseFloat(c.index_elec)-parseFloat(p.index_elec);
    // Ignorer valeurs négatives
    if(eau  > 0) parJourC8[jourCle].eau  += eau;
    if(elec > 0) parJourC8[jourCle].elec += elec;
  }

  const chartEau = Object.entries(parJourC8)
    .sort(([a],[b])=>new Date(a)-new Date(b))
    .map(([date,v])=>({ name: date.slice(5), 'Eau (m³)': +v.eau.toFixed(1) }));

  const chartElec = Object.entries(parJourC8)
    .sort(([a],[b])=>new Date(a)-new Date(b))
    .map(([date,v])=>({ name: date.slice(5), 'Élec (kWh)': +v.elec.toFixed(1) }));

  const roleLabel = { manager:'Manager', chef_atelier:"Chef d'atelier", contremaitre:'Contremaitre' };

  if(loading) return (
    <div style={{ display:'flex', alignItems:'center', justifyContent:'center', height:'80vh', flexDirection:'column', gap:12 }}>
      <div style={{ width:36, height:36, border:`3px solid ${T.border}`, borderTop:`3px solid ${T.primary}`, borderRadius:'50%', animation:'spin 0.8s linear infinite' }}/>
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
      <span style={{ fontSize:13, color:T.textSoft }}>Chargement...</span>
    </div>
  );

  return (
    <div style={{ padding:isMobile?'16px 14px 90px':'24px 28px', background:T.bg, minHeight:'100vh', transition:'background 0.3s', overflowX:'hidden', maxWidth:'100vw', boxSizing:'border-box' }}>

      {/* SALUTATION */}
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:isMobile?'flex-start':'center', marginBottom:20, flexWrap:'wrap', gap:10 }}>
        <div>
          <h1 style={{ fontSize:isMobile?18:22, fontWeight:700, color:T.text, margin:0, letterSpacing:-0.3 }}>
            Bonjour, {user?.username}
          </h1>
          <p style={{ fontSize:12, color:T.textSoft, margin:'3px 0 0' }}>
            {roleLabel[user?.role]} — Vue d'ensemble · J-1 : {jm1}
          </p>
        </div>
        <div style={{
          display:'flex', alignItems:'center', gap:8, padding:'8px 14px', borderRadius:12,
          background: nbAlertes>0?'#FEF2F2':'#F0FDF4',
          border:`1px solid ${nbAlertes>0?'#FECACA':'#BBF7D0'}`,
        }}>
          {nbAlertes>0 ? <IconBell size={16} color={T.danger}/> : <IconCheck size={16} color={T.success}/>}
          <span style={{ fontSize:12, fontWeight:600, color:nbAlertes>0?T.danger:T.success }}>
            {nbAlertes>0 ? `${nbAlertes} alerte${nbAlertes>1?'s':''} active${nbAlertes>1?'s':''}` : 'Système nominal'}
          </span>
        </div>
      </div>

      {/* KPI CARDS */}
      <div style={{ display:'grid', gridTemplateColumns:isMobile?'1fr 1fr':'repeat(4, 1fr)', gap:isMobile?10:16, marginBottom:20 }}>

        {/* 1 — Production J-1 */}
        <KpiCard
          icon={<IconBottle size={isMobile?17:20} color={T.primary}/>}
          label={`Production J-1 (objectif ${OBJECTIF_TOTAL.toLocaleString()} hl)`}
          value={productionJm1 > 0 ? productionJm1.toLocaleString() : '—'}
          unit="hl"
          color={T.primary}
          progress={pctObjectif}
          trend={pctObjectif >= 90 ? 'down' : 'up'}
          trendVal={pctObjectif}
          T={T} isMobile={isMobile}
        />

        {/* SANTÉ DES CHAÎNES IA */}
        {Object.keys(scoresSante).length > 0 && (
          <div style={{
            background: T.card, borderRadius: 14, padding: '20px',
            boxShadow: '0 1px 8px rgba(0,0,0,0.06)',
            border: `1px solid ${T.border}`, marginBottom: 20,
          }}>
            <div style={{ display:'flex', justifyContent:'space-between',
              alignItems:'center', marginBottom:16 }}>
              <div style={{ display:'flex', alignItems:'center', gap:8 }}>
                <div style={{ width:26, height:26, borderRadius:7,
                  background:`${T.primary}18`,
                  display:'flex', alignItems:'center', justifyContent:'center' }}>
                  <IconBrain size={14} color={T.primary}/>
                </div>
                <h3 style={{ margin:0, fontSize:13, fontWeight:700, color:T.text }}>
                  Santé des chaînes · IA
                </h3>
              </div>
              <span onClick={() => navigate('/maintenance')}
                style={{ fontSize:12, color:T.primary, cursor:'pointer', fontWeight:600 }}>
                Détails →
              </span>
            </div>

            <div style={{
              display: 'grid',
              gridTemplateColumns: isMobile ? '1fr 1fr' : 'repeat(4, 1fr)',
              gap: 12,
            }}>
              {['Chaîne 8','Chaîne 14','Chaîne 15','Chaîne 16'].map(a => {
                const s = scoresSante[a];
                const score  = s?.score ?? null;
                const niveau = s?.niveau ?? 'inconnu';
                const color  = niveau === 'vert'   ? '#22C55E'
                             : niveau === 'orange' ? '#F59E0B'
                             : niveau === 'rouge'  ? '#EF4444'
                             : T.textSoft;
                const r = 28, circum = 2 * Math.PI * r;
                const offset = score != null ? circum - (score/100)*circum : circum;

                return (
                  <div key={a} style={{
                    background: T.bg, borderRadius: 10,
                    padding: '12px', textAlign: 'center',
                    border: `1px solid ${T.border}`,
                  }}>
                    <svg width="70" height="70" viewBox="0 0 70 70">
                      <circle cx="35" cy="35" r={r} fill="none"
                        stroke={T.border} strokeWidth="6"/>
                      <circle cx="35" cy="35" r={r} fill="none"
                        stroke={color} strokeWidth="6"
                        strokeDasharray={circum}
                        strokeDashoffset={offset}
                        strokeLinecap="round"
                        transform="rotate(-90 35 35)"
                        style={{ transition:'stroke-dashoffset 1s ease' }}
                      />
                      <text x="35" y="35" textAnchor="middle"
                        dominantBaseline="middle"
                        fill={score != null ? T.text : T.textSoft}
                        fontSize="14" fontWeight="700" fontFamily="Arial">
                        {score != null ? Math.round(score) : '—'}
                      </text>
                    </svg>
                    <div style={{ fontSize:11, color:T.text, fontWeight:600, marginTop:4 }}>
                      {a.replace('Chaîne ','Ch.')}
                    </div>
                    <div style={{
                      fontSize:9, fontWeight:700, color,
                      background:`${color}18`,
                      padding:'1px 8px', borderRadius:20, marginTop:3,
                      display:'inline-block',
                    }}>
                      {niveau === 'vert' ? 'Bon' : niveau === 'orange' ? 'Attention' : niveau === 'rouge' ? 'Critique' : '—'}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* 2 — Alertes */}
        <KpiCard
          icon={<IconBell size={isMobile?17:20} color={nbAlertes>0?T.danger:T.success}/>}
          label="Alertes actives"
          value={nbAlertes} unit=""
          color={nbAlertes>0?T.danger:T.success}
          progress={nbAlertes>0?Math.min(100,nbAlertes*10):5}
          T={T} isMobile={isMobile}
        />

        {/* 3 — Taux de saisie J-1 */}
        <KpiCard
          icon={<IconClipboard size={isMobile?17:20} color={T.gold}/>}
          label={`Taux de saisie J-1 (${nbRelevesJm1}/${RELEVES_ATTENDUS} relevés)`}
          value={`${pctSaisie}`} unit="%"
          color={pctSaisie>=80?T.success:pctSaisie>=50?T.warning:T.danger}
          progress={pctSaisie}
          T={T} isMobile={isMobile}
        />

        {/* 4 — Chaînes actives */}
        <KpiCard
          icon={<IconFactory size={isMobile?17:20} color={T.success}/>}
          label="Chaînes actives J-1"
          value={chainesActives} unit={`/ ${ATELIERS.length}`}
          color={T.success}
          progress={chainesActives/ATELIERS.length*100}
          T={T} isMobile={isMobile}
        />
      </div>

      {/* GRAPHIQUES */}
      <div style={{ display:'grid', gridTemplateColumns:isMobile?'1fr':'1fr 1fr 300px', gap:isMobile?14:20, marginBottom:20 }}>

        {/* Graphique eau */}
        <ChartCard
          title="Consommation eau" subtitle="Chaîne 8 — bain + rinçage (m³/jour)"
          icon={<IconWater size={15} color={T.primary}/>} iconColor={T.primary}
          badge="14 derniers jours" T={T}
        >
          {chartEau.length > 0 ? (
            <ResponsiveContainer width="100%" height={210}>
              <BarChart data={chartEau.slice(-14)} barSize={isMobile?14:18} barCategoryGap="25%">
                <CartesianGrid strokeDasharray="3 3" stroke={T.border} vertical={false}/>
                <XAxis dataKey="name" tick={{fontSize:10,fill:T.textSoft}} axisLine={false} tickLine={false}/>
                <YAxis tick={{fontSize:10,fill:T.textSoft}} axisLine={false} tickLine={false}/>
                <Tooltip content={(props)=><CustomTooltip {...props} T={T}/>} cursor={{fill:`${T.border}60`}}/>
                <Bar dataKey="Eau (m³)" radius={[6,6,0,0]} onMouseEnter={(_,idx)=>setActiveBar(idx)}>
                  {chartEau.map((_,idx)=>(
                    <Cell key={idx} fill={activeBar===idx?T.primaryDark:T.primary} fillOpacity={activeBar!==null&&activeBar!==idx?0.5:1}/>
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          ) : (
            <div style={{height:180,display:'flex',alignItems:'center',justifyContent:'center',color:T.textSoft,fontSize:13}}>Pas encore de données</div>
          )}
        </ChartCard>

        {/* Graphique électricité */}
        <ChartCard
          title="Consommation électrique" subtitle="Chaîne 8 — kWh par jour"
          icon={<IconBolt size={15} color={T.gold}/>} iconColor={T.gold}
          badge="14 derniers jours" T={T}
        >
          {chartElec.length > 0 ? (
            <ResponsiveContainer width="100%" height={210}>
              <BarChart data={chartElec.slice(-14)} barSize={isMobile?14:18} barCategoryGap="25%">
                <CartesianGrid strokeDasharray="3 3" stroke={T.border} vertical={false}/>
                <XAxis dataKey="name" tick={{fontSize:10,fill:T.textSoft}} axisLine={false} tickLine={false}/>
                <YAxis tick={{fontSize:10,fill:T.textSoft}} axisLine={false} tickLine={false}/>
                <Tooltip content={(props)=><CustomTooltip {...props} T={T}/>} cursor={{fill:`${T.border}60`}}/>
                <Bar dataKey="Élec (kWh)" fill={T.gold} radius={[6,6,0,0]}>
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          ) : (
            <div style={{height:180,display:'flex',alignItems:'center',justifyContent:'center',color:T.textSoft,fontSize:13}}>Pas encore de données</div>
          )}
        </ChartCard>

        {/* Colonne droite */}
        <div style={{ display:'flex', flexDirection:'column', gap:14 }}>

          {/* Statut chaînes */}
          <div style={{ background:T.card, borderRadius:14, padding:'18px', boxShadow:'0 1px 8px rgba(0,0,0,0.06)', border:`1px solid ${T.border}` }}>
            <div style={{ display:'flex', alignItems:'center', gap:8, marginBottom:12 }}>
              <div style={{ width:26, height:26, borderRadius:7, background:`${T.success}18`, display:'flex', alignItems:'center', justifyContent:'center' }}>
                <IconFactory size={14} color={T.success}/>
              </div>
              <h3 style={{ margin:0, fontSize:13, fontWeight:700, color:T.text }}>Statut des chaînes · J-1</h3>
            </div>
            {ATELIERS.map((a,i) => (
              <StatutChaine
                key={i} nom={a}
                statut={statutChaine(a)}
                prod={Math.round(prodParChaine[a])}
                objectif={OBJECTIFS[a]}
                T={T}
              />
            ))}
          </div>

          {/* Production J-1 détail */}
          <div style={{ background:T.card, borderRadius:14, padding:'18px', boxShadow:'0 1px 8px rgba(0,0,0,0.06)', border:`1px solid ${T.border}` }}>
            <div style={{ fontSize:10, color:T.textSoft, fontWeight:700, textTransform:'uppercase', letterSpacing:1, marginBottom:8 }}>
              Production J-1 totale
            </div>
            <div style={{ fontSize:28, fontWeight:700, color:T.primary, lineHeight:1, letterSpacing:-1 }}>
              {productionJm1 > 0 ? productionJm1.toLocaleString() : '—'}
              <span style={{ fontSize:13, color:T.textSoft, marginLeft:5, fontWeight:400 }}>hl</span>
            </div>
            <div style={{ fontSize:11, color:T.textSoft, marginTop:4, marginBottom:10 }}>
              Objectif : {OBJECTIF_TOTAL.toLocaleString()} hl / jour
            </div>
            <div style={{ height:8, background:T.border, borderRadius:4, overflow:'hidden' }}>
              <div style={{ height:'100%', width:`${Math.min(100,pctObjectif)}%`, background:`linear-gradient(90deg, ${T.primary}, ${T.gold})`, borderRadius:4 }}/>
            </div>
            <div style={{ display:'flex', justifyContent:'space-between', marginTop:6 }}>
              <span style={{ fontSize:10, color:T.textSoft }}>{pctObjectif}% de l'objectif</span>
              <span style={{ fontSize:10, color:T.primary, fontWeight:600 }}>
                {productionJm1 > 0 ? `+${(OBJECTIF_TOTAL-productionJm1).toLocaleString()} hl restants` : 'Aucun relevé'}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* ALERTES */}
      <div style={{ background:T.card, borderRadius:14, padding:'20px', boxShadow:'0 1px 8px rgba(0,0,0,0.06)', border:`1px solid ${T.border}` }}>
        <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:14 }}>
          <div style={{ display:'flex', alignItems:'center', gap:8 }}>
            <div style={{ width:26, height:26, borderRadius:7, background:`${T.danger}18`, display:'flex', alignItems:'center', justifyContent:'center' }}>
              <IconBell size={14} color={T.danger}/>
            </div>
            <h3 style={{ margin:0, fontSize:13, fontWeight:700, color:T.text }}>Dernières alertes</h3>
          </div>
          <span 
            onClick={() => navigate('/alertes')}
            style={{ fontSize:12, color:T.primary, cursor:'pointer', fontWeight:600 }}
          >Voir tout →</span>
        </div>
        {alertes.length > 0 ? (
          <div style={{ display:'grid', gridTemplateColumns:isMobile?'1fr':'repeat(auto-fill, minmax(300px, 1fr))', gap:'0 32px' }}>
            {alertes.map((a,i) => <AlerteItem key={i} alerte={a} T={T}/>)}
          </div>
        ) : (
          <div style={{ textAlign:'center', padding:'24px 0', color:T.textSoft, fontSize:13, display:'flex', alignItems:'center', justifyContent:'center', gap:8 }}>
            <IconCheck size={18} color={T.success}/> Aucune alerte active — système nominal
          </div>
        )}
      </div>
    </div>
  );
}