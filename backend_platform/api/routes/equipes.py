from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from core.database import get_db
from models.equipe import Equipe, MembreEquipe
from models.utilisateur import Utilisateur
from schemas.pointage import (
    EquipeCreate, EquipeUpdate, EquipeResponse,
    MembreCreate, MembreResponse
)
from .auth import get_current_user, require_role, log_action

router = APIRouter(prefix="/equipes", tags=["Équipes"])

FONCTIONS_ORDRE = [
    "Conducteur dépalettiseur",
    "Conducteur décaisseuse",
    "Conducteur laveuse",
    "Conducteur EBI/Mireuse électronique",
    "Conducteur soutireuse",
    "Conducteur pasteurisateur",
    "Conducteur étiquetteuse",
    "Assistant conducteur étiquetteuse",
    "Conducteur encaisseuse",
    "Conducteur palettiseur",
    "Cariste 1",
    "Cariste 2",
    "Cariste 3",
    "Cariste 4",
]


@router.get("/", response_model=List[EquipeResponse])
def get_equipes(
    chaine: str = None,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    query = db.query(Equipe).filter(Equipe.actif == True)
    if chaine:
        query = query.filter(Equipe.chaine == chaine)
    equipes = query.order_by(Equipe.chaine, Equipe.nom).all()
    # Filtrer les membres inactifs de chaque équipe
    for eq in equipes:
        eq.membres = [m for m in eq.membres if m.actif != False]
    return equipes


@router.get("/fonctions")
def get_fonctions(current_user: Utilisateur = Depends(get_current_user)):
    return {"fonctions": FONCTIONS_ORDRE}


@router.post("/", response_model=EquipeResponse)
def creer_equipe(
    data: EquipeCreate,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("manager"))
):
    equipe = Equipe(nom=data.nom, chaine=data.chaine)
    db.add(equipe)
    db.commit()
    db.refresh(equipe)
    log_action(db, current_user.username, "INSERT", "equipes",
               f"Équipe {data.nom} — {data.chaine}")
    return equipe


@router.put("/{equipe_id}", response_model=EquipeResponse)
def modifier_equipe(
    equipe_id: int,
    data: EquipeUpdate,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("manager"))
):
    equipe = db.query(Equipe).filter(Equipe.id == equipe_id).first()
    if not equipe:
        raise HTTPException(status_code=404, detail="Équipe non trouvée")
    if data.nom    is not None: equipe.nom    = data.nom
    if data.chaine is not None: equipe.chaine = data.chaine
    if data.actif  is not None: equipe.actif  = data.actif
    db.commit()
    db.refresh(equipe)
    return equipe


@router.delete("/{equipe_id}")
def supprimer_equipe(
    equipe_id: int,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("manager"))
):
    equipe = db.query(Equipe).filter(Equipe.id == equipe_id).first()
    if not equipe:
        raise HTTPException(status_code=404, detail="Équipe non trouvée")
    equipe.actif = False
    db.commit()
    return {"message": f"Équipe {equipe.nom} désactivée"}


@router.post("/{equipe_id}/membres", response_model=MembreResponse)
def ajouter_membre(
    equipe_id: int,
    data: MembreCreate,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("manager"))
):
    equipe = db.query(Equipe).filter(Equipe.id == equipe_id).first()
    if not equipe:
        raise HTTPException(status_code=404, detail="Équipe non trouvée")
    membre = MembreEquipe(equipe_id=equipe_id, **data.model_dump())
    db.add(membre)
    db.commit()
    db.refresh(membre)
    log_action(db, current_user.username, "INSERT", "membres_equipe",
               f"Membre {data.nom_prenom} — {equipe.nom}")
    return membre


@router.put("/{equipe_id}/membres/{membre_id}", response_model=MembreResponse)
def modifier_membre(
    equipe_id: int,
    membre_id: int,
    data: MembreCreate,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(require_role("manager"))
):
    membre = db.query(MembreEquipe).filter(
        MembreEquipe.id == membre_id,
        MembreEquipe.equipe_id == equipe_id
    ).first()
    if not membre:
        raise HTTPException(status_code=404, detail="Membre non trouvé")
    for k, v in data.model_dump().items():
        setattr(membre, k, v)
    db.commit()
    db.refresh(membre)
    return membre


@router.delete("/{equipe_id}/membres/{membre_id}")
def supprimer_membre(
    equipe_id:  int,
    membre_id:  int,
    db:          Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    membre = db.query(MembreEquipe).filter(
        MembreEquipe.id        == membre_id,
        MembreEquipe.equipe_id == equipe_id,
    ).first()

    if not membre:
        raise HTTPException(status_code=404, detail="Membre non trouvé")

    # Vérifier s'il a des lignes de pointage
    from models.pointage import LignePointage
    nb_lignes = db.query(LignePointage).filter(
        LignePointage.membre_id == membre_id
    ).count()

    if nb_lignes > 0:
        # Il a des pointages — on désactive plutôt que supprimer
        membre.actif = False
        db.commit()
        return {
            "message": f"Membre désactivé (avait {nb_lignes} pointage(s) enregistré(s)). Les données historiques sont conservées.",
            "action": "desactive"
        }
    else:
        # Pas de pointages — suppression réelle possible
        db.delete(membre)
        db.commit()
        return {
            "message": "Membre supprimé.",
            "action": "supprime"
        }