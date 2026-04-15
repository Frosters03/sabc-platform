from sqlalchemy import Column, Integer, String, DateTime, Text
from sqlalchemy.sql import func
from core.database import Base

class LogActivite(Base):
    __tablename__ = "logs_activite"

    id              = Column(Integer, primary_key=True, index=True)
    utilisateur     = Column(String(100), nullable=False)
    action          = Column(String(50), nullable=False)
    # Actions possibles :
    # "LOGIN"   → connexion
    # "LOGOUT"  → déconnexion
    # "INSERT"  → ajout d'un relevé
    # "UPDATE"  → modification
    # "DELETE"  → suppression
    # "ARCHIVE" → archivage des données
    table_concernee = Column(String(50), nullable=True)
    details         = Column(Text, nullable=True)
    created_at      = Column(DateTime, default=func.now())