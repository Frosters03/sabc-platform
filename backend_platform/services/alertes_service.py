from sqlalchemy.orm import Session
from models.alerte import Alerte
from models.lean_energie import LeanEnergie


# ── SEUILS ────────────────────────────────────────────────
SEUILS = {
    "laveuse": {
        "warning":  0.3,
        "critique": 0.6,
        "unite":    "L/bte",
        "label":    "Ratio eau laveuse",
        "reco_w":   "Vérifier le réglage des buses de rinçage et l'état des joints de la laveuse.",
        "reco_c":   "Arrêt recommandé pour inspection complète de la laveuse. Contacter la maintenance.",
    },
    "pasteurisateur": {
        "warning":  1.5,
        "critique": 2.0,
        "unite":    "m³/h",
        "label":    "Ratio eau pasteurisateur",
        "reco_w":   "Contrôler les vannes de régulation et vérifier l'absence de fuites.",
        "reco_c":   "Inspection immédiate du circuit eau pasteurisateur. Risque de surconsommation critique.",
    },
    "electricite": {
        "warning":  2.0,
        "critique": 3.0,
        "unite":    "kWh/hl",
        "label":    "Ratio électricité",
        "reco_w":   "Vérifier l'état des moteurs et compresseurs. Contrôler les pics de consommation.",
        "reco_c":   "Consommation électrique anormale. Vérifier immédiatement les équipements en charge.",
    },
    "co2": {
        "warning":  0.3,
        "critique": 0.8,
        "unite":    "kg/hl",
        "label":    "Ratio CO₂",
        "reco_w":   "Contrôler les raccords et vannes CO₂. Vérifier l'absence de fuites.",
        "reco_c":   "Fuite CO₂ probable. Inspection immédiate de l'installation requise.",
    },
}

SEUILS_QUALITE = {
    "brix": {
        "min_w": 11.0, "max_w": 13.0,
        "min_c": 10.0, "max_c": 14.0,
        "unite": "°Brix", "label": "Teneur en sucre (Brix)",
        "reco_w": "Ajuster le dosage de sucre. Vérifier la calibration du réfractomètre.",
        "reco_c": "Teneur en sucre hors norme critique. Arrêt de la ligne recommandé.",
    },
    "co2_qualite": {
        "min_w": 5.0, "max_w": 6.0,
        "min_c": 4.5, "max_c": 6.5,
        "unite": "g/L", "label": "Teneur en CO₂",
        "reco_w": "Vérifier la pression de carbonatation et la température de remplissage.",
        "reco_c": "Carbonatation hors norme critique. Contrôle immédiat requis.",
    },
    "bo2": {
        "max_w": 0.08,
        "max_c": 0.10,
        "unite": "mg/L", "label": "Teneur en O₂ dissous (BO₂)",
        "reco_w": "Vérifier l'étanchéité des raccords et la purge des têtes de remplissage.",
        "reco_c": "Taux d'oxygène critique. Risque de dégradation produit. Arrêt recommandé.",
    },
}


def _creer_alerte(db: Session, source: str, niveau: str, atelier: str,
                  message: str, valeur: float, seuil: float, recommandation: str):
    """Crée une alerte en base si elle n'existe pas déjà récemment."""
    from datetime import datetime, timedelta
    # Évite les doublons — pas de même alerte dans les 8 dernières heures
    recente = db.query(Alerte).filter(
        Alerte.atelier  == atelier,
        Alerte.message  == message,
        Alerte.created_at >= datetime.now() - timedelta(hours=8)
    ).first()
    if recente:
        return

    alerte = Alerte(
        source         = source,
        niveau         = niveau,
        atelier        = atelier,
        message        = message,
        valeur         = round(valeur, 3),
        seuil          = seuil,
        recommandation = recommandation,
        lu             = False,
    )
    db.add(alerte)
    db.commit()


def analyser_energie(releve_actuel: LeanEnergie, releve_precedent: LeanEnergie,
                     atelier: str, db: Session):
    """
    Calcule les ratios à partir de deux relevés consécutifs
    et génère les alertes si les seuils sont dépassés.
    """
    prod = float(releve_actuel.production_hl or 0)
    if prod <= 0:
        return

    # Nb bouteilles selon chaîne
    nb_bte = prod * 100 / 0.5 if atelier == "Chaîne 16" else prod * 100 / 0.65

    def diff(a, b):
        v = float(a or 0) - float(b or 0)
        return v if v > 0 else 0  # ignorer valeurs négatives

    rincage = diff(releve_actuel.index_eau_rincage, releve_precedent.index_eau_rincage)
    bain    = diff(releve_actuel.index_eau_bain,    releve_precedent.index_eau_bain)
    pasteur = diff(releve_actuel.index_eau_pasteur, releve_precedent.index_eau_pasteur)
    aero    = diff(releve_actuel.index_eau_aero,    releve_precedent.index_eau_aero)
    elec    = diff(releve_actuel.index_elec,        releve_precedent.index_elec)
    co2     = diff(releve_actuel.index_co2,         releve_precedent.index_co2)

    # Ratios
    ratio_laveuse = ((bain + rincage) * 1000 / nb_bte) if nb_bte > 0 else 0
    ratio_pasto   = (pasteur + aero) / 24
    ratio_elec    = elec / prod if prod > 0 else 0
    ratio_co2     = co2  / prod if prod > 0 else 0

    ratios = [
        ("laveuse",       ratio_laveuse),
        ("pasteurisateur",ratio_pasto),
        ("electricite",   ratio_elec),
        ("co2",           ratio_co2),
    ]

    for cle, valeur in ratios:
        s = SEUILS[cle]
        if valeur >= s["critique"]:
            _creer_alerte(
                db, source="auto", niveau="critique", atelier=atelier,
                message=f"{s['label']} élevé : {round(valeur,3)} {s['unite']} (limite : {s['critique']})",
                valeur=valeur, seuil=s["critique"],
                recommandation=s["reco_c"]
            )
        elif valeur >= s["warning"]:
            _creer_alerte(
                db, source="auto", niveau="warning", atelier=atelier,
                message=f"{s['label']} en hausse : {round(valeur,3)} {s['unite']} (cible : {s['warning']})",
                valeur=valeur, seuil=s["warning"],
                recommandation=s["reco_w"]
            )


def analyser_qualite(releve, atelier: str, db: Session):
    """
    Analyse un relevé qualité et génère les alertes si nécessaire.
    """
    checks = [
        ("brix",       float(releve.brix       or 0), "brix"),
        ("co2_qualite",float(releve.co2_qualite or 0), "co2_qualite"),
        ("bo2",        float(releve.bo2         or 0), "bo2"),
    ]

    for champ, valeur, cle in checks:
        if valeur <= 0:
            continue
        s = SEUILS_QUALITE[cle]

        # BO₂ — seulement max
        if cle == "bo2":
            if valeur >= s["max_c"]:
                _creer_alerte(db, "auto", "critique", atelier,
                    f"{s['label']} critique : {valeur} {s['unite']} (limite : {s['max_c']})",
                    valeur, s["max_c"], s["reco_c"])
            elif valeur >= s["max_w"]:
                _creer_alerte(db, "auto", "warning", atelier,
                    f"{s['label']} élevé : {valeur} {s['unite']} (seuil : {s['max_w']})",
                    valeur, s["max_w"], s["reco_w"])
        else:
            # Min et max
            if valeur < s["min_c"] or valeur > s["max_c"]:
                _creer_alerte(db, "auto", "critique", atelier,
                    f"{s['label']} hors norme : {valeur} {s['unite']} (norme : {s['min_c']}–{s['max_c']})",
                    valeur, s["max_c"], s["reco_c"])
            elif valeur < s["min_w"] or valeur > s["max_w"]:
                _creer_alerte(db, "auto", "warning", atelier,
                    f"{s['label']} limite : {valeur} {s['unite']} (norme : {s['min_w']}–{s['max_w']})",
                    valeur, s["max_w"], s["reco_w"])