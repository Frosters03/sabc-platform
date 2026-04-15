from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional
from datetime import date

from core.database import get_db
from models.qualite import Qualite
from models.utilisateur import Utilisateur
from schemas.donnees import QualiteCreate, QualiteResponse, MessageResponse
from .auth import get_current_user, require_role, log_action

router = APIRouter(prefix="/qualite", tags=["Qualité"])


@router.post("/", response_model=QualiteResponse)
def creer_releve(
    data: QualiteCreate,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    """Soumet un relevé Qualité"""
    releve = Qualite(**data.model_dump(), saisi_par=current_user.username)
    db.add(releve)
    db.commit()
    db.refresh(releve)
    log_action(db, current_user.username, "INSERT", "qualite",
               f"Atelier: {data.atelier}, Quart: {data.quart}")

    # ── GÉNÉRATION AUTOMATIQUE DES ALERTES ───────────────
    from services.alertes_service import analyser_qualite
    analyser_qualite(releve, data.atelier, db)

    # ── POINT D'EXTENSION IA ──────────────────────────────
    # Quand le module IA est prêt, décommenter :
    # from ...services.ia.anomaly_detection import analyser_qualite
    # analyser_qualite(releve, db)
    # ─────────────────────────────────────────────────────

    return releve


@router.get("/", response_model=list[QualiteResponse])
def get_releves(
    atelier: Optional[str] = Query(None),
    quart: Optional[str] = Query(None),
    date_debut: Optional[date] = Query(None),
    date_fin: Optional[date] = Query(None),
    limit: int = Query(100, le=500),
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    """Récupère les relevés qualité avec filtres"""
    query = db.query(Qualite)
    if atelier:
        query = query.filter(Qualite.atelier == atelier)
    if quart:
        query = query.filter(Qualite.quart == quart)
    if date_debut:
        query = query.filter(Qualite.date >= date_debut)
    if date_fin:
        query = query.filter(Qualite.date <= date_fin)
    return query.order_by(Qualite.date.desc()).limit(limit).all()


@router.get("/{releve_id}", response_model=QualiteResponse)
def get_releve(
    releve_id: int,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    """Récupère un relevé qualité par son ID"""
    releve = db.query(Qualite).filter(Qualite.id == releve_id).first()
    if not releve:
        raise HTTPException(status_code=404, detail="Relevé non trouvé")
    return releve


@router.delete("/{releve_id}", response_model=MessageResponse)
def supprimer_releve(
    releve_id: int,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("admin"))
):
    """Supprime un relevé qualité — admin seulement"""
    releve = db.query(Qualite).filter(Qualite.id == releve_id).first()
    if not releve:
        raise HTTPException(status_code=404, detail="Relevé non trouvé")
    db.delete(releve)
    db.commit()
    log_action(db, current_user.username, "DELETE", "qualite",
               f"Suppression relevé ID {releve_id}")
    return MessageResponse(message=f"Relevé #{releve_id} supprimé")