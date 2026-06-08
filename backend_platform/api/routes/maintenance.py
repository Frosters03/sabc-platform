"""
Routes API — Maintenance Prédictive IA
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import Optional
from datetime import date

from core.database import get_db
from models.utilisateur import Utilisateur
from api.routes.auth import get_current_user
from models.maintenance_predictive import (
    ResultatAnomalie, ScoreSante, PrevisionEnergie, OEEJournalier
)
from services.ia_service import (
    analyser_anomalies, calculer_score_sante,
    calculer_oee, predire_energie, analyse_complete
)

router = APIRouter(prefix="/api/maintenance", tags=["Maintenance Prédictive"])

ATELIERS = ["Chaîne 8", "Chaîne 14", "Chaîne 15", "Chaîne 16"]

# ════════════════════════════════════════════════════════════
# ENDPOINTS ANALYSE (déclenchent les algorithmes IA)
# ════════════════════════════════════════════════════════════

@router.post("/analyser/{atelier}")
def lancer_analyse(
    atelier: str,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user),
):
    """Lance tous les algorithmes IA pour un atelier."""
    if atelier not in ATELIERS:
        from fastapi import HTTPException
        raise HTTPException(400, f"Atelier inconnu. Valeurs : {ATELIERS}")
    return analyse_complete(db, atelier)


@router.post("/analyser-tous")
def lancer_analyse_tous(
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user),
):
    """Lance l'analyse complète sur toutes les chaînes."""
    resultats = {}
    for atelier in ATELIERS:
        resultats[atelier] = analyse_complete(db, atelier)
    return {"status": "ok", "resultats": resultats}


# ════════════════════════════════════════════════════════════
# ENDPOINTS LECTURE (retournent les résultats stockés)
# ════════════════════════════════════════════════════════════

@router.get("/anomalies")
def get_anomalies(
    atelier:      Optional[str]  = Query(None),
    seulement_anomalies: bool    = Query(False),
    nb_jours:     int            = Query(30),
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user),
):
    """Retourne les résultats de détection d'anomalies."""
    from datetime import timedelta
    date_debut = date.today() - timedelta(days=nb_jours)

    query = db.query(ResultatAnomalie).filter(
        ResultatAnomalie.date >= date_debut
    )
    if atelier:
        query = query.filter(ResultatAnomalie.atelier == atelier)
    if seulement_anomalies:
        query = query.filter(ResultatAnomalie.est_anomalie == True)

    resultats = query.order_by(
        ResultatAnomalie.date.desc()
    ).all()

    return [{
        "id":            r.id,
        "date":          str(r.date),
        "atelier":       r.atelier,
        "score":         round(r.score_anomalie, 4),
        "est_anomalie":  r.est_anomalie,
        "production_hl": r.production_hl,
        "index_elec":    r.index_elec,
        "ecart_elec_pct":       r.ecart_elec_pct,
        "ecart_pasteur_pct":    r.ecart_eau_pasteur_pct,
        "ecart_bain_pct":       r.ecart_eau_bain_pct,
        "ecart_production_pct": r.ecart_production_pct,
        "message_xai":   r.message_xai,
    } for r in resultats]


@router.get("/scores-sante")
def get_scores_sante(
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user),
):
    """Retourne le dernier score de santé de chaque chaîne."""
    scores = {}
    for atelier in ATELIERS:
        dernier = db.query(ScoreSante).filter(
            ScoreSante.atelier == atelier
        ).order_by(ScoreSante.date.desc()).first()

        if dernier:
            scores[atelier] = {
                "score":          dernier.score,
                "niveau":         dernier.niveau,
                "date":           str(dernier.date),
                "taux_anomalies": dernier.taux_anomalies,
                "ecart_baseline": dernier.ecart_baseline,
                "taux_qualite":   dernier.taux_qualite,
            }
        else:
            scores[atelier] = {"score": None, "niveau": "inconnu"}

    return scores


@router.get("/oee")
def get_oee(
    atelier:  Optional[str] = Query(None),
    nb_jours: int           = Query(30),
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user),
):
    """Retourne les données OEE."""
    from datetime import timedelta
    date_debut = date.today() - timedelta(days=nb_jours)

    query = db.query(OEEJournalier).filter(
        OEEJournalier.date >= date_debut
    )
    if atelier:
        query = query.filter(OEEJournalier.atelier == atelier)

    resultats = query.order_by(OEEJournalier.date.asc()).all()

    return [{
        "date":              str(r.date),
        "atelier":           r.atelier,
        "disponibilite_pct": round((r.disponibilite or 0) * 100, 1),
        "performance_pct":   round((r.performance   or 0) * 100, 1),
        "qualite_pct":       round((r.qualite_oee   or 0) * 100, 1),
        "trs_pct":           round((r.trs              or 0) * 100, 1),
        "oee_pct":           round((r.oee           or 0) * 100, 1),
        "taux_utilisation_pct": round((r.taux_utilisation or 0) * 100, 1),
        "production_reelle": r.production_reelle,
        "production_cible":  r.production_cible,
    } for r in resultats]


@router.get("/previsions")
def get_previsions(
    atelier: Optional[str] = Query(None),
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user),
):
    """Retourne les prévisions Prophet les plus récentes."""
    # Trouver la date de calcul la plus récente
    from sqlalchemy import func
    derniere_date = db.query(
        func.max(PrevisionEnergie.date_calcul)
    ).scalar()

    if not derniere_date:
        return []

    query = db.query(PrevisionEnergie).filter(
        PrevisionEnergie.date_calcul == derniere_date
    )
    if atelier:
        query = query.filter(PrevisionEnergie.atelier == atelier)

    resultats = query.order_by(
        PrevisionEnergie.atelier,
        PrevisionEnergie.date_prevision
    ).all()

    return [{
        "atelier":        r.atelier,
        "date_prevision": str(r.date_prevision),
        "valeur_predite": r.valeur_predite,
        "borne_inf":      r.borne_inf,
        "borne_sup":      r.borne_sup,
    } for r in resultats]

@router.get("/dashboard-resume")
def get_dashboard_resume(
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user),
):
    """Résumé global pour le dashboard — toutes les chaînes."""
    from datetime import timedelta

    resume = []
    for atelier in ATELIERS:
        # Dernier score santé
        score = db.query(ScoreSante).filter(
            ScoreSante.atelier == atelier
        ).order_by(ScoreSante.date.desc()).first()

        # Dernier OEE (7 jours)
        date_7j = date.today() - timedelta(days=7)
        oees = db.query(OEEJournalier).filter(
            OEEJournalier.atelier == atelier,
            OEEJournalier.date    >= date_7j,
        ).all()
        oee_moyen = round(
            sum(o.oee or 0 for o in oees) / len(oees) * 100, 1
        ) if oees else None

        # Nb anomalies 7 derniers jours
        nb_anomalies = db.query(ResultatAnomalie).filter(
            ResultatAnomalie.atelier      == atelier,
            ResultatAnomalie.est_anomalie == True,
            ResultatAnomalie.date         >= date_7j,
        ).count()

        resume.append({
            "atelier":      atelier,
            "score_sante":  score.score   if score else None,
            "niveau":       score.niveau  if score else "inconnu",
            "oee_7j_pct":   oee_moyen,
            "anomalies_7j": nb_anomalies,
        })

    return resume