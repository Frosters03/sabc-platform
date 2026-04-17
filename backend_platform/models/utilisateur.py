from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.sql import func
from core.database import Base

class Utilisateur(Base):
    __tablename__ = "utilisateurs"

    id         = Column(Integer, primary_key=True, index=True)
    username   = Column(String(100), unique=True, nullable=False)
    password   = Column(String(255), nullable=False)
    role       = Column(String(50), nullable=False)
    actif      = Column(Boolean, default=True)
    created_at = Column(DateTime, default=func.now())
    last_login = Column(DateTime, nullable=True)