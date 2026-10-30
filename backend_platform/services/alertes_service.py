import statistics
from datetime import date, timedelta
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

# Durée (en heures) couverte par un relevé selon son quart
HEURES_RELEVE = {
    "6h-14h": 8, "14h-22h": 8, "22h-6h": 8,
    "Journée complète": 24,
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


# ── NOUVEAUX INDICATEURS ──────────────────────────────────
# Cibles fournies par l'encadreur (27-30/10/2026). Les LIMITES sont dynamiques :
# calculées sur l'historique réel de la chaîne (30 derniers jours), pas fixées à la main.
#   - cible connue  : alerte warning dès la cible ; limite critique dynamique
#                     = médiane + 2 écarts-types, bornée entre 1,25× et 2× la cible
#   - cible inconnue (soude) : cible dynamique = médiane ; warning = médiane + 1 écart-type ;
#                     critique = médiane + 2 écarts-types (avec des minimums de +10 % / +20 %)
# Tant qu'il y a moins de 7 relevés d'historique : limite = 1,25× la cible (soude : pas d'alerte).
NOUVEAUX = {
    "eau_soutireuse": {
        "label": "Ratio eau soutireuse", "unite": "m³/h", "cible": 0.50,
        "reco_w": "Contrôler les vannes et buses d'eau de la soutireuse.",
        "reco_c": "Surconsommation d'eau soutireuse. Inspection immédiate (fuite, électrovanne bloquée).",
    },
    "eau_lubrification": {
        "label": "Ratio eau lubrification", "unite": "L/col", "cible": 0.05,
        "reco_w": "Vérifier le dosage d'eau de lubrification des convoyeurs.",
        "reco_c": "Surconsommation d'eau de lubrification. Contrôler immédiatement le circuit de lubrification.",
    },
    "soude": {
        "label": "Ratio soude", "unite": "L/hl", "cible": None,   # cible à fournir
        "reco_w": "Vérifier la concentration et les appoints de soude de la laveuse.",
        "reco_c": "Consommation de soude anormale. Contrôler les dosages et les fuites du bain de soude.",
    },
    "colle": {
        "label": "Ratio colle", "unite": "g/hl", "cible": 30.0,
        "reco_w": "Contrôler le réglage des pistolets à colle de l'étiqueteuse.",
        "reco_c": "Surconsommation de colle. Inspection immédiate de l'étiqueteuse.",
    },
    "lubrifiant": {
        "label": "Ratio lubrifiant", "unite": "g/hl", "cible": 30.0,
        "reco_w": "Vérifier le dosage du lubrifiant convoyeurs.",
        "reco_c": "Surconsommation de lubrifiant. Inspection immédiate du circuit de lubrification.",
    },
}

ORDRE_QUART = {"6h-14h": 1, "14h-22h": 2, "22h-6h": 3, "Journée complète": 4}


def _nb_cols(releve, atelier: str) -> float:
    """Nombre de cols du relevé : saisi si disponible, sinon estimé à partir des hl (65 cl).
    Chaîne 13 (canettes, formats 33/50 cl) : pas d'estimation possible → 0."""
    cols = float(getattr(releve, "production_cols", None) or 0)
    if cols > 0:
        return cols
    if atelier == 'Chaine 13':
        return 0.0
    return float(releve.production_hl or 0) * 100 / 0.65


def ratios_nouveaux(cur, prev, atelier: str) -> dict:
    """Ratios des nouveaux indicateurs pour deux relevés consécutifs.
    Les index sont toujours en m³ (conversion m³ / dm³ faite à la saisie).
      eau_soutireuse    : m³ consommés / heures couvertes (quart = 8 h, journée = 24 h)
      eau_lubrification : litres / col
      soude             : litres / hl
      colle, lubrifiant : grammes / hl (saisie en kg)"""
    out = {}
    prod = float(cur.production_hl or 0)
    if prod <= 0:
        return out

    def diff(champ):
        a, b = getattr(cur, champ, None), getattr(prev, champ, None)
        if a is None or b is None:
            return None
        return max(0.0, float(a) - float(b))

    heures = HEURES_RELEVE.get(cur.quart, 8)
    so = diff("index_eau_soutireuse")
    if so is not None:
        out["eau_soutireuse"] = so / heures

    lu = diff("index_eau_lubrification")
    nc = _nb_cols(cur, atelier)
    if lu is not None and nc > 0:
        out["eau_lubrification"] = lu * 1000 / nc

    for cle, champ, mult in (("soude", "conso_soude_l", 1.0),
                             ("colle", "conso_colle_kg", 1000.0),
                             ("lubrifiant", "conso_lubrifiant_kg", 1000.0)):
        v = getattr(cur, champ, None)
        if v is not None:
            out[cle] = float(v) * mult / prod
    return out


def historique_ratios(db: Session, atelier: str, cle: str, jours: int = 30) -> list:
    """Valeurs passées d'un ratio (arrêts planifiés et valeurs nulles exclus)."""
    debut = date.today() - timedelta(days=jours)
    rels = db.query(LeanEnergie).filter(
        LeanEnergie.atelier == atelier,
        LeanEnergie.date >= debut - timedelta(days=1),
    ).all()
    rels.sort(key=lambda r: (r.date, ORDRE_QUART.get(r.quart, 0), r.id))
    vals = []
    for prec, cur in zip(rels, rels[1:]):
        if cur.date < debut or cur.arret_planifie:
            continue
        v = ratios_nouveaux(cur, prec, atelier).get(cle)
        if v is not None and v > 0:
            vals.append(v)
    return vals


def seuils_dynamiques(db: Session, atelier: str, cle: str) -> dict:
    """Cible / limites d'un nouvel indicateur (voir le bloc NOUVEAUX)."""
    cfg   = NOUVEAUX[cle]
    vals  = historique_ratios(db, atelier, cle)
    n     = len(vals)
    cible = cfg["cible"]
    base  = {"label": cfg["label"], "unite": cfg["unite"], "n": n,
             "cible_dynamique": cible is None}

    if n >= 7:
        med = statistics.median(vals)
        sd  = statistics.pstdev(vals)

    if cible is not None:
        critique = min(max(med + 2 * sd, 1.25 * cible), 2 * cible) if n >= 7 else 1.25 * cible
        return {**base, "cible": cible, "warning": cible,
                "critique": round(critique, 4), "limite_dynamique": n >= 7}

    # Pas de cible fournie : tout est dynamique
    if n < 7:
        return {**base, "cible": None, "warning": None, "critique": None, "limite_dynamique": False}
    return {**base, "cible": round(med, 4),
            "warning":  round(max(med + sd, 1.10 * med), 4),
            "critique": round(max(med + 2 * sd, 1.20 * med), 4),
            "limite_dynamique": True}


def seuils_nouveaux(db: Session, atelier: str) -> dict:
    """Tous les seuils des nouveaux indicateurs pour une chaîne (utilisé par l'analyse)."""
    return {cle: seuils_dynamiques(db, atelier, cle) for cle in NOUVEAUX}


def _creer_alerte(db: Session, source: str, niveau: str, atelier: str,
                  message: str, valeur: float, seuil: float, recommandation: str):
    """Crée une alerte en base si elle n'existe pas déjà récemment."""
    from datetime import datetime, timedelta
    info = {"niveau": niveau, "message": message, "valeur": round(valeur, 3),
            "seuil": seuil, "recommandation": recommandation}
    # Évite les doublons — pas de même alerte dans les 8 dernières heures
    recente = db.query(Alerte).filter(
        Alerte.atelier  == atelier,
        Alerte.message  == message,
        Alerte.created_at >= datetime.now() - timedelta(hours=8)
    ).first()
    if recente:
        return info

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
    return info


def analyser_energie(releve_actuel: LeanEnergie, releve_precedent: LeanEnergie,
                     atelier: str, db: Session):
    """
    Calcule les ratios à partir de deux relevés consécutifs
    et génère les alertes si les seuils sont dépassés.
    """
    generees = []   # alertes déclenchées par CE relevé (renvoyées à la saisie)
    prod = float(releve_actuel.production_hl or 0)
    if prod <= 0:
        return generees

    # Nb bouteilles : vrai nombre de cols si saisi, sinon estimation hl → bouteilles
    cols = float(getattr(releve_actuel, "production_cols", None) or 0)
    if atelier == 'Chaine 13':
        nb_bte = 0              # Cannettes — laveuse non applicable
    elif cols > 0:
        nb_bte = cols
    else:
        nb_bte = prod * 100 / 0.65   # format non saisi : 65 cl par défaut

    # Durée couverte par ce relevé (un quart = 8 h, une journée complète = 24 h)
    heures = HEURES_RELEVE.get(releve_actuel.quart, 8)

    def diff(a, b):
        v = float(a or 0) - float(b or 0)
        return v if v > 0 else 0  # ignorer valeurs négatives

    # ── Saisie suspecte : un index ne peut pas être inférieur au relevé précédent
    #    (faute de frappe ou mauvaise unité m³ / dm³)
    controles = [
        ("index_eau_rincage", "Eau laveuse rinçage"), ("index_eau_bain", "Eau laveuse bain"),
        ("index_eau_pasteur", "Eau pasteurisateur"),  ("index_eau_aero", "Appoint eau aéro"),
        ("index_eau_soutireuse", "Eau soutireuse"),   ("index_eau_lubrification", "Eau lubrification"),
        ("index_elec", "Électricité"),                ("index_co2", "CO₂"),
    ]
    for champ, nom in controles:
        a = getattr(releve_actuel, champ, None)
        b = getattr(releve_precedent, champ, None)
        if a is None or b is None or float(b) <= 0:
            continue
        if float(a) < float(b):
            generees.append(_creer_alerte(
                db, source="auto", niveau="warning", atelier=atelier,
                message=f"Index {nom} inférieur au relevé précédent ({a} < {b}) — vérifier la saisie ou l'unité",
                valeur=float(a), seuil=float(b),
                recommandation="Relire le compteur et vérifier l'unité choisie (m³ ou dm³). Corriger le relevé si nécessaire."
            ))

    rincage = diff(releve_actuel.index_eau_rincage, releve_precedent.index_eau_rincage)
    bain    = diff(releve_actuel.index_eau_bain,    releve_precedent.index_eau_bain)
    pasteur = diff(releve_actuel.index_eau_pasteur, releve_precedent.index_eau_pasteur)
    aero    = diff(releve_actuel.index_eau_aero,    releve_precedent.index_eau_aero)
    elec    = diff(releve_actuel.index_elec,        releve_precedent.index_elec)
    co2     = diff(releve_actuel.index_co2,         releve_precedent.index_co2)

    # Ratios
    ratio_laveuse = ((bain + rincage) * 1000 / nb_bte) if nb_bte > 0 else 0
    ratio_pasto   = (pasteur + aero) / heures
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
            generees.append(_creer_alerte(
                db, source="auto", niveau="critique", atelier=atelier,
                message=f"{s['label']} élevé : {round(valeur,3)} {s['unite']} (limite : {s['critique']})",
                valeur=valeur, seuil=s["critique"],
                recommandation=s["reco_c"]
            ))
        elif valeur >= s["warning"]:
            generees.append(_creer_alerte(
                db, source="auto", niveau="warning", atelier=atelier,
                message=f"{s['label']} en hausse : {round(valeur,3)} {s['unite']} (cible : {s['warning']})",
                valeur=valeur, seuil=s["warning"],
                recommandation=s["reco_w"]
            ))

    # ── Nouveaux indicateurs : cibles données + limites dynamiques ──
    for cle, valeur in ratios_nouveaux(releve_actuel, releve_precedent, atelier).items():
        s = seuils_dynamiques(db, atelier, cle)
        if s["warning"] is None:
            continue   # pas encore assez d'historique (soude)
        cfg = NOUVEAUX[cle]
        v   = round(valeur, 3)
        if valeur >= s["critique"]:
            generees.append(_creer_alerte(
                db, source="auto", niveau="critique", atelier=atelier,
                message=f"{cfg['label']} critique : {v} {cfg['unite']} (limite : {round(s['critique'], 3)})",
                valeur=valeur, seuil=s["critique"], recommandation=cfg["reco_c"]))
        elif valeur >= s["warning"]:
            generees.append(_creer_alerte(
                db, source="auto", niveau="warning", atelier=atelier,
                message=f"{cfg['label']} en hausse : {v} {cfg['unite']} (cible : {round(s['warning'], 3)})",
                valeur=valeur, seuil=s["warning"], recommandation=cfg["reco_w"]))

    return generees


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