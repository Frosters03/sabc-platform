import { useState, useEffect, useRef } from "react";
import { useTheme } from "../../components/layout/Layout";
import BoutonRetour from "../../components/BoutonRetour";
import * as XLSX from "xlsx";
import { equipesAPI, pointagesAPI } from "../../services/api";
import jsPDF from "jspdf";
import html2canvas from "html2canvas";

const CHAINES = ["Chaîne 8","Chaîne 13","Chaîne 14","Chaîne 15","Chaîne 16"];
const FONCTIONS_AM = ["Agent de maîtrise"];

const IconSearch = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>;
const IconExport = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/></svg>;

// ── EXPORT POINTAGES (module RH) ──────────────────────────
export default function ExportPointages() {
  const { T, dark } = useTheme();
  return (
    <div style={{ padding:"20px 16px", maxWidth:1000, margin:"0 auto" }}>
      <OngletPointages T={T} dark={dark}/>
    </div>
  );
}

// ── ONGLET POINTAGES ──────────────────────────────────────
function OngletPointages({ T, dark }) {
  const [sousOnglet, setSousOnglet] = useState("semaine");
  const [chaine,     setChaine]     = useState("Chaîne 8");
  const [equipeId,   setEquipeId]   = useState("");
  const [equipes,    setEquipes]    = useState([]);
  const [dateLundi,  setDateLundi]  = useState("");
  const [pointages,  setPointages]  = useState([]);
  const [typeFiche,  setTypeFiche]  = useState("titulaires");
  const [loading,    setLoading]    = useState(false);
  const [loadingExp, setLoadingExp] = useState(false);
  const [erreur,     setErreur]     = useState(null);
  const tableauRef = useRef(null);

  const IS = { background:T.card, border:`1px solid ${T.border}`, borderRadius:10, padding:'8px 12px', color:T.text, fontSize:13, width:'100%' };
  const LS = { fontSize:11, fontWeight:700, color:T.textSoft, textTransform:'uppercase', letterSpacing:0.8, marginBottom:4, display:'block' };

  useEffect(() => {
    setEquipeId(""); setPointages([]);
    equipesAPI.lister({ chaine }).then(res => setEquipes(res.data)).catch(console.error);
  }, [chaine]);

  useEffect(() => {
    const d = new Date(); const jour = d.getDay();
    const diff = jour === 0 ? -6 : 1 - jour;
    d.setDate(d.getDate() + diff);
    setDateLundi(d.toISOString().split("T")[0]);
  }, []);

  function getDimanche(lundi) {
    if(!lundi) return "";
    const d = new Date(lundi); d.setDate(d.getDate() + 6);
    return d.toISOString().split("T")[0];
  }

  function handleDateChange(val) {
    const d = new Date(val); const jour = d.getDay();
    const diff = jour === 0 ? -6 : 1 - jour;
    d.setDate(d.getDate() + diff);
    setDateLundi(d.toISOString().split("T")[0]); setPointages([]);
  }

  async function chargerPointages() {
    if(!equipeId)  { setErreur("Sélectionnez une équipe."); return; }
    if(!dateLundi) { setErreur("Sélectionnez une semaine."); return; }
    setErreur(null); setLoading(true);
    try {
      const dimanche = getDimanche(dateLundi);
      const res = await pointagesAPI.lister({ equipe_id:equipeId, date_debut:dateLundi, date_fin:dimanche });
      setPointages(res.data);
      if(res.data.length === 0) setErreur("Aucun pointage trouvé pour cette semaine.");
    } catch(e) { setErreur("Erreur lors du chargement."); }
    setLoading(false);
  }

  async function exporterExcel() {
    if(!equipeId || !dateLundi) { setErreur("Sélectionnez une équipe et une semaine."); return; }
    setErreur(null); setLoadingExp(true);
    try {
      const res = await pointagesAPI.exportExcel({ equipe_id:equipeId, date_lundi:dateLundi });
      const url = window.URL.createObjectURL(new Blob([res.data]));
      const link = document.createElement("a");
      link.href = url;
      const eq = equipes.find(e => e.id === parseInt(equipeId));
      link.setAttribute("download", `Pointage_${eq?.nom}_${chaine.replace(/\s/g,"_")}_${dateLundi}.xlsx`);
      document.body.appendChild(link); link.click(); link.remove();
      window.URL.revokeObjectURL(url);
    } catch(e) { setErreur("Erreur lors de l'export."); console.error(e); }
    setLoadingExp(false);
  }

  async function exporterExcelAM() {
    if(!equipeId || !dateLundi) { setErreur("Sélectionnez une équipe et une semaine."); return; }
    setErreur(null); setLoadingExp(true);
    try {
      const res = await pointagesAPI.exportExcelAM({ equipe_id:equipeId, date_lundi:dateLundi });
      const url = window.URL.createObjectURL(new Blob([res.data]));
      const link = document.createElement("a");
      link.href = url;
      const eq = equipes.find(e => e.id === parseInt(equipeId));
      link.setAttribute("download", `Pointage_AM_${eq?.nom}_${chaine.replace(/\s/g,"_")}_${dateLundi}.xlsx`);
      document.body.appendChild(link); link.click(); link.remove();
      window.URL.revokeObjectURL(url);
    } catch(e) { setErreur("Erreur lors de l'export AM."); console.error(e); }
    setLoadingExp(false);
  }

  async function exporterExcelPrestataire() {
    if(!equipeId || !dateLundi) return;
    setLoadingExp(true);
    try {
      const res = await pointagesAPI.exportExcelPrestataire({ equipe_id: equipeId, date_lundi: dateLundi });
      const url = window.URL.createObjectURL(new Blob([res.data]));
      const a   = document.createElement('a');
      a.href    = url;
      a.download = `Pointage_Prestataire_${dateLundi}.xlsx`;
      a.click();
    } catch(e) { setErreur("Erreur export prestataire"); }
    setLoadingExp(false);
  }

  async function exporterExcelPepiniere() {
    if(!equipeId || !dateLundi) return;
    setLoadingExp(true);
    try {
      const res = await pointagesAPI.exportExcelPepiniere({ equipe_id: equipeId, date_lundi: dateLundi });
      const url = window.URL.createObjectURL(new Blob([res.data]));
      const a   = document.createElement('a');
      a.href    = url;
      a.download = `Pointage_Pepiniere_${dateLundi}.xlsx`;
      a.click();
    } catch(e) { setErreur("Erreur export pépinière"); }
    setLoadingExp(false);
  }

  async function exporterExcelOccasionnel() {
    if(!equipeId || !dateLundi) return;
    setLoadingExp(true);
    try {
      const res = await pointagesAPI.exportExcelOccasionnel({ equipe_id: equipeId, date_lundi: dateLundi });
      const url = window.URL.createObjectURL(new Blob([res.data]));
      const a   = document.createElement('a');
      a.href    = url;
      a.download = `Pointage_Occasionnel_${dateLundi}.xlsx`;
      a.click();
    } catch(e) { setErreur("Erreur export occasionnel"); }
    setLoadingExp(false);
  }

  async function exporterPDF() {
    if(!equipeId || !dateLundi) { setErreur("Sélectionnez une équipe et une semaine."); return; }
    if(pointages.length === 0)  { setErreur("Chargez d'abord les pointages."); return; }
    const element = tableauRef.current;
    if(!element) return;
    const canvas = await html2canvas(element, { scale:2, useCORS:true, backgroundColor:'#ffffff' });
    const imgData = canvas.toDataURL('image/png');
    const pdf = new jsPDF({ orientation:'landscape', unit:'mm', format:'a3' });
    const pdfW = pdf.internal.pageSize.getWidth();
    const pdfH = pdf.internal.pageSize.getHeight();
    const ratio = Math.min(pdfW/canvas.width, pdfH/canvas.height);
    pdf.addImage(imgData,'PNG',(pdfW-canvas.width*ratio)/2,(pdfH-canvas.height*ratio)/2,canvas.width*ratio,canvas.height*ratio);
    const eq = equipes.find(e => e.id === parseInt(equipeId));
    pdf.save(`Pointage_${eq?.nom}_${dateLundi}.pdf`);
  }

  const dimanche = getDimanche(dateLundi);
  const eq       = equipes.find(e => e.id === parseInt(equipeId));
  const jours    = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"];
  const resumeParJour = dateLundi ? jours.map((jour, i) => {
    const d = new Date(dateLundi); d.setDate(d.getDate() + i);
    const dateStr = d.toISOString().split("T")[0];
    const ptg = pointages.find(p => p.date === dateStr);
    return { jour, date: dateStr, ptg };
  }) : [];

  // Filtrer les lignes selon le type de fiche
  function filtrerLignes(lignes) {
    if(!lignes) return [];
    return lignes.filter(l => {
      if(typeFiche === 'titulaires')   return l.statut_emploi === 'titulaire' || (!l.est_occasionnel && !FONCTIONS_AM.includes(l.fonction) && !['am','prestataire','pepiniere','occasionnel'].includes(l.statut_emploi));
      if(typeFiche === 'am')           return l.statut_emploi === 'am' || FONCTIONS_AM.includes(l.fonction);
      if(typeFiche === 'prestataire')  return l.statut_emploi === 'prestataire';
      if(typeFiche === 'pepiniere')    return l.statut_emploi === 'pepiniere';
      if(typeFiche === 'occasionnel')  return l.statut_emploi === 'occasionnel' || l.est_occasionnel;
      return true;
    });
  }

  return (
    <div>
      <BoutonRetour vers="/pointage" titre="Export Pointages" />

      {/* Sous-onglets */}
      <div style={{ display:'flex', gap:8, marginBottom:20, flexWrap:'wrap' }}>
        {[
          { key:"semaine",     label:"Fiche hebdomadaire" },
          { key:"rapport",     label:"Rapport AB" },
          { key:"heures_supp", label:"Heures Supplémentaires" },
        ].map(o => (
          <button key={o.key} onClick={() => setSousOnglet(o.key)} style={{
            padding:'8px 18px', borderRadius:10, border:'none', cursor:'pointer',
            fontSize:13, fontWeight:sousOnglet===o.key?700:500,
            background:sousOnglet===o.key?T.primary:T.borderSoft,
            color:sousOnglet===o.key?'#fff':T.textSoft,
          }}>
            {o.label}
          </button>
        ))}
      </div>

      {/* ── SOUS-ONGLET SEMAINE ── */}
      {sousOnglet === "semaine" && (
        <div>
          <div style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:16, padding:20, marginBottom:20 }}>
            <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit, minmax(160px, 1fr))', gap:12, marginBottom:16 }}>
              <div>
                <label style={LS}>Chaîne</label>
                <select value={chaine} onChange={e => setChaine(e.target.value)} style={IS}>
                  {CHAINES.map(c => <option key={c}>{c}</option>)}
                </select>
              </div>
              <div>
                <label style={LS}>Équipe</label>
                <select value={equipeId} onChange={e => { setEquipeId(e.target.value); setPointages([]); }} style={IS}>
                  <option value="">-- Sélectionner --</option>
                  {equipes.map(e => <option key={e.id} value={e.id}>{e.nom}</option>)}
                </select>
              </div>
              <div>
                <label style={LS}>Semaine</label>
                <input type="date" value={dateLundi} onChange={e => handleDateChange(e.target.value)} style={IS}/>
              </div>
              <div>
                <label style={LS}>Type de fiche</label>
                <select value={typeFiche} onChange={e => setTypeFiche(e.target.value)} style={IS}>
                  <option value="titulaires">Personnel titulaire</option>
                  <option value="am">Agents de maîtrise (AM)</option>
                  <option value="prestataire">Prestataires</option>
                  <option value="pepiniere">Pépinières</option>
                  <option value="occasionnel">Occasionnels</option>
                </select>
              </div>
            </div>

            {/* Badge type fiche */}
            <div style={{ marginBottom:12 }}>
              <span style={{
                display:'inline-block', maxWidth:'100%',
                fontSize:11, fontWeight:700,
                color: typeFiche==='am' ? '#F97316' :
                       typeFiche==='prestataire' ? '#8B5CF6' :
                       typeFiche==='pepiniere' ? '#06B6D4' :
                       typeFiche==='occasionnel' ? '#F59E0B' :
                       '#3B82F6',
                background: typeFiche==='am' ? 'rgba(249,115,22,0.1)' :
                            typeFiche==='prestataire' ? 'rgba(139,92,246,0.1)' :
                            typeFiche==='pepiniere' ? 'rgba(6,182,212,0.1)' :
                            typeFiche==='occasionnel' ? 'rgba(245,158,11,0.1)' :
                            'rgba(59,130,246,0.1)',
                padding:'4px 10px', borderRadius:20,
                border:`1px solid ${
                  typeFiche==='am' ? '#F97316' :
                  typeFiche==='prestataire' ? '#8B5CF6' :
                  typeFiche==='pepiniere' ? '#06B6D4' :
                  typeFiche==='occasionnel' ? '#F59E0B' :
                  '#3B82F6'
                }`,
                whiteSpace:'nowrap', overflow:'hidden', textOverflow:'ellipsis',
              }}>
                {typeFiche==='am' ? 'Mode : AM — Export fichier AM' :
                 typeFiche==='prestataire' ? 'Mode : Prestataires — Export fichier Prestataires' :
                 typeFiche==='pepiniere' ? 'Mode : Pépinières — Export fichier Pépinières' :
                 typeFiche==='occasionnel' ? 'Mode : Occasionnels — Export fichier Occasionnels' :
                 'Mode : Titulaire — Export standard'}
              </span>
            </div>

            {dateLundi && (
              <div style={{ padding:'10px 14px', borderRadius:10, background:T.borderSoft, border:`1px solid ${T.border}`, fontSize:13, color:T.text, marginBottom:16 }}>
                Semaine : <strong>{new Date(dateLundi).toLocaleDateString('fr-FR',{day:'numeric',month:'long'})}</strong> au <strong>{new Date(dimanche).toLocaleDateString('fr-FR',{day:'numeric',month:'long',year:'numeric'})}</strong>
                {eq && <> · Équipe : <strong>{eq.nom}</strong></>}
              </div>
            )}

            <div style={{ display:'flex', gap:10, flexWrap:'wrap' }}>
              <button onClick={chargerPointages} disabled={loading} style={{ background:T.primary, color:'#fff', border:'none', borderRadius:10, padding:'10px 20px', fontSize:13, fontWeight:700, cursor:'pointer', display:'flex', alignItems:'center', gap:6, opacity:loading?0.7:1 }}>
                <IconSearch size={16} color="#fff"/>
                {loading ? "Chargement..." : "Afficher la semaine"}
              </button>

              {/* Bouton export Excel selon le type */}
              <button
                onClick={
                  typeFiche === 'am' ? exporterExcelAM :
                  typeFiche === 'prestataire' ? exporterExcelPrestataire :
                  typeFiche === 'pepiniere' ? exporterExcelPepiniere :
                  typeFiche === 'occasionnel' ? exporterExcelOccasionnel :
                  exporterExcel
                }
                disabled={loadingExp||!equipeId||!dateLundi}
                style={{
                  background: (!equipeId||!dateLundi) ? T.borderSoft :
                    typeFiche==='am' ? '#F97316' :
                    typeFiche==='prestataire' ? '#8B5CF6' :
                    typeFiche==='pepiniere' ? '#06B6D4' :
                    typeFiche==='occasionnel' ? '#F59E0B' :
                    '#10B981',
                  color:(!equipeId||!dateLundi)?T.textSoft:'#fff',
                  border:`1px solid ${(!equipeId||!dateLundi)?T.border:typeFiche==='am'?'#F97316':'#10B981'}`,
                  borderRadius:10, padding:'10px 20px', fontSize:13, fontWeight:700,
                  cursor:(!equipeId||!dateLundi)?'not-allowed':'pointer',
                  display:'flex', alignItems:'center', gap:6, opacity:loadingExp?0.7:1,
                }}
              >
                <IconExport size={16} color={(!equipeId||!dateLundi)?T.textSoft:'#fff'}/>
                {loadingExp ? "Export..." : typeFiche==='am' ? "Exporter Excel AM" : "Exporter Excel"}
              </button>

              <button onClick={exporterPDF} disabled={pointages.length===0} style={{
                background:pointages.length===0?T.borderSoft:'#DA291C',
                color:pointages.length===0?T.textSoft:'#fff',
                border:`1px solid ${pointages.length===0?T.border:'#DA291C'}`,
                borderRadius:10, padding:'10px 20px', fontSize:13, fontWeight:700,
                cursor:pointages.length===0?'not-allowed':'pointer',
                display:'flex', alignItems:'center', gap:6,
              }}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill={pointages.length===0?T.textSoft:'white'}><path d="M20 2H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-8.5 7.5c0 .83-.67 1.5-1.5 1.5H9v2H7.5V7H10c.83 0 1.5.67 1.5 1.5v1zm5 2c0 .83-.67 1.5-1.5 1.5h-2.5V7H15c.83 0 1.5.67 1.5 1.5v3zm4-3H19v1h1.5V11H19v2h-1.5V7h3v1.5zM9 9.5h1v-1H9v1zM4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm10 5.5h1v-3h-1v3z"/></svg>
                Exporter PDF
              </button>
            </div>
          </div>

          {erreur && <div style={{ background:'#FEF2F2', border:'1px solid #FCA5A5', borderRadius:12, padding:'12px 16px', color:'#B91C1C', fontSize:13, marginBottom:16 }}>{erreur}</div>}

          {pointages.length > 0 && (
            <div ref={tableauRef}>
              {/* Tableau récapitulatif semaine — un seul tableau */}
              <div style={{ overflowX:'auto', background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:20 }}>

                {/* En-tête info semaine */}
                <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:16, flexWrap:'wrap', gap:8 }}>
                  <div>
                    <p style={{ fontSize:14, fontWeight:700, color:T.text, margin:'0 0 4px' }}>
                      {eq?.nom} · {chaine}
                    </p>
                    <p style={{ fontSize:12, color:T.textSoft, margin:0 }}>
                      Semaine du {new Date(dateLundi).toLocaleDateString('fr-FR',{day:'numeric',month:'long'})} au {new Date(dimanche).toLocaleDateString('fr-FR',{day:'numeric',month:'long',year:'numeric'})}
                    </p>
                  </div>
                  <div style={{ display:'flex', gap:12 }}>
                    {(() => {
                      const toutesLignes = pointages.flatMap(p => filtrerLignes(p.lignes));
                      const membres = [...new Map(toutesLignes.map(l => [l.membre_id||l.nom_prenom, l])).values()];
                      const presentsTotal = toutesLignes.filter(l => l.presence==='P').length;
                      const absentsTotal  = toutesLignes.filter(l => ['AB','AA','R','RM','CP'].includes(l.presence)).length;
                      return (
                        <>
                          <span style={{ fontSize:12, color:'#10B981', fontWeight:700 }}>{membres.length} membres</span>
                          <span style={{ fontSize:12, color:'#3B82F6', fontWeight:700 }}>{presentsTotal} présences</span>
                          <span style={{ fontSize:12, color:'#EF4444', fontWeight:700 }}>{absentsTotal} absences/repos</span>
                        </>
                      );
                    })()}
                  </div>
                </div>

                <table style={{ width:'100%', borderCollapse:'collapse', fontSize:11, color:T.text }}>
                  <thead>
                    <tr style={{ background:dark?'#1E293B':'#F1F5F9' }}>
                      <th style={{ padding:'8px 10px', textAlign:'left', fontWeight:700, color:T.textSoft, fontSize:10, whiteSpace:'nowrap', borderBottom:`2px solid ${T.border}`, minWidth:30 }}>#</th>
                      <th style={{ padding:'8px 10px', textAlign:'left', fontWeight:700, color:T.textSoft, fontSize:10, whiteSpace:'nowrap', borderBottom:`2px solid ${T.border}`, minWidth:120 }}>Nom et Prénom</th>
                      <th style={{ padding:'8px 10px', textAlign:'left', fontWeight:700, color:T.textSoft, fontSize:10, whiteSpace:'nowrap', borderBottom:`2px solid ${T.border}`, minWidth:140 }}>Fonction</th>
                      {resumeParJour.map(({ jour, date }) => (
                        <th key={jour} style={{
                          padding:'8px 6px', textAlign:'center', fontWeight:700,
                          color:T.textSoft, fontSize:10, whiteSpace:'nowrap',
                           borderBottom:`2px solid ${T.border}`, minWidth:60,
                        }}>
                          <div>{jour}</div>
                          <div style={{ fontSize:9, fontWeight:400, color:T.textMuted }}>
                            {new Date(date).toLocaleDateString('fr-FR',{day:'numeric',month:'short'})}
                          </div>
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {(() => {
                      // Construire la liste unique des membres à afficher
                      const toutesLignes = pointages.flatMap(p => filtrerLignes(p.lignes));
                      const membresMap = new Map();
                      toutesLignes.forEach(l => {
                        const cle = l.membre_id || l.nom_prenom;
                        if(!membresMap.has(cle)) membresMap.set(cle, { ...l });
                      });
                      const membres = [...membresMap.values()];

                      // Pour chaque membre, trouver sa présence par jour
                      return membres.map((m, i) => {
                        const presenceParJour = resumeParJour.map(({ date }) => {
                          const ptg = pointages.find(p => p.date === date);
                          if(!ptg) return null;
                          const lg = filtrerLignes(ptg.lignes).find(l =>
                            l.membre_id ? l.membre_id === m.membre_id : l.nom_prenom === m.nom_prenom
                          );
                          return lg || null;
                        });

                        return (
                          <tr key={i} style={{
                            borderBottom:`1px solid ${T.border}`,
                            background:i%2===0?'transparent':dark?'rgba(255,255,255,0.02)':'rgba(0,0,0,0.01)',
                          }}>
                            <td style={{ padding:'7px 10px', color:T.textMuted, fontSize:11 }}>{i+1}</td>
                            <td style={{ padding:'7px 10px', fontWeight:700, fontSize:11, whiteSpace:'nowrap' }}>{m.nom_prenom}</td>
                            <td style={{ padding:'7px 10px', fontSize:10, color:T.textSoft, whiteSpace:'nowrap' }}>{m.fonction}</td>
                            {presenceParJour.map((lg, j) => (
                              <td key={j} style={{ padding:'5px 6px', textAlign:'center' }}>
                                {lg ? (
                                  <span style={{
                                    display:'inline-block',
                                    fontSize:10, fontWeight:700,
                                    padding:'2px 6px', borderRadius:6,
                                    color: lg.presence==='P'  ? '#10B981'
                                         : lg.presence==='AB' ? '#EF4444'
                                         : lg.presence==='AA' ? '#F97316'
                                         : lg.presence==='RM' ? '#8B5CF6'
                                         : '#F59E0B',
                                    background: lg.presence==='P'  ? 'rgba(16,185,129,0.1)'
                                              : lg.presence==='AB' ? 'rgba(239,68,68,0.1)'
                                              : lg.presence==='AA' ? 'rgba(249,115,22,0.1)'
                                              : lg.presence==='RM' ? 'rgba(139,92,246,0.1)'
                                              : 'rgba(245,158,11,0.1)',
                                  }}>
                                    {lg.presence==='P' ? `${lg.heures_N||''}h` : lg.presence}
                                  </span>
                                ) : (
                                  <span style={{ fontSize:10, color:T.borderSoft }}>—</span>
                                )}
                              </td>
                            ))}
                          </tr>
                        );
                      });
                    })()}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </div>
      )}

      {/* ── SOUS-ONGLET RAPPORT AB ── */}
      {sousOnglet === "rapport" && <SectionRapportAB T={T} dark={dark}/>}

      {/* ── SOUS-ONGLET HEURES SUPP ── */}
      {sousOnglet === "heures_supp" && <SectionHeuresSupp T={T} dark={dark}/>}
    </div>
  );
}


// ── SECTION RAPPORT AB ────────────────────────────────────
function SectionRapportAB({ T, dark }) {
  const [dateDebut, setDateDebut] = useState("");
  const [dateFin,   setDateFin]   = useState("");
  const [chaine,    setChaine]    = useState("");
  const [rapport,   setRapport]   = useState([]);
  const [loading,   setLoading]   = useState(false);
  const [erreur,    setErreur]    = useState(null);

  const CHAINES_OPT = ["","Chaîne 8","Chaîne 13","Chaîne 14","Chaîne 15","Chaîne 16"];
  const IS = { background:T.card, border:`1px solid ${T.border}`, borderRadius:10, padding:'8px 12px', color:T.text, fontSize:13, width:'100%' };
  const LS = { fontSize:11, fontWeight:700, color:T.textSoft, textTransform:'uppercase', letterSpacing:0.8, marginBottom:4, display:'block' };

  async function charger() {
    if(!dateDebut || !dateFin) { setErreur("Sélectionnez une période."); return; }
    setErreur(null); setLoading(true);
    try {
      const params = { date_debut:dateDebut, date_fin:dateFin };
      if(chaine) params.chaine = chaine;
      const res = await pointagesAPI.rapportAB(params);
      setRapport(res.data);
      if(res.data.length === 0) setErreur("Aucune absence non justifiée sur cette période.");
    } catch(e) { setErreur("Erreur lors du chargement."); }
    setLoading(false);
  }

  function exporterExcelAB() {
    if(!rapport.length) return;
    const wb = XLSX.utils.book_new();
    const rows = [];
    rapport.forEach(r => {
      r.details.forEach(d => {
        rows.push({
          "Nom et Prénom": r.nom_prenom, "Fonction": r.fonction,
          "Chaîne": r.chaine, "Équipe": r.equipe_nom,
          "Date": d.date, "Jour": d.jour, "Quart": d.quart,
          "Nb AB total": r.nb_absences, "Heures abs. tot": r.heures_total,
        });
      });
    });
    const ws = XLSX.utils.json_to_sheet(rows);
    ws["!cols"] = Object.keys(rows[0]).map(() => ({ wch:18 }));
    XLSX.utils.book_append_sheet(wb, ws, "Rapport AB");
    XLSX.writeFile(wb, `Rapport_AB_${dateDebut}_${dateFin}.xlsx`);
  }

  const totalAB     = rapport.reduce((s,r) => s + r.nb_absences,  0);
  const totalHeures = rapport.reduce((s,r) => s + r.heures_total, 0);

  return (
    <div>
      <div style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:16, marginBottom:20 }}>
        <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(150px,1fr))', gap:12, marginBottom:12 }}>
          <div><label style={LS}>Date début</label><input type="date" value={dateDebut} onChange={e=>setDateDebut(e.target.value)} style={IS}/></div>
          <div><label style={LS}>Date fin</label><input type="date" value={dateFin} onChange={e=>setDateFin(e.target.value)} style={IS}/></div>
          <div><label style={LS}>Chaîne (optionnel)</label>
            <select value={chaine} onChange={e=>setChaine(e.target.value)} style={IS}>
              {CHAINES_OPT.map(c=><option key={c} value={c}>{c||"Toutes"}</option>)}
            </select>
          </div>
        </div>
        <div style={{ display:'flex', gap:10 }}>
          <button onClick={charger} disabled={loading} style={{ background:T.primary, color:'#fff', border:'none', borderRadius:10, padding:'10px 20px', fontSize:13, fontWeight:700, cursor:'pointer' }}>
            {loading ? "Chargement..." : "Générer le rapport"}
          </button>
          {rapport.length > 0 && (
            <button onClick={exporterExcelAB} style={{ background:'#10B981', color:'#fff', border:'none', borderRadius:10, padding:'10px 20px', fontSize:13, fontWeight:700, cursor:'pointer' }}>
              Exporter Excel
            </button>
          )}
        </div>
      </div>

      {erreur && <div style={{ background:'#FEF2F2', border:'1px solid #FCA5A5', borderRadius:12, padding:'12px 16px', color:'#B91C1C', fontSize:13, marginBottom:16 }}>{erreur}</div>}

      {rapport.length > 0 && (
        <>
          <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(160px,1fr))', gap:12, marginBottom:20 }}>
            {[
              { label:"Employés avec AB",    value:rapport.length, color:'#EF4444' },
              { label:"Total absences AB",   value:totalAB,        color:'#F97316' },
              { label:"Total heures perdues",value:`${totalHeures}h`, color:'#8B5CF6' },
            ].map(c => (
              <div key={c.label} style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:'16px', borderLeft:`4px solid ${c.color}` }}>
                <div style={{ fontSize:28, fontWeight:800, color:c.color }}>{c.value}</div>
                <div style={{ fontSize:12, color:T.textSoft, marginTop:4 }}>{c.label}</div>
              </div>
            ))}
          </div>
          <div style={{ overflowX:'auto' }}>
            <table style={{ width:'100%', borderCollapse:'collapse', fontSize:12, color:T.text }}>
              <thead>
                <tr style={{ background:dark?'#1E293B':'#F1F5F9' }}>
                  {["Nom et Prénom","Fonction","Chaîne","Équipe","Nb AB","Heures abs.","Détail jours"].map(h=>(
                    <th key={h} style={{ padding:'8px 10px', textAlign:'left', fontWeight:700, color:T.textSoft, fontSize:11, whiteSpace:'nowrap', borderBottom:`2px solid ${T.border}` }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {rapport.map((r,i) => (
                  <tr key={i} style={{ borderBottom:`1px solid ${T.border}`, background:i%2===0?'transparent':dark?'rgba(255,255,255,0.02)':'rgba(0,0,0,0.01)' }}>
                    <td style={{ padding:'8px 10px', fontWeight:700 }}>{r.nom_prenom}</td>
                    <td style={{ padding:'8px 10px' }}>{r.fonction}</td>
                    <td style={{ padding:'8px 10px' }}>{r.chaine}</td>
                    <td style={{ padding:'8px 10px' }}>{r.equipe_nom}</td>
                    <td style={{ padding:'8px 10px' }}><span style={{ fontSize:12, fontWeight:800, color:'#EF4444', background:'rgba(239,68,68,0.1)', padding:'3px 10px', borderRadius:20 }}>{r.nb_absences}</span></td>
                    <td style={{ padding:'8px 10px', fontWeight:700, color:'#8B5CF6' }}>{r.heures_total}h</td>
                    <td style={{ padding:'8px 10px', color:T.textSoft, fontSize:11 }}>
                      {r.details.map((d,j) => <div key={j}>{d.date} — {d.quart}</div>)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}
    </div>
  );
}

// ── SECTION HEURES SUPPLÉMENTAIRES ───────────────────────
function SectionHeuresSupp({ T, dark }) {
  const [dateLundi,  setDateLundi]  = useState("");
  const [rapport,    setRapport]    = useState({ parChaine:{}, tous:[] });
  const [loading,    setLoading]    = useState(false);
  const [loadingPDF, setLoadingPDF] = useState(false);
  const [erreur,     setErreur]     = useState(null);
  const tableauRef = useRef(null);

  const IS = { background:T.card, border:`1px solid ${T.border}`, borderRadius:10, padding:'8px 12px', color:T.text, fontSize:13, width:'100%' };
  const LS = { fontSize:11, fontWeight:700, color:T.textSoft, textTransform:'uppercase', letterSpacing:0.8, marginBottom:4, display:'block' };

  useEffect(() => {
    const d = new Date(); const jour = d.getDay();
    const diff = jour === 0 ? -6 : 1 - jour;
    d.setDate(d.getDate() + diff);
    setDateLundi(d.toISOString().split("T")[0]);
  }, []);

  function getDimanche(lundi) {
    if(!lundi) return "";
    const d = new Date(lundi); d.setDate(d.getDate() + 6);
    return d.toISOString().split("T")[0];
  }

  function handleDateChange(val) {
    const d = new Date(val); const jour = d.getDay();
    const diff = jour === 0 ? -6 : 1 - jour;
    d.setDate(d.getDate() + diff);
    setDateLundi(d.toISOString().split("T")[0]);
    setRapport({ parChaine:{}, tous:[] });
  }

  async function charger() {
    if(!dateLundi) { setErreur("Sélectionnez une semaine."); return; }
    setErreur(null); setLoading(true);
    try {
      const dimanche = getDimanche(dateLundi);
      const res = await pointagesAPI.lister({ date_debut:dateLundi, date_fin:dimanche });

      const parMembre = {};
      for(const ptg of res.data) {
        const chaine = ptg.chaine || "Inconnu";
        for(const lg of ptg.lignes || []) {
          if(lg.est_occasionnel) continue;
          const cle = `${lg.membre_id}`;
          if(!parMembre[cle]) {
            parMembre[cle] = {
              membre_id:lg.membre_id, nom_prenom:lg.nom_prenom,
              fonction:lg.fonction, statut:lg.statut_emploi,
              chaine, equipe:ptg.equipe_nom||"",
              heures_N:0, heures_F:0, heures_PN:0,
            };
          }
          parMembre[cle].heures_N  += lg.heures_N  || 0;
          parMembre[cle].heures_F  += lg.heures_F  || 0;
          parMembre[cle].heures_PN += lg.heures_PN || 0;
        }
      }

      const membres = Object.values(parMembre).map(m => {
        const ht = m.heures_N + m.heures_F;
        const hs = Math.max(0, ht - 40);
        const hn = ht - hs;
        return { ...m, ht, hs, hn };
      }).filter(m => m.hs > 0);

      const parChaineResult = {};
      for(const m of membres) {
        if(!parChaineResult[m.chaine]) parChaineResult[m.chaine] = [];
        parChaineResult[m.chaine].push(m);
      }

      setRapport({ parChaine:parChaineResult, tous:membres });
      if(membres.length === 0) setErreur("Aucune heure supplémentaire trouvée pour cette semaine.");
    } catch(e) { setErreur("Erreur lors du chargement."); console.error(e); }
    setLoading(false);
  }

  async function exporterPDF() {
    if(!tableauRef.current) return;
    setLoadingPDF(true);
    const canvas = await html2canvas(tableauRef.current, { scale:2, useCORS:true, backgroundColor:'#ffffff' });
    const imgData = canvas.toDataURL('image/png');
    const pdf = new jsPDF({ orientation:'landscape', unit:'mm', format:'a3' });
    const pdfW = pdf.internal.pageSize.getWidth();
    const pdfH = pdf.internal.pageSize.getHeight();
    const ratio = Math.min(pdfW/canvas.width, pdfH/canvas.height);
    pdf.addImage(imgData,'PNG',(pdfW-canvas.width*ratio)/2,(pdfH-canvas.height*ratio)/2,canvas.width*ratio,canvas.height*ratio);
    pdf.save(`Heures_Supp_SEM_${dateLundi}.pdf`);
    setLoadingPDF(false);
  }

  const dimanche = getDimanche(dateLundi);
  const totalHS  = rapport.tous.reduce((s,m) => s + m.hs, 0);
  const totalHN  = rapport.tous.reduce((s,m) => s + m.hn, 0);

  const TableauHS = ({ membres, titre, couleur }) => (
    <div style={{ marginBottom:20 }}>
      <div style={{
        background:couleur||T.primary, color:'#fff',
        padding:'10px 16px', borderRadius:'10px 10px 0 0',
        fontSize:13, fontWeight:700,
        display:'flex', justifyContent:'space-between', alignItems:'center',
      }}>
        <span>{titre}</span>
        <span style={{ fontSize:12 }}>
          {membres.length} employé(s) · HS total : <strong>{membres.reduce((s,m)=>s+m.hs,0)}h</strong>
        </span>
      </div>
      <div style={{ overflowX:'auto', border:`1px solid ${T.border}`, borderTop:'none', borderRadius:'0 0 10px 10px' }}>
        <table style={{ width:'100%', borderCollapse:'collapse', fontSize:12, color:T.text }}>
          <thead>
            <tr style={{ background:dark?'#1E293B':'#F1F5F9' }}>
              {["#","Nom et Prénom","Fonction","Équipe","H. Travaillées","H. Normales (HN)","H. Supp (HS)","Total"].map(h=>(
                <th key={h} style={{ padding:'8px 12px', textAlign:'left', fontWeight:700, color:T.textSoft, fontSize:11, whiteSpace:'nowrap', borderBottom:`2px solid ${T.border}` }}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {membres.map((m,i) => (
              <tr key={i} style={{ borderBottom:`1px solid ${T.border}`, background:i%2===0?'transparent':dark?'rgba(255,255,255,0.02)':'rgba(0,0,0,0.01)' }}>
                <td style={{ padding:'8px 12px', color:T.textMuted }}>{i+1}</td>
                <td style={{ padding:'8px 12px', fontWeight:700 }}>{m.nom_prenom}</td>
                <td style={{ padding:'8px 12px' }}>{m.fonction}</td>
                <td style={{ padding:'8px 12px', color:T.textSoft }}>{m.equipe}</td>
                <td style={{ padding:'8px 12px', textAlign:'center', fontWeight:600 }}>{m.ht}h</td>
                <td style={{ padding:'8px 12px', textAlign:'center', color:'#10B981', fontWeight:700 }}>{m.hn}h</td>
                <td style={{ padding:'8px 12px', textAlign:'center' }}>
                  <span style={{ background:'rgba(239,68,68,0.1)', color:'#EF4444', padding:'3px 12px', borderRadius:20, fontWeight:800, fontSize:13 }}>+{m.hs}h</span>
                </td>
                <td style={{ padding:'8px 12px', textAlign:'center', fontWeight:700, color:T.primary }}>{m.ht}h</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );

  return (
    <div>
      {/* Filtres */}
      <div style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:16, marginBottom:20 }}>
        <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(200px,1fr))', gap:12, marginBottom:12 }}>
          <div>
            <label style={LS}>Semaine (choisir n'importe quel jour)</label>
            <input type="date" value={dateLundi} onChange={e => handleDateChange(e.target.value)} style={IS}/>
          </div>
        </div>
        {dateLundi && (
          <div style={{ fontSize:13, color:T.text, marginBottom:12, padding:'8px 12px', background:T.borderSoft, borderRadius:8, border:`1px solid ${T.border}` }}>
            Semaine du <strong>{new Date(dateLundi).toLocaleDateString('fr-FR',{day:'numeric',month:'long'})}</strong> au <strong>{new Date(dimanche).toLocaleDateString('fr-FR',{day:'numeric',month:'long',year:'numeric'})}</strong>
          </div>
        )}
        <div style={{ display:'flex', gap:10, flexWrap:'wrap' }}>
          <button onClick={charger} disabled={loading} style={{ background:T.primary, color:'#fff', border:'none', borderRadius:10, padding:'10px 20px', fontSize:13, fontWeight:700, cursor:'pointer', opacity:loading?0.7:1 }}>
            {loading ? "Chargement..." : "Générer le rapport"}
          </button>
          {rapport.tous.length > 0 && (
            <button onClick={exporterPDF} disabled={loadingPDF} style={{ background:'#DA291C', color:'#fff', border:'none', borderRadius:10, padding:'10px 20px', fontSize:13, fontWeight:700, cursor:'pointer', opacity:loadingPDF?0.7:1, display:'flex', alignItems:'center', gap:6 }}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="white"><path d="M20 2H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-8.5 7.5c0 .83-.67 1.5-1.5 1.5H9v2H7.5V7H10c.83 0 1.5.67 1.5 1.5v1zm5 2c0 .83-.67 1.5-1.5 1.5h-2.5V7H15c.83 0 1.5.67 1.5 1.5v3zm4-3H19v1h1.5V11H19v2h-1.5V7h3v1.5zM9 9.5h1v-1H9v1zM4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm10 5.5h1v-3h-1v3z"/></svg>
              {loadingPDF ? "Export..." : "Exporter PDF"}
            </button>
          )}
        </div>
      </div>

      {erreur && <div style={{ background:'#FEF2F2', border:'1px solid #FCA5A5', borderRadius:12, padding:'12px 16px', color:'#B91C1C', fontSize:13, marginBottom:16 }}>{erreur}</div>}

      {rapport.tous.length > 0 && (
        <div ref={tableauRef}>
          {/* Cartes résumé */}
          <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(180px,1fr))', gap:12, marginBottom:24 }}>
            {[
              { label:"Employés avec HS",   value:rapport.tous.length,                    color:'#F97316' },
              { label:"Total Heures Norm",  value:`${totalHN}h`,                          color:'#10B981' },
              { label:"Total Heures Supp",  value:`${totalHS}h`,                          color:'#EF4444' },
              { label:"Chaînes concernées", value:Object.keys(rapport.parChaine).length,  color:T.primary },
            ].map(c => (
              <div key={c.label} style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:'16px', borderLeft:`4px solid ${c.color}` }}>
                <div style={{ fontSize:28, fontWeight:800, color:c.color }}>{c.value}</div>
                <div style={{ fontSize:12, color:T.textSoft, marginTop:4 }}>{c.label}</div>
              </div>
            ))}
          </div>

          {/* Par chaîne */}
          <p style={{ fontSize:14, fontWeight:700, color:T.text, marginBottom:12 }}>Détail par chaîne</p>
          {CHAINES.filter(c => rapport.parChaine[c]?.length > 0).map(chaine => (
            <TableauHS key={chaine} titre={chaine} membres={rapport.parChaine[chaine]} couleur={T.primary}/>
          ))}

          {/* Global */}
          <div style={{ borderTop:`2px solid ${T.border}`, paddingTop:20, marginTop:8 }}>
            <p style={{ fontSize:14, fontWeight:700, color:T.text, marginBottom:12 }}>Vue globale — Toutes chaînes</p>
            <TableauHS titre="Toutes les chaînes combinées" membres={rapport.tous} couleur="#1E293B"/>
          </div>
        </div>
      )}
    </div>
  );
}
