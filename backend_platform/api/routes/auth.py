from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from datetime import datetime

from core.database import get_db
from core.security import verify_password, hash_password, create_access_token, decode_token
from models.utilisateur import Utilisateur
from models.log_activite import LogActivite
from schemas.auth import (
    LoginRequest, TokenResponse,
    UtilisateurCreate, UtilisateurUpdate, UtilisateurResponse
)
from schemas.donnees import MessageResponse
from models.log_activite import LogActivite
from models.lean_energie import LeanEnergie
from models.qualite import Qualite

router   = APIRouter(prefix="/auth", tags=["Authentification"])
security = HTTPBearer()


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> Utilisateur:
    """Vérifie le token et retourne l'utilisateur connecté"""
    token   = credentials.credentials
    payload = decode_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Token invalide ou expiré")
    user = db.query(Utilisateur).filter(
        Utilisateur.username == payload.get("sub")
    ).first()
    if not user or not user.actif:
        raise HTTPException(status_code=401, detail="Utilisateur non trouvé")
    return user


def require_role(*roles):
    """Vérifie que l'utilisateur a le bon rôle"""
    def checker(current_user: Utilisateur = Depends(get_current_user)):
        if current_user.role not in roles:
            raise HTTPException(
                status_code=403,
                detail=f"Accès réservé aux rôles : {', '.join(roles)}"
            )
        return current_user
    return checker


def log_action(db, utilisateur, action, table="", details=""):
    """Enregistre une action dans les logs"""
    log = LogActivite(
        utilisateur=utilisateur,
        action=action,
        table_concernee=table,
        details=details
    )
    db.add(log)
    db.commit()


# ─── ENDPOINTS ────────────────────────────────────────────

@router.post("/login", response_model=TokenResponse)
def login(request: LoginRequest, db: Session = Depends(get_db)):
    """Connexion — renvoie un token JWT"""
    user = db.query(Utilisateur).filter(
        Utilisateur.username == request.username,
        Utilisateur.actif == True
    ).first()
    if not user or not verify_password(request.password, user.password):
        raise HTTPException(status_code=401, detail="Identifiants incorrects")
    user.last_login = datetime.now()
    db.commit()
    token = create_access_token(data={"sub": user.username, "role": user.role})
    log_action(db, user.username, "LOGIN", "connexion", "Connexion réussie")
    return TokenResponse(access_token=token, username=user.username, role=user.role)


@router.get("/me", response_model=UtilisateurResponse)
def get_me(current_user: Utilisateur = Depends(get_current_user)):
    """Retourne le profil de l'utilisateur connecté"""
    return current_user


@router.get("/users", response_model=list[UtilisateurResponse])
def get_users(
    db: Session = Depends(get_db),
    _=Depends(require_role("manager"))
):
    """Liste tous les utilisateurs — manager seulement"""
    return db.query(Utilisateur).all()


@router.post("/users", response_model=UtilisateurResponse)
def create_user(
    data: UtilisateurCreate,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("manager"))
):
    """Crée un utilisateur — manager seulement"""
    if db.query(Utilisateur).filter(Utilisateur.username == data.username).first():
        raise HTTPException(status_code=400, detail="Nom d'utilisateur déjà utilisé")
    user = Utilisateur(
        username=data.username,
        password=hash_password(data.password),
        role=data.role
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    log_action(db, current_user.username, "CREATE", "utilisateurs",
               f"Création de {data.username} ({data.role})")
    return user


@router.put("/users/{user_id}", response_model=UtilisateurResponse)
def update_user(
    user_id: int,
    data: UtilisateurUpdate,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("manager"))
):
    """Modifie un utilisateur — manager seulement"""
    user = db.query(Utilisateur).filter(Utilisateur.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Utilisateur non trouvé")
    if data.password:
        user.password = hash_password(data.password)
    if data.role:
        user.role = data.role
    if data.actif is not None:
        user.actif = data.actif
    db.commit()
    db.refresh(user)
    log_action(db, current_user.username, "UPDATE", "utilisateurs",
               f"Modification de {user.username}")
    return user


@router.delete("/users/{user_id}", response_model=MessageResponse)
def delete_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("manager"))
):
    """Supprime un utilisateur — manager seulement"""
    user = db.query(Utilisateur).filter(Utilisateur.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Utilisateur non trouvé")
    if user.username == "manager":
        raise HTTPException(status_code=400, detail="Impossible de supprimer le manager principal")
    username = user.username
    db.delete(user)
    db.commit()
    log_action(db, current_user.username, "DELETE", "utilisateurs",
               f"Suppression de {username}")
    return MessageResponse(message=f"Utilisateur {username} supprimé")

@router.get("/logs", response_model=list[dict])
def get_logs(
    limit: int = 100,
    db: Session = Depends(get_db),
    _=Depends(require_role("manager"))
):
    """Retourne les logs d'activité — manager seulement"""
    logs = db.query(LogActivite).order_by(LogActivite.created_at.desc()).limit(limit).all()
    return [
        {
            "id": l.id,
            "utilisateur": l.utilisateur,
            "action": l.action,
            "table_concernee": l.table_concernee,
            "details": l.details,
            "created_at": l.created_at.isoformat() if l.created_at else None,
        }
        for l in logs
    ]


@router.get("/stats", response_model=dict)
def get_stats(
    db: Session = Depends(get_db),
    _=Depends(require_role("manager"))
):
    """Statistiques générales — manager seulement"""
    return {
        "nb_energie":     db.query(LeanEnergie).count(),
        "nb_qualite":     db.query(Qualite).count(),
        "nb_utilisateurs":db.query(Utilisateur).filter(Utilisateur.actif == True).count(),
        "nb_logs":        db.query(LogActivite).count(),
    }