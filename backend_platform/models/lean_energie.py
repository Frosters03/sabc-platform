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
    production_hl = Column(Float, nullable=True)   # hl
    saisi_par     = Column(String(100), nullable=True)
    created_at    = Column(DateTime, default=func.now())
    arret_planifie = Column(Boolean, default=False)  # True = entretien hebdomadaire planifié