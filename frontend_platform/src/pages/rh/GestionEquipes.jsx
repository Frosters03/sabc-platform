import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useTheme } from "../../components/layout/Layout";
import { equipesAPI } from "../../services/api";

const CHAINES = ["Chaîne 8","Chaîne 13","Chaîne 14","Chaîne 15","Chaîne 16"];

const FONCTIONS_AM = ["Agent de maîtrise"];

const CATEGORIES_SPECIALES = [
  { key:"am",          label:"Agent de maîtrise", color:"#F97316", bg:"rgba(249,115,22,0.1)",  max:6  },
  { key:"prestataire", label:"Prestataire",        color:"#8B5CF6", bg:"rgba(139,92,246,0.1)", max:null },
  { key:"pepiniere",   label:"Pépinière",           color:"#06B6D4", bg:"rgba(6,182,212,0.1)", max:null },
  { key:"occasionnel", label:"Occasionnel",         color:"#F59E0B", bg:"rgba(245,158,11,0.1)",max:null },
];

const FONCTIONS_TITULAIRES = [
  "Conducteur dépalettiseur",
  "Conducteur décaisseuse",
  "Conducteur laveuse",
  "Conducteur EBI/Mireuse",
  "Conducteur soutireuse",
  "Conducteur pasteurisateur",
  "Conducteur étiquetteuse",
  "Assistant conducteur étiquetteuse",
  "Conducteur encaisseuse",
  "Conducteur palettiseur",
  "Cariste 1","Cariste 2","Cariste 3","Cariste 4",
];

const IconAdd    = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>;
const IconBack   = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>;

// ── HEADER SOUS-PAGE ──────────────────────────────────────
function SousPageHeader({ titre, setPage, T }) {
  return (
    <div style={{ display:'flex', alignItems:'center', gap:12, marginBottom:20, paddingBottom:16, borderBottom:`1px solid ${T.border}` }}>
      <button onClick={() => setPage("accueil")} style={{
        background:T.borderSoft, border:`1px solid ${T.border}`, borderRadius:10,
        width:36, height:36, display:'flex', alignItems:'center', justifyContent:'center',
        cursor:'pointer', flexShrink:0,
      }}>
        <IconBack size={18} color={T.textSoft}/>
      </button>
      <p style={{ fontSize:16, fontWeight:700, color:T.text, margin:0 }}>{titre}</p>
    </div>
  );
}

function OngletEquipes({ T, dark, setPage }) {
  const [equipes,  setEquipes]  = useState([]);
  const [loading,  setLoading]  = useState(true);
  const [selected, setSelected] = useState(null);
  const [modalEq,  setModalEq]  = useState(null);
  const [modalMb,  setModalMb]  = useState(null);
  const [formEq,   setFormEq]   = useState({ nom:'', chaine:'Chaîne 8' });
  const [formMb, setFormMb] = useState({ fonction:'', nom_prenom:'', matricule:'', statut:'titulaire', ordre:0, date_naissance:'', lieu_naissance:'', cnps:'', categorie_pro:'', salaire_horaire:null });
  const [erreur,   setErreur]   = useState(null);
  const [succes,   setSucces]   = useState(null);

  const IS = { background:T.card, border:`1px solid ${T.border}`, borderRadius:10, padding:'8px 12px', color:T.text, fontSize:13, width:'100%' };
  const LS = { fontSize:11, fontWeight:700, color:T.textSoft, textTransform:'uppercase', letterSpacing:0.8, marginBottom:4, display:'block' };

  useEffect(() => { charger(); }, []);

  useEffect(() => {
    if(selected && equipes.length > 0) {
      const updated = equipes.find(e => e.id === selected.id);
      if(updated) setSelected(updated);
    }
  }, [equipes]);

  async function charger() {
    setLoading(true);
    try {
      const res = await equipesAPI.lister();
      setEquipes(res.data);
      if(res.data.length > 0 && !selected) setSelected(res.data[0]);
    } catch(e) { setErreur("Erreur chargement"); }
    setLoading(false);
  }

  async function sauvegarderEquipe() {
    setErreur(null);
    try {
      if(modalEq === "create") { await equipesAPI.creer(formEq); setSucces(`Équipe "${formEq.nom}" créée`); }
      else { await equipesAPI.modifier(modalEq.id, formEq); setSucces("Équipe modifiée"); }
      setModalEq(null); charger();
    } catch(e) { setErreur(e.response?.data?.detail || "Erreur"); }
  }

  async function supprimerEquipe(eq) {
    if(!window.confirm(`Supprimer "${eq.nom}" ?`)) return;
    try { await equipesAPI.supprimer(eq.id); setSucces("Équipe supprimée"); setSelected(null); charger(); }
    catch(e) { setErreur(e.response?.data?.detail || "Erreur"); }
  }

  async function sauvegarderMembre() {
    setErreur(null);
    if(!selected) return;
    const statutFinal = formMb.statut || 'titulaire';
    try {
      if(modalMb === "create") {
        await equipesAPI.ajouterMembre(selected.id, { ...formMb, statut: statutFinal, ordre: selected.membres.length });
        setSucces(`Membre "${formMb.nom_prenom}" ajouté`);
      } else {
        await equipesAPI.modifierMembre(selected.id, modalMb.id, { ...formMb, statut: statutFinal });
        setSucces("Membre modifié");
      }
      setModalMb(null); charger();
    } catch(e) { setErreur(e.response?.data?.detail || "Erreur"); }
  }

  async function supprimerMembre(mb) {
    try { await equipesAPI.supprimerMembre(selected.id, mb.id); setSucces("Membre retiré"); charger(); }
    catch(e) { setErreur(e.response?.data?.detail || "Erreur suppression"); }
  }

  const membresTries = selected
    ? [...selected.membres].filter(m => m.actif !== false).sort((a,b) => a.ordre - b.ordre)
    : [];
  const membresAM     = membresTries.filter(m => FONCTIONS_AM.includes(m.fonction));
  const membresTit    = membresTries.filter(m => !FONCTIONS_AM.includes(m.fonction));

  return (
    <div>
      <SousPageHeader titre="Gestion des équipes" setPage={setPage} T={T}/>
      {succes && <div style={{ background:'#F0FDF4', border:'1px solid #86EFAC', borderRadius:10, padding:'10px 14px', color:'#166534', fontSize:13, marginBottom:12 }}>{succes}</div>}
      {erreur && <div style={{ background:'#FEF2F2', border:'1px solid #FCA5A5', borderRadius:10, padding:'10px 14px', color:'#B91C1C', fontSize:13, marginBottom:12 }}>{erreur}</div>}

      <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit, minmax(250px, 1fr))', gap:16 }}>
        {/* Liste équipes */}
        <div>
          <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:10 }}>
            <p style={{ fontSize:13, fontWeight:700, color:T.text, margin:0 }}>{equipes.length} équipe(s)</p>
            <button onClick={() => { setFormEq({nom:'',chaine:'Chaîne 8'}); setModalEq("create"); }} style={{ background:T.primary, color:'#fff', border:'none', borderRadius:8, padding:'6px 12px', fontSize:12, fontWeight:700, cursor:'pointer' }}>+ Créer</button>
          </div>
          {loading ? <div style={{ textAlign:'center', padding:20, color:T.textSoft }}>Chargement...</div> : (
            <div style={{ display:'flex', flexDirection:'column', gap:6 }}>
              {equipes.map(eq => (
                <button key={eq.id} onClick={() => setSelected(eq)} style={{
                  background: selected?.id===eq.id ? T.primary+'22' : T.card,
                  border:`1px solid ${selected?.id===eq.id ? T.primary : T.border}`,
                  borderRadius:10, padding:'10px 12px', cursor:'pointer', textAlign:'left',
                  display:'flex', flexDirection:'column', gap:3,
                }}>
                  <span style={{ fontSize:13, fontWeight:700, color:selected?.id===eq.id?T.primary:T.text }}>{eq.nom}</span>
                  <span style={{ fontSize:11, color:T.textSoft }}>{eq.chaine} · {eq.membres.length} membres</span>
                </button>
              ))}
              {equipes.length === 0 && <p style={{ fontSize:12, color:T.textSoft, textAlign:'center', padding:20 }}>Aucune équipe. Créez-en une.</p>}
            </div>
          )}
        </div>

        {/* Détail équipe */}
        <div>
          {selected ? (
            <div style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:20 }}>
              <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:16 }}>
                <div>
                  <p style={{ fontSize:16, fontWeight:700, color:T.text, margin:'0 0 4px' }}>{selected.nom}</p>
                  <p style={{ fontSize:12, color:T.textSoft, margin:0 }}>
                    {selected.chaine} ·{' '}
                    <span style={{ color:'#F97316', fontWeight:700 }}>{membresAM.length} AM</span>
                    {' · '}
                    <span style={{ color:'#3B82F6', fontWeight:700 }}>{membresTit.length}/14 titulaires</span>
                  </p>
                </div>
                <div style={{ display:'flex', gap:8 }}>
                  <button onClick={() => { setFormEq({nom:selected.nom,chaine:selected.chaine}); setModalEq(selected); }} style={{ background:T.borderSoft, border:`1px solid ${T.border}`, borderRadius:8, padding:'6px 12px', fontSize:12, fontWeight:600, color:T.text, cursor:'pointer' }}>Modifier</button>
                  <button onClick={() => supprimerEquipe(selected)} style={{ background:'#FEF2F2', border:'1px solid #FECACA', borderRadius:8, padding:'6px 12px', fontSize:12, fontWeight:600, color:'#B91C1C', cursor:'pointer' }}>Supprimer</button>
                </div>
              </div>

              {/* Tableau membres AM en premier */}
              {membresAM.length > 0 && (
                <div style={{ marginBottom:16 }}>
                  <div style={{ display:'flex', alignItems:'center', gap:8, marginBottom:8 }}>
                    <span style={{ fontSize:12, fontWeight:700, color:'#F97316', background:'rgba(249,115,22,0.1)', padding:'3px 10px', borderRadius:20 }}>
                      Agents de maîtrise ({membresAM.length})
                    </span>
                  </div>
                  <div style={{ overflowX:'auto' }}>
                    <table style={{ width:'100%', borderCollapse:'collapse', fontSize:12, color:T.text }}>
                      <thead>
                        <tr style={{ background:dark?'#1E293B':'#FFF7ED' }}>
                          {["#","Nom et Prénom","Matricule","Actions"].map(h => (
                            <th key={h} style={{ padding:'8px 10px', textAlign:'left', fontWeight:700, color:'#F97316', fontSize:11, whiteSpace:'nowrap', borderBottom:`2px solid #F97316` }}>{h}</th>
                          ))}
                        </tr>
                      </thead>
                      <tbody>
                        {membresAM.map((m,i) => (
                          <tr key={m.id} style={{ borderBottom:`1px solid ${T.border}`, background:i%2===0?'transparent':'rgba(249,115,22,0.03)' }}>
                            <td style={{ padding:'8px 10px', color:T.textMuted }}>{i+1}</td>
                            <td style={{ padding:'8px 10px', fontWeight:700 }}>{m.nom_prenom} <span style={{ fontSize:10, color:'#F97316', marginLeft:4 }}>{m.matricule||''}</span></td>
                            <td style={{ padding:'8px 10px', color:T.textSoft }}>{m.matricule||'—'}</td>
                            <td style={{ padding:'8px 10px' }}>
                              <div style={{ display:'flex', gap:6 }}>
                                <button onClick={() => { setFormMb({fonction:m.fonction,nom_prenom:m.nom_prenom,matricule:m.matricule||'',statut:m.statut,ordre:m.ordre}); setModalMb(m); }} style={{ background:T.borderSoft, border:`1px solid ${T.border}`, borderRadius:6, padding:'4px 8px', fontSize:11, fontWeight:600, color:T.text, cursor:'pointer' }}>Modifier</button>
                                <button onClick={() => supprimerMembre(m)} style={{ background:'#FEF2F2', border:'1px solid #FECACA', borderRadius:6, padding:'4px 8px', fontSize:11, fontWeight:600, color:'#B91C1C', cursor:'pointer' }}>Retirer</button>
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              )}

              {/* Tableau membres titulaires */}
              <div style={{ marginBottom:12 }}>
                {membresTit.length > 0 && (
                  <div style={{ display:'flex', alignItems:'center', gap:8, marginBottom:8 }}>
                    <span style={{ fontSize:12, fontWeight:700, color:'#3B82F6', background:'rgba(59,130,246,0.1)', padding:'3px 10px', borderRadius:20 }}>
                      Personnel titulaire ({membresTit.length}/14)
                    </span>
                  </div>
                )}
                <div style={{ overflowX:'auto' }}>
                  <table style={{ width:'100%', borderCollapse:'collapse', fontSize:12, color:T.text }}>
                    <thead>
                      <tr style={{ background:dark?'#1E293B':'#F1F5F9' }}>
                        {["#","Fonction","Nom et Prénom","Matricule","Actions"].map(h => (
                          <th key={h} style={{ padding:'8px 10px', textAlign:'left', fontWeight:700, color:T.textSoft, fontSize:11, whiteSpace:'nowrap', borderBottom:`2px solid ${T.border}` }}>{h}</th>
                        ))}
                      </tr>
                    </thead>
                    <tbody>
                      {membresTit.map((m,i) => (
                        <tr key={m.id} style={{ borderBottom:`1px solid ${T.border}`, background:i%2===0?'transparent':dark?'rgba(255,255,255,0.02)':'rgba(0,0,0,0.01)' }}>
                          <td style={{ padding:'8px 10px', color:T.textMuted }}>{i+1}</td>
                          <td style={{ padding:'8px 10px', fontWeight:500 }}>{m.fonction}</td>
                          <td style={{ padding:'8px 10px', fontWeight:600 }}>{m.nom_prenom}</td>
                          <td style={{ padding:'8px 10px', color:T.textSoft }}>{m.matricule||'—'}</td>
                          <td style={{ padding:'8px 10px' }}>
                            <div style={{ display:'flex', gap:6 }}>
                              <button onClick={() => { setFormMb({fonction:m.fonction,nom_prenom:m.nom_prenom,matricule:m.matricule||'',statut:m.statut,ordre:m.ordre}); setModalMb(m); }} style={{ background:T.borderSoft, border:`1px solid ${T.border}`, borderRadius:6, padding:'4px 8px', fontSize:11, fontWeight:600, color:T.text, cursor:'pointer' }}>Modifier</button>
                              <button onClick={() => supprimerMembre(m)} style={{ background:'#FEF2F2', border:'1px solid #FECACA', borderRadius:6, padding:'4px 8px', fontSize:11, fontWeight:600, color:'#B91C1C', cursor:'pointer' }}>Retirer</button>
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Boutons ajouter */}
              <div style={{ display:'flex', gap:8, flexWrap:'wrap', marginTop:12 }}>
                {/* Titulaires */}
                {membresTit.length < 14 && (
                  <button onClick={() => {
                    setFormMb({ fonction:FONCTIONS_TITULAIRES[membresTit.length]||"", nom_prenom:'', matricule:'', statut:'titulaire', ordre:membresTries.length });
                    setModalMb("create");
                  }} style={{ background:T.borderSoft, border:`1px solid ${T.border}`, borderRadius:10, padding:'8px 14px', fontSize:12, fontWeight:600, color:T.text, cursor:'pointer', display:'flex', alignItems:'center', gap:5 }}>
                    <IconAdd size={14} color={T.textSoft}/> Titulaire ({membresTit.length}/14)
                  </button>
                )}

                {/* Catégories spéciales */}
                {CATEGORIES_SPECIALES.map(cat => {
                  const count = membresTries.filter(m => m.statut === cat.key).length;
                  if(cat.max && count >= cat.max) return null;
                  return (
                    <button key={cat.key} onClick={() => {
                      setFormMb({ fonction:cat.key==='am'?'Agent de maîtrise':'', nom_prenom:'', matricule:'', statut:cat.key, ordre:membresTries.length });
                      setModalMb("create");
                    }} style={{
                      background:cat.bg, border:`1px solid ${cat.color}`,
                      borderRadius:10, padding:'8px 14px', fontSize:12,
                      fontWeight:600, color:cat.color, cursor:'pointer',
                      display:'flex', alignItems:'center', gap:5,
                    }}>
                      <IconAdd size={14} color={cat.color}/> {cat.label} ({count}{cat.max?` · max ${cat.max}`:""})
                    </button>
                  );
                })}
              </div>
            </div>
          ) : (
            <div style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:'40px 20px', textAlign:'center' }}>
              <p style={{ fontSize:13, color:T.textSoft }}>Sélectionnez une équipe pour voir ses membres</p>
            </div>
          )}
        </div>
      </div>

      {/* Modal équipe */}
      {modalEq !== null && (
        <div style={{ position:'fixed', inset:0, background:'rgba(0,0,0,0.5)', display:'flex', alignItems:'center', justifyContent:'center', zIndex:2000, padding:16 }}>
          <div style={{ background:T.card, borderRadius:16, padding:24, width:'100%', maxWidth:400, border:`1px solid ${T.border}` }}>
            <p style={{ fontSize:16, fontWeight:700, color:T.text, margin:'0 0 20px' }}>{modalEq === "create" ? "Nouvelle équipe" : `Modifier ${modalEq.nom}`}</p>
            <div style={{ display:'flex', flexDirection:'column', gap:14 }}>
              <div><label style={LS}>Nom de l'équipe</label><input value={formEq.nom} onChange={e=>setFormEq({...formEq,nom:e.target.value})} style={IS} placeholder="ex: Équipe ENGOLO"/></div>
              <div><label style={LS}>Chaîne</label><select value={formEq.chaine} onChange={e=>setFormEq({...formEq,chaine:e.target.value})} style={IS}>{CHAINES.map(c=><option key={c}>{c}</option>)}</select></div>
            </div>
            <div style={{ display:'flex', gap:10, marginTop:20 }}>
              <button onClick={sauvegarderEquipe} style={{ flex:1, background:T.primary, color:'#fff', border:'none', borderRadius:10, padding:'10px', fontSize:14, fontWeight:700, cursor:'pointer' }}>{modalEq === "create" ? "Créer" : "Enregistrer"}</button>
              <button onClick={() => setModalEq(null)} style={{ flex:1, background:T.borderSoft, color:T.text, border:`1px solid ${T.border}`, borderRadius:10, padding:'10px', fontSize:14, cursor:'pointer' }}>Annuler</button>
            </div>
          </div>
        </div>
      )}

      {/* Modal membre */}
      {modalMb !== null && (
        <div style={{ position:'fixed', inset:0, background:'rgba(0,0,0,0.5)', display:'flex', alignItems:'center', justifyContent:'center', zIndex:2000, padding:16 }}>
          <div style={{ background:T.card, borderRadius:16, padding:24, width:'100%', maxWidth:440, border:`1px solid ${T.border}` }}>
            <p style={{ fontSize:16, fontWeight:700, color:T.text, margin:'0 0 20px' }}>{modalMb === "create" ? "Ajouter un membre" : `Modifier ${modalMb.nom_prenom}`}</p>
            {erreur && <div style={{ background:'#FEF2F2', border:'1px solid #FCA5A5', borderRadius:8, padding:'8px 12px', color:'#B91C1C', fontSize:12, marginBottom:12 }}>{erreur}</div>}
            <div style={{ display:'flex', flexDirection:'column', gap:14 }}>


              <div>
                <label style={LS}>Catégorie</label>
                <select value={formMb.statut} onChange={e => {
                  const cat = e.target.value;
                  setFormMb({...formMb, statut:cat,
                    fonction: cat==='titulaire' ? '' : cat==='am' ? 'Agent de maîtrise' : ''
                  });
                }} style={IS}>
                  <option value="titulaire">Personnel titulaire</option>
                  {CATEGORIES_SPECIALES.map(c => <option key={c.key} value={c.key}>{c.label}</option>)}
                </select>
              </div>

              {formMb.statut === 'titulaire' && (
                <div>
                  <label style={LS}>Fonction</label>
                  <select value={formMb.fonction} onChange={e=>setFormMb({...formMb,fonction:e.target.value})} style={IS}>
                    <option value="">-- Sélectionner --</option>
                    {FONCTIONS_TITULAIRES.map(f=><option key={f}>{f}</option>)}
                  </select>
                </div>
              )}

              {['prestataire','pepiniere','occasionnel'].includes(formMb.statut) && (
                <div>
                  <label style={LS}>Fonction / Poste</label>
                  <input value={formMb.fonction} onChange={e=>setFormMb({...formMb,fonction:e.target.value})} style={IS} placeholder="ex: Opérateur ligne, Manutentionnaire..."/>
                </div>
              )}

              {formMb.statut === 'occasionnel' && (
                <>
                  <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:10 }}>
                    <div>
                      <label style={LS}>Date de naissance</label>
                      <input value={formMb.date_naissance||''} onChange={e=>setFormMb({...formMb,date_naissance:e.target.value})} style={IS} placeholder="ex: 12/05/1995"/>
                    </div>
                    <div>
                      <label style={LS}>Lieu de naissance</label>
                      <input value={formMb.lieu_naissance||''} onChange={e=>setFormMb({...formMb,lieu_naissance:e.target.value})} style={IS} placeholder="ex: Yaoundé"/>
                    </div>
                  </div>
                  <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:10 }}>
                    <div>
                      <label style={LS}>N° CNPS</label>
                      <input value={formMb.cnps||''} onChange={e=>setFormMb({...formMb,cnps:e.target.value})} style={IS} placeholder="ex: 123456789"/>
                    </div>
                    <div>
                      <label style={LS}>Catégorie professionnelle</label>
                      <input value={formMb.categorie_pro||''} onChange={e=>setFormMb({...formMb,categorie_pro:e.target.value})} style={IS} placeholder="ex: OS1"/>
                    </div>
                  </div>
                  <div>
                    <label style={LS}>Salaire horaire (FCFA)</label>
                    <input type="number" value={formMb.salaire_horaire||''} onChange={e=>setFormMb({...formMb,salaire_horaire:parseFloat(e.target.value)||null})} style={IS} placeholder="ex: 575"/>
                  </div>
                </>
              )}

              {formMb.statut === 'pepiniere' && (
                <div>
                  <label style={LS}>Taux horaire (FCFA)</label>
                  <input type="number" value={formMb.salaire_horaire||''} onChange={e=>setFormMb({...formMb,salaire_horaire:parseFloat(e.target.value)||null})} style={IS} placeholder="ex: 4600"/>
                </div>
              )}

              {formMb.statut !== 'titulaire' && formMb.statut && (
                <div style={{
                  background: CATEGORIES_SPECIALES.find(c=>c.key===formMb.statut)?.bg,
                  border: `1px solid ${CATEGORIES_SPECIALES.find(c=>c.key===formMb.statut)?.color}`,
                  borderRadius:8, padding:'8px 12px', fontSize:12,
                  color: CATEGORIES_SPECIALES.find(c=>c.key===formMb.statut)?.color,
                }}>
                  {formMb.statut === 'am'          && "Agent de maîtrise — exporté dans le fichier Excel AM séparé."}
                  {formMb.statut === 'prestataire' && "Prestataire — fichier Excel séparé à venir."}
                  {formMb.statut === 'pepiniere'   && "Pépinière — fichier Excel séparé à venir."}
                  {formMb.statut === 'occasionnel' && "Occasionnel — géré par l'administrateur."}
                </div>
                )}

              
              <div><label style={LS}>Nom et Prénom</label><input value={formMb.nom_prenom} onChange={e=>setFormMb({...formMb,nom_prenom:e.target.value})} style={IS} placeholder="ex: MBABWE EDGARD"/></div>
              <div><label style={LS}>Matricule</label><input value={formMb.matricule} onChange={e=>setFormMb({...formMb,matricule:e.target.value})} style={IS} placeholder="ex: 116084"/></div>
            </div>
            <div style={{ display:'flex', gap:10, marginTop:20 }}>
              <button onClick={sauvegarderMembre} style={{ flex:1, background:T.primary, color:'#fff', border:'none', borderRadius:10, padding:'10px', fontSize:14, fontWeight:700, cursor:'pointer' }}>{modalMb === "create" ? "Ajouter" : "Enregistrer"}</button>
              <button onClick={() => { setModalMb(null); setErreur(null); }} style={{ flex:1, background:T.borderSoft, color:T.text, border:`1px solid ${T.border}`, borderRadius:10, padding:'10px', fontSize:14, cursor:'pointer' }}>Annuler</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

// ── PAGE GESTION D'ÉQUIPE (module RH) ─────────────────────
export default function GestionEquipes() {
  const { T, dark } = useTheme();
  const navigate = useNavigate();
  // Le bouton retour de l'en-tête ramène à l'accueil RH
  const setPage = () => navigate("/pointage");
  return (
    <div style={{ padding:'20px 16px', maxWidth:1000, margin:'0 auto' }}>
      <OngletEquipes T={T} dark={dark} setPage={setPage}/>
    </div>
  );
}
