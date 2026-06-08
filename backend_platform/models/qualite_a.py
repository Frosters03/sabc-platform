from sqlalchemy import Column, Integer, String, Float, Date, DateTime, Text
from sqlalchemy.sql import func
from core.database import Base

class QualiteA(Base):
    """
    Volet A — Contrôle bière alcoolisée sortie soutireuse
    Fiche : FICHE GRAPHIQUE DE CONTROLE BIERE SORTIE SOUTIREUSE
    """
    __tablename__ = "qualite_a"

    id      = Column(Integer, primary_key=True, index=True)
    date    = Column(Date,        nullable=False)
    heure   = Column(String(10),  nullable=False)
    quart   = Column(String(20),  nullable=False)
    atelier = Column(String(50),  nullable=False)
    produit = Column(String(50),  nullable=True)   # ex: CMS, 33 Export...

    # ── DENSITÉ (Extrait Primitif) ────────────────────────
    # Cible ~14.40, tolérance ±0.30
    densite_valeur  = Column(Float, nullable=True)   # valeur mesurée
    densite_ecart   = Column(Float, nullable=True)   # écart vs cible

    # ── SATURATION (Carbonatation CO2) ───────────────────
    # Cible ~4.90 g/L, tolérance ±0.30
    saturation_valeur = Column(Float, nullable=True)
    saturation_ecart  = Column(Float, nullable=True)
    saturation_pression = Column(Float, nullable=True)  # P°
    saturation_temperature = Column(Float, nullable=True)  # T°
    saturation_air_total   = Column(Float, nullable=True)

    # ── O2 DISSOUS ────────────────────────────────────────
    # Limite supérieure : 0.09 mg/L
    o2_dissous = Column(Float, nullable=True)   # mg/L

    # ── VOLUME DE GAZ ÉTRANGER ────────────────────────────
    # Limite supérieure : 1.0 vol
    gaz_etranger = Column(Float, nullable=True)  # volumes de gaz

    # ── BILAN OXYGÈNE ─────────────────────────────────────
    # Limite supérieure : 0.15 mg/L
    bilan_o2_total      = Column(Float, nullable=True)
    bilan_o2_col        = Column(Float, nullable=True)   # O2 col [0-0.7]
    bilan_o2_reprise    = Column(Float, nullable=True)   # Reprise O2 [0-0.09]
    bilan_o2_bln        = Column(Float, nullable=True)   # O2 bln [0-0.01]
    bilan_o2_es         = Column(Float, nullable=True)   # O2 ES [0-0.0]
    pression_pissette   = Column(Float, nullable=True)   # [4-7] bar
    contre_pression     = Column(Float, nullable=True)   # [1.5-2.5] bar
    cadence_soutireuse  = Column(Float, nullable=True)   # [24.5-45] cols/min
    debit_co2_balayage  = Column(Float, nullable=True)   # m³/h

    # ── SERTISSAGE ────────────────────────────────────────
    sertissage_data = Column(Text, nullable=True)   # JSON

    saisi_par  = Column(String(100), nullable=True)
    created_at = Column(DateTime, default=func.now())