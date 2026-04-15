from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional

from core.database import get_db
from models.alerte import Alerte
from models.utilisateur import Utilisateur
from schemas.donnees import AlerteResponse, MessageResponse
from .auth import get_current_user, require_role

router = APIRouter(prefix="/alertes", tags=["Alertes"])


@router.get("/", response_model=list[AlerteResponse])
def get_alertes(
    lu: Optional[bool] = Query(None),
    niveau: Optional[str] = Query(None),
    atelier: Optional[str] = Query(None),
    limit: int = Query(50, le=200),
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    """Récupère les alertes avec filtres"""
    query = db.query(Alerte)
    if lu is not None:
        query = query.filter(Alerte.lu == lu)
    if niveau:
        query = query.filter(Alerte.niveau == niveau)
    if atelier:
        query = query.filter(Alerte.atelier == atelier)
    return query.order_by(Alerte.created_at.desc()).limit(limit).all()


@router.put("/{alerte_id}/lire", response_model=AlerteResponse)
def marquer_lue(
    alerte_id: int,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    """Marque une alerte comme lue"""
    alerte = db.query(Alerte).filter(Alerte.id == alerte_id).first()
    if not alerte:
        raise HTTPException(status_code=404, detail="Alerte non trouvée")
    alerte.lu = True
    db.commit()
    db.refresh(alerte)
    return alerte


@router.get("/count")
def count_alertes(
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    """Compte les alertes non lues — pour le badge dans la sidebar"""
    total    = db.query(Alerte).filter(Alerte.lu == False).count()
    critiques = db.query(Alerte).filter(
        Alerte.lu == False,
        Alerte.niveau == "critique"
    ).count()
    return {"total": total, "critiques": critiques}


@router.delete("/{alerte_id}", response_model=MessageResponse)
def supprimer_alerte(
    alerte_id: int,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("admin", "chef_atelier"))
):
    """Supprime une alerte — admin et chef_atelier seulement"""
    alerte = db.query(Alerte).filter(Alerte.id == alerte_id).first()
    if not alerte:
        raise HTTPException(status_code=404, detail="Alerte non trouvée")
    db.delete(alerte)
    db.commit()
    return MessageResponse(message=f"Alerte #{alerte_id} supprimée")