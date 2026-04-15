from sqlalchemy import Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from sqlalchemy import DateTime
from core.database import Base

class Equipe(Base):
    __tablename__ = "equipes"

    id         = Column(Integer, primary_key=True, index=True)
    nom        = Column(String(100), nullable=False)
    chaine     = Column(String(50), nullable=False)
    # Chaîne 8, 13, 14, 15, 16
    actif      = Column(Boolean, default=True)
    created_at = Column(DateTime, default=func.now())

    membres    = relationship("MembreEquipe", back_populates="equipe",
                              cascade="all, delete-orphan")


class MembreEquipe(Base):
    __tablename__ = "membres_equipe"

    id         = Column(Integer, primary_key=True, index=True)
    equipe_id  = Column(Integer, ForeignKey("equipes.id"), nullable=False)
    fonction   = Column(String(100), nullable=False)
    # 14 fonctions prédéfinies
    nom_prenom = Column(String(150), nullable=False)
    matricule  = Column(String(50), nullable=True)
    statut     = Column(String(20), default="titulaire")
    # "titulaire" ou "occasionnel"
    ordre      = Column(Integer, default=0)
    # Pour garder l'ordre des 14 fonctions
    actif      = Column(Boolean, default=True)

    equipe     = relationship("Equipe", back_populates="membres")