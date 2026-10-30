from sqlalchemy import Column, Integer, String, Float, Date, DateTime, Boolean
from sqlalchemy.sql import func
from core.database import Base

class LeanEnergie(Base):
    __tablename__ = "lean_energie"

    id            = Column(Integer, primary_key=True, index=True)
    date          = Column(Date, nullable=False)
    heure         = Column(String(10), nullable=False)
    quart         = Column(String(20), nullable=False)
    # Quarts : "6h-14h" / "14h-22h" / "22h-6h"
    atelier       = Column(String(50), nullable=False)
    # Ateliers : "Chaîne 8" / "Chaîne 14" / "Chaîne 15" / "Chaîne 16" / "Traitement des eaux"
    index_eau_rincage   = Column(Float, nullable=True)   # m³
    index_eau_bain      = Column(Float, nullable=True)   # m³
    index_eau_pasteur   = Column(Float, nullable=True)   # m³
    index_eau_aero      = Column(Float, nullable=True)   # m³
    index_elec          = Column(Float, nullable=True)   # kWh
    index_co2           = Column(Float, nullable=True)   # kg
    # ── Nouveaux compteurs (eau toujours stockée en m³, quelle que soit l'unité choisie à la saisie)
    index_eau_soutireuse    = Column(Float, nullable=True)   # m³ cumulés
    index_eau_lubrification = Column(Float, nullable=True)   # m³ cumulés
    conso_soude_l           = Column(Float, nullable=True)   # litres consommés sur le quart
    conso_colle_kg          = Column(Float, nullable=True)   # kg consommés sur le quart
    conso_lubrifiant_kg     = Column(Float, nullable=True)   # kg consommés sur le quart
    production_hl = Column(Float, nullable=True)   # hl
    production_cols = Column(Float, nullable=True) # nombre de bouteilles / canettes (cols)
    saisi_par     = Column(String(100), nullable=True)
    created_at    = Column(DateTime, default=func.now())
    arret_planifie = Column(Boolean, default=False)  # True = entretien hebdomadaire planifié