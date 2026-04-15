import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useTheme } from "../../components/layout/Layout";
import { useAuth } from "../../context/AuthContext";

export default function EnergieAccueil() {
  const { T } = useTheme();
  const { user } = useAuth();
  const navigate = useNavigate();

  const canAnalyse = ['manager', 'contremaitre', 'chef_atelier'].includes(user?.role);

  const cards = [
    {
      icon: (
        <svg width="36" height="36" viewBox="0 0 24 24" fill="none">
          <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" stroke="#DA291C" strokeWidth="2" strokeLinecap="round"/>
          <path d="M9 12h6M9 16h4" stroke="#DA291C" strokeWidth="2" strokeLinecap="round"/>
        </svg>
      ),
      title: "Relevés",
      desc: "Saisie des index compteurs",
      route: "/energie/releves",
      color: "#DA291C",
      bg: "rgba(218,41,28,0.08)",
      roles: ['manager', 'chef_atelier', 'contremaitre'],
    },
    {
      icon: (
        <svg width="36" height="36" viewBox="0 0 24 24" fill="none">
          <path d="M3 3v18h18" stroke="#F5A623" strokeWidth="2" strokeLinecap="round"/>
          <path d="M7 16l4-4 4 4 4-6" stroke="#F5A623" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
        </svg>
      ),
      title: "Analyse",
      desc: "Ratios & graphiques",
      route: "/energie/analyse",
      color: "#F5A623",
      bg: "rgba(245,166,35,0.08)",
      roles: ['manager', 'contremaitre', 'chef_atelier'],
    },
  ].filter(c => c.roles.includes(user?.role));

  return (
    <div style={{ padding: '24px 16px', maxWidth: 600, margin: '0 auto' }}>
      {/* En-tête */}
      <div style={{ marginBottom: 32 }}>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 12, marginBottom: 8
        }}>
          <div style={{
            width: 44, height: 44, borderRadius: 14,
            background: 'rgba(218,41,28,0.1)',
            display: 'flex', alignItems: 'center', justifyContent: 'center'
          }}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
              <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" stroke="#DA291C" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          </div>
          <div>
            <h1 style={{ fontSize: 22, fontWeight: 700, color: T.text, margin: 0 }}>
              Lean Énergie
            </h1>
            <p style={{ fontSize: 13, color: T.textSoft, margin: 0 }}>
              Gestion des consommations
            </p>
          </div>
        </div>
      </div>

      {/* Cards */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
        {cards.map(card => (
          <button
            key={card.route}
            onClick={() => navigate(card.route)}
            style={{
              background: T.card,
              border: `1px solid ${T.border}`,
              borderRadius: 20,
              padding: '24px 20px',
              cursor: 'pointer',
              textAlign: 'left',
              display: 'flex',
              alignItems: 'center',
              gap: 18,
              transition: 'all 0.2s',
              boxShadow: '0 2px 8px rgba(0,0,0,0.06)',
            }}
            onMouseEnter={e => e.currentTarget.style.transform = 'translateY(-2px)'}
            onMouseLeave={e => e.currentTarget.style.transform = 'translateY(0)'}
          >
            <div style={{
              width: 64, height: 64, borderRadius: 18,
              background: card.bg, flexShrink: 0,
              display: 'flex', alignItems: 'center', justifyContent: 'center'
            }}>
              {card.icon}
            </div>
            <div style={{ flex: 1 }}>
              <p style={{ fontSize: 18, fontWeight: 700, color: card.color, margin: '0 0 4px' }}>
                {card.title}
              </p>
              <p style={{ fontSize: 14, color: T.textSoft, margin: 0 }}>
                {card.desc}
              </p>
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