import { useEffect, useState } from 'react';

export default function SplashScreen({ onFinish }) {
  const [progress, setProgress] = useState(0);
  const [fade, setFade] = useState(false);

  useEffect(() => {
    // Barre de progression
    const interval = setInterval(() => {
      setProgress(prev => {
        if (prev >= 100) {
          clearInterval(interval);
          return 100;
        }
        return prev + 2;
      });
    }, 50);

    // Fade out puis finish
    const timer = setTimeout(() => {
      setFade(true);
      setTimeout(onFinish, 500);
    }, 3000);

    return () => {
      clearInterval(interval);
      clearTimeout(timer);
    };
  }, [onFinish]);

  return (
    <div style={{
      position: 'fixed',
      top: 0, left: 0, right: 0, bottom: 0,
      background: '#F1F5F9',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      zIndex: 9999,
      opacity: fade ? 0 : 1,
      transition: 'opacity 0.5s ease',
    }}>

      {/* Card centrale */}
      <div style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '48px 56px',
        background: '#FFFFFF',
        borderRadius: 24,
        boxShadow: '0 8px 48px rgba(0,0,0,0.10)',
        border: '1px solid #E2E8F0',
        width: '90%',
        maxWidth: 420,
      }}>

        {/* Logo */}
        <div style={{
          width: 100, height: 100,
          marginBottom: 24,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}>
          <img
            src="/images/logo_sabc.png"
            alt="SABC"
            style={{
              width: '100%',
              height: '100%',
              objectFit: 'contain',
            }}
            onError={(e) => {
              e.target.style.display = 'none';
              e.target.nextSibling.style.display = 'flex';
            }}
          />
          {/* Fallback si pas de logo */}
          <div style={{
            display: 'none',
            width: 80, height: 80,
            borderRadius: 20,
            background: '#DA291C',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: 36,
          }}>
            🍺
          </div>
        </div>

        {/* Titre */}
        <h1 style={{
          fontSize: 28,
          fontWeight: 800,
          color: '#DA291C',
          margin: '0 0 4px',
          letterSpacing: 1,
          textAlign: 'center',
        }}>
          SABC
        </h1>

        {/* Sous-titre */}
        <p style={{
          fontSize: 13,
          color: '#64748B',
          margin: '0 0 6px',
          textAlign: 'center',
          fontWeight: 500,
          letterSpacing: 0.5,
          textTransform: 'uppercase',
        }}>
          Packaging Platform
        </p>

        {/* Slogan */}
        <p style={{
          fontSize: 12,
          color: '#94A3B8',
          margin: '0 0 32px',
          textAlign: 'center',
          fontStyle: 'italic',
        }}>
          La bière qui unit les Camerounais
        </p>

        {/* Barre de progression */}
        <div style={{
          width: '100%',
          height: 4,
          background: '#E2E8F0',
          borderRadius: 2,
          overflow: 'hidden',
          marginBottom: 10,
        }}>
          <div style={{
            height: '100%',
            width: `${progress}%`,
            background: 'linear-gradient(90deg, #DA291C, #F5A623)',
            borderRadius: 2,
            transition: 'width 0.05s linear',
          }} />
        </div>

        {/* Pourcentage */}
        <span style={{
          fontSize: 11,
          color: '#94A3B8',
          fontWeight: 600,
        }}>
          Chargement... {progress}%
        </span>
      </div>

      {/* Footer */}
      <p style={{
        position: 'absolute',
        bottom: 24,
        fontSize: 11,
        color: '#94A3B8',
        margin: 0,
      }}>
        © 2026 SABC Ndokoti — Tous droits réservés
      </p>
    </div>
  );
}