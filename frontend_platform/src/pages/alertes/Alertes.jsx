import { useState, useEffect } from "react";
import { useTheme } from "../../components/layout/Layout";
import { useAuth } from "../../context/AuthContext";
import { alertesAPI } from "../../services/api";

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

const ATELIERS = ["","Chaîne 8","Chaîne 13","Chaîne 14","Chaîne 15","Chaîne 16"];

const IconWarning  = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>;
const IconCheck    = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>;
const IconDelete   = ({size=16,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>;
const IconRefresh  = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/></svg>;
const IconBell     = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>;

export default function Alertes() {
  const { T }      = useTheme();
  const { user }   = useAuth();
  const isMobile   = useIsMobile();

  const [alertes,  setAlertes]  = useState([]);
  const [loading,  setLoading]  = useState(true);
  const [stats,    setStats]    = useState({ total:0, critiques:0 });

  // Filtres
  const [filtreNiveau,  setFiltreNiveau]  = useState("");
  const [filtreAtelier, setFiltreAtelier] = useState("");
  const [filtreLu,      setFiltreLu]      = useState("false");

  const canDelete = ['manager','chef_atelier','contremaitre'].includes(user?.role);

  useEffect(() => { charger(); }, [filtreNiveau, filtreAtelier, filtreLu]);

  async function charger() {
    setLoading(true);
    try {
      const params = { limit: 100 };
      if(filtreNiveau)           params.niveau  = filtreNiveau;
      if(filtreAtelier)          params.atelier = filtreAtelier;
      if(filtreLu !== "")        params.lu      = filtreLu === "true";

      const [alertesRes, countRes] = await Promise.all([
        alertesAPI.lister(params),
        alertesAPI.compter(),
      ]);
      setAlertes(alertesRes.data);
      setStats({ total: countRes.data.total || 0, critiques: countRes.data.critiques || 0 });
    } catch(e) { console.error(e); }
    setLoading(false);
  }

  async function marquerLue(id) {
    try {
      await alertesAPI.marquerLu(id);
      charger();
    } catch(e) { console.error(e); }
  }

  async function marquerToutesLues() {
    const nonLues = alertes.filter(a => !a.lu);
    await Promise.all(nonLues.map(a => alertesAPI.marquerLu(a.id)));
    charger();
  }

  async function supprimer(id) {
    if(!window.confirm("Supprimer cette alerte ?")) return;
    try {
      await alertesAPI.supprimer(id);
      charger();
    } catch(e) { console.error(e); }
  }

  const IS = {
    background:T.card, border:`1px solid ${T.border}`,
    borderRadius:10, padding:'7px 12px',
    color:T.text, fontSize:13,
  };
  const LS = {
    fontSize:11, fontWeight:700, color:T.textSoft,
    textTransform:'uppercase', letterSpacing:0.8,
    marginBottom:4, display:'block',
  };

  return (
    <div style={{ padding:isMobile?'16px 14px 90px':'24px 28px', maxWidth:900, margin:'0 auto' }}>

      {/* En-tête */}
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:20, flexWrap:'wrap', gap:10 }}>
        <div style={{ display:'flex', alignItems:'center', gap:12 }}>
          <div style={{ width:44, height:44, borderRadius:14, background:'rgba(239,68,68,0.1)', display:'flex', alignItems:'center', justifyContent:'center' }}>
            <IconBell size={24} color="#EF4444"/>
          </div>
          <div>
            <h1 style={{ fontSize:20, fontWeight:700, color:T.text, margin:0 }}>Alertes</h1>
            <p style={{ fontSize:12, color:T.textSoft, margin:0 }}>Surveillance automatique des seuils</p>
          </div>
        </div>
        <button onClick={charger} style={{
          background:T.borderSoft, border:`1px solid ${T.border}`,
          borderRadius:10, padding:'8px 14px', cursor:'pointer',
          display:'flex', alignItems:'center', gap:6,
          fontSize:13, fontWeight:600, color:T.text,
        }}>
          <IconRefresh size={16} color={T.textSoft}/> Actualiser
        </button>
      </div>

      {/* Cartes stats */}
      <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(140px,1fr))', gap:12, marginBottom:20 }}>
        {[
          { label:'Non lues',  value:stats.total,    color:'#EF4444' },
          { label:'Critiques', value:stats.critiques, color:'#DC2626' },
          { label:'Total affiché', value:alertes.length, color:T.primary },
        ].map(c=>(
          <div key={c.label} style={{
            background:T.card, border:`1px solid ${T.border}`,
            borderRadius:14, padding:'16px',
            borderLeft:`4px solid ${c.color}`,
          }}>
            <div style={{ fontSize:28, fontWeight:800, color:c.color }}>{c.value}</div>
            <div style={{ fontSize:12, color:T.textSoft, marginTop:4 }}>{c.label}</div>
          </div>
        ))}
      </div>

      {/* Filtres */}
      <div style={{ background:T.card, border:`1px solid ${T.border}`, borderRadius:14, padding:16, marginBottom:20 }}>
        <div style={{ display:'grid', gridTemplateColumns:'repeat(auto-fit,minmax(140px,1fr))', gap:10, marginBottom:12 }}>
          <div>
            <label style={LS}>Niveau</label>
            <select value={filtreNiveau} onChange={e=>setFiltreNiveau(e.target.value)} style={IS}>
              <option value="">Tous</option>
              <option value="critique">Critique</option>
              <option value="warning">Warning</option>
              <option value="info">Info</option>
            </select>
          </div>
          <div>
            <label style={LS}>Atelier</label>
            <select value={filtreAtelier} onChange={e=>setFiltreAtelier(e.target.value)} style={IS}>
              {ATELIERS.map(a=><option key={a} value={a}>{a||"Tous"}</option>)}
            </select>
          </div>
          <div>
            <label style={LS}>Statut</label>
            <select value={filtreLu} onChange={e=>setFiltreLu(e.target.value)} style={IS}>
              <option value="">Toutes</option>
              <option value="false">Non lues</option>
              <option value="true">Lues</option>
            </select>
          </div>
        </div>
        {stats.total > 0 && (
          <button onClick={marquerToutesLues} style={{
            background:'#F0FDF4', border:'1px solid #86EFAC',
            borderRadius:10, padding:'8px 16px',
            fontSize:13, fontWeight:600, color:'#166534', cursor:'pointer',
            display:'flex', alignItems:'center', gap:6,
          }}>
            <IconCheck size={15} color="#166534"/> Tout marquer comme lu
          </button>
        )}
      </div>

      {/* Liste alertes */}
      {loading ? (
        <div style={{ textAlign:'center', padding:40, color:T.textSoft }}>Chargement...</div>
      ) : alertes.length === 0 ? (
        <div style={{
          background:T.card, border:`1px solid ${T.border}`,
          borderRadius:14, padding:'40px 20px',
          textAlign:'center',
        }}>
          <IconCheck size={40} color={T.success}/>
          <p style={{ fontSize:14, color:T.textSoft, marginTop:12 }}>Aucune alerte — système nominal</p>
        </div>
      ) : (
        <div style={{ display:'flex', flexDirection:'column', gap:10 }}>
          {alertes.map(a => (
            <CarteAlerte
              key={a.id}
              alerte={a}
              T={T}
              canDelete={canDelete}
              onLire={() => marquerLue(a.id)}
              onSupprimer={() => supprimer(a.id)}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function CarteAlerte({ alerte, T, canDelete, onLire, onSupprimer }) {
  const [expanded, setExpanded] = useState(false);

  const isCritique = alerte.niveau === 'critique';
  const isWarning  = alerte.niveau === 'warning';
  const color = isCritique ? '#EF4444' : isWarning ? '#F59E0B' : '#3B82F6';
  const bg    = isCritique ? 'rgba(239,68,68,0.06)' : isWarning ? 'rgba(245,158,11,0.06)' : 'rgba(59,130,246,0.06)';

  const dt = alerte.created_at ? new Date(alerte.created_at) : null;

  return (
    <div style={{
      background: T.card,
      border: `1px solid ${alerte.lu ? T.border : color+'66'}`,
      borderRadius: 14,
      borderLeft: `4px solid ${color}`,
      padding: '14px 16px',
      opacity: alerte.lu ? 0.7 : 1,
    }}>
      {/* Ligne principale */}
      <div style={{ display:'flex', alignItems:'flex-start', gap:12 }}>
        <div style={{
          width:36, height:36, borderRadius:10,
          background: bg, flexShrink:0,
          display:'flex', alignItems:'center', justifyContent:'center',
        }}>
          <IconWarning size={18} color={color}/>
        </div>

        <div style={{ flex:1, minWidth:0 }}>
          <div style={{ display:'flex', alignItems:'center', gap:8, flexWrap:'wrap', marginBottom:4 }}>
            <span style={{
              fontSize:10, fontWeight:700, padding:'2px 8px', borderRadius:20,
              color, background:`${color}22`,
              textTransform:'uppercase',
            }}>
              {alerte.niveau}
            </span>
            {alerte.atelier && (
              <span style={{ fontSize:11, color:T.textSoft, fontWeight:600 }}>{alerte.atelier}</span>
            )}
            {!alerte.lu && (
              <span style={{ fontSize:10, color:'#3B82F6', background:'rgba(59,130,246,0.1)', padding:'2px 8px', borderRadius:20, fontWeight:600 }}>
                Nouveau
              </span>
            )}
          </div>
          <p style={{ fontSize:13, fontWeight:600, color:T.text, margin:'0 0 2px' }}>{alerte.message}</p>
          <p style={{ fontSize:11, color:T.textSoft, margin:0 }}>
            {dt?.toLocaleDateString('fr-FR')} à {dt?.toLocaleTimeString('fr-FR',{hour:'2-digit',minute:'2-digit'})}
            {alerte.valeur != null && <> · Valeur : <strong>{alerte.valeur}</strong></>}
            {alerte.seuil  != null && <> · Seuil : <strong>{alerte.seuil}</strong></>}
          </p>
        </div>

        {/* Actions */}
        <div style={{ display:'flex', gap:6, flexShrink:0 }}>
          {alerte.recommandation && (
            <button onClick={() => setExpanded(e=>!e)} style={{
              background:T.borderSoft, border:`1px solid ${T.border}`,
              borderRadius:8, padding:'5px 10px', fontSize:11,
              fontWeight:600, color:T.textSoft, cursor:'pointer',
            }}>
              {expanded ? 'Moins' : 'Conseil'}
            </button>
          )}
          {!alerte.lu && (
            <button onClick={onLire} style={{
              background:'#F0FDF4', border:'1px solid #86EFAC',
              borderRadius:8, padding:'5px 10px', fontSize:11,
              fontWeight:600, color:'#166534', cursor:'pointer',
              display:'flex', alignItems:'center', gap:4,
            }}>
              <IconCheck size={12} color="#166534"/> Lu
            </button>
          )}
          {canDelete && (
            <button onClick={onSupprimer} style={{
              background:'#FEF2F2', border:'1px solid #FECACA',
              borderRadius:8, padding:'5px 8px',
              cursor:'pointer', display:'flex', alignItems:'center',
            }}>
              <IconDelete size={14} color="#B91C1C"/>
            </button>
          )}
        </div>
      </div>

      {/* Recommandation dépliable */}
      {expanded && alerte.recommandation && (
        <div style={{
          marginTop:12, padding:'10px 14px',
          background: bg, borderRadius:10,
          fontSize:12, color:T.text, lineHeight:1.6,
          borderLeft:`3px solid ${color}`,
        }}>
          <strong style={{ color }}>Recommandation :</strong> {alerte.recommandation}
        </div>
      )}
    </div>
  );
}