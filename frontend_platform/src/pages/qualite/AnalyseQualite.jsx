import { useState, useEffect } from 'react';
import { useTheme } from '../../components/layout/Layout';
import { qualiteAPI } from '../../services/api';
import BoutonRetour from '../../components/BoutonRetour';
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, Cell, ReferenceLine
} from 'recharts';

function useIsMobile() {
  return useState(() => window.innerWidth < 768)[0];
}

const ATELIERS = ['Chaîne 8','Chaîne 14','Chaîne 15','Chaîne 16'];

const NORMES = {
  brix:        { min:10.5, max:11.5, cible:11.0, unite:'°Bx',  label:'Brix' },
  co2_qualite: { min:5.0,  max:6.0,  cible:5.5,  unite:'g/L',  label:'CO₂ qualité' },
  bo2:         { min:0.0,  max:0.10, cible:0.05, unite:'mg/L', label:'BO₂' },
};

function CustomTooltip({ active, payload, label, T }) {
  if (!active || !payload?.length) return null;
  return (
    <div style={{ background:T.card, border:`1px solid ${T.border}`,
      borderRadius:10, padding:'10px 14px', fontSize:12 }}>
      <div style={{ fontWeight:600, color:T.text, marginBottom:6 }}>{label}</div>
      {payload.map((p,i) => (
        <div key={i} style={{ color:p.color, marginBottom:2 }}>
          {p.name} : <strong>{typeof p.value==='number'?p.value.toFixed(2):p.value}</strong>
        </div>
      ))}
    </div>
  );
}

export default function AnalyseQualite() {
  const { T }    = useTheme();
  const isMobile = useIsMobile();

  const [atelier,  setAtelier]  = useState('Tous');
  const [nbJours,  setNbJours]  = useState(30);
  const [donnees,  setDonnees]  = useState([]);
  const [loading,  setLoading]  = useState(false);

  useEffect(() => { charger(); }, [atelier, nbJours]);

  const charger = async () => {
    setLoading(true);
    try {
      const fin   = new Date();
      const debut = new Date();
      debut.setDate(debut.getDate() - nbJours);
      const fmt = d => d.toISOString().split('T')[0];

      const params = {
        date_debut: fmt(debut), date_fin: fmt(fin), limit: 500,
      };
      if (atelier !== 'Tous') params.atelier = atelier;

      const res = await qualiteAPI.lister(params);
      setDonnees(res.data || []);
    } catch(e) { console.error(e); }
    finally { setLoading(false); }
  };

  // ── CALCULS STATISTIQUES ─────────────────────────────────
  const stats = Object.entries(NORMES).map(([key, norme]) => {
    const vals = donnees.map(d => d[key]).filter(v => v != null);
    if (!vals.length) return { key, ...norme, vals:[], moy:null, conformes:0, total:0 };
    const moy      = vals.reduce((a,b)=>a+b,0) / vals.length;
    const ecartType= Math.sqrt(vals.reduce((a,b)=>a+(b-moy)**2,0)/vals.length);
    const conformes= vals.filter(v => v >= norme.min && v <= norme.max).length;
    return {
      key, ...norme, vals,
      moy:       +moy.toFixed(3),
      ecartType: +ecartType.toFixed(3),
      conformes,
      total:     vals.length,
      pctConf:   Math.round(conformes/vals.length*100),
      min:       +Math.min(...vals).toFixed(3),
      max:       +Math.max(...vals).toFixed(3),
    };
  });

  // Conformité sertissage
  let sertConf = null;
  const sertData = donnees.filter(d => d.sertissage_data);
  if (sertData.length > 0) {
    let totalCases = 0, horsCases = 0;
    sertData.forEach(d => {
      try {
        const cases = JSON.parse(d.sertissage_data);
        totalCases += cases.length;
        horsCases  += cases.filter(v => v < 1.10 || v > 1.15).length;
      } catch {}
    });
    sertConf = totalCases > 0 ? Math.round((1 - horsCases/totalCases)*100) : 100;
  }

  // Données par atelier pour graphique
  const parAtelier = ATELIERS.map(a => {
    const d = donnees.filter(x => x.atelier === a);
    const brixVals = d.map(x=>x.brix).filter(Boolean);
    const co2Vals  = d.map(x=>x.co2_qualite).filter(Boolean);
    const avg = arr => arr.length ? +(arr.reduce((a,b)=>a+b,0)/arr.length).toFixed(2) : 0;
    const pctBrix = brixVals.length
      ? Math.round(brixVals.filter(v=>v>=10.5&&v<=11.5).length/brixVals.length*100) : 0;
    return {
      atelier: a.replace('Chaîne ','Ch.'),
      'Brix moy': avg(brixVals),
      'CO₂ moy':  avg(co2Vals),
      '% conf Brix': pctBrix,
    };
  });

  // Évolution quotidienne conformité
  const parJour = {};
  donnees.forEach(d => {
    if (!parJour[d.date]) parJour[d.date] = { brix:[], co2:[] };
    if (d.brix)        parJour[d.date].brix.push(d.brix >= 10.5 && d.brix <= 11.5 ? 1 : 0);
    if (d.co2_qualite) parJour[d.date].co2.push(d.co2_qualite >= 5.0 && d.co2_qualite <= 6.0 ? 1 : 0);
  });
  const evolutionConf = Object.entries(parJour)
    .sort(([a],[b])=>a.localeCompare(b))
    .map(([date,v])=>({
      date: date.slice(5),
      'Brix %':  v.brix.length  ? Math.round(v.brix.reduce((a,b)=>a+b,0)/v.brix.length*100)  : null,
      'CO₂ %':   v.co2.length   ? Math.round(v.co2.reduce((a,b)=>a+b,0)/v.co2.length*100)    : null,
    }));

  return (
    <div style={{ padding:isMobile?'16px 14px 100px':'24px 28px',
      background:T.bg, minHeight:'100vh', boxSizing:'border-box' }}>

        {/* En-tête */}
        <BoutonRetour vers="/qualite" titre="Analyse Qualité" />

        {/* Filtres */}
        <div style={{ display:'flex', gap:8, flexWrap:'wrap', marginBottom:20 }}>
          <select value={atelier} onChange={e=>setAtelier(e.target.value)}
            style={{ padding:'8px 12px', borderRadius:8,
              border:`1px solid ${T.border}`, background:T.card,
              color:T.text, fontSize:12, cursor:'pointer' }}>
            <option value="Tous">Toutes chaînes</option>
            {ATELIERS.map(a=><option key={a} value={a}>{a}</option>)}
          </select>
          <select value={nbJours} onChange={e=>setNbJours(+e.target.value)}
            style={{ padding:'8px 12px', borderRadius:8,
              border:`1px solid ${T.border}`, background:T.card,
              color:T.text, fontSize:12, cursor:'pointer' }}>
            {[7,14,30,60,90].map(n=><option key={n} value={n}>{n}j</option>)}
          </select>
        </div>
        <div style={{ display:'flex', gap:8 }}>
          <select value={atelier} onChange={e=>setAtelier(e.target.value)}
            style={{ padding:'8px 12px', borderRadius:8,
              border:`1px solid ${T.border}`, background:T.card,
              color:T.text, fontSize:12, cursor:'pointer' }}>
            <option value="Tous">Toutes chaînes</option>
            {ATELIERS.map(a=><option key={a} value={a}>{a}</option>)}
          </select>
          <select value={nbJours} onChange={e=>setNbJours(+e.target.value)}
            style={{ padding:'8px 12px', borderRadius:8,
              border:`1px solid ${T.border}`, background:T.card,
              color:T.text, fontSize:12, cursor:'pointer' }}>
            {[7,14,30,60,90].map(n=><option key={n} value={n}>{n}j</option>)}
          </select>
        </div>

      {loading && (
        <div style={{ textAlign:'center', padding:'40px 0',
          color:T.textSoft }}>Chargement...</div>
      )}

      {/* KPI conformité */}
      {!loading && (
        <div style={{ display:'grid',
          gridTemplateColumns:isMobile?'1fr 1fr':'repeat(4,1fr)',
          gap:12, marginBottom:20 }}>
          {[...stats, sertConf !== null ? {
            label:'Sertissage', unite:'', pctConf:sertConf,
            moy:null, ecartType:null, min:null, max:null,
          } : null].filter(Boolean).map((s,i) => {
            const color = s.pctConf>=95?'#10B981':s.pctConf>=80?'#F59E0B':'#EF4444';
            return (
              <div key={i} style={{ background:T.card, borderRadius:12,
                padding:'14px', border:`1px solid ${T.border}` }}>
                <div style={{ fontSize:10, color:T.textSoft, fontWeight:600,
                  marginBottom:8, textTransform:'uppercase' }}>{s.label}</div>
                <div style={{ fontSize:28, fontWeight:700, color, lineHeight:1 }}>
                  {s.pctConf}%
                </div>
                <div style={{ fontSize:10, color:T.textSoft, marginTop:4 }}>
                  conformité
                </div>
                {s.moy && (
                  <div style={{ fontSize:10, color:T.textSoft, marginTop:2 }}>
                    Moy: {s.moy} {s.unite} · σ: {s.ecartType}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}

      {/* Tableau statistiques */}
      {!loading && donnees.length > 0 && (
        <div style={{ background:T.card, borderRadius:14, padding:'20px',
          border:`1px solid ${T.border}`, marginBottom:20,
          boxShadow:'0 1px 8px rgba(0,0,0,0.06)' }}>
          <h3 style={{ margin:'0 0 14px', fontSize:13, fontWeight:700, color:T.text }}>
            Résumé statistique
          </h3>
          <div style={{ overflowX:'auto' }}>
            <table style={{ width:'100%', borderCollapse:'collapse', fontSize:11 }}>
              <thead>
                <tr>
                  {['Paramètre','Normes','Moyenne','Écart-type','Min','Max','Conformité'].map(h=>(
                    <th key={h} style={{ padding:'8px 12px', textAlign:'center',
                      background:T.bg, color:T.textSoft, fontWeight:600,
                      borderBottom:`2px solid ${T.border}` }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {stats.filter(s=>s.total>0).map((s,i) => {
                  const color = s.pctConf>=95?'#10B981':s.pctConf>=80?'#F59E0B':'#EF4444';
                  return (
                    <tr key={i} style={{ background:i%2===0?T.bg:T.card }}>
                      <td style={{ padding:'8px 12px', fontWeight:600, color:T.text }}>{s.label}</td>
                      <td style={{ padding:'8px 12px', textAlign:'center', color:T.textSoft,fontSize:10 }}>
                        [{s.min} – {s.max}] {s.unite}
                      </td>
                      <td style={{ padding:'8px 12px', textAlign:'center',
                        fontWeight:700, color:T.text }}>{s.moy} {s.unite}</td>
                      <td style={{ padding:'8px 12px', textAlign:'center',
                        color:T.textSoft }}>{s.ecartType}</td>
                      <td style={{ padding:'8px 12px', textAlign:'center', color:T.text }}>{s.min}</td>
                      <td style={{ padding:'8px 12px', textAlign:'center', color:T.text }}>{s.max}</td>
                      <td style={{ padding:'8px 12px', textAlign:'center' }}>
                        <span style={{ fontWeight:700, color,
                          background:`${color}18`, padding:'2px 8px', borderRadius:20 }}>
                          {s.pctConf}% ({s.conformes}/{s.total})
                        </span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Conformité par chaîne */}
      {!loading && atelier === 'Tous' && (
        <div style={{ background:T.card, borderRadius:14, padding:'20px',
          border:`1px solid ${T.border}`, marginBottom:20,
          boxShadow:'0 1px 8px rgba(0,0,0,0.06)' }}>
          <h3 style={{ margin:'0 0 14px', fontSize:13, fontWeight:700, color:T.text }}>
            % Conformité Brix par chaîne
          </h3>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={parAtelier} barSize={30} barCategoryGap="30%">
              <CartesianGrid strokeDasharray="3 3" stroke={T.border} vertical={false}/>
              <XAxis dataKey="atelier" tick={{ fontSize:11, fill:T.textSoft }}
                axisLine={false} tickLine={false}/>
              <YAxis domain={[0,100]} tick={{ fontSize:10, fill:T.textSoft }}
                axisLine={false} tickLine={false}
                tickFormatter={v=>`${v}%`}/>
              <Tooltip content={p=><CustomTooltip {...p} T={T}/>}
                cursor={{ fill:`${T.border}40` }}/>
              <ReferenceLine y={95} stroke="#10B981" strokeDasharray="4 2"
                label={{ value:'95%', fontSize:9, fill:'#10B981', position:'right' }}/>
              <Bar dataKey="% conf Brix" radius={[6,6,0,0]}>
                {parAtelier.map((row,i) => (
                  <Cell key={i}
                    fill={row['% conf Brix']>=95?'#10B981':row['% conf Brix']>=80?'#F59E0B':'#EF4444'}/>
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}

      {/* Évolution quotidienne */}
      {!loading && evolutionConf.length > 0 && (
        <div style={{ background:T.card, borderRadius:14, padding:'20px',
          border:`1px solid ${T.border}`,
          boxShadow:'0 1px 8px rgba(0,0,0,0.06)' }}>
          <h3 style={{ margin:'0 0 14px', fontSize:13, fontWeight:700, color:T.text }}>
            Évolution quotidienne de la conformité (%)
          </h3>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={evolutionConf.slice(-14)} barCategoryGap="20%">
              <CartesianGrid strokeDasharray="3 3" stroke={T.border} vertical={false}/>
              <XAxis dataKey="date" tick={{ fontSize:9, fill:T.textSoft }}
                axisLine={false} tickLine={false}/>
              <YAxis domain={[0,100]} tick={{ fontSize:9, fill:T.textSoft }}
                axisLine={false} tickLine={false}/>
              <Tooltip content={p=><CustomTooltip {...p} T={T}/>}
                cursor={{ fill:`${T.border}40` }}/>
              <ReferenceLine y={95} stroke="#10B981" strokeDasharray="4 2"/>
              <Bar dataKey="Brix %" fill="#3B82F6" radius={[4,4,0,0]}/>
              <Bar dataKey="CO₂ %" fill="#10B981" radius={[4,4,0,0]}/>
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}

      {!loading && donnees.length === 0 && (
        <div style={{ textAlign:'center', padding:'60px 0',
          color:T.textSoft, fontSize:14 }}>
          Aucune donnée disponible. Saisir des relevés dans la section Data.
        </div>
      )}
    </div>
  );
}