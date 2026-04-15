from pydantic import BaseModel
from typing import Optional, List
from datetime import date, datetime

# ── ÉQUIPE ────────────────────────────────────────────────

class MembreCreate(BaseModel):
    fonction:   str
    nom_prenom: str
    matricule:  Optional[str] = None
    statut:     str = "titulaire"
    ordre:      int = 0

class MembreResponse(MembreCreate):
    id:        int
    equipe_id: int
    actif:     bool = True
    class Config:
        from_attributes = True

class EquipeCreate(BaseModel):
    nom:    str
    chaine: str

class EquipeUpdate(BaseModel):
    nom:    Optional[str] = None
    chaine: Optional[str] = None
    actif:  Optional[bool] = None

class EquipeResponse(BaseModel):
    id:        int
    nom:       str
    chaine:    str
    actif:     bool
    membres:   List[MembreResponse] = []
    class Config:
        from_attributes = True

# ── POINTAGE ──────────────────────────────────────────────

class LignePointageCreate(BaseModel):
    membre_id:      Optional[int] = None
    fonction:       str
    nom_prenom:     str
    statut_emploi:  str = "titulaire"
    presence:       str
    # "A", "R", "RM", "CP", "P"
    heures_N:       float = 0
    heures_F:       float = 0
    heures_PN:      float = 0
    est_occasionnel: bool = False

class LignePointageResponse(LignePointageCreate):
    id:          int
    pointage_id: int
    class Config:
        from_attributes = True

class PointageCreate(BaseModel):
    date:       date
    chaine:     str
    equipe_id:  int
    equipe_nom: str
    quart:      str
    lignes:     List[LignePointageCreate]

class PointageResponse(BaseModel):
    id:         int
    date:       date
    chaine:     str
    equipe_id:  int
    equipe_nom: str
    quart:      str
    saisi_par:  str
    created_at: Optional[datetime] = None
    lignes:     List[LignePointageResponse] = []
    class Config:
        from_attributes = True