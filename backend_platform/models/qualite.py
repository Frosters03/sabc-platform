from sqlalchemy import Column, Integer, String, Float, Date, DateTime, Text
from sqlalchemy.sql import func
from core.database import Base

class Qualite(Base):
    __tablename__ = "qualite"

    id              = Column(Integer, primary_key=True, index=True)
    date            = Column(Date, nullable=False)
    heure           = Column(String(10), nullable=False)
    quart           = Column(String(20), nullable=False)
    atelier         = Column(String(50), nullable=False)
    sertissage_data = Column(Text, nullable=True)
    # Stocké en JSON — ex: "[1.2, 1.3, 1.1, ...]"
    # Nombre de cases selon atelier :
    # Chaîne 15 et 16 → 24 cases
    # Chaîne 8        → 20 cases
    # Chaîne 14       → 16 cases
    brix            = Column(Float, nullable=True)   # °
    co2_qualite     = Column(Float, nullable=True)   # g/L
    bo2             = Column(Float, nullable=True)   # mg/L
    saisi_par       = Column(String(100), nullable=True)
    created_at      = Column(DateTime, default=func.now())