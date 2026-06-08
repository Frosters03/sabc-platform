"""
Script de simulation SABC Ndokoti — v2
Inclut : arrêts entretien hebdomadaires par chaîne
         anomalies de pannes non planifiées
         données calibrées sur relevés terrain
"""
import sys, os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

import random
import json
from datetime import date, timedelta
from core.database import SessionLocal
from models import LeanEnergie, Qualite

random.seed(42)
db = SessionLocal()

ATELIERS = ["Chaîne 8", "Chaîne 14", "Chaîne 15", "Chaîne 16"]
QUARTS   = ["6h-14h", "14h-22h", "22h-6h"]

# ════════════════════════════════════════════════════════════
# JOURS D'ENTRETIEN HEBDOMADAIRE PAR CHAÎNE
# Chaque chaîne a UN jour fixe d'arrêt par semaine
# Décalés pour ne pas arrêter l'usine entière le même jour
# weekday : 0=Lundi, 1=Mardi, 2=Mercredi, 3=Jeudi, 4=Vendredi
# ════════════════════════════════════════════════════════════
JOURS_ENTRETIEN = {
    "Chaîne 8":  0,   # Lundi
    "Chaîne 14": 1,   # Mardi
    "Chaîne 15": 2,   # Mercredi
    "Chaîne 16": 3,   # Jeudi
}

# ════════════════════════════════════════════════════════════
# BASELINES PAR ATELIER ET PAR QUART
# ════════════════════════════════════════════════════════════
production = {
    "Chaîne 8":  {"6h-14h": 1200, "14h-22h": 1300, "22h-6h": 1172},
    "Chaîne 14": {"6h-14h": 1080, "14h-22h": 1100, "22h-6h": 1052},
    "Chaîne 15": {"6h-14h":  980, "14h-22h": 1000, "22h-6h":  961},
    "Chaîne 16": {"6h-14h": 1200, "14h-22h": 1250, "22h-6h": 1164},
}

# Électricité estimée à 2.2 kWh/hl
elec = {
    atelier: {q: round(production[atelier][q] * 2.2, 0) for q in production[atelier]}
    for atelier in production
}

eau_rincage = {
    "Chaîne 8":  {"6h-14h": 1050, "14h-22h": 1100, "22h-6h": 1000},
    "Chaîne 14": {"6h-14h":  635, "14h-22h":  645, "22h-6h":  622},
    "Chaîne 15": {"6h-14h":  575, "14h-22h":  580, "22h-6h":  572},
    "Chaîne 16": {"6h-14h":  718, "14h-22h":  718, "22h-6h":  718},
}

eau_bain = {
    "Chaîne 8":  {"6h-14h": 210, "14h-22h": 220, "22h-6h": 215},
    "Chaîne 14": {"6h-14h": 236, "14h-22h": 240, "22h-6h": 232},
    "Chaîne 15": {"6h-14h":  22, "14h-22h":  23, "22h-6h":  22},
    "Chaîne 16": {"6h-14h": 100, "14h-22h": 102, "22h-6h": 101},
}

eau_pasteur = {
    "Chaîne 8":  {"6h-14h": 9700, "14h-22h": 9700, "22h-6h": 9700},
    "Chaîne 14": {"6h-14h": 8730, "14h-22h": 8730, "22h-6h": 8730},
    "Chaîne 15": {"6h-14h": 1534, "14h-22h": 1535, "22h-6h": 1533},
    "Chaîne 16": {"6h-14h": 4672, "14h-22h": 4672, "22h-6h": 4672},
}

eau_aero = {
    "Chaîne 8":  {"6h-14h": 487, "14h-22h": 487, "22h-6h": 487},
    "Chaîne 14": {"6h-14h": 432, "14h-22h": 432, "22h-6h": 432},
    "Chaîne 15": {"6h-14h": 396, "14h-22h": 396, "22h-6h": 396},
    "Chaîne 16": {"6h-14h": 485, "14h-22h": 485, "22h-6h": 485},
}

co2 = {
    "Chaîne 8":  {"6h-14h": 180, "14h-22h": 195, "22h-6h": 176},
    "Chaîne 14": {"6h-14h": 158, "14h-22h": 161, "22h-6h": 154},
    "Chaîne 15": {"6h-14h": 141, "14h-22h": 144, "22h-6h": 138},
    "Chaîne 16": {"6h-14h": 620, "14h-22h": 646, "22h-6h": 601},
}

qualite_base = {
    "Chaîne 8":  {"brix": 10.8, "co2q": 5.2, "bo2": 0.06},
    "Chaîne 14": {"brix": 11.0, "co2q": 5.3, "bo2": 0.05},
    "Chaîne 15": {"brix": 11.2, "co2q": 5.5, "bo2": 0.05},
    "Chaîne 16": {"brix": 11.0, "co2q": 5.2, "bo2": 0.06},
}

OBJECTIF_JOUR = {
    "Chaîne 8":  3675,
    "Chaîne 14": 3232,
    "Chaîne 15": 2941,
    "Chaîne 16": 3614,
}

# ════════════════════════════════════════════════════════════
# ANOMALIES NON PLANIFIÉES (pannes imprévues)
# Ces jours NE SONT PAS des jours d'entretien
# ════════════════════════════════════════════════════════════
ANOMALIES = [
    (5,  "Chaîne 15", "elec_spike"),
    (12, "Chaîne 8",  "pasteur_leak"),
    (18, "Chaîne 14", "production_drop"),
    (25, "Chaîne 16", "brix_drift"),
    (31, "Chaîne 15", "multi"),
    (38, "Chaîne 8",  "elec_spike"),
    (45, "Chaîne 14", "bain_leak"),
    (52, "Chaîne 16", "production_drop"),
    (58, "Chaîne 15", "pasteur_leak"),
    (65, "Chaîne 8",  "multi"),
    (72, "Chaîne 14", "elec_spike"),
    (79, "Chaîne 16", "brix_drift"),
    (85, "Chaîne 15", "bain_leak"),
]
anomalies_set = {(o, a): t for o, a, t in ANOMALIES}

# ════════════════════════════════════════════════════════════
# FONCTIONS UTILITAIRES
# ════════════════════════════════════════════════════════════
def bruit(valeur, pct=0.06):
    return round(valeur * (1 + random.uniform(-pct, pct)), 2)

def appliquer_anomalie(vals, type_anomalie):
    v = vals.copy()
    if type_anomalie == "elec_spike":
        v["elec"]    *= random.uniform(1.35, 1.55)
        v["prod"]    *= random.uniform(0.80, 0.92)
    elif type_anomalie == "pasteur_leak":
        v["pasteur"] *= random.uniform(1.40, 1.70)
        v["elec"]    *= random.uniform(1.10, 1.20)
    elif type_anomalie == "bain_leak":
        v["bain"]    *= random.uniform(1.45, 1.75)
        v["rincage"] *= random.uniform(1.15, 1.25)
    elif type_anomalie == "production_drop":
        v["prod"]    *= random.uniform(0.45, 0.65)
        v["elec"]    *= random.uniform(0.88, 0.95)
        v["co2"]     *= random.uniform(0.50, 0.70)
    elif type_anomalie == "brix_drift":
        v["brix"]    += random.uniform(0.8, 1.4)
        v["co2q"]    += random.uniform(0.6, 1.1)
    elif type_anomalie == "multi":
        v["elec"]    *= random.uniform(1.30, 1.50)
        v["pasteur"] *= random.uniform(1.35, 1.60)
        v["prod"]    *= random.uniform(0.55, 0.72)
        v["brix"]    += random.uniform(0.5, 1.0)
    return v

def generer_sertissage(atelier, anomalie=False):
    n = {"Chaîne 15": 24, "Chaîne 16": 24,
         "Chaîne 8": 20, "Chaîne 14": 16}.get(atelier, 20)
    cases = [round(random.uniform(1.10, 1.15), 2) for _ in range(n)]
    if anomalie:
        for i in random.sample(range(n), random.randint(2, 5)):
            cases[i] = round(random.choice([
                random.uniform(1.05, 1.09),
                random.uniform(1.16, 1.22),
            ]), 2)
    return json.dumps(cases)

# ════════════════════════════════════════════════════════════
# GÉNÉRATION
# ════════════════════════════════════════════════════════════
date_debut = date.today() - timedelta(days=90)
count_e = count_q = count_entretien = 0

print("Génération des données de simulation SABC Ndokoti v2...")

for day_offset in range(90):
    jour = date_debut + timedelta(days=day_offset)
    facteur_dimanche = 0.85 if jour.weekday() == 6 else 1.0

    for atelier in ATELIERS:

        # ── CAS 1 : JOUR D'ENTRETIEN ──────────────────────
        # Production à zéro, consommations minimales
        # Marqué arret_planifie=True → EXCLU du training IA
        if jour.weekday() == JOURS_ENTRETIEN[atelier]:
            for quart in QUARTS:
                heure_debut = quart.split("-")[0]
                db.add(LeanEnergie(
                    date              = jour,
                    heure             = heure_debut,
                    quart             = quart,
                    atelier           = atelier,
                    index_elec        = bruit(elec[atelier][quart] * 0.12),  # 12% = éclairage seul
                    index_eau_rincage = 0.0,
                    index_eau_bain    = bruit(eau_bain[atelier][quart] * 0.30),  # nettoyage laveuse
                    index_eau_pasteur = 0.0,
                    index_eau_aero    = bruit(eau_aero[atelier][quart] * 0.15),
                    index_co2         = 0.0,
                    production_hl     = 0.0,
                    arret_planifie    = True,   # ← FLAG CRUCIAL pour le ML
                    saisi_par         = "simulation",
                ))
                count_entretien += 1
            # Pas de relevé qualité les jours d'entretien
            continue

        # ── CAS 2 : JOUR DE PRODUCTION NORMAL ─────────────
        atype = anomalies_set.get((day_offset, atelier))

        for quart in QUARTS:
            heure_debut = quart.split("-")[0]
            fq = 0.93 if quart == "22h-6h" else (1.02 if quart == "14h-22h" else 1.0)

            vals = {
                "elec":    elec[atelier][quart],
                "rincage": eau_rincage[atelier][quart],
                "bain":    eau_bain[atelier][quart],
                "pasteur": eau_pasteur[atelier][quart],
                "aero":    eau_aero[atelier][quart],
                "co2":     co2[atelier][quart],
                "prod":    production[atelier][quart],
                "brix":    qualite_base[atelier]["brix"],
                "co2q":    qualite_base[atelier]["co2q"],
                "bo2":     qualite_base[atelier]["bo2"],
            }

            if atype:
                vals = appliquer_anomalie(vals, atype)

            db.add(LeanEnergie(
                date              = jour,
                heure             = heure_debut,
                quart             = quart,
                atelier           = atelier,
                index_elec        = bruit(vals["elec"]    * fq * facteur_dimanche),
                index_eau_rincage = bruit(vals["rincage"] * fq * facteur_dimanche),
                index_eau_bain    = bruit(vals["bain"]    * fq * facteur_dimanche),
                index_eau_pasteur = bruit(vals["pasteur"] * fq),
                index_eau_aero    = bruit(vals["aero"]    * fq),
                index_co2         = bruit(vals["co2"]     * fq * facteur_dimanche),
                production_hl     = bruit(vals["prod"]    * fq * facteur_dimanche, pct=0.08),
                arret_planifie    = False,
                saisi_par         = "simulation",
            ))
            count_e += 1

            db.add(Qualite(
                date            = jour,
                heure           = heure_debut,
                quart           = quart,
                atelier         = atelier,
                brix            = round(bruit(vals["brix"], pct=0.02), 2),
                co2_qualite     = round(bruit(vals["co2q"], pct=0.04), 2),
                bo2             = round(bruit(vals["bo2"],  pct=0.08), 4),
                sertissage_data = generer_sertissage(atelier, anomalie=bool(atype)),
                saisi_par       = "simulation",
            ))
            count_q += 1

db.commit()
db.close()

print(f"✓ {count_e} relevés énergie (jours production)")
print(f"✓ {count_q} relevés qualité")
print(f"✓ {count_entretien} relevés entretien (arret_planifie=True)")
print(f"\nJours d'entretien par chaîne :")
jours_noms = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"]
for a, j in JOURS_ENTRETIEN.items():
    print(f"  {a} → {jours_noms[j]}")
print(f"\nAnomalies injectées : {len(ANOMALIES)} événements")
print("Ces anomalies sont sur des jours de PRODUCTION (pas d'entretien)")
print("→ L'Isolation Forest doit les retrouver automatiquement")