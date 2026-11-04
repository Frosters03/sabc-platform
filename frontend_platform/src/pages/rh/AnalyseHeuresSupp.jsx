import { useState, useEffect } from "react";
import { useTheme } from "../../components/layout/Layout";
import { equipesAPI, pointagesAPI } from "../../services/api";
import BoutonRetour from "../../components/BoutonRetour";

const NIVEAUX = {
  ok:        { label: "Dans le quota",  color: "#10B981" },
  attention: { label: "Proche du quota", color: "#F59E0B" },
  depasse:   { label: "Quota dépassé",  color: "#EF4444" },
};
const GRAVITES = {
  critique:  { color: "#EF4444", bg: "rgba(239,68,68,0.08)",  titre: "Quota dépassé" },
  attention: { color: "#F59E0B", bg: "rgba(245,158,11,0.08)", titre: "Proche du quota" },
  prevision: { color: "#3B82F6", bg: "rgba(59,130,246,0.08)", titre: "Prévision IA" },
};

function moisCourant() {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}`;
}
function fmtDate(iso) {
  if (!iso) return "";
  const [a, m, j] = iso.split("-");
  return `${j}/${m}/${a}`;
}
function useIsMobile() {
  const [m, setM] = useState(() => window.innerWidth < 768);
  useEffect(() => {
    const h = () => setM(window.innerWidth < 768);
    window.addEventListener("resize", h);
    return () => window.removeEventListener("resize", h);
  }, []);
  return m;
}

function Kpi({ label, value, color, T }) {
  return (
    <div style={{ background: T.card, border: `1px solid ${T.border}`, borderRadius: 14, padding: "14px 16px" }}>
      <div style={{ fontSize: 24, fontWeight: 700, color, lineHeight: 1 }}>{value}</div>
      <div style={{ fontSize: 11, color: T.textSoft, marginTop: 6 }}>{label}</div>
    </div>
  );
}

export default function AnalyseHeuresSupp() {
  const { T } = useTheme();
  const isMobile = useIsMobile();

  const [mois, setMois] = useState(moisCourant());
  const [equipeId, setEquipeId] = useState("");
  const [quota, setQuota] = useState(40);
  const [equipes, setEquipes] = useState([]);
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [erreur, setErreur] = useState(null);

  const IS = { background: T.card, border: `1px solid ${T.border}`, borderRadius: 10, padding: "8px 12px", color: T.text, fontSize: 13, width: "100%", boxSizing: "border-box" };
  const LS = { fontSize: 11, fontWeight: 700, color: T.textSoft, textTransform: "uppercase", letterSpacing: 0.8, marginBottom: 4, display: "block" };

  useEffect(() => {
    equipesAPI.lister().then(r => setEquipes(r.data || [])).catch(() => setEquipes([]));
  }, []);

  useEffect(() => {
    let actif = true;
    const q = Number(quota);
    if (!mois || !(q > 0)) return undefined;
    setLoading(true); setErreur(null);
    const params = { mois, quota: q };
    if (equipeId) params.equipe_id = equipeId;
    pointagesAPI.analyseHeuresSupp(params)
      .then(r => { if (actif) setData(r.data); })
      .catch(e => { if (actif) { setData(null); setErreur(e?.response?.data?.detail || "Erreur de récupération des données."); } })
      .finally(() => { if (actif) setLoading(false); });
    return () => { actif = false; };
  }, [mois, equipeId, quota]);

  return (
    <div style={{ padding: isMobile ? "16px 14px 100px" : "24px 28px", maxWidth: 1000, margin: "0 auto", boxSizing: "border-box" }}>
      <BoutonRetour vers="/pointage" titre="Analyse heures supplémentaires" />

      {/* Filtres */}
      <div style={{ display: "grid", gridTemplateColumns: isMobile ? "1fr 1fr" : "1fr 1fr 140px", gap: 12, marginBottom: 20 }}>
        <div>
          <label style={LS}>Mois</label>
          <input type="month" value={mois} onChange={e => setMois(e.target.value)} style={IS} />
        </div>
        <div>
          <label style={LS}>Équipe</label>
          <select value={equipeId} onChange={e => setEquipeId(e.target.value)} style={IS}>
            <option value="">Toutes</option>
            {equipes.map(e => <option key={e.id} value={e.id}>{e.nom} — {e.chaine}</option>)}
          </select>
        </div>
        <div>
          <label style={LS}>Quota (h / mois)</label>
          <input type="number" min="1" max="200" value={quota} onChange={e => setQuota(e.target.value)} style={IS} />
        </div>
      </div>

      {loading && <div style={{ textAlign: "center", padding: 40, color: T.textSoft, fontSize: 13 }}>Analyse en cours…</div>}
      {erreur && <div style={{ padding: 14, borderRadius: 10, background: "rgba(239,68,68,0.08)", color: "#EF4444", fontSize: 13 }}>{erreur}</div>}

      {data && !loading && (
        <>
          {/* Résumé */}
          <div style={{ display: "grid", gridTemplateColumns: isMobile ? "1fr 1fr" : "repeat(4, 1fr)", gap: 12, marginBottom: 20 }}>
            <Kpi T={T} label="Personnes suivies" value={data.resume.nb_personnes} color={T.text} />
            <Kpi T={T} label="Quota dépassé" value={data.resume.nb_depasse} color="#EF4444" />
            <Kpi T={T} label="Proches du quota (≥ 80 %)" value={data.resume.nb_attention} color="#F59E0B" />
            <Kpi T={T} label="Total heures supp." value={`${data.resume.total_hs} h`} color="#3B82F6" />
          </div>

          {data.resume.nb_personnes === 0 && (
            <div style={{ textAlign: "center", padding: 40, color: T.textSoft, fontSize: 13, background: T.card, border: `1px dashed ${T.border}`, borderRadius: 14 }}>
              Aucun pointage pour ce mois. Les heures supp. se calculent sur les pointages saisis (heures normales + fériées au-delà de 40 h par semaine).
            </div>
          )}

          {/* Alertes IA */}
          {data.alertes.length > 0 && (
            <div style={{ marginBottom: 24 }}>
              <h3 style={{ fontSize: 13, fontWeight: 700, color: T.text, margin: "0 0 10px" }}>Alertes pointage · IA</h3>
              <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                {data.alertes.map((a, i) => {
                  const g = GRAVITES[a.gravite] || GRAVITES.prevision;
                  return (
                    <div key={i} style={{ background: g.bg, borderLeft: `4px solid ${g.color}`, borderRadius: 10, padding: "10px 14px" }}>
                      <span style={{ fontSize: 10, fontWeight: 700, color: g.color, textTransform: "uppercase", letterSpacing: 0.6 }}>{g.titre}</span>
                      <div style={{ fontSize: 13, color: T.text, marginTop: 2 }}>
                        {a.gravite === "prevision" ? a.message.replace(/(\d{4})-(\d{2})-(\d{2})/, (_, y, m, d) => `${d}/${m}/${y}`) : a.message}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* Par équipe */}
          {data.equipes.map(eq => (
            <div key={eq.equipe_id} style={{ background: T.card, border: `1px solid ${T.border}`, borderRadius: 14, padding: isMobile ? 14 : 18, marginBottom: 16 }}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", flexWrap: "wrap", gap: 6, marginBottom: 12 }}>
                <div>
                  <span style={{ fontSize: 15, fontWeight: 700, color: T.text }}>{eq.equipe}</span>
                  <span style={{ fontSize: 12, color: T.textSoft, marginLeft: 8 }}>{eq.chaine}</span>
                </div>
                <span style={{ fontSize: 12, color: T.textSoft }}>
                  {eq.total_hs} h supp. · {eq.nb_depasse} dépassé{eq.nb_depasse > 1 ? "s" : ""} · {eq.nb_attention} proche{eq.nb_attention > 1 ? "s" : ""}
                </span>
              </div>

              <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
                {eq.membres.map(m => {
                  const nv = NIVEAUX[m.niveau];
                  return (
                    <div key={m.membre_id}>
                      <div style={{ display: "flex", justifyContent: "space-between", gap: 8, fontSize: 13 }}>
                        <span style={{ color: T.text, fontWeight: 600, minWidth: 0, overflow: "hidden", textOverflow: "ellipsis" }}>
                          {m.nom_prenom} <span style={{ color: T.textSoft, fontWeight: 400, fontSize: 11 }}>{m.fonction}</span>
                        </span>
                        <span style={{ color: nv.color, fontWeight: 700, whiteSpace: "nowrap" }}>{m.hs_mois} / {m.quota} h</span>
                      </div>
                      <div style={{ height: 6, borderRadius: 3, background: T.border, overflow: "hidden", margin: "5px 0 3px" }}>
                        <div style={{ height: "100%", width: `${Math.min(100, m.pct)}%`, background: nv.color }} />
                      </div>
                      <div style={{ fontSize: 11, color: T.textSoft }}>
                        {nv.label} · {m.pct.toFixed(0)} %
                        {m.niveau !== "depasse" && ` · reste ${m.reste} h`}
                        {m.prevision && (m.prevision.atteint_le
                          ? ` · quota atteint vers le ${fmtDate(m.prevision.atteint_le)} à ce rythme`
                          : ` · fin de mois estimée : ${m.prevision.fin_de_mois} h`)}
                      </div>
                    </div>
                  );
                })}
              </div>

              {eq.suggestion.length > 0 && (
                <div style={{ marginTop: 14, padding: "10px 12px", borderRadius: 10, background: "rgba(16,185,129,0.08)", fontSize: 12, color: T.text }}>
                  <strong style={{ color: "#10B981" }}>Suggestion IA :</strong> pour les prochaines heures supp., solliciter en priorité{" "}
                  {eq.suggestion.map(s => `${s.nom_prenom} (${s.hs_mois} h faites, ${s.reste} h de marge)`).join(", ")}.
                </div>
              )}
            </div>
          ))}

          <p style={{ fontSize: 11, color: T.textSoft, marginTop: 8 }}>
            Calcul : heures supp. d'une semaine = max(0, heures normales + fériées − 40). Une semaine compte dans le mois de son jeudi.
            {data.derniere_saisie && ` Dernier pointage du mois : ${fmtDate(data.derniere_saisie)}.`}
          </p>
        </>
      )}
    </div>
  );
}
