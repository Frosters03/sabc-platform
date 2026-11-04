import { useState, useEffect } from "react";
import { useTheme } from "../../components/layout/Layout";
import api from "../../services/api";
import * as XLSX from "xlsx";

const ROLES = ["manager", "chef_atelier", "contremaitre", "operateur"];
const ROLE_LABELS = {
  manager: "Manager", chef_atelier: "Chef d'atelier",
  contremaitre: "Contremaitre", operateur: "Opérateur",
};
const ROLE_COLORS = {
  chef_atelier: "#10B981",
  contremaitre: "#3B82F6", manager: "#DA291C", operateur: "#8B5CF6",
};


// ── ICÔNES SVG ────────────────────────────────────────────
const IconUsers  = ({size=28,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>;
const IconDB     = ({size=28,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 3C7.58 3 4 4.79 4 7v10c0 2.21 3.58 4 8 4s8-1.79 8-4V7c0-2.21-3.58-4-8-4zm0 2c3.87 0 6 1.5 6 2s-2.13 2-6 2-6-1.5-6-2 2.13-2 6-2zm0 14c-3.87 0-6-1.5-6-2v-2.23C7.61 15.56 9.72 16 12 16s4.39-.44 6-1.23V17c0 .5-2.13 2-6 2zm0-4c-3.87 0-6-1.5-6-2V9.77C7.61 10.56 9.72 11 12 11s4.39-.44 6-1.23V13c0 .5-2.13 2-6 2z"/></svg>;
const IconLogs   = ({size=28,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>;
const IconStats  = ({size=28,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 14H7v-2h5v2zm5-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>;
const IconBack   = ({size=20,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>;
const IconShield = ({size=32,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 4l5 2.18V11c0 3.5-2.33 6.79-5 7.93-2.67-1.14-5-4.43-5-7.93V7.18L12 5z"/></svg>;
const IconEdit   = ({size=16,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>;
const IconDelete = ({size=16,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>;
const IconAdd    = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>;
const IconSearch = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>;
const IconRefresh= ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/></svg>;
const IconExport = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/></svg>;

// ── PAGE ACCUEIL ADMIN ────────────────────────────────────
function AccueilAdmin({ setPage }) {
  const { T } = useTheme();
  const cards = [
    { id:"users",     icon:<IconUsers size={36} color="#DA291C"/>, title:"Utilisateurs",   desc:"Créer, modifier, supprimer les comptes",              color:"#DA291C", bg:"rgba(218,41,28,0.08)" },
    { id:"base",      icon:<IconDB    size={36} color="#3B82F6"/>, title:"Interrogation",   desc:"Rechercher dans les relevés énergie et qualité",      color:"#3B82F6", bg:"rgba(59,130,246,0.08)" },
    { id:"logs",      icon:<IconLogs  size={36} color="#8B5CF6"/>, title:"Logs d'activité", desc:"Historique des actions utilisateurs",                 color:"#8B5CF6", bg:"rgba(139,92,246,0.08)" },
    { id:"stats",     icon:<IconStats size={36} color="#F5A623"/>, title:"Statistiques",    desc:"Vue globale de la base de données",                   color:"#F5A623", bg:"rgba(245,166,35,0.08)" },
  ];
  return (
    <div style={{ padding:'24px 16px', maxWidth:600, margin:'0 auto' }}>
      <div style={{ marginBottom:32 }}>
        <div style={{ display:'flex', alignItems:'center', gap:12, marginBottom:8 }}>
          <div style={{ width:44, height:44, borderRadius:14, background:'rgba(218,41,28,0.1)', display:'flex', alignItems:'center', justifyContent:'center' }}>
            <IconShield size={24} color="#DA291C"/>
          </div>
          <div>
            <h1 style={{ fontSize:22, fontWeight:700, color:T.text, margin:0 }}>Administration</h1>
            <p style={{ fontSize:13, color:T.textSoft, margin:0 }}>Gestion de la plateforme</p>
          </div>
        </div>
      </div>
      <div style={{ display:'flex', flexDirection:'column', gap:16 }}>
        {cards.map(card => (
          <button key={card.id} onClick={() => setPage(card.id)} style={{
            background:T.card, border:`1px solid ${T.border}`, borderRadius:20, padding:'24px 20px',
            cursor:'pointer', textAlign:'left', display:'flex', alignItems:'center', gap:18,
            transition:'all 0.2s', boxShadow:'0 2px 8px rgba(0,0,0,0.06)',
          }}
            onMouseEnter={e => e.currentTarget.style.transform='translateY(-2px)'}
            onMouseLeave={e => e.currentTarget.style.transform='translateY(0)'}
          >
            <div style={{ width:64, height:64, borderRadius:18, background:card.bg, flexShrink:0, display:'flex', alignItems:'center', justifyContent:'center' }}>
              {card.icon}
            </div>
            <div style={{ flex:1 }}>
              <p style={{ fontSize:18, fontWeight:700, color:card.color, margin:'0 0 4px' }}>{card.title}</p>
              <p style={{ fontSize:14, color:T.textSoft, margin:0 }}>{card.desc}</p>
            </div>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
              <path d="M9 18l6-6-6-6" stroke={T.textSoft} strokeWidth="2" strokeLinecap="round"/>
            </svg>
          </button>
        ))}
      </div>
    </div>
  );
}

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

// ── ADMINISTRATION PRINCIPALE ─────────────────────────────
export default function Administration() {
  const { T, dark } = useTheme();
  const [page, setPage] = useState("accueil");
  return (
    <div style={{ padding:'20px 16px', maxWidth:1000, margin:'0 auto' }}>
      {page === "accueil"   && <AccueilAdmin  setPage={setPage}/>}
      {page === "users"     && <OngletUsers   T={T} dark={dark} setPage={setPage}/>}
      {page === "base"      && <OngletBase    T={T} dark={dark} setPage={setPage}/>}
      {page === "logs"      && <OngletLogs    T={T} dark={dark} setPage={setPage}/>}
      {page === "stats"     && <OngletStats   T={T} dark={dark} setPage={setPage}/>}
    </div>
  );
}

// ── ONGLET UTILISATEURS ───────────────────────────────────
function OngletUsers({ T, dark, setPage }) {
  const [users,   setUsers]   = useState([]);
  const [loading, setLoading] = useState(true);
  const [modal,   setModal]   = useState(null);
  const [form,    setForm]    = useState({ username:"", password:"", role:"operateur" });
  const [erreur,  setErreur]  = useState(null);
  const [succes,  setSucces]  = useState(null);

  useEffect(() => { charger(); }, []);

  async function charger() {
    setLoading(true);
    try { const res = await api.get("/auth/users"); setUsers(res.data); }
    catch(e) { setErreur("Erreur chargement utilisateurs"); }
    setLoading(false);
  }

  function ouvrirCreer() { setForm({ username:"", password:"", role:"operateur" }); setErreur(null); setSucces(null); setModal("create"); }
  function ouvrirModifier(user) { setForm({ username:user.username, password:"", role:user.role, actif:user.actif }); setErreur(null); setSucces(null); setModal(user); }

  async function sauvegarder() {
    setErreur(null);
    try {
      if(modal === "create") {
        if(!form.username || !form.password) { setErreur("Tous les champs sont requis"); return; }
        await api.post("/auth/users", { username:form.username, password:form.password, role:form.role });
        setSucces(`Utilisateur "${form.username}" créé`);
      } else {
        const payload = { role:form.role, actif:form.actif };
        if(form.password) payload.password = form.password;
        await api.put(`/auth/users/${modal.id}`, payload);
        setSucces(`Utilisateur "${modal.username}" modifié`);
      }
      setModal(null); charger();
    } catch(e) { setErreur(e.response?.data?.detail || "Erreur"); }
  }

  async function supprimer(user) {
    if(!window.confirm(`Supprimer "${user.username}" ?`)) return;
    try { await api.delete(`/auth/users/${user.id}`); setSucces(`Utilisateur "${user.username}" supprimé`); charger(); }
    catch(e) { setErreur(e.response?.data?.detail || "Erreur suppression"); }
  }

  const IS = { background:T.card, border:`1px solid ${T.border}`, borderRadius:10, padding:'8px 12px', color:T.text, fontSize:13, width:'100%' };
  const LS = { fontSize:11, fontWeight:700, color:T.textSoft, textTransform:'uppercase', letterSpacing:0.8, marginBottom:4, display:'block' };

  return (
    <div>
      <SousPageHeader titre="Gestion des utilisateurs" setPage={setPage} T={T}/>
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:16 }}>
        <p style={{ fontSize:13, color:T.textSoft, margin:0 }}>{users.length} utilisateur(s)</p>
        <button onClick={ouvrirCreer} style={{ background:T.primary, color:'#fff', border:'none', borderRadius:10, padding:'9px 16px', fontSize:13, fontWeight:700, cursor:'pointer', display:'flex', alignItems:'center', gap:6 }}>
          <IconAdd size={16} color="#fff"/> Nouvel utilisateur
        </button>
      </div>
      {succes && <div style={{ background:'#F0FDF4', border:'1px solid #86EFAC', borderRadius:10, padding:'10px 14px', color:'#166534', fontSize:13, marginBottom:12 }}>{succes}</div>}
      {erreur && <div style={{ background:'#FEF2F2', border:'1px solid #FCA5A5', borderRadius:10, padding:'10px 14px', color:'#B91C1C', fontSize:13, marginBottom:12 }}>{erreur}</div>}
      {loading ? <div style={{ textAlign:'center', padding:40, color:T.textSoft }}>Chargement...</div> : (
        <div style={{ display:'flex', flexDirection:'column', gap:8 }}>
          {users.map(u => (
            <div key={u.id} style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:12, padding:'14px 16px', display:'flex', alignItems:'center', gap:12, flexWrap:'wrap' }}>
              <div style={{ width:40, height:40, borderRadius:'50%', background:`${ROLE_COLORS[u.role]}22`, border:`2px solid ${ROLE_COLORS[u.role]}44`, display:'flex', alignItems:'center', justifyContent:'center', fontSize:16, fontWeight:700, color:ROLE_COLORS[u.role], flexShrink:0 }}>
                {u.username[0].toUpperCase()}
              </div>
              <div style={{ flex:1, minWidth:120 }}>
                <div style={{ display:'flex', alignItems:'center', gap:8 }}>
                  <span style={{ fontSize:14, fontWeight:700, color:T.text }}>{u.username}</span>
                  {!u.actif && <span style={{ fontSize:10, color:'#EF4444', background:'#FEF2F2', padding:'2px 8px', borderRadius:20, fontWeight:600 }}>Inactif</span>}
                </div>
                <div style={{ display:'flex', alignItems:'center', gap:8, marginTop:3 }}>
                  <span style={{ fontSize:11, fontWeight:600, color:ROLE_COLORS[u.role], background:`${ROLE_COLORS[u.role]}18`, padding:'2px 8px', borderRadius:20 }}>{ROLE_LABELS[u.role] || u.role}</span>
                  {u.last_login && <span style={{ fontSize:10, color:T.textMuted }}>Dernière connexion : {new Date(u.last_login).toLocaleDateString('fr-FR')}</span>}
                </div>
              </div>
              {u.username !== 'manager' ? (
                <div style={{ display:'flex', gap:8 }}>
                  <button onClick={() => ouvrirModifier(u)} style={{ background:T.borderSoft, border:`1px solid ${T.border}`, borderRadius:8, padding:'7px 12px', fontSize:12, fontWeight:600, color:T.text, cursor:'pointer', display:'flex', alignItems:'center', gap:5 }}>
                    <IconEdit size={14} color={T.textSoft}/> Modifier
                  </button>
                  <button onClick={() => supprimer(u)} style={{ background:'#FEF2F2', border:'1px solid #FECACA', borderRadius:8, padding:'7px 12px', fontSize:12, fontWeight:600, color:'#B91C1C', cursor:'pointer', display:'flex', alignItems:'center', gap:5 }}>
                    <IconDelete size={14} color="#B91C1C"/> Supprimer
                  </button>
                </div>
              ) : <span style={{ fontSize:11, color:T.textMuted, fontStyle:'italic' }}>Protégé</span>}
            </div>
          ))}
        </div>
      )}
      {modal !== null && (
        <div style={{ position:'fixed', inset:0, background:'rgba(0,0,0,0.5)', display:'flex', alignItems:'center', justifyContent:'center', zIndex:2000, padding:16 }}>
          <div style={{ background:T.card, borderRadius:16, padding:24, width:'100%', maxWidth:420, border:`1px solid ${T.border}` }}>
            <p style={{ fontSize:16, fontWeight:700, color:T.text, margin:'0 0 20px' }}>{modal === "create" ? "Nouvel utilisateur" : `Modifier ${modal.username}`}</p>
            {erreur && <div style={{ background:'#FEF2F2', border:'1px solid #FCA5A5', borderRadius:8, padding:'8px 12px', color:'#B91C1C', fontSize:12, marginBottom:12 }}>{erreur}</div>}
            <div style={{ display:'flex', flexDirection:'column', gap:14 }}>
              {modal === "create" && <div><label style={LS}>Nom d'utilisateur</label><input value={form.username} onChange={e=>setForm({...form,username:e.target.value})} style={IS} placeholder="ex: operateur3"/></div>}
              <div><label style={LS}>{modal === "create" ? "Mot de passe" : "Nouveau mot de passe (vide = inchangé)"}</label><input type="password" value={form.password} onChange={e=>setForm({...form,password:e.target.value})} style={IS} placeholder="••••••••"/></div>
              <div><label style={LS}>Rôle</label><select value={form.role} onChange={e=>setForm({...form,role:e.target.value})} style={IS}>{ROLES.map(r=><option key={r} value={r}>{ROLE_LABELS[r]}</option>)}</select></div>
              {modal !== "create" && <div style={{ display:'flex', alignItems:'center', gap:10 }}><input type="checkbox" id="actif" checked={form.actif} onChange={e=>setForm({...form,actif:e.target.checked})} style={{ width:16, height:16 }}/><label htmlFor="actif" style={{ fontSize:13, color:T.text, cursor:'pointer' }}>Compte actif</label></div>}
            </div>
            <div style={{ display:'flex', gap:10, marginTop:20 }}>
              <button onClick={sauvegarder} style={{ flex:1, background:T.primary, color:'#fff', border:'none', borderRadius:10, padding:'10px', fontSize:14, fontWeight:700, cursor:'pointer' }}>{modal === "create" ? "Créer" : "Enregistrer"}</button>
              <button onClick={() => { setModal(null); setErreur(null); }} style={{ flex:1, background:T.borderSoft, color:T.text, border:`1px solid ${T.border}`, borderRadius:10, padding:'10px', fontSize:14, cursor:'pointer' }}>Annuler</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

// ── ONGLET ÉQUIPES ────────────────────────────────────────
// ── ONGLET INTERROGATION ──────────────────────────────────
function OngletBase({ T, dark, setPage }) {
  const [sousOnglet, setSousOnglet] = useState("energie");
  const [atelier,    setAtelier]    = useState("");
  const [quart,      setQuart]      = useState("");
  const [dateDebut,  setDateDebut]  = useState("");
  const [dateFin,    setDateFin]    = useState("");
  const [resultats,  setResultats]  = useState([]);
  const [loading,    setLoading]    = useState(false);
  const [erreur,     setErreur]     = useState(null);

  const ATELIERS = ["","Chaîne 8","Chaîne 13","Chaîne 14","Chaîne 15","Chaîne 16"];
  const QUARTS   = ["","22h-6h","6h-14h","14h-22h"];
  const IS = { background:T.card, border:`1px solid ${T.border}`, borderRadius:10, padding:'8px 12px', color:T.text, fontSize:13, width:'100%' };
  const LS = { fontSize:11, fontWeight:700, color:T.textSoft, textTransform:'uppercase', letterSpacing:0.8, marginBottom:4, display:'block' };

  async function rechercher() {
    setErreur(null); setResultats([]); setLoading(true);
    try {
      const p = new URLSearchParams({ limit:200 });
      if(atelier)   p.append("atelier",    atelier);
      if(quart)     p.append("quart",      quart);
      if(dateDebut) p.append("date_debut", dateDebut);
      if(dateFin)   p.append("date_fin",   dateFin);
      const url = sousOnglet==="energie" ? `/energie/?${p}` : `/qualite/?${p}`;
      const res = await api.get(url);
      setResultats(res.data);
    } catch(e) { setErreur("Erreur lors de la recherche"); }
    setLoading(false);
  }

  function exporterExcel() {
    if(!resultats.length) return;
    const wb = XLSX.utils.book_new();
    const ws = XLSX.utils.json_to_sheet(resultats);
    ws["!cols"] = Object.keys(resultats[0]).map(()=>({ wch:16 }));
    XLSX.utils.book_append_sheet(wb, ws, sousOnglet==="energie"?"Lean Énergie":"Qualité");
    XLSX.writeFile(wb, `Interrogation_${sousOnglet}_${new Date().toISOString().slice(0,10)}.xlsx`);
  }

  const colsEnergie = [
    {key:"id",label:"ID"},{key:"date",label:"Date"},{key:"heure",label:"Heure"},{key:"quart",label:"Quart"},{key:"atelier",label:"Atelier"},
    {key:"index_eau_rincage",label:"Eau rinç."},{key:"index_eau_bain",label:"Eau bain"},{key:"index_eau_pasteur",label:"Eau past."},
    {key:"index_eau_aero",label:"Eau aéro"},{key:"index_elec",label:"Élec (kWh)"},{key:"index_co2",label:"CO₂ (kg)"},
    {key:"production_hl",label:"Prod (hl)"},{key:"saisi_par",label:"Saisi par"},
  ];
  const colsQualite = [
    {key:"id",label:"ID"},{key:"date",label:"Date"},{key:"heure",label:"Heure"},{key:"quart",label:"Quart"},{key:"atelier",label:"Atelier"},
    {key:"brix",label:"Brix (°)"},{key:"co2_qualite",label:"CO₂ (g/L)"},{key:"bo2",label:"BO₂ (mg/L)"},{key:"saisi_par",label:"Saisi par"},
  ];
  const cols = sousOnglet==="energie" ? colsEnergie : colsQualite;

  return (
    <div>
      <SousPageHeader titre="Interrogation base de données" setPage={setPage} T={T}/>
      <div style={{ display:'flex', gap:8, marginBottom:16 }}>
        {["energie","qualite"].map(s=>(
          <button key={s} onClick={()=>{ setSousOnglet(s); setResultats([]); }} style={{
            padding:'7px 16px', borderRadius:8, border:'none', cursor:'pointer',
            fontSize:12, fontWeight:sousOnglet===s?700:500,
            background:sousOnglet===s?T.primary+'22':T.borderSoft,
            color:sousOnglet===s?T.primary:T.textSoft,
          }}>
            {s==="energie" ? "Énergie" : "Qualité"}
          </button>
        ))}
      </div>
      <div style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:16, marginBottom:16 }}>
        <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(140px,1fr))', gap:10, marginBottom:12 }}>
          <div><label style={LS}>Atelier</label><select value={atelier} onChange={e=>setAtelier(e.target.value)} style={IS}>{ATELIERS.map(a=><option key={a} value={a}>{a||"Tous"}</option>)}</select></div>
          <div><label style={LS}>Quart</label><select value={quart} onChange={e=>setQuart(e.target.value)} style={IS}>{QUARTS.map(q=><option key={q} value={q}>{q||"Tous"}</option>)}</select></div>
          <div><label style={LS}>Date début</label><input type="date" value={dateDebut} onChange={e=>setDateDebut(e.target.value)} style={IS}/></div>
          <div><label style={LS}>Date fin</label><input type="date" value={dateFin} onChange={e=>setDateFin(e.target.value)} style={IS}/></div>
        </div>
        <div style={{ display:'flex', gap:10 }}>
          <button onClick={rechercher} disabled={loading} style={{ background:T.primary, color:'#fff', border:'none', borderRadius:10, padding:'9px 18px', fontSize:13, fontWeight:700, cursor:'pointer', display:'flex', alignItems:'center', gap:6 }}>
            <IconSearch size={16} color="#fff"/>{loading ? "Recherche..." : "Rechercher"}
          </button>
          {resultats.length > 0 && (
            <button onClick={exporterExcel} style={{ background:'#10B981', color:'#fff', border:'none', borderRadius:10, padding:'9px 18px', fontSize:13, fontWeight:700, cursor:'pointer', display:'flex', alignItems:'center', gap:6 }}>
              <IconExport size={16} color="#fff"/> Exporter Excel
            </button>
          )}
        </div>
      </div>
      {erreur && <div style={{ background:'#FEF2F2', border:'1px solid #FCA5A5', borderRadius:10, padding:'10px 14px', color:'#B91C1C', fontSize:13, marginBottom:12 }}>{erreur}</div>}
      {resultats.length > 0 && (
        <div>
          <p style={{ fontSize:12, color:T.textSoft, marginBottom:8 }}>{resultats.length} résultat(s)</p>
          <div style={{ overflowX:'auto' }}>
            <table style={{ width:'100%', borderCollapse:'collapse', fontSize:12, color:T.text }}>
              <thead>
                <tr style={{ background:dark?'#1E293B':'#F1F5F9' }}>
                  {cols.map(c=><th key={c.key} style={{ padding:'8px 10px', textAlign:'left', fontWeight:700, color:T.textSoft, fontSize:11, whiteSpace:'nowrap', borderBottom:`2px solid ${T.border}` }}>{c.label}</th>)}
                </tr>
              </thead>
              <tbody>
                {resultats.map((r,i)=>(
                  <tr key={i} style={{ borderBottom:`1px solid ${T.border}`, background:i%2===0?'transparent':dark?'rgba(255,255,255,0.02)':'rgba(0,0,0,0.01)' }}>
                    {cols.map(c=><td key={c.key} style={{ padding:'7px 10px', whiteSpace:'nowrap' }}>{r[c.key]??'-'}</td>)}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}

// ── ONGLET LOGS ───────────────────────────────────────────
function OngletLogs({ T, dark, setPage }) {
  const [logs,    setLogs]    = useState([]);
  const [loading, setLoading] = useState(false);

  async function charger() {
    setLoading(true);
    try { const res = await api.get("/auth/logs?limit=200"); setLogs(res.data); }
    catch(e) { console.error(e); }
    setLoading(false);
  }

  const ACTION_COLORS = { LOGIN:"#10B981", LOGOUT:"#64748B", INSERT:"#3B82F6", UPDATE:"#F59E0B", DELETE:"#EF4444", ARCHIVE:"#8B5CF6" };

  return (
    <div>
      <SousPageHeader titre="Logs d'activité" setPage={setPage} T={T}/>
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:16 }}>
        <p style={{ fontSize:13, color:T.textSoft, margin:0 }}>{logs.length > 0 ? `${logs.length} entrée(s)` : "Cliquez sur Charger pour afficher"}</p>
        <button onClick={charger} disabled={loading} style={{ background:T.primary, color:'#fff', border:'none', borderRadius:10, padding:'8px 16px', fontSize:13, fontWeight:700, cursor:'pointer', display:'flex', alignItems:'center', gap:6 }}>
          <IconRefresh size={16} color="#fff"/>{loading ? "Chargement..." : "Charger les logs"}
        </button>
      </div>
      {logs.length > 0 && (
        <div style={{ overflowX:'auto' }}>
          <table style={{ width:'100%', borderCollapse:'collapse', fontSize:12, color:T.text }}>
            <thead>
              <tr style={{ background:dark?'#1E293B':'#F1F5F9' }}>
                {["ID","Date","Heure","Utilisateur","Action","Table","Détails"].map(h=>(
                  <th key={h} style={{ padding:'8px 10px', textAlign:'left', fontWeight:700, color:T.textSoft, fontSize:11, whiteSpace:'nowrap', borderBottom:`2px solid ${T.border}` }}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {logs.map((l,i)=>{
                const dt = l.created_at ? new Date(l.created_at) : null;
                return (
                  <tr key={i} style={{ borderBottom:`1px solid ${T.border}`, background:i%2===0?'transparent':dark?'rgba(255,255,255,0.02)':'rgba(0,0,0,0.01)' }}>
                    <td style={{ padding:'7px 10px' }}>{l.id}</td>
                    <td style={{ padding:'7px 10px', whiteSpace:'nowrap' }}>{dt?.toLocaleDateString('fr-FR')||'-'}</td>
                    <td style={{ padding:'7px 10px', whiteSpace:'nowrap' }}>{dt?.toLocaleTimeString('fr-FR',{hour:'2-digit',minute:'2-digit'})||'-'}</td>
                    <td style={{ padding:'7px 10px', fontWeight:600 }}>{l.utilisateur}</td>
                    <td style={{ padding:'7px 10px' }}>
                      <span style={{ fontSize:10, fontWeight:700, padding:'2px 8px', borderRadius:20, color:ACTION_COLORS[l.action]||T.textSoft, background:(ACTION_COLORS[l.action]||T.textSoft)+'22' }}>{l.action}</span>
                    </td>
                    <td style={{ padding:'7px 10px', color:T.textSoft }}>{l.table_concernee||'-'}</td>
                    <td style={{ padding:'7px 10px', color:T.textSoft, maxWidth:200, overflow:'hidden', textOverflow:'ellipsis', whiteSpace:'nowrap' }}>{l.details||'-'}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

// ── ONGLET STATISTIQUES ───────────────────────────────────
function OngletStats({ T, setPage }) {
  const [stats,   setStats]   = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => { charger(); }, []);

  async function charger() {
    setLoading(true);
    try { const res = await api.get("/auth/stats"); setStats(res.data); }
    catch(e) { console.error(e); }
    setLoading(false);
  }

  if(loading) return <div style={{ textAlign:'center', padding:40, color:T.textSoft }}>Chargement...</div>;
  if(!stats)  return <div style={{ textAlign:'center', padding:40, color:T.textSoft }}>Erreur chargement</div>;

  const cartes = [
    { label:"Relevés énergie",     value:stats.nb_energie,      icon:<IconDB    size={26} color="#F5A623"/>, color:"#F5A623" },
    { label:"Relevés qualité",     value:stats.nb_qualite,      icon:<IconStats size={26} color="#10B981"/>, color:"#10B981" },
    { label:"Utilisateurs actifs", value:stats.nb_utilisateurs, icon:<IconUsers size={26} color="#3B82F6"/>, color:"#3B82F6" },
    { label:"Actions loggées",     value:stats.nb_logs,         icon:<IconLogs  size={26} color="#8B5CF6"/>, color:"#8B5CF6" },
  ];

  return (
    <div>
      <SousPageHeader titre="Statistiques générales" setPage={setPage} T={T}/>
      <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(180px,1fr))', gap:14 }}>
        {cartes.map(c=>(
          <div key={c.label} style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:'20px 18px', borderLeft:`4px solid ${c.color}` }}>
            <div style={{ marginBottom:10 }}>{c.icon}</div>
            <div style={{ fontSize:32, fontWeight:800, color:c.color, lineHeight:1 }}>{c.value}</div>
            <div style={{ fontSize:12, color:T.textSoft, marginTop:4 }}>{c.label}</div>
          </div>
        ))}
      </div>
    </div>
  );
}
