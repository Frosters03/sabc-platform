"""
Analyse des heures supplémentaires (module RH).

Règle (identique au rapport hebdomadaire existant) :
  heures supp d'une semaine = max(0, heures N + heures F de la semaine − 40)
Une semaine est rattachée au mois qui contient son jeudi (convention ISO).
Quota mensuel par défaut : 40 h supp / personne / mois.
"""
from calendar import monthrange
from datetime import date, timedelta

QUOTA_DEFAUT = 40.0
SEUIL_ATTENTION = 0.8      # 80 % du quota
HEURES_SEMAINE = 40.0


def _lundi(d: date) -> date:
    return d - timedelta(days=d.weekday())


def bornes_mois(annee: int, mois: int):
    """Premier lundi à inclure et dernier dimanche à inclure pour couvrir les semaines du mois."""
    debut = date(annee, mois, 1)
    fin = date(annee, mois, monthrange(annee, mois)[1])
    return _lundi(debut), _lundi(fin) + timedelta(days=6)


def niveau(pct: float) -> str:
    if pct >= 1.0:
        return "depasse"
    if pct >= SEUIL_ATTENTION:
        return "attention"
    return "ok"


def analyser(pointages, annee: int, mois: int, quota: float = QUOTA_DEFAUT,
             aujourdhui: date | None = None, membres_actifs: dict | None = None) -> dict:
    """
    pointages : liste d'objets Pointage (avec .lignes) couvrant les semaines du mois.
    membres_actifs : {membre_id: statut} pour filtrer/étiqueter (facultatif).
    """
    aujourdhui = aujourdhui or date.today()
    debut_mois = date(annee, mois, 1)
    nb_jours = monthrange(annee, mois)[1]
    fin_mois = date(annee, mois, nb_jours)

    # {membre_id: {"info": {...}, "semaines": {lundi: N+F}}}
    membres: dict = {}
    derniere_saisie = None
    for ptg in pointages:
        lundi = _lundi(ptg.date)
        for lg in ptg.lignes:
            if lg.est_occasionnel or lg.membre_id is None:
                continue
            m = membres.setdefault(lg.membre_id, {
                "membre_id": lg.membre_id, "nom_prenom": lg.nom_prenom,
                "fonction": lg.fonction, "equipe": ptg.equipe_nom, "equipe_id": ptg.equipe_id,
                "chaine": ptg.chaine, "semaines": {},
            })
            m["semaines"][lundi] = m["semaines"].get(lundi, 0.0) + (lg.heures_N or 0) + (lg.heures_F or 0)
        if debut_mois <= ptg.date <= fin_mois and (derniere_saisie is None or ptg.date > derniere_saisie):
            derniere_saisie = ptg.date

    mois_courant = (aujourdhui.year, aujourdhui.month) == (annee, mois)
    jour_ref = min(aujourdhui, fin_mois) if mois_courant else fin_mois
    jours_ecoules = max(1, (jour_ref - debut_mois).days + 1)

    resultat = []
    for m in membres.values():
        hs = 0.0
        detail = []
        for lundi, total in sorted(m["semaines"].items()):
            jeudi = lundi + timedelta(days=3)
            if (jeudi.year, jeudi.month) != (annee, mois):
                continue
            hs_sem = max(0.0, total - HEURES_SEMAINE)
            hs += hs_sem
            detail.append({"semaine": lundi.isoformat(), "heures": round(total, 1), "hs": round(hs_sem, 1)})
        pct = hs / quota if quota > 0 else 0.0
        prevision = None
        if mois_courant and hs > 0 and hs < quota:
            rythme = hs / jours_ecoules
            fin_projetee = rythme * nb_jours
            if fin_projetee >= quota:
                jours_pour_quota = quota / rythme
                date_quota = debut_mois + timedelta(days=int(jours_pour_quota) - 1)
                prevision = {"atteint_le": min(date_quota, fin_mois).isoformat(),
                             "fin_de_mois": round(fin_projetee, 1)}
            else:
                prevision = {"atteint_le": None, "fin_de_mois": round(fin_projetee, 1)}
        resultat.append({
            "membre_id": m["membre_id"], "nom_prenom": m["nom_prenom"], "fonction": m["fonction"],
            "equipe": m["equipe"], "equipe_id": m["equipe_id"], "chaine": m["chaine"],
            "statut": (membres_actifs or {}).get(m["membre_id"]),
            "hs_mois": round(hs, 1), "quota": quota, "pct": round(pct * 100, 1),
            "reste": round(max(0.0, quota - hs), 1), "niveau": niveau(pct),
            "prevision": prevision, "semaines": detail,
        })

    resultat.sort(key=lambda r: (-r["hs_mois"], r["nom_prenom"]))

    # Regroupement par équipe + suggestions
    equipes: dict = {}
    for r in resultat:
        e = equipes.setdefault(r["equipe_id"], {
            "equipe_id": r["equipe_id"], "equipe": r["equipe"], "chaine": r["chaine"],
            "membres": [], "total_hs": 0.0,
        })
        e["membres"].append(r)
        e["total_hs"] += r["hs_mois"]
    liste_equipes = []
    for e in equipes.values():
        e["total_hs"] = round(e["total_hs"], 1)
        e["nb_depasse"] = sum(1 for x in e["membres"] if x["niveau"] == "depasse")
        e["nb_attention"] = sum(1 for x in e["membres"] if x["niveau"] == "attention")
        # Suggestion : si au moins un membre est à ≥ 80 %, proposer ceux qui ont le plus de marge
        if e["nb_depasse"] + e["nb_attention"] > 0:
            marge = sorted([x for x in e["membres"] if x["niveau"] == "ok"], key=lambda x: x["hs_mois"])
            e["suggestion"] = [
                {"nom_prenom": x["nom_prenom"], "fonction": x["fonction"], "hs_mois": x["hs_mois"], "reste": x["reste"]}
                for x in marge[:3]
            ]
        else:
            e["suggestion"] = []
        liste_equipes.append(e)
    liste_equipes.sort(key=lambda e: (-e["nb_depasse"], -e["nb_attention"], e["equipe"] or ""))

    alertes = []
    for r in resultat:
        if r["niveau"] == "depasse":
            alertes.append({"gravite": "critique", "membre_id": r["membre_id"],
                            "message": f"{r['nom_prenom']} ({r['equipe']}) a dépassé son quota : {r['hs_mois']} h / {quota:g} h."})
        elif r["niveau"] == "attention":
            alertes.append({"gravite": "attention", "membre_id": r["membre_id"],
                            "message": f"{r['nom_prenom']} ({r['equipe']}) approche du quota : {r['hs_mois']} h / {quota:g} h ({r['pct']:.0f} %)."})
        elif r["prevision"] and r["prevision"]["atteint_le"]:
            alertes.append({"gravite": "prevision", "membre_id": r["membre_id"],
                            "message": f"À ce rythme, {r['nom_prenom']} ({r['equipe']}) atteindra son quota vers le {r['prevision']['atteint_le']}."})

    return {
        "annee": annee, "mois": mois, "quota": quota,
        "derniere_saisie": derniere_saisie.isoformat() if derniere_saisie else None,
        "resume": {
            "nb_personnes": len(resultat),
            "nb_depasse": sum(1 for r in resultat if r["niveau"] == "depasse"),
            "nb_attention": sum(1 for r in resultat if r["niveau"] == "attention"),
            "total_hs": round(sum(r["hs_mois"] for r in resultat), 1),
        },
        "equipes": liste_equipes,
        "alertes": alertes,
    }
