import { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useTheme } from '../../components/layout/Layout';
import { energieAPI } from '../../services/api';

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
const IconWater   = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 2c-5.33 4.55-8 8.48-8 11.8 0 4.98 3.8 8.2 8 8.2s8-3.22 8-8.2c0-3.32-2.67-7.25-8-11.8z"/></svg>;
const IconBolt    = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M7 2v11h3v9l7-12h-4l4-8z"/></svg>;
const IconCo2     = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 14H9V8h2v8zm4 0h-2V8h2v8z"/></svg>;
const IconBottle  = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M17 3h-2V1H9v2H7.5C6.7 3 6 3.7 6 4.5v1C6 6.9 7 8 7 9.5V20c0 1.1.9 2 2 2h6c1.1 0 2-.9 2-2V9.5c0-1.5 1-2.6 1-4V4.5C18 3.7 17.3 3 16.5 3H15zm-3 4.5c-.8 0-1.5-.7-1.5-1.5S11.2 4.5 12 4.5s1.5.7 1.5 1.5S12.8 7.5 12 7.5zm0 9c-1.7 0-3-1.3-3-3s1.3-3 3-3 3 1.3 3 3-1.3 3-3 3z"/></svg>;
const IconCheck   = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>;
const IconWarning = ({size=18,color='currentColor'}) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>;

// ── CHAMP DE SAISIE ───────────────────────────────────────
function InputField({ label, icon, iconColor, value, onChange, unit, placeholder, T }) {
  const [focused, setFocused] = useState(false);
  return (
    <div style={{ marginBottom: 14 }}>
      <label style={{
        display: 'flex', alignItems: 'center', gap: 6,
        fontSize: 11, fontWeight: 600, color: T.textSoft,
        marginBottom: 6, textTransform: 'uppercase', letterSpacing: 0.5,
      }}>
        <span style={{ color: iconColor }}>{icon}</span>
        {label}
      </label>
      <div style={{
        display: 'flex', alignItems: 'center',
        background: T.bg,
        border: `1.5px solid ${focused ? T.primary : T.border}`,
        borderRadius: 10, overflow: 'hidden', transition: 'border 0.2s',
      }}>
        <input
          type="number"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          onFocus={() => setFocused(true)}
          onBlur={() => setFocused(false)}
          placeholder={placeholder || '0.00'}
          style={{
            flex: 1, padding: '11px 12px',
            background: 'transparent', border: 'none', outline: 'none',
            fontSize: 14, color: T.text, fontWeight: 500,
            minWidth: 0,
          }}
        />
        {unit && (
          <span style={{
            padding: '0 10px', fontSize: 11, color: T.textSoft,
            background: T.borderSoft, borderLeft: `1px solid ${T.border}`,
            height: '100%', display: 'flex', alignItems: 'center',
            whiteSpace: 'nowrap',
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
      background: T.card, borderRadius: 14,
      padding: '18px', boxShadow: '0 1px 8px rgba(0,0,0,0.06)',
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

// ── FORM VIDE ─────────────────────────────────────────────
const FORM_VIDE = {
  date:             new Date().toISOString().split('T')[0],
  heure:            new Date().toTimeString().slice(0, 5),
  quart:            '',
  atelier:          '',
  index_eau_rincage:'',
  index_eau_bain:   '',
  index_eau_pasteur:'',
  index_eau_aero:   '',
  index_elec:       '',
  index_co2:        '',
  production_hl:    '',
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

// ── PAGE SAISIE ENERGIE ───────────────────────────────────
export default function SaisieEnergie() {
  const { user }  = useAuth();
  const { T }     = useTheme();
  const isMobile  = useIsMobile();

  const [form,    setForm]    = useState(FORM_VIDE);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState(null);

  const set = (field) => (value) => setForm(prev => ({ ...prev, [field]: value }));

  const ateliers = ['Chaîne 8', 'Chaine 13', 'Chaîne 14', 'Chaîne 15', 'Chaîne 16'];
  const quarts   = ['22h-6h', '6h-14h', '14h-22h'];

  const valider = () => {
    const champs = [
      'date','heure','quart','atelier',
      'index_eau_rincage','index_eau_bain',
      'index_eau_pasteur','index_eau_aero',
      'index_elec','index_co2','production_hl',
    ];
    for (const c of champs) {
      if (!form[c] && form[c] !== 0)
        return `Le champ "${c.replace(/_/g, ' ')}" est obligatoire`;
    }
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
      await energieAPI.creer({
        ...form,
        index_eau_rincage: parseFloat(form.index_eau_rincage),
        index_eau_bain:    parseFloat(form.index_eau_bain),
        index_eau_pasteur: parseFloat(form.index_eau_pasteur),
        index_eau_aero:    parseFloat(form.index_eau_aero),
        index_elec:        parseFloat(form.index_elec),
        index_co2:         parseFloat(form.index_co2),
        production_hl:     parseFloat(form.production_hl),
        saisi_par:         user?.username,
      });
      setForm({
        ...FORM_VIDE,
        date:  new Date().toISOString().split('T')[0],
        heure: new Date().toTimeString().slice(0, 5),
      });
      setMessage({ type: 'success', text: 'Relevé enregistré avec succès !' });
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

  return (
    <div style={{
      padding: isMobile ? '16px 14px 100px' : '24px 28px',
      background: T.bg, minHeight: '100vh',
      maxWidth: 800, margin: '0 auto',
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
        <div style={{
          display: 'grid',
          gridTemplateColumns: '1fr 1fr',
          gap: '0 14px',
        }}>
          {/* Date */}
          <div style={{ marginBottom: 14 }}>
            <label style={{ ...labelStyle, color: T.textSoft }}>Date</label>
            <input type="date" value={form.date}
              onChange={(e) => set('date')(e.target.value)}
              style={inputStyle(T)}
              onFocus={(e) => e.target.style.borderColor = T.primary}
              onBlur={(e)  => e.target.style.borderColor = T.border}
            />
          </div>

          {/* Heure */}
          <div style={{ marginBottom: 14 }}>
            <label style={{ ...labelStyle, color: T.textSoft }}>Heure</label>
            <input type="time" value={form.heure}
              onChange={(e) => set('heure')(e.target.value)}
              style={inputStyle(T)}
              onFocus={(e) => e.target.style.borderColor = T.primary}
              onBlur={(e)  => e.target.style.borderColor = T.border}
            />
          </div>

          {/* Quart */}
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

          {/* Atelier */}
          <div style={{ marginBottom: 14 }}>
            <label style={{ ...labelStyle, color: T.textSoft }}>Atelier / Chaîne</label>
            <select value={form.atelier}
              onChange={(e) => set('atelier')(e.target.value)}
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

      {/* ── EAU ── */}
      <SectionCard
        title="Index eau (m³ cumulés)"
        icon={<IconWater size={15} color="#3B82F6" />}
        iconColor="#3B82F6" T={T}
      >
        <div style={{
          display: 'grid',
          gridTemplateColumns: isMobile ? '1fr' : '1fr 1fr',
          gap: '0 14px',
        }}>
          <InputField
            label="Laveuse — rinçage"
            icon={<IconWater size={13} color="#3B82F6" />}
            iconColor="#3B82F6"
            value={form.index_eau_rincage}
            onChange={set('index_eau_rincage')}
            unit="m³" T={T}
          />
          <InputField
            label="Laveuse — bain"
            icon={<IconWater size={13} color="#3B82F6" />}
            iconColor="#3B82F6"
            value={form.index_eau_bain}
            onChange={set('index_eau_bain')}
            unit="m³" T={T}
          />
          <InputField
            label="Pasteurisateur"
            icon={<IconWater size={13} color="#3B82F6" />}
            iconColor="#3B82F6"
            value={form.index_eau_pasteur}
            onChange={set('index_eau_pasteur')}
            unit="m³" T={T}
          />
          <InputField
            label="Appoint d'eau aéro"
            icon={<IconWater size={13} color="#3B82F6" />}
            iconColor="#3B82F6"
            value={form.index_eau_aero}
            onChange={set('index_eau_aero')}
            unit="m³" T={T}
          />
        </div>
      </SectionCard>

      {/* ── ÉNERGIE & PRODUCTION ── */}
      <SectionCard
        title="Énergie & Production"
        icon={<IconBolt size={15} color={T.gold} />}
        iconColor={T.gold} T={T}
      >
        <div style={{
          display: 'grid',
          gridTemplateColumns: isMobile ? '1fr' : '1fr 1fr 1fr',
          gap: '0 14px',
        }}>
          <InputField
            label="Électricité"
            icon={<IconBolt size={13} color={T.gold} />}
            iconColor={T.gold}
            value={form.index_elec}
            onChange={set('index_elec')}
            unit="kWh" T={T}
          />
          <InputField
            label="CO₂"
            icon={<IconCo2 size={13} color={T.success} />}
            iconColor={T.success}
            value={form.index_co2}
            onChange={set('index_co2')}
            unit="kg" T={T}
          />
          <div style={{ gridColumn: isMobile ? '1 / -1' : 'auto' }}>
            <InputField
              label="Production"
              icon={<IconBottle size={13} color={T.primary} />}
              iconColor={T.primary}
              value={form.production_hl}
              onChange={set('production_hl')}
              unit="hl" T={T}
            />
          </div>
        </div>
      </SectionCard>

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
          <><IconCheck size={18} color="#fff" /> Enregistrer le relevé</>
        )}
      </button>
    </div>
  );
}