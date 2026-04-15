import { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useTheme } from '../../components/layout/Layout';
import { qualiteAPI } from '../../services/api';

// ── DÉTECTION MOBILE ──────────────────────────────────────
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

// ── ICÔNES SVG ────────────────────────────────────────────
const IconScience = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M7 2v2h1v9.26l-5 6.74V22h18v-2.74l-5-6.74V4h1V2H7zm5 14c-.55 0-1-.45-1-1s.45-1 1-1 1 .45 1 1-.45 1-1 1zm3-4H9V4h6v8z"/></svg>;
const IconCheck   = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>;
const IconWarning = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>;
const IconBottle  = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M17 3h-2V1H9v2H7.5C6.7 3 6 3.7 6 4.5v1C6 6.9 7 8 7 9.5V20c0 1.1.9 2 2 2h6c1.1 0 2-.9 2-2V9.5c0-1.5 1-2.6 1-4V4.5C18 3.7 17.3 3 16.5 3H15zm-3 4.5c-.8 0-1.5-.7-1.5-1.5S11.2 4.5 12 4.5s1.5.7 1.5 1.5S12.8 7.5 12 7.5zm0 9c-1.7 0-3-1.3-3-3s1.3-3 3-3 3 1.3 3 3-1.3 3-3 3z"/></svg>;

// ── NB CASES SELON ATELIER ────────────────────────────────
const getNbCases = (atelier) => {
  if (atelier === 'Chaîne 14') return 20;
  if (atelier === 'Traitement des eaux') return 0;
  return 24;
};

// ── STYLES COMMUNS ────────────────────────────────────────
const labelStyle = {
  display: 'block', fontSize: 11, fontWeight: 600,
  marginBottom: 6, textTransform: 'uppercase', letterSpacing: 0.5,
};
const inputStyle = (T) => ({
  width: '100%', padding: '11px 12px',
  background: T.bg, border: `1.5px solid ${T.border}`,
  borderRadius: 10, fontSize: 14, color: T.text,
  outline: 'none', boxSizing: 'border-box',
});

// ── CHAMP SIMPLE ──────────────────────────────────────────
function InputField({ label, value, onChange, unit, placeholder, T, step }) {
  const [focused, setFocused] = useState(false);
  return (
    <div style={{ marginBottom: 14 }}>
      <label style={{ ...labelStyle, color: T.textSoft }}>{label}</label>
      <div style={{
        display: 'flex', alignItems: 'center',
        background: T.bg,
        border: `1.5px solid ${focused ? T.primary : T.border}`,
        borderRadius: 10, overflow: 'hidden', transition: 'border 0.2s',
      }}>
        <input
          type="number" step={step || '0.01'} value={value}
          onChange={(e) => onChange(e.target.value)}
          onFocus={() => setFocused(true)}
          onBlur={() => setFocused(false)}
          placeholder={placeholder || '0.00'}
          style={{
            flex: 1, padding: '11px 12px',
            background: 'transparent', border: 'none', outline: 'none',
            fontSize: 14, color: T.text, fontWeight: 500, minWidth: 0,
          }}
        />
        {unit && (
          <span style={{
            padding: '0 10px', fontSize: 11, color: T.textSoft,
            background: T.borderSoft, borderLeft: `1px solid ${T.border}`,
            height: '100%', display: 'flex', alignItems: 'center',
          }}>
            {unit}
          </span>
        )}
      </div>
    </div>
  );
}

// ── SECTION CARD ──────────────────────────────────────────
function SectionCard({ title, icon, iconColor, children, T }) {
  return (
    <div style={{
      background: T.card, borderRadius: 14, padding: '18px',
      boxShadow: '0 1px 8px rgba(0,0,0,0.06)',
      border: `1px solid ${T.border}`, marginBottom: 14,
      boxSizing: 'border-box', width: '100%',
    }}>
      <div style={{
        display: 'flex', alignItems: 'center', gap: 8,
        marginBottom: 16, paddingBottom: 12,
        borderBottom: `1px solid ${T.border}`,
      }}>
        <div style={{
          width: 28, height: 28, borderRadius: 8,
          background: `${iconColor}18`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          {icon}
        </div>
        <h3 style={{ margin: 0, fontSize: 13, fontWeight: 700, color: T.text }}>
          {title}
        </h3>
      </div>
      {children}
    </div>
  );
}

// ── GRILLE SERTISSAGE ─────────────────────────────────────
function GrilleSertissage({ values, onChange, T, isMobile }) {
  const handleChange = (idx, val) => {
    const newVals = [...values];
    newVals[idx] = val;
    onChange(newVals);
  };

  const getColor = (val) => {
    const v = parseFloat(val);
    if (!v) return T.border;
    if (v < 1.08 || v > 1.17) return T.danger;
    if (v < 1.10 || v > 1.15) return T.warning;
    return T.success;
  };

  const cols = isMobile
    ? (values.length === 20 ? 4 : 4)
    : (values.length === 20 ? 5 : 6);

  return (
    <div>
      {/* Légende */}
      <div style={{ display: 'flex', gap: 12, marginBottom: 12, flexWrap: 'wrap' }}>
        {[
          { color: T.success, label: 'Normal (1.10–1.15)' },
          { color: T.warning, label: 'Limite' },
          { color: T.danger,  label: 'Hors seuil' },
        ].map((l, i) => (
          <div key={i} style={{
            display: 'flex', alignItems: 'center', gap: 5,
            fontSize: 10, color: T.textSoft,
          }}>
            <div style={{
              width: 8, height: 8, borderRadius: '50%', background: l.color,
            }} />
            {l.label}
          </div>
        ))}
      </div>

      {/* Grille */}
      <div style={{
        display: 'grid',
        gridTemplateColumns: `repeat(${cols}, 1fr)`,
        gap: isMobile ? 6 : 8,
      }}>
        {values.map((val, idx) => (
          <div key={idx}>
            <div style={{
              fontSize: 9, color: T.textMuted,
              marginBottom: 2, textAlign: 'center', fontWeight: 600,
            }}>
              C{idx + 1}
            </div>
            <input
              type="number" step="0.01" value={val}
              onChange={(e) => handleChange(idx, e.target.value)}
              placeholder="1.12"
              style={{
                width: '100%',
                padding: isMobile ? '6px 2px' : '8px 4px',
                background: T.bg,
                border: `2px solid ${getColor(val)}`,
                borderRadius: 7, fontSize: isMobile ? 11 : 12,
                color: T.text, outline: 'none',
                textAlign: 'center', boxSizing: 'border-box',
                fontWeight: 600, transition: 'border 0.2s',
              }}
            />
          </div>
        ))}
      </div>

      {/* Stats */}
      {values.some(v => v !== '') && (() => {
        const nums = values.map(v => parseFloat(v)).filter(v => !isNaN(v));
        if (!nums.length) return null;
        const moy      = (nums.reduce((a, b) => a + b, 0) / nums.length).toFixed(3);
        const min      = Math.min(...nums).toFixed(3);
        const max      = Math.max(...nums).toFixed(3);
        const horsSeuil= nums.filter(v => v < 1.08 || v > 1.17).length;
        return (
          <div style={{ display: 'flex', gap: 8, marginTop: 10, flexWrap: 'wrap' }}>
            {[
              { label: 'Moy', value: moy, color: T.text },
              { label: 'Min', value: min, color: parseFloat(min) < 1.08 ? T.danger : T.success },
              { label: 'Max', value: max, color: parseFloat(max) > 1.17 ? T.danger : T.success },
              { label: 'Hors seuil', value: horsSeuil, color: horsSeuil > 0 ? T.danger : T.success },
            ].map((s, i) => (
              <div key={i} style={{
                background: T.bg, border: `1px solid ${T.border}`,
                borderRadius: 8, padding: '5px 10px', fontSize: 11,
              }}>
                <span style={{ color: T.textSoft }}>{s.label}: </span>
                <span style={{ color: s.color, fontWeight: 700 }}>{s.value}</span>
              </div>
            ))}
          </div>
        );
      })()}
    </div>
  );
}

// ── FORM VIDE ─────────────────────────────────────────────
const FORM_VIDE = {
  date:        new Date().toISOString().split('T')[0],
  heure:       new Date().toTimeString().slice(0, 5),
  quart:       '',
  atelier:     '',
  brix:        '',
  co2_qualite: '',
  bo2:         '',
};

// ── PAGE SAISIE QUALITE ───────────────────────────────────
export default function SaisieQualite() {
  const { user }  = useAuth();
  const { T }     = useTheme();
  const isMobile  = useIsMobile();

  const [form,       setForm]       = useState(FORM_VIDE);
  const [sertissage, setSertissage] = useState(Array(24).fill(''));
  const [loading,    setLoading]    = useState(false);
  const [message,    setMessage]    = useState(null);

  const set = (field) => (value) => setForm(prev => ({ ...prev, [field]: value }));

  const ateliers = ['Chaîne 8', 'Chaîne 14', 'Chaîne 15', 'Chaîne 16', 'Traitement des eaux'];
  const quarts   = ['22h-6h', '6h-14h', '14h-22h'];

  const valider = () => {
    if (!form.date || !form.heure || !form.quart || !form.atelier)
      return 'Veuillez remplir tous les champs d\'identification';
    if (!form.brix || !form.co2_qualite || !form.bo2)
      return 'Veuillez remplir tous les paramètres qualité';
    const nbCases = getNbCases(form.atelier);
    if (nbCases > 0 && sertissage.some(v => v === ''))
      return `Veuillez remplir toutes les ${nbCases} cases de sertissage`;
    return null;
  };

  const handleSubmit = async () => {
    const erreur = valider();
    if (erreur) {
      setMessage({ type: 'error', text: erreur });
      setTimeout(() => setMessage(null), 4000);
      return;
    }
    setLoading(true);
    setMessage(null);
    try {
      const nbCases = getNbCases(form.atelier);
      await qualiteAPI.creer({
        ...form,
        brix:            parseFloat(form.brix),
        co2_qualite:     parseFloat(form.co2_qualite),
        bo2:             parseFloat(form.bo2),
        sertissage_data: nbCases > 0
          ? JSON.stringify(sertissage.map(v => parseFloat(v)))
          : null,
        saisi_par: user?.username,
      });
      setForm({
        ...FORM_VIDE,
        date:  new Date().toISOString().split('T')[0],
        heure: new Date().toTimeString().slice(0, 5),
      });
      setSertissage(Array(24).fill(''));
      setMessage({ type: 'success', text: 'Relevé qualité enregistré avec succès !' });
      setTimeout(() => setMessage(null), 5000);
    } catch (e) {
      setMessage({
        type: 'error',
        text: e.response?.data?.detail || 'Erreur lors de l\'enregistrement',
      });
      setTimeout(() => setMessage(null), 5000);
    } finally {
      setLoading(false);
    }
  };

  const nbCases = getNbCases(form.atelier);

  return (
    <div style={{
      padding: isMobile ? '16px 14px 100px' : '24px 28px',
      background: T.bg, minHeight: '100vh',
      maxWidth: 860, margin: '0 auto',
      boxSizing: 'border-box', overflowX: 'hidden',
    }}>

      {/* ── MESSAGE ── */}
      {message && (
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10,
          padding: '12px 16px', borderRadius: 12, marginBottom: 16,
          background: message.type === 'success' ? '#F0FDF4' : '#FEF2F2',
          border: `1px solid ${message.type === 'success' ? '#BBF7D0' : '#FECACA'}`,
          color: message.type === 'success' ? T.success : T.danger,
          fontSize: 13, fontWeight: 600, animation: 'fadeIn 0.3s ease',
        }}>
          {message.type === 'success'
            ? <IconCheck size={17} color={T.success} />
            : <IconWarning size={17} color={T.danger} />
          }
          {message.text}
        </div>
      )}
      <style>{`
        @keyframes fadeIn { from { opacity:0; transform:translateY(-8px); } to { opacity:1; transform:translateY(0); } }
        @keyframes spin { to { transform:rotate(360deg); } }
      `}</style>

      {/* ── IDENTIFICATION ── */}
      <SectionCard
        title="Identification du relevé"
        icon={<IconBottle size={15} color={T.primary} />}
        iconColor={T.primary} T={T}
      >
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0 14px' }}>
          <div style={{ marginBottom: 14 }}>
            <label style={{ ...labelStyle, color: T.textSoft }}>Date</label>
            <input type="date" value={form.date}
              onChange={(e) => set('date')(e.target.value)}
              style={inputStyle(T)}
              onFocus={(e) => e.target.style.borderColor = T.primary}
              onBlur={(e)  => e.target.style.borderColor = T.border}
            />
          </div>
          <div style={{ marginBottom: 14 }}>
            <label style={{ ...labelStyle, color: T.textSoft }}>Heure</label>
            <input type="time" value={form.heure}
              onChange={(e) => set('heure')(e.target.value)}
              style={inputStyle(T)}
              onFocus={(e) => e.target.style.borderColor = T.primary}
              onBlur={(e)  => e.target.style.borderColor = T.border}
            />
          </div>
          <div style={{ marginBottom: 14 }}>
            <label style={{ ...labelStyle, color: T.textSoft }}>Quart</label>
            <select value={form.quart}
              onChange={(e) => set('quart')(e.target.value)}
              style={{ ...inputStyle(T), cursor: 'pointer',
                color: form.quart ? T.text : T.textSoft }}
              onFocus={(e) => e.target.style.borderColor = T.primary}
              onBlur={(e)  => e.target.style.borderColor = T.border}
            >
              <option value="">-- Sélectionner --</option>
              {quarts.map(q => <option key={q} value={q}>{q}</option>)}
            </select>
          </div>
          <div style={{ marginBottom: 14 }}>
            <label style={{ ...labelStyle, color: T.textSoft }}>Atelier / Chaîne</label>
            <select value={form.atelier}
              onChange={(e) => {
                set('atelier')(e.target.value);
                setSertissage(Array(getNbCases(e.target.value)).fill(''));
              }}
              style={{ ...inputStyle(T), cursor: 'pointer',
                color: form.atelier ? T.text : T.textSoft }}
              onFocus={(e) => e.target.style.borderColor = T.primary}
              onBlur={(e)  => e.target.style.borderColor = T.border}
            >
              <option value="">-- Sélectionner --</option>
              {ateliers.map(a => <option key={a} value={a}>{a}</option>)}
            </select>
          </div>
        </div>
      </SectionCard>

      {/* ── PARAMÈTRES QUALITÉ ── */}
      <SectionCard
        title="Paramètres qualité"
        icon={<IconScience size={15} color={T.primary} />}
        iconColor={T.primary} T={T}
      >
        <div style={{
          display: 'grid',
          gridTemplateColumns: isMobile ? '1fr' : '1fr 1fr 1fr',
          gap: '0 14px',
        }}>
          <InputField
            label="Brix (°Bx)" value={form.brix}
            onChange={set('brix')} unit="°Bx" placeholder="10.8" T={T}
          />
          <InputField
            label="CO₂ qualité" value={form.co2_qualite}
            onChange={set('co2_qualite')} unit="g/L" placeholder="5.2" T={T}
          />
          <div style={{ gridColumn: isMobile ? '1 / -1' : 'auto' }}>
            <InputField
              label="BO₂ (O₂ dissous)" value={form.bo2}
              onChange={set('bo2')} unit="mg/L" placeholder="0.05" step="0.001" T={T}
            />
          </div>
        </div>
      </SectionCard>

      {/* ── SERTISSAGE ── */}
      {form.atelier && nbCases > 0 && (
        <SectionCard
          title={`Sertissage — ${nbCases} cases (mm)`}
          icon={<IconScience size={15} color={T.gold} />}
          iconColor={T.gold} T={T}
        >
          <GrilleSertissage
            values={sertissage}
            onChange={setSertissage}
            T={T}
            isMobile={isMobile}
          />
        </SectionCard>
      )}

      {form.atelier === 'Traitement des eaux' && (
        <div style={{
          padding: '12px 16px', borderRadius: 12,
          background: T.bg, border: `1px solid ${T.border}`,
          color: T.textSoft, fontSize: 13, marginBottom: 14, textAlign: 'center',
        }}>
          Pas de sertissage pour le Traitement des eaux
        </div>
      )}

      {/* ── BOUTON ── */}
      <button
        onClick={handleSubmit}
        disabled={loading}
        style={{
          width: '100%', padding: '14px',
          background: loading ? T.textMuted : T.primary,
          color: '#fff', border: 'none', borderRadius: 12,
          fontSize: 15, fontWeight: 700,
          cursor: loading ? 'not-allowed' : 'pointer',
          display: 'flex', alignItems: 'center',
          justifyContent: 'center', gap: 10,
          transition: 'background 0.2s',
        }}
        onMouseEnter={(e) => { if (!loading) e.currentTarget.style.background = T.primaryDark; }}
        onMouseLeave={(e) => { if (!loading) e.currentTarget.style.background = T.primary; }}
      >
        {loading ? (
          <>
            <div style={{
              width: 16, height: 16,
              border: '2px solid rgba(255,255,255,0.3)',
              borderTop: '2px solid #fff',
              borderRadius: '50%',
              animation: 'spin 0.8s linear infinite',
            }} />
            Enregistrement...
          </>
        ) : (
          <><IconCheck size={18} color="#fff" /> Enregistrer le relevé qualité</>
        )}
      </button>
    </div>
  );
}