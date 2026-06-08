"""
Service IA — Maintenance Prédictive SABC Ndokoti
Contient : Isolation Forest, Score Santé, OEE, Prophet, XAI
"""
import pandas as pd
import numpy as np
from datetime import date, timedelta
from sqlalchemy.orm import Session
from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import StandardScaler

from models import LeanEnergie, Qualite
from models.maintenance_predictive import (
    ResultatAnomalie, ScoreSante, PrevisionEnergie, OEEJournalier
)

ATELIERS = ["Chaîne 8", "Chaîne 14", "Chaîne 15", "Chaîne 16"]

OBJECTIF_JOUR = {
    "Chaîne 8":  3675.0,
    "Chaîne 14": 3232.0,
    "Chaîne 15": 2941.0,
    "Chaîne 16": 3614.0,
}

# Normes qualité brassicoles
NORMES_QUALITE = {
    "brix_min": 10.5, "brix_max": 11.5,
    "co2q_min": 5.0,  "co2q_max": 6.0,
    "bo2_max":  0.10,
    "sertissage_min": 1.10, "sertissage_max": 1.15,
}

FEATURES = [
    "index_elec", "index_eau_rincage", "index_eau_bain",
    "index_eau_pasteur", "index_eau_aero", "index_co2",
    "production_hl", "brix", "pct_hors_sertissage"
]

# ════════════════════════════════════════════════════════════
# HELPERS
# ════════════════════════════════════════════════════════════

def charger_donnees_energie(db: Session, atelier: str,
                             nb_jours: int = 90) -> pd.DataFrame:
    """Charge et agrège les relevés énergie par jour (hors arrêts planifiés)."""
    date_debut = date.today() - timedelta(days=nb_jours)
    releves = db.query(LeanEnergie).filter(
        LeanEnergie.atelier == atelier,
        LeanEnergie.date    >= date_debut,
        LeanEnergie.arret_planifie == False,
    ).all()

    if not releves:
        return pd.DataFrame()

    rows = [{
        "date":              r.date,
        "index_elec":        r.index_elec        or 0,
        "index_eau_rincage": r.index_eau_rincage  or 0,
        "index_eau_bain":    r.index_eau_bain     or 0,
        "index_eau_pasteur": r.index_eau_pasteur  or 0,
        "index_eau_aero":    r.index_eau_aero     or 0,
        "index_co2":         r.index_co2          or 0,
        "production_hl":     r.production_hl      or 0,
    } for r in releves]

    df = pd.DataFrame(rows)
    # Agrégation journalière (somme des 3 quarts)
    df = df.groupby("date").sum().reset_index()
    return df.sort_values("date")


def charger_donnees_qualite(db: Session, atelier: str,
                             nb_jours: int = 90) -> pd.DataFrame:
    """Charge et agrège les relevés qualité par jour."""
    import json
    date_debut = date.today() - timedelta(days=nb_jours)
    releves = db.query(Qualite).filter(
        Qualite.atelier == atelier,
        Qualite.date    >= date_debut,
    ).all()

    if not releves:
        return pd.DataFrame()

    rows = []
    for r in releves:
        # Calcul % sertissage hors seuil
        pct_hors = 0.0
        if r.sertissage_data:
            try:
                cases = json.loads(r.sertissage_data)
                hors = sum(1 for v in cases
                           if v < NORMES_QUALITE["sertissage_min"]
                           or v > NORMES_QUALITE["sertissage_max"])
                pct_hors = hors / len(cases) * 100 if cases else 0
            except Exception:
                pass

        # Conformité qualité (True si tous les paramètres sont dans les normes)
        brix_ok = (NORMES_QUALITE["brix_min"] <= (r.brix or 0)
                   <= NORMES_QUALITE["brix_max"])
        co2q_ok = (NORMES_QUALITE["co2q_min"] <= (r.co2_qualite or 0)
                   <= NORMES_QUALITE["co2q_max"])
        bo2_ok  = (r.bo2 or 0) <= NORMES_QUALITE["bo2_max"]
        conforme = brix_ok and co2q_ok and bo2_ok

        rows.append({
            "date":         r.date,
            "brix":         r.brix         or 0,
            "co2_qualite":  r.co2_qualite  or 0,
            "bo2":          r.bo2          or 0,
            "pct_hors_sertissage": pct_hors,
            "conforme":     int(conforme),
        })

    df = pd.DataFrame(rows)
    df_agg = df.groupby("date").agg({
        "brix":         "mean",
        "co2_qualite":  "mean",
        "bo2":          "mean",
        "pct_hors_sertissage": "mean",
        "conforme":     "mean",  # taux de conformité (0–1)
    }).reset_index()
    return df_agg.sort_values("date")


# ════════════════════════════════════════════════════════════
# 1. ISOLATION FOREST — DÉTECTION D'ANOMALIES
# ════════════════════════════════════════════════════════════

def analyser_anomalies(db: Session, atelier: str) -> dict:
    """
    Lance l'Isolation Forest sur les 90 derniers jours.
    Sauvegarde les résultats dans resultats_anomalies.
    """
    df_e = charger_donnees_energie(db, atelier)
    df_q = charger_donnees_qualite(db, atelier)

    if df_e.empty:
        return {"status": "error", "message": "Pas de données disponibles"}

    # Fusion énergie + qualité sur la date
    if not df_q.empty:
        df = pd.merge(df_e, df_q[["date", "brix", "conforme", "pct_hors_sertissage"]],
                      on="date", how="left")
    else:
        df = df_e.copy()
        df["brix"]     = 11.0
        df["conforme"] = 1.0
        df["pct_hors_sertissage"] = 0.0

    df["brix"]     = df["brix"].fillna(11.0)
    df["conforme"] = df["conforme"].fillna(1.0)
    df["pct_hors_sertissage"] = df["pct_hors_sertissage"].fillna(0.0)

    # Features disponibles
    features_dispo = [f for f in FEATURES if f in df.columns]
    X = df[features_dispo].fillna(0).values

    if len(X) < 10:
        return {"status": "error", "message": "Pas assez de données (< 10 jours)"}

    # Normalisation
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    # Entraînement Isolation Forest
    model = IsolationForest(
        n_estimators=200,
        contamination=0.08,
        random_state=42,
        max_samples="auto",
    )
    scores    = model.fit_predict(X_scaled)        # -1=anomalie, 1=normal
    scores_raw = model.score_samples(X_scaled)     # score continu

    # Calcul baselines (médiane sur jours normaux)
    idx_normaux = scores == 1
    baselines = {}
    for f in features_dispo:
        vals = df.loc[idx_normaux, f]
        baselines[f] = float(vals.median()) if len(vals) > 0 else 1.0

    # Suppression des anciens résultats pour cet atelier
    db.query(ResultatAnomalie).filter(
        ResultatAnomalie.atelier == atelier
    ).delete()

    nb_anomalies = 0
    for i, row in df.iterrows():
        est_anomalie = bool(scores[i] == -1)
        if est_anomalie:
            nb_anomalies += 1

        # Calcul écarts vs baseline
        def ecart(col):
            b = baselines.get(col, 1.0)
            return round((row.get(col, b) - b) / b * 100, 1) if b != 0 else 0.0

        # Génération message XAI
        message = generer_message_xai(atelier, row["date"], est_anomalie,
                                       row, baselines, features_dispo)

        db.add(ResultatAnomalie(
            date           = row["date"],
            atelier        = atelier,
            score_anomalie = float(scores_raw[i]),
            est_anomalie   = est_anomalie,
            index_elec          = float(row.get("index_elec") or 0),
            index_eau_rincage   = float(row.get("index_eau_rincage") or 0),
            index_eau_bain      = float(row.get("index_eau_bain") or 0),
            index_eau_pasteur   = float(row.get("index_eau_pasteur") or 0),
            index_eau_aero      = float(row.get("index_eau_aero") or 0),
            index_co2           = float(row.get("index_co2") or 0),
            production_hl       = float(row.get("production_hl") or 0),
            brix                = float(row.get("brix") or 0),
            pct_hors_sertissage = float(row.get("pct_hors_sertissage") or 0),
            ecart_elec_pct        = float(ecart("index_elec")),
            ecart_eau_rincage_pct = float(ecart("index_eau_rincage")),
            ecart_eau_bain_pct    = float(ecart("index_eau_bain")),
            ecart_eau_pasteur_pct = float(ecart("index_eau_pasteur")),
            ecart_eau_aero_pct    = float(ecart("index_eau_aero")),
            ecart_production_pct  = float(ecart("production_hl")),
            message_xai    = message,
        ))

    db.commit()
    return {
        "status":       "ok",
        "atelier":      atelier,
        "nb_jours":     len(df),
        "nb_anomalies": nb_anomalies,
        "taux_anomalies_pct": round(nb_anomalies / len(df) * 100, 1),
    }


# ════════════════════════════════════════════════════════════
# 2. XAI — GÉNÉRATION MESSAGES EXPLICATIFS
# ════════════════════════════════════════════════════════════

def generer_message_xai(atelier, jour, est_anomalie,
                         row, baselines, features) -> str:
    if not est_anomalie:
        return "Fonctionnement normal."

    causes = []
    seuil  = 25  # % d'écart pour signaler une cause

    def ecart_pct(col):
        b = baselines.get(col, 1.0)
        return (row.get(col, b) - b) / b * 100 if b != 0 else 0

    e_elec    = ecart_pct("index_elec")
    e_pasteur = ecart_pct("index_eau_pasteur")
    e_bain    = ecart_pct("index_eau_bain")
    e_rincage = ecart_pct("index_eau_rincage")
    e_prod    = ecart_pct("production_hl")
    e_brix    = row.get("brix", 11.0) - 11.0

    if e_elec > seuil:
        causes.append(
            f"Électricité +{e_elec:.0f}% vs baseline "
            f"({row.get('index_elec',0):.0f} kWh vs {baselines.get('index_elec',0):.0f} kWh) "
            f"→ Vérifier moteurs et tableau électrique"
        )
    if e_pasteur > seuil:
        causes.append(
            f"Eau pasteurisateur +{e_pasteur:.0f}% "
            f"→ Suspecter fuite circuit pasteurisateur"
        )
    if e_bain > seuil:
        causes.append(
            f"Eau bain laveuse +{e_bain:.0f}% "
            f"→ Suspecter fuite bain chloré"
        )
    if e_rincage > seuil:
        causes.append(
            f"Eau rinçage +{e_rincage:.0f}% "
            f"→ Vérifier circuit rinçage"
        )
    if e_prod < -seuil:
        causes.append(
            f"Production {e_prod:.0f}% "
            f"({row.get('production_hl',0):.0f} hl vs objectif) "
            f"→ Arrêt non planifié probable"
        )
    e_sertissage = row.get("pct_hors_sertissage", 0)
    if e_sertissage > 15:
        causes.append(
            f"Sertissage hors tolerance : {e_sertissage:.1f}% des mesures non conformes "
            f"-> Usure des rouleaux probable — verifier la sertisseuse"
        )
    if abs(e_brix) > 0.5:
        direction = "trop élevé" if e_brix > 0 else "trop bas"
        causes.append(
            f"Brix {row.get('brix',0):.2f}°Bx ({direction}, norme 10.5–11.5) "
            f"→ Vérifier dosage et capteur Brix"
        )

    if not causes:
        causes.append("Combinaison anormale de plusieurs paramètres — inspection générale recommandée")

    date_str = jour.strftime("%d/%m/%Y") if hasattr(jour, "strftime") else str(jour)
    return (f"⚠ Anomalie {atelier} — {date_str} : " + " | ".join(causes))


# ════════════════════════════════════════════════════════════
# 3. SCORE DE SANTÉ (0–100)
# ════════════════════════════════════════════════════════════

def calculer_score_sante(db: Session, atelier: str) -> dict:
    """Calcule le score de santé composite pour un atelier."""
    date_fin   = date.today()
    date_debut = date_fin - timedelta(days=30)

    # Récupère les anomalies des 30 derniers jours
    anomalies = db.query(ResultatAnomalie).filter(
        ResultatAnomalie.atelier     == atelier,
        ResultatAnomalie.date        >= date_debut,
    ).all()

    if not anomalies:
        return {"status": "error",
                "message": "Lancer d'abord l'analyse anomalies"}

    nb_jours    = len(anomalies)
    nb_anomalies = sum(1 for a in anomalies if a.est_anomalie)

    # Composante 1 — Taux anomalies (35%)
    taux_ok   = 1 - (nb_anomalies / nb_jours)
    score_c1  = taux_ok * 35

    # Composante 2 — Écart énergie vs baseline (25%)
    ecarts = [abs(a.ecart_elec_pct or 0) for a in anomalies]
    ecart_moyen = np.mean(ecarts) if ecarts else 0
    score_c2 = max(0, (1 - ecart_moyen / 50)) * 25

    # Composante 3 — Qualité (25%)
    df_q = charger_donnees_qualite(db, atelier, nb_jours=30)
    if not df_q.empty:
        taux_qualite = float(df_q["conforme"].mean())
    else:
        taux_qualite = 1.0
    score_c3 = taux_qualite * 25

    # Composante 4 — Régularité des saisies (15%)
    jours_planifies = 30 - (30 // 7)  # ~26 jours (hors entretien)
    score_c4 = min(nb_jours / jours_planifies, 1.0) * 15

    score_final = round(score_c1 + score_c2 + score_c3 + score_c4, 1)

    if score_final >= 80:
        niveau = "vert"
    elif score_final >= 50:
        niveau = "orange"
    else:
        niveau = "rouge"

    # Sauvegarde
    db.query(ScoreSante).filter(
        ScoreSante.atelier == atelier,
        ScoreSante.date    == date_fin,
    ).delete()

    db.add(ScoreSante(
        date           = date_fin,
        atelier        = atelier,
        score          = float(score_final),
        niveau         = niveau,
        taux_anomalies = float(round(nb_anomalies / nb_jours * 100, 1)),
        ecart_baseline = float(round(ecart_moyen, 1)),
        taux_qualite   = float(round(taux_qualite * 100, 1)),
    ))
    db.commit()

    # ── ALERTE AUTOMATIQUE SI SCORE CRITIQUE ─────────────────
    if score_final < 50:
        from models.alerte import Alerte
        niveau_alerte = "critique" if score_final < 35 else "warning"

        # Ne pas créer de doublon si alerte IA déjà présente aujourd'hui
        alerte_existante = db.query(Alerte).filter(
            Alerte.atelier == atelier,
            Alerte.source  == "IA",
            Alerte.lu      == False,
        ).first()

        if not alerte_existante:
            derniere = db.query(ResultatAnomalie).filter(
                ResultatAnomalie.atelier      == atelier,
                ResultatAnomalie.est_anomalie == True,
            ).order_by(ResultatAnomalie.date.desc()).first()

            message = (
                f"Score de santé {atelier} : {score_final}/100 ({niveau.upper()}). "
                f"Anomalies détectées : {nb_anomalies} sur {nb_jours} jours "
                f"({round(nb_anomalies/nb_jours*100,1)}%). "
                f"Écart énergie vs baseline : {round(ecart_moyen,1)}%. "
                f"Qualité : {round(taux_qualite*100,1)}%."
            )

            recommandation = (
                derniere.message_xai
                if derniere and derniere.message_xai
                else f"Inspecter {atelier} — score dégradé depuis {nb_jours} jours."
            )

            db.add(Alerte(
                source         = "IA",
                niveau         = niveau_alerte,
                atelier        = atelier,
                message        = message,
                valeur         = float(score_final),
                seuil          = 50.0,
                recommandation = recommandation,
                lu             = False,
            ))
            db.commit()

    return {
        "status":  "ok",
        "atelier": atelier,
        "score":   score_final,
        "niveau":  niveau,
        "details": {
            "taux_anomalies_pct": round(nb_anomalies / nb_jours * 100, 1),
            "ecart_energie_pct":  round(ecart_moyen, 1),
            "taux_qualite_pct":   round(taux_qualite * 100, 1),
            "nb_jours_analyses":  nb_jours,
        }
    }


# ════════════════════════════════════════════════════════════
# 4. OEE — OVERALL EQUIPMENT EFFECTIVENESS
# ════════════════════════════════════════════════════════════

def calculer_oee(db: Session, atelier: str, nb_jours: int = 30) -> dict:
    """
    Calcule le TRS et le TRG journalier par atelier.

    TRS (Taux de Rendement Synthétique) = Disponibilité × Performance × Qualité
        → Mesure l'efficacité pendant le temps de production planifié

    TRG (Taux de Rendement Global) = Taux_Utilisation × TRS
        → Mesure l'efficacité sur le temps calendaire total
        → Plus rigoureux : intègre les arrêts planifiés comme perte

    Qualité = Conformité produit (Brix/CO2/BO2) × Conformité sertissage
        → Une bouteille valide = bon produit ET bon sertissage
    """
    import json as _json
    date_fin   = date.today()
    date_debut = date_fin - timedelta(days=nb_jours)

    releves_e = db.query(LeanEnergie).filter(
        LeanEnergie.atelier == atelier,
        LeanEnergie.date    >= date_debut,
    ).all()

    if not releves_e:
        return {"status": "error", "message": "Pas de données"}

    df = pd.DataFrame([{
        "date":           r.date,
        "production_hl":  r.production_hl or 0,
        "arret_planifie": r.arret_planifie,
    } for r in releves_e])

    df_day = df.groupby("date").agg({
        "production_hl":  "sum",
        "arret_planifie": "max",
    }).reset_index()

    # ── TAUX D'UTILISATION ─────────────────────────────────
    # = jours de production planifiés / jours calendaire total
    # Les jours d'entretien hebdomadaire réduisent ce taux
    total_jours      = len(df_day)
    jours_entretien  = int(df_day["arret_planifie"].sum())
    jours_planifies  = total_jours - jours_entretien
    taux_utilisation = jours_planifies / total_jours if total_jours > 0 else 1.0

    objectif       = OBJECTIF_JOUR.get(atelier, 3000.0)
    resultats_trs  = []
    resultats_trg  = []

    for _, row in df_day.iterrows():
        if row["arret_planifie"]:
            continue  # exclus du TRS, déjà comptés dans taux_utilisation

        # ── DISPONIBILITÉ ──────────────────────────────────
        # 1.0 si la chaîne a produit ce jour, 0.0 si arrêt non planifié
        dispo = 1.0 if row["production_hl"] > 0 else 0.0

        # ── PERFORMANCE ────────────────────────────────────
        # Production réelle / objectif journalier (plafonné à 1.0)
        perf = min(row["production_hl"] / objectif, 1.0) if objectif > 0 else 0.0

        # ── QUALITÉ (Produit + Sertissage) ─────────────────
        releves_q = db.query(Qualite).filter(
            Qualite.atelier == atelier,
            Qualite.date    == row["date"],
        ).all()

        if releves_q:
            nb_conformes     = 0
            total_sertissage = 0
            hors_sertissage  = 0

            for q in releves_q:
                # Conformité produit : Brix + CO2 + BO2
                brix_ok = NORMES_QUALITE["brix_min"] <= (q.brix or 0) <= NORMES_QUALITE["brix_max"]
                co2q_ok = NORMES_QUALITE["co2q_min"] <= (q.co2_qualite or 0) <= NORMES_QUALITE["co2q_max"]
                bo2_ok  = (q.bo2 or 0) <= NORMES_QUALITE["bo2_max"]
                if brix_ok and co2q_ok and bo2_ok:
                    nb_conformes += 1

                # Conformité sertissage (validation bouteille)
                if q.sertissage_data:
                    try:
                        cases = _json.loads(q.sertissage_data)
                        total_sertissage += len(cases)
                        hors_sertissage  += sum(
                            1 for v in cases
                            if v < NORMES_QUALITE["sertissage_min"]
                            or v > NORMES_QUALITE["sertissage_max"]
                        )
                    except Exception:
                        pass

            # Taux de conformité produit (Brix/CO2/BO2)
            qual_produit = nb_conformes / len(releves_q)

            # Taux de conformité sertissage
            # = bouteilles correctement sertissées / total bouteilles mesurées
            qual_sertissage = (
                1 - hors_sertissage / total_sertissage
            ) if total_sertissage > 0 else 1.0

            # Qualité globale = produit conforme ET sertissage conforme
            qual = qual_produit * qual_sertissage
        else:
            qual = 1.0

        # ── CALCULS TRS ET TRG ─────────────────────────────
        trs = round(dispo * perf * qual, 4)
        trg = round(taux_utilisation * trs, 4)

        resultats_trs.append(trs)
        resultats_trg.append(trg)

        # Sauvegarde
        db.query(OEEJournalier).filter(
            OEEJournalier.atelier == atelier,
            OEEJournalier.date    == row["date"],
        ).delete()

        db.add(OEEJournalier(
            date              = row["date"],
            atelier           = atelier,
            disponibilite     = round(dispo, 4),
            performance       = round(perf, 4),
            qualite_oee       = round(qual, 4),
            trs               = round(trs, 4),
            oee               = round(trg, 4),  # oee stocke le TRG
            taux_utilisation  = round(taux_utilisation, 4),
            production_reelle = row["production_hl"],
            production_cible  = objectif,
        ))

    db.commit()

    trs_moyen = round(np.mean(resultats_trs) * 100, 1) if resultats_trs else 0
    trg_moyen = round(np.mean(resultats_trg) * 100, 1) if resultats_trg else 0

    return {
        "status":               "ok",
        "atelier":              atelier,
        "trs_moyen_pct":        trs_moyen,
        "trg_moyen_pct":        trg_moyen,
        "taux_utilisation_pct": round(taux_utilisation * 100, 1),
        "nb_jours":             len(resultats_trs),
        "objectif_trs_pct":     85.0,
        "objectif_trg_pct":     75.0,
    }

# ════════════════════════════════════════════════════════════
# 5. PROPHET — PRÉDICTION 7 JOURS
# ════════════════════════════════════════════════════════════

def predire_energie(db: Session, atelier: str) -> dict:
    """Prédit la consommation électrique des 7 prochains jours."""
    try:
        from prophet import Prophet
    except ImportError:
        return {"status": "error", "message": "Prophet non installé"}

    df_e = charger_donnees_energie(db, atelier, nb_jours=90)
    if df_e.empty or len(df_e) < 14:
        return {"status": "error", "message": "Pas assez de données (< 14 jours)"}

    # Format requis par Prophet : colonnes 'ds' et 'y'
    df_prophet = df_e[["date", "index_elec"]].rename(
        columns={"date": "ds", "index_elec": "y"}
    )
    df_prophet["ds"] = pd.to_datetime(df_prophet["ds"])

    # Entraînement
    model = Prophet(
        yearly_seasonality=False,
        weekly_seasonality=True,
        daily_seasonality=False,
        changepoint_prior_scale=0.01,
        interval_width=0.80,
    )
    # Filtrer les valeurs aberrantes avant entraînement (±3 écarts-types)
    mean_y = df_prophet['y'].mean()
    std_y  = df_prophet['y'].std()
    df_prophet = df_prophet[
        df_prophet['y'].between(mean_y - 3*std_y, mean_y + 3*std_y)
    ]
    model.fit(df_prophet)

    # Prédiction 7 jours
    futur    = model.make_future_dataframe(periods=7)
    forecast = model.predict(futur)

    # Cliper les prévisions dans une plage raisonnable
    val_max = df_prophet['y'].max() * 1.5
    val_min = max(0, df_prophet['y'].min() * 0.5)
    forecast['yhat']       = forecast['yhat'].clip(val_min, val_max)
    forecast['yhat_lower'] = forecast['yhat_lower'].clip(0, val_max)
    forecast['yhat_upper'] = forecast['yhat_upper'].clip(0, val_max * 1.2)

    # Récupère seulement les 7 jours futurs
    aujourd_hui = pd.Timestamp(date.today())
    prev_futures = forecast[forecast["ds"] > aujourd_hui].head(7)

    # Suppression anciennes prévisions
    db.query(PrevisionEnergie).filter(
        PrevisionEnergie.atelier     == atelier,
        PrevisionEnergie.date_calcul == date.today(),
    ).delete()

    resultats = []
    for _, row in prev_futures.iterrows():
        db.add(PrevisionEnergie(
            atelier        = atelier,
            date_prevision = row["ds"].date(),
            date_calcul    = date.today(),
            valeur_predite = round(float(row["yhat"]),  1),
            borne_inf      = round(float(row["yhat_lower"]), 1),
            borne_sup      = round(float(row["yhat_upper"]), 1),
        ))
        resultats.append({
            "date":          row["ds"].strftime("%Y-%m-%d"),
            "valeur_predite": round(float(row["yhat"]), 1),
            "borne_inf":      round(float(row["yhat_lower"]), 1),
            "borne_sup":      round(float(row["yhat_upper"]), 1),
        })

    db.commit()
    return {
        "status":      "ok",
        "atelier":     atelier,
        "previsions":  resultats,
        "nb_jours":    len(resultats),
    }


# ════════════════════════════════════════════════════════════
# 6. ANALYSE COMPLÈTE (tous les algos d'un coup)
# ════════════════════════════════════════════════════════════

def analyse_complete(db: Session, atelier: str) -> dict:
    """Lance tous les algorithmes pour un atelier."""
    return {
        "anomalies":   analyser_anomalies(db, atelier),
        "score_sante": calculer_score_sante(db, atelier),
        "oee":         calculer_oee(db, atelier),
        "previsions":  predire_energie(db, atelier),
    }