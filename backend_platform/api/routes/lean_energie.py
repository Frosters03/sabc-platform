from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional
from datetime import date

from core.database import get_db
from models.lean_energie import LeanEnergie
from models.utilisateur import Utilisateur
from schemas.donnees import LeanEnergieCreate, LeanEnergieResponse, MessageResponse
from .auth import get_current_user, require_role, log_action

router = APIRouter(prefix="/energie", tags=["Lean Énergie"])


@router.post("/", response_model=LeanEnergieResponse)
def creer_releve(
    data: LeanEnergieCreate,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    releve = LeanEnergie(**data.model_dump(), saisi_par=current_user.username)
    db.add(releve)
    db.commit()
    db.refresh(releve)
    log_action(db, current_user.username, "INSERT", "lean_energie",
               f"Atelier: {data.atelier}, Quart: {data.quart}")

    # ── GÉNÉRATION AUTOMATIQUE DES ALERTES ───────────────
    from services.alertes_service import analyser_energie
    # Récupère le relevé précédent pour calculer les consommations
    precedent = db.query(LeanEnergie).filter(
        LeanEnergie.atelier == data.atelier,
        LeanEnergie.id != releve.id
    ).order_by(LeanEnergie.date.desc(), LeanEnergie.id.desc()).first()

    if precedent:
        analyser_energie(releve, precedent, data.atelier, db)

    # ── POINT D'EXTENSION IA ──────────────────────────────
    # Quand le module IA est prêt, décommenter :
    # from ...services.ia.anomaly_detection import analyser_energie
    # analyser_energie(releve, db)
    # ─────────────────────────────────────────────────────

    return releve


@router.get("/", response_model=list[LeanEnergieResponse])
def get_releves(
    atelier: Optional[str] = Query(None),
    quart: Optional[str] = Query(None),
    date_debut: Optional[date] = Query(None),
    date_fin: Optional[date] = Query(None),
    limit: int = Query(100, le=500),
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    """Récupère les relevés avec filtres optionnels"""
    query = db.query(LeanEnergie)
    if atelier:
        query = query.filter(LeanEnergie.atelier == atelier)
    if quart:
        query = query.filter(LeanEnergie.quart == quart)
    if date_debut:
        query = query.filter(LeanEnergie.date >= date_debut)
    if date_fin:
        query = query.filter(LeanEnergie.date <= date_fin)
    return query.order_by(LeanEnergie.date.desc()).limit(limit).all()


@router.get("/{releve_id}", response_model=LeanEnergieResponse)
def get_releve(
    releve_id: int,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    """Récupère un relevé par son ID"""
    releve = db.query(LeanEnergie).filter(LeanEnergie.id == releve_id).first()
    if not releve:
        raise HTTPException(status_code=404, detail="Relevé non trouvé")
    return releve


@router.delete("/{releve_id}", response_model=MessageResponse)
def supprimer_releve(
    releve_id: int,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("admin"))
):
    """Supprime un relevé — admin seulement"""
    releve = db.query(LeanEnergie).filter(LeanEnergie.id == releve_id).first()
    if not releve:
        raise HTTPException(status_code=404, detail="Relevé non trouvé")
    db.delete(releve)
    db.commit()
    log_action(db, current_user.username, "DELETE", "lean_energie",
               f"Suppression relevé ID {releve_id}")
    return MessageResponse(message=f"Relevé #{releve_id} supprimé")