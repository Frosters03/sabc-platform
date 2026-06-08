from sqlalchemy import Column, Integer, String, Float, Date, DateTime, Text, Boolean
from sqlalchemy.sql import func
from core.database import Base

class ResultatAnomalie(Base):
    __tablename__ = "resultats_anomalies"

    id             = Column(Integer, primary_key=True, index=True)
    date           = Column(Date, nullable=False)
    atelier        = Column(String(50), nullable=False)
    quart          = Column(String(20), nullable=True)
    score_anomalie = Column(Float, nullable=False)
    est_anomalie   = Column(Boolean, default=False)
    index_elec          = Column(Float, nullable=True)
    index_eau_rincage   = Column(Float, nullable=True)
    index_eau_bain      = Column(Float, nullable=True)
    index_eau_pasteur   = Column(Float, nullable=True)
    index_eau_aero      = Column(Float, nullable=True)
    index_co2           = Column(Float, nullable=True)
    production_hl       = Column(Float, nullable=True)
    brix                = Column(Float, nullable=True)
    pct_hors_sertissage = Column(Float, nullable=True)
    co2_qualite         = Column(Float, nullable=True)
    bo2                 = Column(Float, nullable=True)
    ecart_elec_pct        = Column(Float, nullable=True)
    ecart_eau_rincage_pct = Column(Float, nullable=True)
    ecart_eau_bain_pct    = Column(Float, nullable=True)
    ecart_eau_pasteur_pct = Column(Float, nullable=True)
    ecart_eau_aero_pct    = Column(Float, nullable=True)
    ecart_production_pct  = Column(Float, nullable=True)
    message_xai  = Column(Text, nullable=True)
    created_at   = Column(DateTime, default=func.now())


class ScoreSante(Base):
    __tablename__ = "scores_sante"

    id             = Column(Integer, primary_key=True, index=True)
    date           = Column(Date, nullable=False)
    atelier        = Column(String(50), nullable=False)
    score          = Column(Float, nullable=False)
    niveau         = Column(String(10), nullable=False)  # "vert"/"orange"/"rouge"
    taux_anomalies = Column(Float, nullable=True)
    ecart_baseline = Column(Float, nullable=True)
    taux_qualite   = Column(Float, nullable=True)
    created_at     = Column(DateTime, default=func.now())


class PrevisionEnergie(Base):
    __tablename__ = "previsions_energie"

    id             = Column(Integer, primary_key=True, index=True)
    atelier        = Column(String(50), nullable=False)
    date_prevision = Column(Date, nullable=False)
    date_calcul    = Column(Date, nullable=False)
    valeur_predite = Column(Float, nullable=False)
    borne_inf      = Column(Float, nullable=True)
    borne_sup      = Column(Float, nullable=True)
    created_at     = Column(DateTime, default=func.now())


class OEEJournalier(Base):
    __tablename__ = "oee_journalier"

    id                = Column(Integer, primary_key=True, index=True)
    date              = Column(Date, nullable=False)
    atelier           = Column(String(50), nullable=False)
    disponibilite     = Column(Float, nullable=True)
    performance       = Column(Float, nullable=True)
    qualite_oee       = Column(Float, nullable=True)
    oee               = Column(Float, nullable=True)
    trs               = Column(Float, nullable=True)   # ← ajouter
    taux_utilisation  = Column(Float, nullable=True)
    production_reelle = Column(Float, nullable=True)
    production_cible  = Column(Float, nullable=True)
    created_at        = Column(DateTime, default=func.now())