"""
Analyse des heures supplémentaires (module RH).

Règle :
  heures supp d'une semaine = max(0, heures N + heures F de la semaine − 40)
  plafond : 8 h supp maximum par personne et par semaine (consigne de la direction).
Une semaine est rattachée au mois qui contient son jeudi (convention ISO).
Niveaux : ok < 80 % du plafond ; attention de 80 % jusqu'au plafond inclus ; depasse au-delà du plafond.
"""
from calendar import monthrange
from datetime import date, timedelta

QUOTA_DEFAUT = 8.0         # plafond hebdomadaire (h supp / semaine)
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
    if pct > 1.0 + 1e-9:
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

    # Semaine de référence pour « reste » et prévision : la semaine en cours si on analyse le mois courant,
    # sinon la dernière semaine du mois.
    lundi_ref = _lundi(jour_ref)
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
            detail.append({"semaine": lundi.isoformat(), "heures": round(total, 1), "hs": round(hs_sem, 1),
                           "depasse": hs_sem > quota + 1e-9})
        pire = max((d["hs"] for d in detail), default=0.0)
        nb_sem_depassees = sum(1 for d in detail if d["depasse"])
        pct = pire / quota if quota > 0 else 0.0
        # semaine de référence
        sem_ref = next((d for d in detail if d["semaine"] == lundi_ref.isoformat()), detail[-1] if detail else None)
        hs_ref = sem_ref["hs"] if sem_ref else 0.0
        prevision = None
        if mois_courant and sem_ref and sem_ref["semaine"] == lundi_ref.isoformat() and 0 < hs_ref < quota:
            jours_sem = max(1, (min(aujourdhui, lundi_ref + timedelta(days=6)) - lundi_ref).days + 1)
            rythme = hs_ref / jours_sem
            fin_projetee = rythme * 6          # semaine de 6 jours travaillés
            if fin_projetee > quota:
                jours_pour_plafond = quota / rythme
                date_plafond = lundi_ref + timedelta(days=max(0, int(jours_pour_plafond) - 1))
                prevision = {"atteint_le": min(date_plafond, lundi_ref + timedelta(days=6)).isoformat(),
                             "fin_de_semaine": round(fin_projetee, 1)}
            else:
                prevision = {"atteint_le": None, "fin_de_semaine": round(fin_projetee, 1)}
        resultat.append({
            "membre_id": m["membre_id"], "nom_prenom": m["nom_prenom"], "fonction": m["fonction"],
            "equipe": m["equipe"], "equipe_id": m["equipe_id"], "chaine": m["chaine"],
            "statut": (membres_actifs or {}).get(m["membre_id"]),
            "hs_mois": round(hs, 1), "quota": quota, "pire_semaine": round(pire, 1),
            "nb_semaines_depassees": nb_sem_depassees,
            "pct": round(pct * 100, 1),
            "reste": round(max(0.0, quota - hs_ref), 1), "niveau": niveau(pct),
            "prevision": prevision, "semaines": detail,
        })

    resultat.sort(key=lambda r: (-r["pire_semaine"], -r["hs_mois"], r["nom_prenom"]))

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
            marge = sorted([x for x in e["membres"] if x["niveau"] == "ok"], key=lambda x: (x["pire_semaine"], x["hs_mois"]))
            e["suggestion"] = [
                {"nom_prenom": x["nom_prenom"], "fonction": x["fonction"], "hs_mois": x["hs_mois"], "reste": x["reste"]}
                for x in marge[:3]
            ]
        else:
            e["suggestion"] = []
        liste_equipes.append(e)
    liste_equipes.sort(key=lambda e: (-e["nb_depasse"], -e["nb_attention"], e["equipe"] or ""))

    def _fmt(iso):
        d = date.fromisoformat(iso)
        return d.strftime("%d/%m")

    alertes = []
    for r in resultat:
        if r["niveau"] == "depasse":
            sems = ", ".join(f"sem. du {_fmt(d['semaine'])} : {d['hs']:g} h" for d in r["semaines"] if d["depasse"])
            alertes.append({"gravite": "critique", "membre_id": r["membre_id"],
                            "message": f"{r['nom_prenom']} ({r['equipe']}) a dépassé le plafond de {quota:g} h/semaine ({sems})."})
        elif r["niveau"] == "attention":
            alertes.append({"gravite": "attention", "membre_id": r["membre_id"],
                            "message": f"{r['nom_prenom']} ({r['equipe']}) est proche du plafond hebdomadaire : {r['pire_semaine']:g} h / {quota:g} h sur sa pire semaine."})
        elif r["prevision"] and r["prevision"]["atteint_le"]:
            alertes.append({"gravite": "prevision", "membre_id": r["membre_id"],
                            "message": f"À ce rythme, {r['nom_prenom']} ({r['equipe']}) atteindra le plafond de {quota:g} h cette semaine, vers le {r['prevision']['atteint_le']}."})

    return {
        "annee": annee, "mois": mois, "quota": quota, "plafond_semaine": quota,
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
