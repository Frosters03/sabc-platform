from sqlalchemy import Column, Integer, String, Float, Date, Boolean, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from sqlalchemy import DateTime
from core.database import Base

class Pointage(Base):
    __tablename__ = "pointages"

    id          = Column(Integer, primary_key=True, index=True)
    date        = Column(Date, nullable=False)
    chaine      = Column(String(50), nullable=False)
    equipe_id   = Column(Integer, ForeignKey("equipes.id"), nullable=False)
    equipe_nom  = Column(String(100), nullable=False)
    quart       = Column(String(20), nullable=False)
    # "7h-19h", "19h-7h", "7h-14h", "14h-21h", "21h-6h"
    saisi_par   = Column(String(100), nullable=False)
    created_at  = Column(DateTime, default=func.now())

    lignes      = relationship("LignePointage", back_populates="pointage",
                               cascade="all, delete-orphan")


class LignePointage(Base):
    __tablename__ = "lignes_pointage"

    id             = Column(Integer, primary_key=True, index=True)
    pointage_id    = Column(Integer, ForeignKey("pointages.id"), nullable=False)
    membre_id      = Column(Integer, ForeignKey("membres_equipe.id"), nullable=True)
    # Null si occasionnel
    fonction       = Column(String(100), nullable=False)
    nom_prenom     = Column(String(150), nullable=False)
    statut_emploi  = Column(String(20), nullable=False)
    # "titulaire" ou "occasionnel"
    presence       = Column(String(10), nullable=False)
    # "A", "R", "RM", "CP", "P"
    heures_N       = Column(Float, default=0)
    # Heures normales (8 ou 12 selon quart)
    heures_F       = Column(Float, default=0)
    # Heures fériées
    heures_PN      = Column(Float, default=0)
    # Heures de présence nuit
    est_occasionnel = Column(Boolean, default=False)

    pointage       = relationship("Pointage", back_populates="lignes")