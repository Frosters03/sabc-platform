from pydantic import BaseModel
from typing import Optional, Any
from datetime import date, datetime

# ─── LEAN ÉNERGIE ─────────────────────────────────────────

class LeanEnergieCreate(BaseModel):
    """Ce que l'opérateur envoie — index lus sur les compteurs"""
    date:               date
    heure:              str
    quart:              str
    atelier:            str

    # Index des compteurs (valeur lue sur le compteur physique)
    index_eau_rincage:  Optional[float] = None   # m³ cumulés
    index_eau_bain:     Optional[float] = None   # m³ cumulés
    index_eau_pasteur:  Optional[float] = None   # m³ cumulés
    index_eau_aero:     Optional[float] = None   # m³ cumulés
    index_elec:         Optional[float] = None   # kWh cumulés
    index_co2:          Optional[float] = None   # kg cumulés

    production_hl:      Optional[float] = None   # hl de la veille

class LeanEnergieResponse(LeanEnergieCreate):
    """Ce qu'on renvoie — avec en plus les consommations calculées"""
    id:                 int
    saisi_par:          Optional[str]      = None
    created_at:         Optional[datetime] = None

    # Consommations calculées (index actuel - index précédent)
    # Ces champs sont calculés côté API, pas stockés en BDD
    conso_eau_rincage:  Optional[float]    = None   # m³
    conso_eau_bain:     Optional[float]    = None   # m³
    conso_eau_pasteur:  Optional[float]    = None   # m³
    conso_eau_aero:     Optional[float]    = None   # m³
    conso_elec:         Optional[float]    = None   # kWh
    conso_co2:          Optional[float]    = None   # kg

    # Ratios calculés
    ratio_laveuse:      Optional[float]    = None   # L/bouteille
    ratio_pasteur:      Optional[float]    = None   # m³/h
    ratio_elec:         Optional[float]    = None   # kWh/hl
    ratio_co2:          Optional[float]    = None   # kg/hl

    class Config:
        from_attributes = True

# ─── RÉSUMÉ 24H ───────────────────────────────────────────

class Resume24h(BaseModel):
    """Résumé journalier — somme des 3 quarts"""
    date:               date
    atelier:            str
    nb_quarts_saisis:   int              # 1, 2 ou 3 quarts saisis

    # Consommations totales du jour (somme des 3 quarts)
    conso_totale_eau_rincage:  Optional[float] = None   # m³
    conso_totale_eau_bain:     Optional[float] = None   # m³
    conso_totale_eau_pasteur:  Optional[float] = None   # m³
    conso_totale_eau_aero:     Optional[float] = None   # m³
    conso_totale_elec:         Optional[float] = None   # kWh
    conso_totale_co2:          Optional[float] = None   # kg
    production_hl:             Optional[float] = None   # hl

    # Ratios journaliers
    ratio_laveuse_jour:  Optional[float] = None   # L/bouteille
    ratio_pasteur_jour:  Optional[float] = None   # m³/h sur 24h
    ratio_elec_jour:     Optional[float] = None   # kWh/hl
    ratio_co2_jour:      Optional[float] = None   # kg/hl

# ─── QUALITÉ ──────────────────────────────────────────────

class QualiteCreate(BaseModel):
    """Ce que l'opérateur envoie pour un relevé qualité"""
    date:            date
    heure:           str
    quart:           str
    atelier:         str
    sertissage_data: Optional[str]   = None
    # JSON — nombre de cases selon atelier :
    # Chaîne 15 et 16 → 24 cases
    # Chaîne 8        → 20 cases
    # Chaîne 14       → 16 cases
    brix:            Optional[float] = None   # °
    co2_qualite:     Optional[float] = None   # g/L
    bo2:             Optional[float] = None   # mg/L

class QualiteResponse(QualiteCreate):
    """Ce qu'on renvoie après enregistrement"""
    id:         int
    saisi_par:  Optional[str]      = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True

# ─── ALERTES ──────────────────────────────────────────────

class AlerteResponse(BaseModel):
    """Ce qu'on renvoie pour une alerte"""
    id:             int
    source:         str
    niveau:         str
    atelier:        Optional[str]   = None
    message:        str
    valeur:         Optional[float] = None
    seuil:          Optional[float] = None
    recommandation: Optional[str]   = None
    lu:             bool
    created_at:     Optional[datetime] = None

    class Config:
        from_attributes = True

# ─── RÉPONSE GÉNÉRIQUE ────────────────────────────────────

class MessageResponse(BaseModel):
    """Réponse simple pour confirmer une action"""
    message: str
    success: bool = True
    data:    Optional[Any] = None