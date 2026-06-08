import { useState, useEffect } from 'react';
import { useTheme } from '../../components/layout/Layout';
import { qualiteAPI } from '../../services/api';
import BoutonRetour from '../../components/BoutonRetour';
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, ReferenceLine, Legend
} from 'recharts';

function useIsMobile() {
  const [isMobile, setIsMobile] = useState(() => window.innerWidth < 768);
  return isMobile;
}

const ATELIERS = ['Chaîne 8', 'Chaîne 14', 'Chaîne 15', 'Chaîne 16'];

// ── LIMITES DE CONTRÔLE SPC ───────────────────────────────
const LIMITES = {
  brix: {
    label: 'Brix (°Bx)', unite: '°Bx',
    cible: 11.0, ls: 11.5, li: 10.5,
    couleur: '#3B82F6', domaine: [10.0, 12.0],
  },
  co2_qualite: {
    label: 'CO₂ Qualité', unite: 'g/L',
    cible: 5.5, ls: 6.0, li: 5.0,
    couleur: '#10B981', domaine: [4.0, 7.0],
  },
  bo2: {
    label: 'BO₂ (O₂ dissous)', unite: 'mg/L',
    cible: 0.05, ls: 0.10, li: 0.0,
    couleur: '#F59E0B', domaine: [0, 0.15],
  },
  pct_sertissage: {
    label: '% Sertissage hors tolérance', unite: '%',
    cible: 0, ls: 10, li: null,
    couleur: '#EF4444', domaine: [0, 20],
  },
};

// ── TOOLTIP PERSONNALISÉ ──────────────────────────────────
function CustomTooltip({ active, payload, label, T, parametre }) {
  if (!active || !payload?.length) return null;
  const limite = LIMITES[parametre];
  const val = payload[0]?.value;
  const hors = limite.ls && val > limite.ls || limite.li && val < limite.li;
  return (
    <div style={{ background:T.card, border:`1px solid ${T.border}`,
      borderRadius:10, padding:'10px 14px', fontSize:12 }}>
      <div style={{ fontWeight:600, color:T.text, marginBottom:6 }}>{label}</div>
      <div style={{ color: hors ? '#EF4444' : '#10B981', fontWeight:700 }}>
        {val?.toFixed(3)} {limite.unite}
        {hors ? ' ⚠ Hors limite' : ' ✓ Conforme'}
      </div>
      <div style={{ fontSize:10, color:T.textSoft, marginTop:4 }}>
        {limite.li != null && `LI: ${limite.li} | `}
        Cible: {limite.cible} | LS: {limite.ls}
      </div>
    </div>
  );
}

// ── CARTE SPC ─────────────────────────────────────────────
function CarteSPC({ parametre, data, T, isMobile }) {
  const limite = LIMITES[parametre];
  const nbHors = data.filter(d => {
    const v = d[parametre];
    if (v == null) return false;
    if (limite.ls && v > limite.ls) return true;
    if (limite.li != null && v < limite.li) return true;
    return false;
  }).length;
  const pctConf = data.length > 0
    ? Math.round((1 - nbHors / data.length) * 100) : 100;

  return (
    <div style={{ background:T.card, borderRadius:14, padding:'18px',
      boxShadow:'0 1px 8px rgba(0,0,0,0.06)',
      border:`1px solid ${T.border}`, marginBottom:16 }}>

      {/* Header */}
      <div style={{ display:'flex', justifyContent:'space-between',
        alignItems:'flex-start', marginBottom:12, flexWrap:'wrap', gap:8 }}>
        <div>
          <div style={{ display:'flex', alignItems:'center', gap:8, marginBottom:4 }}>
            <div style={{ width:10, height:10, borderRadius:'50%',
              background:limite.couleur }}/>
            <h3 style={{ margin:0, fontSize:13, fontWeight:700, color:T.text }}>
              {limite.label}
            </h3>
          </div>
          <div style={{ display:'flex', gap:12, fontSize:10, color:T.textSoft }}>
            {limite.li != null && <span>LI: <strong>{limite.li} {limite.unite}</strong></span>}
            <span style={{ color:'#10B981' }}>Cible: <strong>{limite.cible} {limite.unite}</strong></span>
            <span style={{ color:'#EF4444' }}>LS: <strong>{limite.ls} {limite.unite}</strong></span>
          </div>
        </div>
        <div style={{ textAlign:'right' }}>
          <div style={{ fontSize:20, fontWeight:700,
            color: pctConf >= 95 ? '#10B981' : pctConf >= 80 ? '#F59E0B' : '#EF4444' }}>
            {pctConf}%
          </div>
          <div style={{ fontSize:10, color:T.textSoft }}>conformité</div>
          {nbHors > 0 && (
            <div style={{ fontSize:10, color:'#EF4444', fontWeight:600 }}>
              {nbHors} hors limite{nbHors > 1 ? 's' : ''}
            </div>
          )}
        </div>
      </div>

      {/* Graphique SPC */}
      {data.length > 0 ? (
        <ResponsiveContainer width="100%" height={isMobile ? 160 : 200}>
          <LineChart data={data} margin={{ top:5, right:20, left:0, bottom:5 }}>
            <CartesianGrid strokeDasharray="3 3" stroke={T.border} vertical={false}/>
            <XAxis dataKey="date" tick={{ fontSize:9, fill:T.textSoft }}
              axisLine={false} tickLine={false}
              tickFormatter={d => d?.slice(5) || d}/>
            <YAxis domain={limite.domaine} tick={{ fontSize:9, fill:T.textSoft }}
              axisLine={false} tickLine={false}
              tickFormatter={v => v.toFixed(2)}/>
            <Tooltip content={p => <CustomTooltip {...p} T={T} parametre={parametre}/>}/>

            {/* Ligne LS (rouge) */}
            <ReferenceLine y={limite.ls} stroke="#EF4444" strokeWidth={1.5}
              strokeDasharray="4 2"
              label={{ value:`LS:${limite.ls}`, fontSize:9, fill:'#EF4444', position:'right' }}/>

            {/* Ligne Cible (verte) */}
            <ReferenceLine y={limite.cible} stroke="#10B981" strokeWidth={1.5}
              strokeDasharray="0"
              label={{ value:`C:${limite.cible}`, fontSize:9, fill:'#10B981', position:'right' }}/>

            {/* Ligne LI (rouge) si applicable */}
            {limite.li != null && (
              <ReferenceLine y={limite.li} stroke="#EF4444" strokeWidth={1.5}
                strokeDasharray="4 2"
                label={{ value:`LI:${limite.li}`, fontSize:9, fill:'#EF4444', position:'right' }}/>
            )}

            {/* Données mesurées */}
            <Line type="monotone" dataKey={parametre}
              stroke={limite.couleur} strokeWidth={2}
              dot={(props) => {
                const val = props.payload[parametre];
                const hors = (limite.ls && val > limite.ls) ||
                             (limite.li != null && val < limite.li);
                return <circle key={props.key} cx={props.cx} cy={props.cy} r={hors?5:3}
                  fill={hors?'#EF4444':limite.couleur}
                  stroke={hors?'#EF4444':limite.couleur}/>;
              }}
              activeDot={{ r:5 }}
              connectNulls={false}
            />
          </LineChart>
        </ResponsiveContainer>
      ) : (
        <div style={{ height:160, display:'flex', alignItems:'center',
          justifyContent:'center', color:T.textSoft, fontSize:13 }}>
          Pas de données — saisir des relevés dans Data
        </div>
      )}
    </div>
  );
}

// ══════════════════════════════════════════════════════════
// PAGE AFFICHAGE SPC
// ══════════════════════════════════════════════════════════
export default function AffichageQualite() {
  const { T }    = useTheme();
  const isMobile = useIsMobile();

  const [atelier,  setAtelier]  = useState('Chaîne 15');
  const [nbJours,  setNbJours]  = useState(30);
  const [donnees,  setDonnees]  = useState([]);
  const [loading,  setLoading]  = useState(false);

  useEffect(() => { charger(); }, [atelier, nbJours]);

  const charger = async () => {
    setLoading(true);
    try {
      const fin    = new Date();
      const debut  = new Date();
      debut.setDate(debut.getDate() - nbJours);
      const fmt = d => d.toISOString().split('T')[0];

      const res = await qualiteAPI.lister({
        atelier,
        date_debut: fmt(debut),
        date_fin:   fmt(fin),
        limit: 500,
      });

      // Agrégation par date (moyenne des quarts)
      const parDate = {};
      (res.data || []).forEach(r => {
        if (!parDate[r.date]) parDate[r.date] = { brix:[], co2:[], bo2:[], sert:[] };
        if (r.brix)        parDate[r.date].brix.push(r.brix);
        if (r.co2_qualite) parDate[r.date].co2.push(r.co2_qualite);
        if (r.bo2)         parDate[r.date].bo2.push(r.bo2);
        if (r.sertissage_data) {
          try {
            const cases = JSON.parse(r.sertissage_data);
            const hors  = cases.filter(v => v < 1.10 || v > 1.15).length;
            parDate[r.date].sert.push(hors / cases.length * 100);
          } catch {}
        }
      });

      const avg = arr => arr.length ? arr.reduce((a,b)=>a+b,0)/arr.length : null;

      const rows = Object.entries(parDate)
        .sort(([a],[b]) => a.localeCompare(b))
        .map(([date, v]) => ({
          date,
          brix:          avg(v.brix)  != null ? +avg(v.brix).toFixed(3)  : null,
          co2_qualite:   avg(v.co2)   != null ? +avg(v.co2).toFixed(3)   : null,
          bo2:           avg(v.bo2)   != null ? +avg(v.bo2).toFixed(4)   : null,
          pct_sertissage:avg(v.sert)  != null ? +avg(v.sert).toFixed(2)  : null,
        }));

      setDonnees(rows);
    } catch(e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  // Stats globales
  const stats = Object.keys(LIMITES).map(p => {
    const vals = donnees.map(d => d[p]).filter(v => v != null);
    if (!vals.length) return null;
    const l = LIMITES[p];
    const hors = vals.filter(v => (l.ls && v > l.ls) || (l.li != null && v < l.li)).length;
    return {
      label: l.label, unite: l.unite,
      moy: (vals.reduce((a,b)=>a+b,0)/vals.length).toFixed(3),
      min: Math.min(...vals).toFixed(3),
      max: Math.max(...vals).toFixed(3),
      conf: Math.round((1 - hors/vals.length)*100),
      couleur: l.couleur,
    };
  }).filter(Boolean);

  return (
    <div style={{ padding:isMobile?'16px 14px 100px':'24px 28px',
      background:T.bg, minHeight:'100vh', boxSizing:'border-box' }}>

      {/* En-tête */}
        <BoutonRetour vers="/qualite" titre="Affichage — Cartes de Contrôle SPC" />
        <p style={{ fontSize:11, color:T.textSoft, margin:'-12px 0 16px' }}>
          Statistical Process Control · Évolution des paramètres qualité
        </p>

        {/* Filtres */}
        <div style={{ display:'flex', gap:8, flexWrap:'wrap', marginBottom:20 }}>
          <select value={atelier} onChange={e=>setAtelier(e.target.value)}
            style={{ padding:'8px 12px', borderRadius:8,
              border:`1px solid ${T.border}`, background:T.card,
              color:T.text, fontSize:12, cursor:'pointer' }}>
            {ATELIERS.map(a=><option key={a} value={a}>{a}</option>)}
          </select>
          <select value={nbJours} onChange={e=>setNbJours(+e.target.value)}
            style={{ padding:'8px 12px', borderRadius:8,
              border:`1px solid ${T.border}`, background:T.card,
              color:T.text, fontSize:12, cursor:'pointer' }}>
            {[7,14,30,60,90].map(n=><option key={n} value={n}>{n} jours</option>)}
          </select>
        </div>

      {/* Bandeau info SPC */}
      <div style={{ background:'#EFF6FF', border:'1px solid #BFDBFE',
        borderRadius:10, padding:'10px 16px', marginBottom:20,
        fontSize:11, color:'#1E40AF', display:'flex', gap:16,
        alignItems:'center', flexWrap:'wrap' }}>
        <span><strong>SPC (Statistical Process Control)</strong> — Les points rouges indiquent des mesures hors limites de contrôle.</span>
        <span>— <strong style={{color:'#EF4444'}}>LS</strong> = Limite Supérieure</span>
        <span>— <strong style={{color:'#10B981'}}>C</strong> = Cible</span>
        <span>— <strong style={{color:'#EF4444'}}>LI</strong> = Limite Inférieure</span>
      </div>

      {loading && (
        <div style={{ textAlign:'center', padding:'40px 0',
          color:T.textSoft, fontSize:13 }}>
          Chargement...
        </div>
      )}

      {/* Résumé stats */}
      {!loading && stats.length > 0 && (
        <div style={{ display:'grid',
          gridTemplateColumns:isMobile?'1fr 1fr':'repeat(4,1fr)',
          gap:10, marginBottom:20 }}>
          {stats.map((s,i) => (
            <div key={i} style={{ background:T.card, borderRadius:12,
              padding:'12px 14px', border:`1px solid ${T.border}` }}>
              <div style={{ display:'flex', alignItems:'center', gap:6, marginBottom:6 }}>
                <div style={{ width:8, height:8, borderRadius:'50%', background:s.couleur }}/>
                <span style={{ fontSize:10, color:T.textSoft, fontWeight:600 }}>{s.label}</span>
              </div>
              <div style={{ fontSize:18, fontWeight:700,
                color:s.conf>=95?'#10B981':s.conf>=80?'#F59E0B':'#EF4444' }}>
                {s.conf}%
              </div>
              <div style={{ fontSize:9, color:T.textSoft }}>conformité</div>
              <div style={{ fontSize:10, color:T.textSoft, marginTop:4 }}>
                Moy: {s.moy} {s.unite}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Cartes SPC */}
      {!loading && (
        <>
          <CarteSPC parametre="brix"           data={donnees} T={T} isMobile={isMobile}/>
          <CarteSPC parametre="co2_qualite"     data={donnees} T={T} isMobile={isMobile}/>
          <CarteSPC parametre="bo2"             data={donnees} T={T} isMobile={isMobile}/>
          <CarteSPC parametre="pct_sertissage"  data={donnees} T={T} isMobile={isMobile}/>
        </>
      )}

      {!loading && donnees.length === 0 && (
        <div style={{ textAlign:'center', padding:'60px 0',
          color:T.textSoft, fontSize:14 }}>
          Aucune donnée pour {atelier} sur {nbJours} jours.
          Saisir des relevés dans la section Data.
        </div>
      )}
    </div>
  );
}