import { useState, useEffect } from "react";
import { useTheme } from "../../components/layout/Layout";
import { useAuth } from "../../context/AuthContext";
import { equipesAPI, pointagesAPI } from "../../services/api";

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

const CHAINES = ["Chaîne 8","Chaîne 13","Chaîne 14","Chaîne 15","Chaîne 16"];
const QUARTS  = ["7h-19h","19h-7h","7h-14h","14h-21h","21h-7h"];
const HEURES_QUART = {
  "7h-19h": 12, "19h-7h": 12,
  "7h-14h": 7,  "14h-21h": 7, "21h-7h": 10,
};
const OPTIONS_PRESENCE = [
  { val:"P",  label:"P — Présence" },
  { val:"AA", label:"AA — Autorisation d'absence" },
  { val:"AB", label:"AB — Absence non justifiée" },
  { val:"R",  label:"R — Repos" },
  { val:"RM", label:"RM — Repos maladie" },
  { val:"CP", label:"CP — Congé payé" },
];

function today() { return new Date().toISOString().split("T")[0]; }

// ── ICÔNES ────────────────────────────────────────────────
const IconAdd    = ({size=16,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>;
const IconDelete = ({size=14,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>;
const IconSend   = ({size=16,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>;
const IconExport = ({size=16,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/></svg>;
const IconCheck  = ({size=16,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>;

export default function SaisiePointage() {
  const { T }     = useTheme();
  const { user }  = useAuth();
  const isMobile  = useIsMobile();

  // Filtres
  const [date,      setDate]      = useState(today());
  const [chaine,    setChaine]    = useState("Chaîne 8");
  const [quart,     setQuart]     = useState("7h-14h");
  const [equipeId,  setEquipeId]  = useState("");

  // Données
  const [equipes,   setEquipes]   = useState([]);
  const [lignes,    setLignes]    = useState([]);
  const [loading,   setLoading]   = useState(false);
  const [dejaS,     setDejaS]     = useState(false);
  const [succes,    setSucces]    = useState(null);
  const [erreur,    setErreur]    = useState(null);

  const IS = {
    background:T.card, border:`1px solid ${T.border}`,
    borderRadius:10, padding:'8px 12px',
    color:T.text, fontSize:13, width:'100%',
  };
  const LS = {
    fontSize:11, fontWeight:700, color:T.textSoft,
    textTransform:'uppercase', letterSpacing:0.8,
    marginBottom:4, display:'block',
  };

  // Charger équipes selon chaîne
  useEffect(() => {
    setEquipeId("");
    setLignes([]);
    equipesAPI.lister({ chaine }).then(res => setEquipes(res.data)).catch(console.error);
  }, [chaine]);

  // Charger membres quand équipe change
  useEffect(() => {
    if(!equipeId) { setLignes([]); return; }
    const eq = equipes.find(e => e.id === parseInt(equipeId));
    if(!eq) return;
    const heures = HEURES_QUART[quart] || 8;
    const membres = [...eq.membres].sort((a,b) => a.ordre - b.ordre);
    setLignes(membres.map(m => ({
      membre_id:      m.id,
      fonction:       m.fonction,
      nom_prenom:     m.nom_prenom,
      statut_emploi:  m.statut,
      presence:       "P",
      heures_N:       heures,
      heures_F:       0,
      heures_PN:      0,
      est_occasionnel: false,
    })));
    setDejaS(false);
    setSucces(null);
    setErreur(null);
  }, [equipeId, equipes]);

  // Vérifier double saisie quand date/equipe/quart changent
  useEffect(() => {
    if(!equipeId || !date || !quart) return;
    pointagesAPI.verifier({ date, equipe_id: equipeId, quart })
      .then(res => setDejaS(res.data.existe))
      .catch(console.error);
  }, [date, equipeId, quart]);

  // Recalculer heures quand quart change
  useEffect(() => {
    const heures = HEURES_QUART[quart] || 8;
    setLignes(prev => prev.map(l => ({
      ...l,
      heures_N: l.presence === "P" ? heures : 0,
    })));
  }, [quart]);

  function changerPresence(idx, val) {
    const heures = HEURES_QUART[quart] || 8;
    setLignes(prev => prev.map((l, i) => i !== idx ? l : {
      ...l,
      presence: val,
      heures_N: val === "P" ? heures : 0,
    }));
  }

  function changerHeures(idx, val) {
    setLignes(prev => prev.map((l, i) => i !== idx ? l : {
      ...l, heures_N: parseFloat(val) || 0,
    }));
  }

  function ajouterOccasionnel() {
    setLignes(prev => [...prev, {
      membre_id:       null,
      fonction:        "",
      nom_prenom:      "",
      statut_emploi:   "occasionnel",
      presence:        "P",
      heures_N:        HEURES_QUART[quart] || 8,
      heures_F:        0,
      heures_PN:       0,
      est_occasionnel: true,
    }]);
  }

  function supprimerOccasionnel(idx) {
    setLignes(prev => prev.filter((_, i) => i !== idx));
  }

  function changerOccasionnel(idx, field, val) {
    setLignes(prev => prev.map((l, i) => i !== idx ? l : { ...l, [field]: val }));
  }

  async function envoyer() {
    setErreur(null); setSucces(null);
    // Validation
    for(const l of lignes) {
      if(!l.nom_prenom.trim()) { setErreur("Tous les noms doivent être remplis."); return; }
      if(!l.presence)          { setErreur("Tous les statuts de présence doivent être remplis."); return; }
    }
    const eq = equipes.find(e => e.id === parseInt(equipeId));
    setLoading(true);
    try {
      await pointagesAPI.creer({
        date, chaine, quart,
        equipe_id:  parseInt(equipeId),
        equipe_nom: eq?.nom || "",
        lignes,
      });
      setSucces("Pointage enregistré avec succès !");
      setDejaS(true);
    } catch(e) {
      setErreur(e.response?.data?.detail || "Erreur lors de l'envoi.");
    }
    setLoading(false);
  }

 

  const eq = equipes.find(e => e.id === parseInt(equipeId));

  return (
    <div style={{ padding:isMobile?'16px 14px 90px':'24px 28px', maxWidth:1100, margin:'0 auto' }}>

      {/* En-tête */}
      <div style={{ marginBottom:20 }}>
        <h1 style={{ fontSize:isMobile?18:22, fontWeight:700, color:T.text, margin:'0 0 4px' }}>
          Pointage Personnel
        </h1>
        <p style={{ fontSize:12, color:T.textSoft, margin:0 }}>
          Service Conditionnement — SABC Ndokoti
        </p>
      </div>

      {/* Filtres */}
      <div style={{
        background:T.card, border:`1px solid ${T.border}`,
        borderRadius:16, padding:20, marginBottom:20,
      }}>
        <div style={{
          display:'grid',
          gridTemplateColumns: isMobile ? '1fr 1fr' : 'repeat(4, 1fr)',
          gap:12, marginBottom:16,
        }}>
          <div>
            <label style={LS}>Date</label>
            <input type="date" value={date}
              onChange={e => setDate(e.target.value)} style={IS}/>
          </div>
          <div>
            <label style={LS}>Chaîne</label>
            <select value={chaine} onChange={e => setChaine(e.target.value)} style={IS}>
              {CHAINES.map(c => <option key={c}>{c}</option>)}
            </select>
          </div>
          <div>
            <label style={LS}>Quart</label>
            <select value={quart} onChange={e => setQuart(e.target.value)} style={IS}>
              {QUARTS.map(q => <option key={q}>{q} — {HEURES_QUART[q]}h</option>)}
            </select>
          </div>
          <div>
            <label style={LS}>Équipe</label>
            <select value={equipeId} onChange={e => setEquipeId(e.target.value)} style={IS}>
              <option value="">-- Sélectionner --</option>
              {equipes.map(e => <option key={e.id} value={e.id}>{e.nom}</option>)}
            </select>
          </div>
        </div>

        {/* Infos équipe */}
        {eq && (
          <div style={{
            display:'flex', alignItems:'center', gap:10,
            padding:'10px 14px', borderRadius:10,
            background: T.borderSoft, border:`1px solid ${T.border}`,
          }}>
            <div style={{
              width:8, height:8, borderRadius:'50%',
              background: dejaS ? '#EF4444' : '#10B981',
            }}/>
            <span style={{ fontSize:13, color:T.text, fontWeight:600 }}>
              {eq.nom} — {chaine}
            </span>
            <span style={{ fontSize:11, color:T.textSoft }}>
              {eq.membres.length} membre(s) · Quart {quart} · {HEURES_QUART[quart]}h
            </span>
            {dejaS && (
              <span style={{
                marginLeft:'auto', fontSize:11, fontWeight:700,
                color:'#EF4444', background:'#FEF2F2',
                padding:'3px 10px', borderRadius:20,
              }}>
                Déjà saisi
              </span>
            )}
          </div>
        )}
      </div>

      {/* Messages */}
      {succes && (
        <div style={{
          background:'#F0FDF4', border:'1px solid #86EFAC',
          borderRadius:12, padding:'12px 16px', color:'#166534',
          fontSize:13, marginBottom:16,
          display:'flex', alignItems:'center', gap:8,
        }}>
          <IconCheck size={16} color="#166534"/> {succes}
        </div>
      )}
      {erreur && (
        <div style={{
          background:'#FEF2F2', border:'1px solid #FCA5A5',
          borderRadius:12, padding:'12px 16px', color:'#B91C1C',
          fontSize:13, marginBottom:16,
        }}>
          {erreur}
        </div>
      )}

      {/* Tableau pointage */}
      {lignes.length > 0 && (
        <div style={{
          background:T.card, border:`1px solid ${T.border}`,
          borderRadius:16, padding:20, marginBottom:20,
        }}>
          <p style={{ fontSize:14, fontWeight:700, color:T.text, margin:'0 0 16px' }}>
            Relevé du {new Date(date).toLocaleDateString('fr-FR', {
              weekday:'long', day:'numeric', month:'long', year:'numeric'
            })}
          </p>

          <div style={{ overflowX:'auto' }}>
            <table style={{ width:'100%', borderCollapse:'collapse', fontSize:12, color:T.text }}>
              <thead>
                <tr style={{ background: T.borderSoft }}>
                  {["#","Fonction","Nom et Prénom","Statut","Présence","Heures"].map(h => (
                    <th key={h} style={{
                      padding:'10px 12px', textAlign:'left',
                      fontWeight:700, color:T.textSoft, fontSize:11,
                      whiteSpace:'nowrap', borderBottom:`2px solid ${T.border}`,
                    }}>{h}</th>
                  ))}
                  <th style={{ borderBottom:`2px solid ${T.border}`, width:40 }}></th>
                </tr>
              </thead>
              <tbody>
                {lignes.map((l, idx) => {
                  const isBg = idx % 2 === 0;
                  const isAbsent = ['A','R','RM','CP'].includes(l.presence);
                  return (
                    <tr key={idx} style={{
                      borderBottom:`1px solid ${T.border}`,
                      background: isBg ? 'transparent' : T.borderSoft,
                      opacity: isAbsent ? 0.7 : 1,
                    }}>
                      {/* Numéro */}
                      <td style={{ padding:'8px 12px', color:T.textMuted, fontWeight:600 }}>
                        {idx + 1}
                      </td>

                      {/* Fonction */}
                      <td style={{ padding:'8px 12px', whiteSpace:'nowrap' }}>
                        {l.est_occasionnel ? (
                          <input
                            value={l.fonction}
                            onChange={e => changerOccasionnel(idx, 'fonction', e.target.value)}
                            placeholder="Fonction"
                            style={{ ...IS, width:140, padding:'4px 8px' }}
                          />
                        ) : (
                          <span style={{ fontWeight:500, color:T.text }}>{l.fonction}</span>
                        )}
                      </td>

                      {/* Nom */}
                      <td style={{ padding:'8px 12px' }}>
                        {l.est_occasionnel ? (
                          <input
                            value={l.nom_prenom}
                            onChange={e => changerOccasionnel(idx, 'nom_prenom', e.target.value)}
                            placeholder="Nom et Prénom"
                            style={{ ...IS, width:180, padding:'4px 8px' }}
                          />
                        ) : (
                          <span style={{ fontWeight:600, color:T.text }}>{l.nom_prenom}</span>
                        )}
                      </td>

                      {/* Statut */}
                      <td style={{ padding:'8px 12px' }}>
                        <span style={{
                          fontSize:10, fontWeight:700,
                          padding:'3px 10px', borderRadius:20,
                          color: l.statut_emploi === 'titulaire' ? '#3B82F6' : '#F59E0B',
                          background: l.statut_emploi === 'titulaire' ? 'rgba(59,130,246,0.1)' : 'rgba(245,158,11,0.1)',
                        }}>
                          {l.statut_emploi === 'titulaire' ? 'Titulaire' : 'Occasionnel'}
                        </span>
                      </td>

                      {/* Présence */}
                      <td style={{ padding:'8px 12px' }}>
                        <select
                          value={l.presence}
                          onChange={e => changerPresence(idx, e.target.value)}
                          disabled={dejaS}
                          style={{
                            ...IS, width:160, padding:'4px 8px',
                            color: l.presence === 'P' ? '#10B981'
                                 : l.presence==='AB' ? '#EF4444'
                                 : l.presence==='AA' ? '#F97316'
                                 : l.presence === 'RM' ? '#8B5CF6'
                                 : '#F59E0B',
                            fontWeight:700,
                          }}
                        >
                          {OPTIONS_PRESENCE.map(o => (
                            <option key={o.val} value={o.val}>{o.label}</option>
                          ))}
                        </select>
                      </td>

                      {/* Heures */}
                      <td style={{ padding:'8px 12px' }}>
                        {l.presence === 'P' ? (
                          <input
                            type="number"
                            value={l.heures_N}
                            onChange={e => changerHeures(idx, e.target.value)}
                            disabled={dejaS}
                            min={0} max={24} step={0.5}
                            style={{
                              ...IS, width:70, padding:'4px 8px',
                              fontWeight:700, color:'#10B981',
                            }}
                          />
                        ) : (
                          <span style={{
                            fontSize:12, fontWeight:700,
                            color: '#EF4444',
                            background:'rgba(239,68,68,0.1)',
                            padding:'3px 10px', borderRadius:20,
                          }}>
                            {l.presence}
                          </span>
                        )}
                      </td>

                      {/* Supprimer occasionnel */}
                      <td style={{ padding:'8px 12px', textAlign:'center' }}>
                        {l.est_occasionnel && !dejaS && (
                          <button onClick={() => supprimerOccasionnel(idx)} style={{
                            background:'#FEF2F2', border:'1px solid #FECACA',
                            borderRadius:6, padding:'4px 6px', cursor:'pointer',
                          }}>
                            <IconDelete size={14} color="#B91C1C"/>
                          </button>
                        )}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          {/* Résumé heures */}
          <div style={{
            display:'flex', gap:16, flexWrap:'wrap',
            marginTop:16, padding:'12px 16px',
            background:T.borderSoft, borderRadius:10,
          }}>
            <span style={{ fontSize:12, color:T.textSoft }}>
              Présents : <strong style={{ color:'#10B981' }}>
                {lignes.filter(l => l.presence === 'P').length}
              </strong>
            </span>
            <span style={{ fontSize:12, color:T.textSoft }}>
              Absents/Repos : <strong style={{ color:'#EF4444' }}>
                {lignes.filter(l => l.presence !== 'P').length}
              </strong>
            </span>
            <span style={{ fontSize:12, color:T.textSoft }}>
              Total heures : <strong style={{ color:T.primary }}>
                {lignes.reduce((s, l) => s + (l.heures_N || 0), 0)}h
              </strong>
            </span>
          </div>

          {/* Boutons actions */}
          {!dejaS && (
            <div style={{ display:'flex', gap:10, marginTop:16, flexWrap:'wrap' }}>
              <button onClick={ajouterOccasionnel} style={{
                background:T.borderSoft, border:`1px solid ${T.border}`,
                borderRadius:10, padding:'9px 16px', cursor:'pointer',
                fontSize:13, fontWeight:600, color:T.text,
                display:'flex', alignItems:'center', gap:6,
              }}>
                <IconAdd size={16} color={T.textSoft}/> Ajouter occasionnel
              </button>
            </div>
          )}
        </div>
      )}

      {/* Boutons principaux */}
      {equipeId && !dejaS && lignes.length > 0 && (
        <div style={{ display:'flex', gap:10, flexWrap:'wrap' }}>
          <button onClick={envoyer} disabled={loading} style={{
            background:T.primary, color:'#fff', border:'none',
            borderRadius:12, padding:'12px 24px',
            fontSize:14, fontWeight:700, cursor:'pointer',
            display:'flex', alignItems:'center', gap:8,
            opacity: loading ? 0.7 : 1,
          }}>
            <IconSend size={16} color="#fff"/>
            {loading ? "Envoi..." : "Envoyer le pointage"}
          </button>
        </div>
      )}

      {/* Message si pas d'équipes */}
      {equipes.length === 0 && chaine && (
        <div style={{
          background:T.card, border:`1px solid ${T.border}`,
          borderRadius:14, padding:'40px 20px', textAlign:'center',
        }}>
          <p style={{ fontSize:14, color:T.textSoft }}>
            Aucune équipe configurée pour {chaine}.
          </p>
          <p style={{ fontSize:12, color:T.textMuted }}>
            Un manager doit d'abord créer les équipes dans Administration → Équipes.
          </p>
        </div>
      )}
    </div>
  );
}