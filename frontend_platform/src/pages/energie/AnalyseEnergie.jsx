import { useState } from "react";
import { useTheme } from "../../components/layout/Layout";
import api from "../../services/api";
import { LabelList } from "recharts";
import * as XLSX from "xlsx";
import {
  ComposedChart, Bar, Line, XAxis, YAxis, CartesianGrid,
  Tooltip, ReferenceLine, ResponsiveContainer, Cell, Legend,
  BarChart
} from "recharts";

const ATELIERS    = ["Chaîne 8","Chaine 13","Chaîne 14","Chaîne 15","Chaîne 16"];
const QUARTS      = ["Journée complète","6h-14h","14h-22h","22h-6h"];
const ORDRE_QUART = { "6h-14h":1, "14h-22h":2, "22h-6h":3};

function today()    { return new Date().toISOString().split("T")[0]; }
function daysAgo(n) { const d=new Date(); d.setDate(d.getDate()-n); return d.toISOString().split("T")[0]; }
function nbBte(hl, atelier) { return atelier==="Chaîne 16" ? hl*100/0.5 : hl*100/0.65; }

const CL = { vert:"#10B981", orange:"#F59E0B", rouge:"#EF4444" };
function clLaveuse(v) { return v<=0.3?CL.vert:v<=0.6?CL.orange:CL.rouge; }
function clPasto(v)   { return v<=1.5?CL.vert:v<=2.0?CL.orange:CL.rouge; }

function stats(arr) {
  if(!arr.length) return {min:0,max:0,moy:0,hors:0};
  const min = +Math.min(...arr).toFixed(3);
  const max = +Math.max(...arr).toFixed(3);
  const moy = +(arr.reduce((a,b)=>a+b,0)/arr.length).toFixed(3);
  return {min,max,moy};
}

function tendance(arr) {
  if(arr.length<2) return "stable";
  const mid = Math.floor(arr.length/2);
  const avg1 = arr.slice(0,mid).reduce((a,b)=>a+b,0)/mid;
  const avg2 = arr.slice(mid).reduce((a,b)=>a+b,0)/(arr.length-mid);
  if(avg2>avg1*1.05) return "hausse";
  if(avg2<avg1*0.95) return "baisse";
  return "stable";
}

export default function AnalyseEnergie() {
  const { T, dark } = useTheme();
  const [atelier,   setAtelier]   = useState("Chaîne 8");
  const [quart,     setQuart]     = useState("Journée complète");
  const [dateDebut, setDateDebut] = useState(daysAgo(30));
  const [dateFin,   setDateFin]   = useState(today());
  const [loading,   setLoading]   = useState(false);
  const [erreur,    setErreur]    = useState(null);
  const [data,      setData]      = useState(null);

  const IS = {
    background: T.card, border:`1px solid ${T.border}`,
    borderRadius:10, padding:'8px 12px',
    color:T.text, fontSize:13, width:'100%',
  };
  const LS = {
    fontSize:11, fontWeight:700, color:T.textSoft,
    textTransform:'uppercase', letterSpacing:0.8,
    marginBottom:4, display:'block',
  };

  // ── FETCH & CALCUL ─────────────────────────────────────
  async function analyser() {
  setErreur(null); setData(null); setLoading(true);
  try {
    const p = new URLSearchParams({ atelier, date_debut:dateDebut, date_fin:dateFin, limit:500 });
    if(quart!=="Journée complète") p.append("quart", quart);
    const res   = await api.get(`/energie/?${p}`);
    const raw   = res.data;

    // Tri : date ASC, puis ordre quart 6h-14h → 14h-22h → 22h-6h
    const tries = [...raw].sort((a,b)=>{
      const dd = new Date(a.date)-new Date(b.date);
      return dd!==0 ? dd : (ORDRE_QUART[a.quart]||0)-(ORDRE_QUART[b.quart]||0);
    });

    if(tries.length < 2){ setErreur("Minimum 2 relevés nécessaires."); setLoading(false); return; }
    
    console.log("Relevés reçus:", tries.length, tries);

    // Calcul des consommations par relevé (différence d'index)
    const consos = [];
    for(let i=1; i<tries.length; i++){
      const c=tries[i], p2=tries[i-1];
      const prod = parseFloat(c.production_hl);
      if(!prod || prod===0) continue;
      const nb = nbBte(prod, atelier);
      consos.push({
        date:  c.date,
        quart: c.quart,
        prod,
        nb,
        ri: Math.max(0, parseFloat(c.index_eau_rincage) - parseFloat(p2.index_eau_rincage)),
        ba: Math.max(0, parseFloat(c.index_eau_bain)    - parseFloat(p2.index_eau_bain)),
        pa: Math.max(0, parseFloat(c.index_eau_pasteur) - parseFloat(p2.index_eau_pasteur)),
        ae: Math.max(0, parseFloat(c.index_eau_aero)    - parseFloat(p2.index_eau_aero)),
        el: Math.max(0, parseFloat(c.index_elec)        - parseFloat(p2.index_elec)),
        co: Math.max(0, parseFloat(c.index_co2)         - parseFloat(p2.index_co2)),
      });
    }

    if(!consos.length){ setErreur("Aucune donnée valide."); setLoading(false); return; }

    let rows = [];

    if(quart === "Journée complète") {
      // Regroupement par date
      // Le quart 22h-6h clôture la journée du JOUR PRECEDENT
      // → on rattache le quart 22h-6h à la date de la veille
      const parJour = {};
      consos.forEach(c => {
        // Si quart 22h-6h, on rattache à la veille
        let jourCle = c.date;
        if(c.quart === "22h-6h") {
          const d = new Date(c.date);
          d.setDate(d.getDate()-1);
          jourCle = d.toISOString().split("T")[0];
        }
        if(!parJour[jourCle]) parJour[jourCle] = { n:0, prod:0, nb:0, ri:0, ba:0, pa:0, ae:0, el:0, co:0 };
        const j = parJour[jourCle];
        j.n++;
        j.prod += c.prod;
        j.nb   += c.nb;
        j.ri   += c.ri;
        j.ba   += c.ba;
        j.pa   += c.pa;
        j.ae   += c.ae;
        j.el   += c.el;
        j.co   += c.co;
      });

      rows = Object.entries(parJour)
        .sort(([a],[b]) => new Date(a)-new Date(b))
        .map(([date, j]) => {
          const nb_bte = j.nb;
          const rBain  = nb_bte>0 ? +((j.ba*1000)/nb_bte).toFixed(3) : 0;
          const rRinc  = nb_bte>0 ? +((j.ri*1000)/nb_bte).toFixed(3) : 0;
          const rLav   = +(rBain+rRinc).toFixed(3);
          const pTot   = +(j.pa+j.ae).toFixed(2);
          // Pasteur : total m³ / 24h
          const rPasto = +(pTot/24).toFixed(3);
          const rElec  = j.prod>0 ? +(j.el/j.prod).toFixed(2) : 0;
          const rCo2   = j.prod>0 ? +(j.co/j.prod).toFixed(2) : 0;
          return {
            label:       date.slice(5),   // MM-DD sur axe X
            labelCourt:  date.slice(5),
            date,
            quart:       `${j.n} quart(s)`,
            prod:        +j.prod.toFixed(1),
            nb_bte:      Math.round(nb_bte),
            bain:        +(j.ba*1000).toFixed(1),
            rincage:     +(j.ri*1000).toFixed(1),
            rBain, rRinc, rLav,
            pasteur:     +j.pa.toFixed(2),
            aero:        +j.ae.toFixed(2),
            pTot, rPasto,
            elec:        +j.el.toFixed(1),
            rElec,
            co2:         +j.co.toFixed(1),
            rCo2,
          };
        });
    } else {
      // Affichage par quart individuel
      rows = consos.map(c => {
        const nb_bte = c.nb;
        const rBain  = nb_bte>0 ? +((c.ba*1000)/nb_bte).toFixed(3) : 0;
        const rRinc  = nb_bte>0 ? +((c.ri*1000)/nb_bte).toFixed(3) : 0;
        const rLav   = +(rBain+rRinc).toFixed(3);
        const pTot   = +(c.pa+c.ae).toFixed(2);
        const rPasto = +(pTot/24).toFixed(3);
        const rElec  = c.prod>0 ? +(c.el/c.prod).toFixed(2) : 0;
        const rCo2   = c.prod>0 ? +(c.co/c.prod).toFixed(2) : 0;
        return {
          label:      `${c.date.slice(5)} ${c.quart}`,
          labelCourt: `${c.date.slice(5)} ${c.quart}`,
          date: c.date, quart: c.quart,
          prod: +c.prod.toFixed(1), nb_bte: Math.round(nb_bte),
          bain: +(c.ba*1000).toFixed(1), rincage: +(c.ri*1000).toFixed(1),
          rBain, rRinc, rLav,
          pasteur: +c.pa.toFixed(2), aero: +c.ae.toFixed(2),
          pTot, rPasto,
          elec: +c.el.toFixed(1), rElec,
          co2:  +c.co.toFixed(1), rCo2,
        };
      });
    }

    if(!rows.length){ setErreur("Aucune donnée valide."); setLoading(false); return; }

    // Stats par quart (pour comparaison — toujours calculé sur consos brutes)
    const parQuart = {};
    ["6h-14h","14h-22h","22h-6h"].forEach(q => {
      const r = consos.filter(x=>x.quart===q);
      if(!r.length) return;
      const nb2 = r.map(x=>x.nb);
      const rl  = r.map(x=> x.nb>0?+((x.ba+x.ri)*1000/x.nb).toFixed(3):0);
      const rp  = r.map(x=> +((x.pa+x.ae)/24).toFixed(3));
      const re  = r.map(x=> x.prod>0?+(x.el/x.prod).toFixed(2):0);
      const rc  = r.map(x=> x.prod>0?+(x.co/x.prod).toFixed(2):0);
      const avg = arr => +(arr.reduce((a,b)=>a+b,0)/arr.length).toFixed(3);
      parQuart[q] = { rLav:avg(rl), rPasto:avg(rp), rElec:avg(re), rCo2:avg(rc), n:r.length };
    });

    setData({
      rows, parQuart,
      sLav:   stats(rows.map(r=>r.rLav)),
      sPasto: stats(rows.map(r=>r.rPasto)),
      sElec:  stats(rows.map(r=>r.rElec)),
      sCo2:   stats(rows.map(r=>r.rCo2)),
      tLav:   tendance(rows.map(r=>r.rLav)),
      tPasto: tendance(rows.map(r=>r.rPasto)),
      tElec:  tendance(rows.map(r=>r.rElec)),
      tCo2:   tendance(rows.map(r=>r.rCo2)),
      horsLav:   rows.filter(r=>r.rLav>0.6).length,
      horsPasto: rows.filter(r=>r.rPasto>2.0).length,
    });

  } catch(e){ setErreur("Erreur de récupération des données."); }
  setLoading(false);
}

  // ── EXPORT EXCEL ───────────────────────────────────────
  function exportExcel() {
    if(!data) return;
    const wb = XLSX.utils.book_new();

    const headerStyle = {
      font:{ bold:true, color:{ rgb:"FFFFFF" }, sz:11 },
      fill:{ fgColor:{ rgb:"DA291C" } },
      alignment:{ horizontal:"center" },
      border:{
        top:{style:"thin",color:{rgb:"999999"}},
        bottom:{style:"thin",color:{rgb:"999999"}},
        left:{style:"thin",color:{rgb:"999999"}},
        right:{style:"thin",color:{rgb:"999999"}},
      }
    };
    const subHeaderStyle = {
      font:{ bold:true, color:{ rgb:"FFFFFF" }, sz:10 },
      fill:{ fgColor:{ rgb:"1E293B" } },
      alignment:{ horizontal:"center" },
    };
    const vertStyle = (v, seuil1, seuil2) => ({
      font:{ bold: v>seuil1 },
      fill:{ fgColor:{ rgb: v<=seuil1?"D1FAE5":v<=seuil2?"FEF3C7":"FEE2E2" } },
      alignment:{ horizontal:"center" },
    });

    function ajouterFeuille(nom, colonnes, lignes, colorCol, s1, s2) {
      const ws = {};
      const range = { s:{r:0,c:0}, e:{r:lignes.length+1, c:colonnes.length-1} };

      // En-tête
      colonnes.forEach((col,ci)=>{
        const ref = XLSX.utils.encode_cell({r:0,c:ci});
        ws[ref] = { v:col.label, t:"s", s:headerStyle };
      });

      // Données
      lignes.forEach((row,ri)=>{
        colonnes.forEach((col,ci)=>{
          const ref = XLSX.utils.encode_cell({r:ri+1,c:ci});
          const val = row[col.key];
          const cell = { v:val, t: typeof val==="number"?"n":"s" };
          if(col.key===colorCol && typeof val==="number") {
            cell.s = vertStyle(val,s1,s2);
          }
          ws[ref] = cell;
        });
      });

      ws["!ref"] = XLSX.utils.encode_range(range);
      ws["!cols"] = colonnes.map(()=>({ wch:18 }));
      XLSX.utils.book_append_sheet(wb, ws, nom);
    }

    // Feuille 1 — Eau laveuse
    ajouterFeuille("Eau laveuse", [
      {key:"date",label:"Date"}, {key:"quart",label: quart==='Journée complète' ? 'Quarts saisis' : "Quart"},
      {key:"nb_bte",label:"Production (btes)"},
      {key:"bain",label:"Conso bain (L)"}, {key:"rincage",label:"Conso rinçage (L)"},
      {key:"rBain",label:"Ratio bain (L/bte)"}, {key:"rRinc",label:"Ratio rinçage (L/bte)"},
      {key:"rLav",label:"Ratio laveuse (L/bte)"},
    ], data.rows, "rLav", 0.3, 0.6);

    // Feuille 2 — Eau pasteurisateur
    ajouterFeuille("Eau pasteurisateur", [
      {key:"date",label:"Date"}, {key:"quart",label: quart==='Journée complète' ? 'Quarts saisis' : "Quart"},
      {key:"pasteur",label:"Conso pasteur (m³)"}, {key:"aero",label:"Conso aéro (m³)"},
      {key:"pTot",label:"Total (m³)"}, {key:"rPasto",label:"Ratio (m³/h)"},
    ], data.rows, "rPasto", 1.5, 2.0);

    // Feuille 3 — Électricité
    ajouterFeuille("Électricité", [
      {key:"date",label:"Date"}, {key:"quart",label:"Quart"},
      {key:"prod",label:"Production (hl)"},
      {key:"elec",label:"Conso (kWh)"}, {key:"rElec",label:"Ratio (kWh/hl)"},
    ], data.rows, null, null, null);

    // Feuille 4 — CO2
    ajouterFeuille("CO2", [
      {key:"date",label:"Date"}, {key:"quart",label:"Quart"},
      {key:"prod",label:"Production (hl)"},
      {key:"co2",label:"Conso (kg)"}, {key:"rCo2",label:"Ratio (kg/hl)"},
    ], data.rows, null, null, null);

    // Feuille 5 — Résumé
    const wsResume = XLSX.utils.aoa_to_sheet([
      ["RAPPORT ANALYSE ÉNERGIE — SABC PACKAGING"],
      [`Chaîne : ${atelier}   |   Quart : ${quart}   |   Période : ${dateDebut} → ${dateFin}`],
      [],
      ["Indicateur","Minimum","Maximum","Moyenne","Tendance","Quarts hors seuil"],
      ["Ratio laveuse (L/bte)", data.sLav.min, data.sLav.max, data.sLav.moy,
        data.tLav==="hausse"?"↑ Hausse":data.tLav==="baisse"?"↓ Baisse":"→ Stable",
        `${data.horsLav} / ${data.rows.length}`],
      ["Ratio pasteurisateur (m³/h)", data.sPasto.min, data.sPasto.max, data.sPasto.moy,
        data.tPasto==="hausse"?"↑ Hausse":data.tPasto==="baisse"?"↓ Baisse":"→ Stable",
        `${data.horsPasto} / ${data.rows.length}`],
      ["Ratio électricité (kWh/hl)", data.sElec.min, data.sElec.max, data.sElec.moy,
        data.tElec==="hausse"?"↑ Hausse":data.tElec==="baisse"?"↓ Baisse":"→ Stable", "-"],
      ["Ratio CO₂ (kg/hl)", data.sCo2.min, data.sCo2.max, data.sCo2.moy,
        data.tCo2==="hausse"?"↑ Hausse":data.tCo2==="baisse"?"↓ Baisse":"→ Stable", "-"],
    ]);
    wsResume["!cols"] = [30,12,12,12,14,18].map(w=>({wch:w}));
    XLSX.utils.book_append_sheet(wb, wsResume, "Résumé");

    XLSX.writeFile(wb, `Analyse_Energie_${atelier.replace(/\s/g,"_")}_${dateDebut}_${dateFin}.xlsx`);
  }

  // ── SOUS-COMPOSANTS ────────────────────────────────────
  function CarteResume({ titre, stats, tendance, seuil, hors, total, unite, couleurFn }) {
    const T2 = useTheme().T;
    const cl = couleurFn ? couleurFn(stats.moy) : T2.primary;
    const icon = tendance==="hausse"?"↑":tendance==="baisse"?"↓":"→";
    const clIcon = tendance==="hausse"?CL.rouge:tendance==="baisse"?CL.vert:CL.orange;
    return (
      <div style={{
        background:T2.card, border:`1px solid ${T2.border}`,
        borderRadius:14, padding:'16px 18px',
        borderLeft:`4px solid ${cl}`,
      }}>
        <p style={{fontSize:11,fontWeight:700,color:T2.textSoft,margin:'0 0 8px',textTransform:'uppercase',letterSpacing:0.8}}>{titre}</p>
        <div style={{display:'flex',alignItems:'baseline',gap:6}}>
          <span style={{fontSize:26,fontWeight:800,color:cl}}>{stats.moy}</span>
          <span style={{fontSize:12,color:T2.textSoft}}>{unite}</span>
          <span style={{fontSize:18,color:clIcon,marginLeft:4}}>{icon}</span>
        </div>
        <div style={{display:'flex',gap:12,marginTop:8}}>
          <span style={{fontSize:11,color:T2.textSoft}}>Min <b style={{color:CL.vert}}>{stats.min}</b></span>
          <span style={{fontSize:11,color:T2.textSoft}}>Max <b style={{color:CL.rouge}}>{stats.max}</b></span>
          {hors!=null && <span style={{fontSize:11,color:hors>0?CL.rouge:CL.vert,fontWeight:700}}>{hors}/{total} hors seuil</span>}
        </div>
      </div>
    );
  }

  function Graphique({ rows, dataKey, colorFn, yLabel, refs=[] }) {
    const T2 = useTheme().T;
    const moy = rows.reduce((a,b)=>a+b[dataKey],0)/rows.length;
    const chartData = rows.map(r=>({...r, moyenne:+moy.toFixed(3)}));
    return (
      <div style={{ overflowX: 'auto', WebkitOverflowScrolling: 'touch' }}>
        <div style={{ minWidth: Math.max(rows.length * 55, 320), height: 240 }}>
          <ResponsiveContainer width="100%" height="100%">
            <ComposedChart 
              data={chartData} 
              margin={{ top:10, right:50, left:0, bottom:50 }} 
              barCategoryGap="10%"
            >
              <CartesianGrid strokeDasharray="3 3" stroke={T2.border} />
              <XAxis
                dataKey="labelCourt"
                tick={{ fontSize:9, fill:T2.textSoft }}
                angle={-40}
                textAnchor="end"
                interval={0}
              />
              <YAxis
                tick={{ fontSize:10, fill:T2.textSoft }}
                label={{
                  value: yLabel,
                  angle: -90,
                  position: 'insideLeft',
                  style: { fontSize:10, fill:T2.textSoft }
                }}
              />
              <Tooltip
                contentStyle={{
                  background:T2.card,
                  border:`1px solid ${T2.border}`,
                  borderRadius:8,
                  color:T2.text,
                  fontSize:11
                }}
              />
              <Legend wrapperStyle={{ fontSize:11, color:T2.textSoft, paddingTop:8 }}/>
              {refs.map(r=>(
                <ReferenceLine
                  key={r.val}
                  y={r.val}
                  stroke={r.color}
                  strokeWidth={2}
                  strokeDasharray="0"
                  label={{
                    value: r.label,
                    position: 'right',
                    fontSize: 10,
                    fontWeight: 700,
                    fill: r.color,
                  }}
                />
              ))}
              <Bar dataKey={dataKey} name="Valeur" radius={[4,4,0,0]} barSize={22}>
                <LabelList 
                  dataKey={dataKey} 
                  position="top" 
                  style={{ fontSize:9, fill:T2.textSoft, fontWeight:600 }}
                />
                {rows.map((r,i)=>(
                  <Cell key={i} fill={colorFn ? colorFn(r[dataKey]) : '#DA291C'}/>
                ))}
              </Bar>
              <Line
                dataKey="moyenne"
                name="Moyenne"
                type="monotone"
                stroke="#F5A623"
                strokeWidth={2}
                dot={false}
                strokeDasharray="4 2"
              />
            </ComposedChart>
          </ResponsiveContainer>
        </div>
      </div>
    );
  }

  function Tableau({ cols, rows, colorCol, colorFn }) {
    const T2 = useTheme().T;
    return (
      <div style={{overflowX:'auto',marginTop:8}}>
        <table style={{width:'100%',borderCollapse:'collapse',fontSize:12,color:T2.text}}>
          <thead>
            <tr style={{background:dark?'#1E293B':'#F1F5F9'}}>
              {cols.map(c=>(
                <th key={c.key} style={{
                  padding:'8px 10px',textAlign:'left',fontWeight:700,
                  color:T2.textSoft,fontSize:11,whiteSpace:'nowrap',
                  borderBottom:`2px solid ${T2.border}`,
                }}>{c.label}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((r,i)=>(
              <tr key={i} style={{borderBottom:`1px solid ${T2.border}`,background:i%2===0?'transparent':dark?'rgba(255,255,255,0.02)':'rgba(0,0,0,0.01)'}}>
                {cols.map(c=>{
                  const val=r[c.key];
                  const isC=c.key===colorCol;
                  const cl=isC?colorFn(val):null;
                  return (
                    <td key={c.key} style={{
                      padding:'7px 10px', whiteSpace:'nowrap',
                      background:isC?cl+'22':'transparent',
                      color:isC?cl:T2.text,
                      fontWeight:isC?700:400,
                    }}>{val}</td>
                  );
                })}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  function ComparaisonQuarts({ parQuart }) {
    const T2 = useTheme().T;
    const quarts = Object.keys(parQuart);
    if(!quarts.length) return null;
    const indicateurs = [
      {key:'rLav',  label:'Laveuse (L/bte)',   cl:q=>clLaveuse(parQuart[q].rLav)},
      {key:'rPasto',label:'Pasteur (m³/h)',     cl:q=>clPasto(parQuart[q].rPasto)},
      {key:'rElec', label:'Élec (kWh/hl)',      cl:()=>T2.primary},
      {key:'rCo2',  label:'CO₂ (kg/hl)',        cl:()=>T2.gold||'#F5A623'},
    ];
    return (
      <div style={{background:T2.card,border:`1px solid ${T2.border}`,borderRadius:16,padding:20,marginBottom:24}}>
        <p style={{fontSize:15,fontWeight:700,color:T2.text,margin:'0 0 16px'}}>
          🔄 Comparaison par quart
        </p>
        <div style={{overflowX:'auto'}}>
          <table style={{width:'100%',borderCollapse:'collapse',fontSize:12}}>
            <thead>
              <tr style={{background:dark?'#1E293B':'#F1F5F9'}}>
                <th style={{padding:'8px 12px',textAlign:'left',color:T2.textSoft,fontSize:11,fontWeight:700,borderBottom:`2px solid ${T2.border}`}}>Indicateur</th>
                {quarts.map(q=>(
                  <th key={q} style={{padding:'8px 12px',textAlign:'center',color:T2.textSoft,fontSize:11,fontWeight:700,borderBottom:`2px solid ${T2.border}`}}>{q}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {indicateurs.map((ind,i)=>(
                <tr key={ind.key} style={{borderBottom:`1px solid ${T2.border}`,background:i%2===0?'transparent':dark?'rgba(255,255,255,0.02)':'rgba(0,0,0,0.01)'}}>
                  <td style={{padding:'8px 12px',fontWeight:600,color:T2.text}}>{ind.label}</td>
                  {quarts.map(q=>{
                    const val=parQuart[q][ind.key];
                    const cl=ind.cl(q);
                    return (
                      <td key={q} style={{padding:'8px 12px',textAlign:'center',fontWeight:700,color:cl}}>
                        {val}
                      </td>
                    );
                  })}
                </tr>
              ))}
              <tr style={{borderTop:`2px solid ${T2.border}`}}>
                <td style={{padding:'8px 12px',color:T2.textSoft,fontSize:11}}>Nb relevés</td>
                {quarts.map(q=>(
                  <td key={q} style={{padding:'8px 12px',textAlign:'center',color:T2.textSoft,fontSize:11}}>{parQuart[q].n}</td>
                ))}
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    );
  }

  function SectionCard({ icone, titre, sousTitre, children }) {
    const T2 = useTheme().T;
    return (
      <div style={{background:T2.card,border:`1px solid ${T2.border}`,borderRadius:16,padding:20,marginBottom:24}}>
        <div style={{display:'flex',alignItems:'center',gap:10,marginBottom:16}}>
          <span style={{fontSize:22}}>{icone}</span>
          <div>
            <p style={{fontSize:15,fontWeight:700,color:T2.text,margin:0}}>{titre}</p>
            <p style={{fontSize:12,color:T2.textSoft,margin:0}}>{sousTitre}</p>
          </div>
        </div>
        {children}
      </div>
    );
  }

  // ── RENDU PRINCIPAL ────────────────────────────────────
  return (
    <div style={{padding:'20px 16px',maxWidth:960,margin:'0 auto'}}>

      {/* Filtres */}
      <div style={{background:T.card,border:`1px solid ${T.border}`,borderRadius:16,padding:20,marginBottom:24}}>
        <p style={{fontSize:15,fontWeight:700,color:T.text,margin:'0 0 16px'}}>🔍 Paramètres d'analyse</p>
        <div style={{display:'grid',gridTemplateColumns:'repeat(auto-fit, minmax(150px,1fr))',gap:12,marginBottom:16}}>
          <div>
            <label style={LS}>Atelier</label>
            <select value={atelier} onChange={e=>setAtelier(e.target.value)} style={IS}>
              {ATELIERS.map(a=><option key={a}>{a}</option>)}
            </select>
          </div>
          <div>
            <label style={LS}>Quart</label>
            <select value={quart} onChange={e=>setQuart(e.target.value)} style={IS}>
              {QUARTS.map(q=><option key={q}>{q}</option>)}
            </select>
          </div>
          <div>
            <label style={LS}>Date début</label>
            <input type="date" value={dateDebut} onChange={e=>setDateDebut(e.target.value)} style={IS}/>
          </div>
          <div>
            <label style={LS}>Date fin</label>
            <input type="date" value={dateFin} onChange={e=>setDateFin(e.target.value)} style={IS}/>
          </div>
        </div>
        <div style={{display:'flex',gap:10,flexWrap:'wrap'}}>
          <button onClick={analyser} disabled={loading} style={{
            background:T.primary,color:'#fff',border:'none',borderRadius:10,
            padding:'10px 24px',fontSize:14,fontWeight:700,
            cursor:loading?'not-allowed':'pointer',opacity:loading?0.7:1,
          }}>
            {loading?"⏳ Chargement...":"📊 Analyser"}
          </button>
          {data && (
            <button onClick={exportExcel} style={{
              background:'#10B981',color:'#fff',border:'none',borderRadius:10,
              padding:'10px 24px',fontSize:14,fontWeight:700,cursor:'pointer',
            }}>
              📥 Exporter Excel
            </button>
          )}
        </div>
      </div>

      {erreur && (
        <div style={{background:'#FEF2F2',border:'1px solid #FCA5A5',borderRadius:12,padding:'12px 16px',color:'#B91C1C',fontSize:13,marginBottom:20}}>
          ⚠️ {erreur}
        </div>
      )}

      {data && (<>

        {/* Cartes résumé */}
        <div style={{display:'grid',gridTemplateColumns:'repeat(auto-fit,minmax(200px,1fr))',gap:14,marginBottom:24}}>
          <CarteResume titre="Eau laveuse"       stats={data.sLav}   tendance={data.tLav}   hors={data.horsLav}   total={data.rows.length} unite="L/bte"   couleurFn={clLaveuse}/>
          <CarteResume titre="Pasteurisateur"    stats={data.sPasto} tendance={data.tPasto} hors={data.horsPasto} total={data.rows.length} unite="m³/h"    couleurFn={clPasto}/>
          <CarteResume titre="Électricité"       stats={data.sElec}  tendance={data.tElec}  hors={null}           total={null}             unite="kWh/hl"  couleurFn={null}/>
          <CarteResume titre="CO₂"               stats={data.sCo2}   tendance={data.tCo2}   hors={null}           total={null}             unite="kg/hl"   couleurFn={null}/>
        </div>

        {/* Comparaison quarts */}
        <ComparaisonQuarts parQuart={data.parQuart}/>

        {/* Section Laveuse */}
        <SectionCard icone="💧" titre="Eau laveuse" sousTitre="Cible ≤ 0,3 L/bte  |  Limite 0,6 L/bte">
          <Graphique rows={data.rows} dataKey="rLav" colorFn={clLaveuse} yLabel="L/bte"
            refs={[{val:0.3,color:CL.vert,label:'Cible 0,3'},{val:0.6,color:CL.orange,label:'Limite 0,6'}]}/>
          <Tableau rows={data.rows} colorCol="rLav" colorFn={clLaveuse} cols={[
            {key:'date',label:'Date'},{key:'quart',label:'Quart'},
            {key:'nb_bte',label:'Prod (btes)'},{key:'bain',label:'Bain (L)'},
            {key:'rincage',label:'Rinçage (L)'},{key:'rBain',label:'Ratio bain'},
            {key:'rRinc',label:'Ratio rinçage'},{key:'rLav',label:'Ratio laveuse'},
          ]}/>
        </SectionCard>

        {/* Section Pasteurisateur */}
        <SectionCard icone="💧" titre="Eau pasteurisateur" sousTitre="Cible ≤ 1,5 m³/h  |  Limite 2,0 m³/h">
          <Graphique rows={data.rows} dataKey="rPasto" colorFn={clPasto} yLabel="m³/h"
            refs={[{val:1.5,color:CL.vert,label:'Cible 1,5'},{val:2.0,color:CL.orange,label:'Limite 2,0'}]}/>
          <Tableau rows={data.rows} colorCol="rPasto" colorFn={clPasto} cols={[
            {key:'date',label:'Date'},{key:'quart',label:'Quart'},
            {key:'pasteur',label:'Pasteur (m³)'},{key:'aero',label:'Aéro (m³)'},
            {key:'pTot',label:'Total (m³)'},{key:'rPasto',label:'Ratio (m³/h)'},
          ]}/>
        </SectionCard>

        {/* Section Électricité */}
        <SectionCard icone="⚡" titre="Électricité" sousTitre="Consommation et ratio par hectolitre produit">
          <Graphique rows={data.rows} dataKey="rElec" colorFn={()=>'#DA291C'} yLabel="kWh/hl"
            refs={[{val:2.0,color:CL.vert,label:'Cible 2,0'},{val:3.0,color:CL.orange,label:'Limite 3,0'}]}/>  
          <Tableau rows={data.rows} colorCol={null} colorFn={null} cols={[
            {key:'date',label:'Date'},{key:'quart',label:'Quart'},
            {key:'prod',label:'Production (hl)'},{key:'elec',label:'Conso (kWh)'},
            {key:'rElec',label:'Ratio (kWh/hl)'},
          ]}/>
        </SectionCard>

        {/* Section CO2 */}
        <SectionCard icone="💨" titre="CO₂" sousTitre="Consommation et ratio par hectolitre produit">
          <Graphique rows={data.rows} dataKey="rCo2" colorFn={()=>'#F5A623'} yLabel="kg/hl"
            refs={[{val:0.3,color:CL.vert,label:'Cible 0,3'},{val:0.8,color:CL.orange,label:'Limite 0,8'}]}/>
          <Tableau rows={data.rows} colorCol={null} colorFn={null} cols={[
            {key:'date',label:'Date'},{key:'quart',label:'Quart'},
            {key:'prod',label:'Production (hl)'},{key:'co2',label:'Conso (kg)'},
            {key:'rCo2',label:'Ratio (kg/hl)'},
          ]}/>
        </SectionCard>

      </>)}
    </div>
  );
}