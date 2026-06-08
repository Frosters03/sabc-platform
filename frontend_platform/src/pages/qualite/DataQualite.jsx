import { useState } from 'react';
import { useTheme } from '../../components/layout/Layout';
import { useAuth } from '../../context/AuthContext';
import { qualiteAPI } from '../../services/api';
import BoutonRetour from '../../components/BoutonRetour';

function useIsMobile() {
  const [isMobile, setIsMobile] = useState(
    () => window.innerWidth < 768
  );
  return isMobile;
}

// ── ICÔNES ────────────────────────────────────────────────
const IconCheck   = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>;
const IconWarn    = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>;
const IconScience = ({s=18,c='currentColor'}) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M7 2v2h1v9.26l-5 6.74V22h18v-2.74l-5-6.74V4h1V2H7zm5 14c-.55 0-1-.45-1-1s.45-1 1-1 1 .45 1 1-.45 1-1 1zm3-4H9V4h6v8z"/></svg>;

// ── STYLES ────────────────────────────────────────────────
const labelStyle = { display:'block', fontSize:11, fontWeight:600,
  marginBottom:6, textTransform:'uppercase', letterSpacing:0.5 };

function inputStyle(T) {
  return { width:'100%', padding:'11px 12px',
    background:T.bg, border:`1.5px solid ${T.border}`,
    borderRadius:10, fontSize:14, color:T.text,
    outline:'none', boxSizing:'border-box' };
}

function InputField({ label, value, onChange, unit, placeholder, T, step }) {
  const [focused, setFocused] = useState(false);
  return (
    <div style={{ marginBottom:14 }}>
      <label style={{ ...labelStyle, color:T.textSoft }}>{label}</label>
      <div style={{
        display:'flex', alignItems:'center', background:T.bg,
        border:`1.5px solid ${focused ? T.primary : T.border}`,
        borderRadius:10, overflow:'hidden', transition:'border 0.2s',
      }}>
        <input type="number" step={step||'0.01'} value={value}
          onChange={e => onChange(e.target.value)}
          onFocus={() => setFocused(true)}
          onBlur={() => setFocused(false)}
          placeholder={placeholder||'0.00'}
          style={{ flex:1, padding:'11px 12px', background:'transparent',
            border:'none', outline:'none', fontSize:14, color:T.text,
            fontWeight:500, minWidth:0 }}
        />
        {unit && <span style={{ padding:'0 10px', fontSize:11,
          color:T.textSoft, background:T.borderSoft,
          borderLeft:`1px solid ${T.border}`,
          height:'100%', display:'flex', alignItems:'center' }}>{unit}</span>}
      </div>
    </div>
  );
}

function SectionCard({ title, icon, iconColor, children, T }) {
  return (
    <div style={{ background:T.card, borderRadius:14, padding:'18px',
      boxShadow:'0 1px 8px rgba(0,0,0,0.06)',
      border:`1px solid ${T.border}`, marginBottom:14,
      boxSizing:'border-box', width:'100%' }}>
      <div style={{ display:'flex', alignItems:'center', gap:8,
        marginBottom:16, paddingBottom:12, borderBottom:`1px solid ${T.border}` }}>
        <div style={{ width:28, height:28, borderRadius:8,
          background:`${iconColor}18`,
          display:'flex', alignItems:'center', justifyContent:'center' }}>
          {icon}
        </div>
        <h3 style={{ margin:0, fontSize:13, fontWeight:700, color:T.text }}>{title}</h3>
      </div>
      {children}
    </div>
  );
}

// ── GRILLE SERTISSAGE ─────────────────────────────────────
function GrilleSertissage({ values, onChange, T, isMobile }) {
  const handleChange = (idx, val) => {
    const n = [...values]; n[idx] = val; onChange(n);
  };
  const getColor = val => {
    const v = parseFloat(val);
    if (!v) return T.border;
    if (v < 1.08 || v > 1.17) return T.danger;
    if (v < 1.10 || v > 1.15) return T.warning;
    return T.success;
  };
  const cols = isMobile ? 4 : (values.length === 20 ? 5 : 6);
  return (
    <div>
      <div style={{ display:'flex', gap:12, marginBottom:12, flexWrap:'wrap' }}>
        {[{c:T.success,l:'Normal (1.10–1.15)'},{c:T.warning,l:'Limite'},{c:T.danger,l:'Hors seuil'}].map((x,i)=>(
          <div key={i} style={{ display:'flex', alignItems:'center', gap:5, fontSize:10, color:T.textSoft }}>
            <div style={{ width:8, height:8, borderRadius:'50%', background:x.c }}/>{x.l}
          </div>
        ))}
      </div>
      <div style={{ display:'grid', gridTemplateColumns:`repeat(${cols},1fr)`, gap:isMobile?6:8 }}>
        {values.map((val,idx)=>(
          <div key={idx}>
            <div style={{ fontSize:9, color:T.textMuted, marginBottom:2, textAlign:'center', fontWeight:600 }}>C{idx+1}</div>
            <input type="number" step="0.01" value={val}
              onChange={e=>handleChange(idx,e.target.value)}
              placeholder="1.12"
              style={{ width:'100%', padding:isMobile?'6px 2px':'8px 4px',
                background:T.bg, border:`2px solid ${getColor(val)}`,
                borderRadius:7, fontSize:isMobile?11:12, color:T.text,
                outline:'none', textAlign:'center', boxSizing:'border-box',
                fontWeight:600, transition:'border 0.2s' }}
            />
          </div>
        ))}
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════
// VOLET AM / BRSA
// ══════════════════════════════════════════════════════════
const getNbCases = atelier => {
  if (atelier === 'Chaîne 14') return 20;
  if (atelier === 'Chaîne 13') return 0;
  return 24;
};

const PRODUITS_AM = [
  'Booster Whisky Cola', 'Booster Gin Tonic',
];
const PRODUITS_BRSA = [
  'Top Grenadine', 'Top Ananas', 'Top Pamplemousse', 'Top Orange',
  'Djino', 'XXL',
];

function FormulaireAMBRSA({ typeVolet, T, isMobile }) {
  const { user } = useAuth();
  const FORM_VIDE = {
    date: new Date().toISOString().split('T')[0],
    heure: new Date().toTimeString().slice(0,5),
    quart:'', atelier:'', produit:'', brix:'', co2_qualite:'', bo2:'',
  };
  const [form, setForm]       = useState(FORM_VIDE);
  const [sert, setSert]       = useState(Array(24).fill(''));
  const [loading, setLoading] = useState(false);
  const [msg, setMsg]         = useState(null);

  const set = f => v => setForm(p=>({...p,[f]:v}));
  const ateliers = ['Chaîne 8','Chaîne 14','Chaîne 15','Chaîne 16'];
  const produits = typeVolet === 'Alcool Mix' ? PRODUITS_AM : PRODUITS_BRSA;

  const handleSubmit = async () => {
    if (!form.quart || !form.atelier || !form.brix || !form.co2_qualite)
      return setMsg({ type:'error', text:'Remplir tous les champs obligatoires' });
    setLoading(true);
    try {
      await qualiteAPI.creer({
        ...form, type_volet: typeVolet,
        brix: parseFloat(form.brix),
        co2_qualite: parseFloat(form.co2_qualite),
        sertissage_data: getNbCases(form.atelier) > 0
          ? JSON.stringify(sert.map(v=>parseFloat(v))) : null,
        saisi_par: user?.username,
      });
      setForm({...FORM_VIDE, date:new Date().toISOString().split('T')[0],
        heure:new Date().toTimeString().slice(0,5)});
      setSert(Array(24).fill(''));
      setMsg({ type:'success', text:'Relevé enregistré !' });
      setTimeout(()=>setMsg(null), 4000);
    } catch(e) {
      setMsg({ type:'error', text: e.response?.data?.detail||'Erreur' });
    } finally { setLoading(false); }
  };

  const nbCases = getNbCases(form.atelier);
  const color   = typeVolet === 'AM' ? '#10B981' : '#3B82F6';

  return (
    <div>
      {msg && (
        <div style={{ padding:'12px 16px', borderRadius:12, marginBottom:16,
          background: msg.type==='success'?'#F0FDF4':'#FEF2F2',
          border:`1px solid ${msg.type==='success'?'#BBF7D0':'#FECACA'}`,
          color: msg.type==='success'?T.success:T.danger,
          fontSize:13, fontWeight:600, display:'flex', alignItems:'center', gap:8 }}>
          {msg.type==='success' ? <IconCheck s={16} c={T.success}/> : <IconWarn s={16} c={T.danger}/>}
          {msg.text}
        </div>
      )}

      <SectionCard title="Identification" icon={<IconScience s={15} c={color}/>} iconColor={color} T={T}>
        <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:'0 14px' }}>
          {[['date','Date','date'],['heure','Heure','time']].map(([f,l,t])=>(
            <div key={f} style={{ marginBottom:14 }}>
              <label style={{ ...labelStyle, color:T.textSoft }}>{l}</label>
              <input type={t} value={form[f]} onChange={e=>set(f)(e.target.value)} style={inputStyle(T)}/>
            </div>
          ))}
          <div style={{ marginBottom:14 }}>
            <label style={{ ...labelStyle, color:T.textSoft }}>Quart</label>
            <select value={form.quart} onChange={e=>set('quart')(e.target.value)} style={{ ...inputStyle(T), cursor:'pointer' }}>
              <option value="">-- Sélectionner --</option>
              {['22h-6h','6h-14h','14h-22h'].map(q=><option key={q} value={q}>{q}</option>)}
            </select>
          </div>
          <div style={{ marginBottom:14 }}>
            <label style={{ ...labelStyle, color:T.textSoft }}>Atelier</label>
            <select value={form.atelier} onChange={e=>{set('atelier')(e.target.value); setSert(Array(getNbCases(e.target.value)).fill(''));}} style={{ ...inputStyle(T), cursor:'pointer' }}>
              <option value="">-- Sélectionner --</option>
              {ateliers.map(a=><option key={a} value={a}>{a}</option>)}
            </select>
          </div>
          <div style={{ marginBottom:14, gridColumn:'1 / -1' }}>
            <label style={{ ...labelStyle, color:T.textSoft }}>Produit</label>
            <select value={form.produit} onChange={e=>set('produit')(e.target.value)} style={{ ...inputStyle(T), cursor:'pointer' }}>
              <option value="">-- Sélectionner --</option>
              {produits.map(p=><option key={p} value={p}>{p}</option>)}
            </select>
          </div>
        </div>
      </SectionCard>

      <SectionCard title="Paramètres qualité" icon={<IconScience s={15} c={color}/>} iconColor={color} T={T}>
        <div style={{ display:'grid', gridTemplateColumns:isMobile?'1fr':'1fr 1fr', gap:'0 14px' }}>
          <InputField label="Brix (°Bx)"        value={form.brix}        onChange={set('brix')}        unit="°Bx"  placeholder="10.8" T={T}/>
          <InputField label="CO₂ qualité"        value={form.co2_qualite} onChange={set('co2_qualite')} unit="g/L"  placeholder="5.2"  T={T}/>
        </div>
      </SectionCard>

      {form.atelier && nbCases > 0 && (
        <SectionCard title={`Sertissage — ${nbCases} cases (mm)`} icon={<IconScience s={15} c={T.gold}/>} iconColor={T.gold} T={T}>
          <GrilleSertissage values={sert} onChange={setSert} T={T} isMobile={isMobile}/>
        </SectionCard>
      )}

      <button onClick={handleSubmit} disabled={loading} style={{
        width:'100%', padding:'14px',
        background: loading ? T.textMuted : color,
        color:'#fff', border:'none', borderRadius:12,
        fontSize:15, fontWeight:700,
        cursor: loading ? 'not-allowed' : 'pointer',
        display:'flex', alignItems:'center', justifyContent:'center', gap:10,
      }}>
        <IconCheck s={18} c="#fff"/>
        {loading ? 'Enregistrement...' : `Enregistrer relevé ${typeVolet}`}
      </button>
    </div>
  );
}

// ══════════════════════════════════════════════════════════
// VOLET A
// ══════════════════════════════════════════════════════════
const PRODUITS_A = [
  'Castle Milk Stout', '33 Export', 'Castel Beer',
  'Mutzig', 'IsenBock', 'Beaufort Light',
  'Beaufort Lager', 'Manyan', 'Doppel Munich', 'Chill Citron',
];

// Limites Volet A
const LIMITES_A = {
  densite:      { cible:14.40, tol:0.30 },
  saturation:   { cible:4.90,  tol:0.30 },
  o2_dissous:   { ls:0.09 },
  gaz_etranger: { ls:1.0  },
  bilan_o2:     { ls:0.15 },
};

function StatutValeur({ valeur, cible, tol, ls, T }) {
  if (valeur === '' || valeur === null || valeur === undefined) return null;
  const v = parseFloat(valeur);
  let ok = true;
  if (cible !== undefined) ok = Math.abs(v - cible) <= tol;
  if (ls    !== undefined) ok = v <= ls;
  return (
    <span style={{ fontSize:10, padding:'1px 7px', borderRadius:20,
      background: ok ? '#F0FDF4':'#FEF2F2',
      color: ok ? T.success : T.danger, fontWeight:600, marginLeft:6 }}>
      {ok ? '✓ OK' : '✗ Hors'}
    </span>
  );
}

const SPECS_BIERES = {
  'Castle Milk Stout': { densite_cible:14.40, densite_tol:0.25, co2_cible:4.90, co2_tol:0.20 },
  '33 Export':         { densite_cible:11.85, densite_tol:0.15, co2_cible:5.50, co2_tol:0.20 },
  'Castel Beer':       { densite_cible:12.00, densite_tol:0.20, co2_cible:6.00, co2_tol:0.20 },
  'Mutzig':            { densite_cible:12.20, densite_tol:0.20, co2_cible:5.30, co2_tol:0.20 },
  'IsenBock':          { densite_cible:11.40, densite_tol:0.20, co2_cible:5.90, co2_tol:0.20 },
  'Beaufort Light':    { densite_cible: 9.70, densite_tol:0.20, co2_cible:5.50, co2_tol:0.20 },
  'Beaufort Lager':    { densite_cible:11.00, densite_tol:0.20, co2_cible:5.80, co2_tol:0.20 },
  'Manyan':            { densite_cible:11.60, densite_tol:0.20, co2_cible:6.00, co2_tol:0.20 },
  'Doppel Munich':     { densite_cible:13.40, densite_tol:0.20, co2_cible:6.00, co2_tol:0.20 },
  'Chill Citron':      { densite_cible:10.40, densite_tol:0.30, co2_cible:5.50, co2_tol:0.20 },
};


function FormulaireVoletA({ T, isMobile }) {
  const { user } = useAuth();
  const VIDE = {
    date: new Date().toISOString().split('T')[0],
    heure: new Date().toTimeString().slice(0,5),
    quart:'', atelier:'', produit:'',
    densite_valeur:'', saturation_valeur:'',
    saturation_pression:'', saturation_temperature:'', saturation_air_total:'',
    o2_dissous:'', gaz_etranger:'',
    bilan_o2_total:'', bilan_o2_col:'', bilan_o2_reprise:'',
    bilan_o2_bln:'', bilan_o2_es:'',
    pression_pissette:'', contre_pression:'',
    cadence_soutireuse:'', debit_co2_balayage:'',
  };
  const [form, setForm]       = useState(VIDE);
  const [sert, setSert]       = useState(Array(24).fill(''));
  const [loading, setLoading] = useState(false);
  const [msg, setMsg]         = useState(null);

  const specs = SPECS_BIERES[form.produit] || { densite_cible:14.40, densite_tol:0.30, co2_cible:4.90, co2_tol:0.30 };
  

  const set = f => v => setForm(p=>({...p,[f]:v}));
  const ateliers = ['Chaîne 8','Chaîne 14','Chaîne 15','Chaîne 16'];
  const color = '#DA291C';

  const toFloat = v => v !== '' ? parseFloat(v) : null;

  const handleSubmit = async () => {
    if (!form.quart || !form.atelier)
      return setMsg({ type:'error', text:'Sélectionner quart et atelier' });
    setLoading(true);
    try {
      await qualiteAPI.creerVoletA({
        ...Object.fromEntries(Object.entries(form).map(([k,v])=>[k, typeof v==='string' && v!=='' && !['date','heure','quart','atelier','produit'].includes(k) ? parseFloat(v)||null : v||null])),
        date: form.date, heure: form.heure, quart: form.quart,
        atelier: form.atelier, produit: form.produit||null,
        sertissage_data: getNbCases(form.atelier) > 0
          ? JSON.stringify(sert.map(v=>parseFloat(v))) : null,
        saisi_par: user?.username,
      });
      setForm({...VIDE, date:new Date().toISOString().split('T')[0], heure:new Date().toTimeString().slice(0,5)});
      setSert(Array(24).fill(''));
      setMsg({ type:'success', text:'Relevé Volet A enregistré !' });
      setTimeout(()=>setMsg(null), 4000);
    } catch(e) {
      setMsg({ type:'error', text: e.response?.data?.detail||'Erreur' });
    } finally { setLoading(false); }
  };

  const IF = ({ label, field, unit, placeholder, cible, tol, ls, step }) => (
    <div style={{ marginBottom:14 }}>
      <label style={{ ...labelStyle, color:T.textSoft, display:'flex', alignItems:'center' }}>
        {label}
        <StatutValeur valeur={form[field]} cible={cible} tol={tol} ls={ls} T={T}/>
        {cible && <span style={{ fontSize:9, color:T.textMuted, marginLeft:4 }}>(cible: {cible} ±{tol})</span>}
        {ls && <span style={{ fontSize:9, color:T.textMuted, marginLeft:4 }}>(LS: {ls})</span>}
      </label>
      <div style={{ display:'flex', alignItems:'center', background:T.bg,
        border:`1.5px solid ${T.border}`, borderRadius:10, overflow:'hidden' }}>
        <input type="number" step={step||'0.01'} value={form[field]}
          onChange={e=>set(field)(e.target.value)} placeholder={placeholder||'0.00'}
          style={{ flex:1, padding:'11px 12px', background:'transparent',
            border:'none', outline:'none', fontSize:14, color:T.text, fontWeight:500 }}
        />
        {unit && <span style={{ padding:'0 10px', fontSize:11, color:T.textSoft,
          background:T.borderSoft, borderLeft:`1px solid ${T.border}`,
          display:'flex', alignItems:'center' }}>{unit}</span>}
      </div>
    </div>
  );

  const nbCases = getNbCases(form.atelier);

  return (
    <div>
      {msg && (
        <div style={{ padding:'12px 16px', borderRadius:12, marginBottom:16,
          background:msg.type==='success'?'#F0FDF4':'#FEF2F2',
          border:`1px solid ${msg.type==='success'?'#BBF7D0':'#FECACA'}`,
          color:msg.type==='success'?T.success:T.danger,
          fontSize:13, fontWeight:600, display:'flex', gap:8, alignItems:'center' }}>
          {msg.type==='success'?<IconCheck s={16} c={T.success}/>:<IconWarn s={16} c={T.danger}/>}
          {msg.text}
        </div>
      )}

      {/* Identification */}
      <SectionCard title="Identification" icon={<IconScience s={15} c={color}/>} iconColor={color} T={T}>
        <div style={{ display:'grid', gridTemplateColumns:'1fr 1fr', gap:'0 14px' }}>
          {[['date','Date','date'],['heure','Heure','time']].map(([f,l,t])=>(
            <div key={f} style={{ marginBottom:14 }}>
              <label style={{ ...labelStyle, color:T.textSoft }}>{l}</label>
              <input type={t} value={form[f]} onChange={e=>set(f)(e.target.value)} style={inputStyle(T)}/>
            </div>
          ))}
          <div style={{ marginBottom:14 }}>
            <label style={{ ...labelStyle, color:T.textSoft }}>Quart</label>
            <select value={form.quart} onChange={e=>set('quart')(e.target.value)} style={{ ...inputStyle(T), cursor:'pointer' }}>
              <option value="">-- Sélectionner --</option>
              {['22h-6h','6h-14h','14h-22h'].map(q=><option key={q} value={q}>{q}</option>)}
            </select>
          </div>
          <div style={{ marginBottom:14 }}>
            <label style={{ ...labelStyle, color:T.textSoft }}>Atelier</label>
            <select value={form.atelier} onChange={e=>{set('atelier')(e.target.value); setSert(Array(getNbCases(e.target.value)).fill(''));}} style={{ ...inputStyle(T), cursor:'pointer' }}>
              <option value="">-- Sélectionner --</option>
              {ateliers.map(a=><option key={a} value={a}>{a}</option>)}
            </select>
          </div>
          <div style={{ marginBottom:14, gridColumn:'1 / -1' }}>
            <label style={{ ...labelStyle, color:T.textSoft }}>Produit</label>
            <select value={form.produit} onChange={e=>set('produit')(e.target.value)} style={{ ...inputStyle(T), cursor:'pointer' }}>
              <option value="">-- Sélectionner --</option>
              {PRODUITS_A.map(p=><option key={p} value={p}>{p}</option>)}
            </select>
          </div>
        </div>
      </SectionCard>

      {/* Densité */}
      <SectionCard title="Densité — Extrait Primitif" icon={<IconScience s={15} c="#8B5CF6"/>} iconColor="#8B5CF6" T={T}>
        <IF label="Valeur densité" field="densite_valeur" unit="°P" placeholder={String(specs.densite_cible)}
          cible={specs.densite_cible} tol={specs.densite_tol}/>
      </SectionCard>

      {/* Saturation */}
      <SectionCard title="Saturation — Carbonatation CO₂" icon={<IconScience s={15} c="#06B6D4"/>} iconColor="#06B6D4" T={T}>
        <div style={{ display:'grid', gridTemplateColumns:isMobile?'1fr':'1fr 1fr 1fr', gap:'0 14px' }}>
          <IF label="CO₂ saturation" field="saturation_valeur" unit="g/L" placeholder={String(specs.co2_cible)} cible={specs.co2_cible} tol={specs.co2_tol}/>
          <IF label="Pression (P°)"  field="saturation_pression" unit="bar" placeholder="1.5"/>
          <IF label="Température"    field="saturation_temperature" unit="°C" placeholder="8.0"/>
        </div>
        <IF label="Air total" field="saturation_air_total" unit="mL/L" placeholder="0.0"/>
      </SectionCard>

      {/* O2 dissous */}
      <SectionCard title="O₂ Dissous — Démarrage" icon={<IconScience s={15} c="#10B981"/>} iconColor="#10B981" T={T}>
        <IF label="O₂ dissous" field="o2_dissous" unit="mg/L" placeholder="0.07"
          ls={0.09} step="0.001"/>
        <div style={{ padding:'8px 12px', borderRadius:8,
          background:'#FFF8E1', border:'1px solid #FDE68A', fontSize:11, color:'#92400E' }}>
          Limite supérieure (LS) : 0.09 mg/L — Au-dessus = risque oxydation du produit
        </div>
      </SectionCard>

      {/* Gaz étranger */}
      <SectionCard title="Volume de Gaz Étranger" icon={<IconScience s={15} c="#F59E0B"/>} iconColor="#F59E0B" T={T}>
        <IF label="Volume gaz étranger" field="gaz_etranger" unit="vol" placeholder="0.5" ls={1.0}/>
        <div style={{ padding:'8px 12px', borderRadius:8,
          background:'#FFF8E1', border:'1px solid #FDE68A', fontSize:11, color:'#92400E' }}>
          Limite supérieure (LS) : 1.0 vol
        </div>
      </SectionCard>

      {/* Bilan Oxygène */}
      <SectionCard title="Bilan Oxygène" icon={<IconScience s={15} c="#EF4444"/>} iconColor="#EF4444" T={T}>
        <div style={{ display:'grid', gridTemplateColumns:isMobile?'1fr':'1fr 1fr', gap:'0 14px' }}>
          <IF label="O₂ total"          field="bilan_o2_total"   unit="mg/L" placeholder="0.10" ls={0.15}/>
          <IF label="O₂ col [0–0.7]"    field="bilan_o2_col"     unit="mg/L" placeholder="0.05" step="0.001"/>
          <IF label="O₂ reprise [0–0.09]" field="bilan_o2_reprise" unit="mg/L" placeholder="0.02" step="0.001"/>
          <IF label="O₂ bln [0–0.01]"   field="bilan_o2_bln"    unit="mg/L" placeholder="0.005" step="0.001"/>
          <IF label="O₂ ES [0–0.0]"     field="bilan_o2_es"     unit="mg/L" placeholder="0.0" step="0.001"/>
        </div>
        <div style={{ display:'grid', gridTemplateColumns:isMobile?'1fr':'1fr 1fr', gap:'0 14px', marginTop:8 }}>
          <IF label="Pression pissette [4–7]"  field="pression_pissette"  unit="bar" placeholder="5.0"/>
          <IF label="Contre-pression [1.5–2.5]" field="contre_pression"   unit="bar" placeholder="2.0"/>
          <IF label="Cadence soutireuse [24.5–45]" field="cadence_soutireuse" unit="col/min" placeholder="35"/>
          <IF label="Débit CO₂ balayage"        field="debit_co2_balayage" unit="m³/h" placeholder="2.0"/>
        </div>
      </SectionCard>

      {/* Sertissage */}
      {form.atelier && nbCases > 0 && (
        <SectionCard title={`Sertissage — ${nbCases} cases (mm)`} icon={<IconScience s={15} c={T.gold}/>} iconColor={T.gold} T={T}>
          <GrilleSertissage values={sert} onChange={setSert} T={T} isMobile={isMobile}/>
        </SectionCard>
      )}

      <button onClick={handleSubmit} disabled={loading} style={{
        width:'100%', padding:'14px',
        background: loading ? T.textMuted : color,
        color:'#fff', border:'none', borderRadius:12,
        fontSize:15, fontWeight:700,
        cursor: loading ? 'not-allowed' : 'pointer',
        display:'flex', alignItems:'center', justifyContent:'center', gap:10,
      }}>
        <IconCheck s={18} c="#fff"/>
        {loading ? 'Enregistrement...' : 'Enregistrer relevé Volet A'}
      </button>
    </div>
  );
}

// ══════════════════════════════════════════════════════════
// PAGE PRINCIPALE — DataQualite
// ══════════════════════════════════════════════════════════
export default function DataQualite() {
  const { T }    = useTheme();
  const isMobile = useIsMobile();
  const [onglet, setOnglet] = useState('A');

  const onglets = [
    { key:'Bière',      label:'Bière',      desc:'Bières alcoolisées', color:'#DA291C' },
    { key:'Alcool Mix', label:'Alcool Mix',  desc:'Boissons maltées',   color:'#10B981' },
    { key:'BRSA',       label:'BRSA',        desc:'Sans alcool',        color:'#3B82F6' },
  ];

  return (
    <div style={{ padding:isMobile?'16px 14px 100px':'24px 28px',
      background:T.bg, minHeight:'100vh', boxSizing:'border-box' }}>

      {/* En-tête */}
      <BoutonRetour vers="/qualite" titre="Data — Saisie Qualité" />

      {/* Onglets */}
      <div style={{ display:'flex', gap:6, marginBottom:20, flexWrap:'wrap' }}>
        {onglets.map(o => (
          <button key={o.key} onClick={() => setOnglet(o.key)} style={{
            padding:'10px 20px', borderRadius:10, border:'none', cursor:'pointer',
            background: onglet === o.key ? o.color : T.card,
            color:       onglet === o.key ? '#fff'  : T.textSoft,
            border: `1px solid ${onglet === o.key ? o.color : T.border}`,
            fontSize:12, fontWeight:600, transition:'all 0.2s',
          }}>
            <div>{o.label}</div>
            <div style={{ fontSize:9, opacity:0.8 }}>{o.desc}</div>
          </button>
        ))}
      </div>

      {/* Contenu */}
      <div style={{ maxWidth:860, margin:'0 auto' }}>
        {onglet === 'Bière'    && <FormulaireVoletA     T={T} isMobile={isMobile}/>}
        {onglet === 'Alcool Mix'   && <FormulaireAMBRSA typeVolet="Alcool Mix"   T={T} isMobile={isMobile}/>}
        {onglet === 'BRSA' && <FormulaireAMBRSA typeVolet="BRSA" T={T} isMobile={isMobile}/>}
      </div>
    </div>
  );
}