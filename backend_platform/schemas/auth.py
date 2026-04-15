from pydantic import BaseModel
from typing import Optional
from datetime import datetime

# ─── CONNEXION ────────────────────────────────────────────

class LoginRequest(BaseModel):
    """Ce qu'on reçoit quand quelqu'un veut se connecter"""
    username: str
    password: str

class TokenResponse(BaseModel):
    """Ce qu'on renvoie après une connexion réussie"""
    access_token: str
    token_type: str = "bearer"
    username: str
    role: str

# ─── UTILISATEURS ─────────────────────────────────────────

class UtilisateurCreate(BaseModel):
    """Pour créer un nouvel utilisateur"""
    username: str
    password: str
    role: str
    # Rôles acceptés :
    # "contremaitre" / "chef_atelier" / "manager"

class UtilisateurUpdate(BaseModel):
    """Pour modifier un utilisateur — tous les champs optionnels"""
    password: Optional[str] = None
    role: Optional[str] = None
    actif: Optional[bool] = None

class UtilisateurResponse(BaseModel):
    """Ce qu'on renvoie quand on affiche un utilisateur"""
    id: int
    username: str
    role: str
    actif: bool
    created_at: Optional[datetime] = None
    last_login: Optional[datetime] = None

    class Config:
        from_attributes = True