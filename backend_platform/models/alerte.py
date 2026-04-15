from sqlalchemy import Column, Integer, String, Float, DateTime, Boolean, Text
from sqlalchemy.sql import func
from core.database import Base

class Alerte(Base):
    __tablename__ = "alertes"

    id              = Column(Integer, primary_key=True, index=True)
    source          = Column(String(50), nullable=False)
    # "IA" → générée automatiquement par le modèle
    # "manuel" → créée par un chef d'atelier ou admin
    niveau          = Column(String(20), nullable=False)
    # "critique" / "warning" / "info"
    atelier         = Column(String(50), nullable=True)
    message         = Column(Text, nullable=False)
    valeur          = Column(Float, nullable=True)   # valeur qui a déclenché l'alerte
    seuil           = Column(Float, nullable=True)   # seuil dépassé
    recommandation  = Column(Text, nullable=True)    # conseil de l'IA
    lu              = Column(Boolean, default=False)
    created_at      = Column(DateTime, default=func.now())