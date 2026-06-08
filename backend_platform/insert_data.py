import psycopg2
from datetime import date, datetime

# Connexion base Render
conn = psycopg2.connect(
    "postgresql://sabc_db_user:y9OtILFSccodBh5i3OpqyqUc59W26DGx@dpg-d7fvhvbeo5us73b9o3c0-a.oregon-postgres.render.com/sabc_db"
)
cur = conn.cursor()

# ── DONNÉES RÉELLES ────────────────────────────────────────
# Production CH16 du 14/04 : 556661 bouteilles → /154 = ~3614 hl
# Production CH13 du 10/04 : 206703 → /77 (format 33cl) = ~2685 hl  
# Production CH15 du 10/04 : 452879 → /154 = ~2941 hl
# Production CH8  du 14/04 : 565563 → /154 = ~3672 hl
# Production CH14 du 03/04 : 497692 → /154 = ~3232 hl

# Eau laveuse rinçage (EAU AERO CHAINES) par chaîne - valeurs moyennes hebdo
eau_rincage = {
    "Chaîne 8":  {"6h-14h": 1050, "14h-22h": 1100, "22h-6h": 1000},
    "Chaîne 13": {"6h-14h": 33,   "14h-22h": 33,   "22h-6h": 33},
    "Chaîne 14": {"6h-14h": 10560,"14h-22h": 10570, "22h-6h": 10550},
    "Chaîne 15": {"6h-14h": 575,  "14h-22h": 580,  "22h-6h": 572},
    "Chaîne 16": {"6h-14h": 718,  "14h-22h": 718,  "22h-6h": 718},
}

# Eau bain laveuse (EAU CHLOREE LAVEUSE BOUTEILLES)
eau_bain = {
    "Chaîne 8":  {"6h-14h": 210, "14h-22h": 220, "22h-6h": 215},
    "Chaîne 13": {"6h-14h": 0,   "14h-22h": 0,   "22h-6h": 0},
    "Chaîne 14": {"6h-14h": 3460,"14h-22h": 3480, "22h-6h": 3450},
    "Chaîne 15": {"6h-14h": 22,  "14h-22h": 23,  "22h-6h": 22},
    "Chaîne 16": {"6h-14h": 100, "14h-22h": 102, "22h-6h": 101},
}

# Eau pasteurisateur
eau_pasteur = {
    "Chaîne 8":  {"6h-14h": 9700, "14h-22h": 9700, "22h-6h": 9700},
    "Chaîne 13": {"6h-14h": 306,  "14h-22h": 306,  "22h-6h": 305},
    "Chaîne 14": {"6h-14h": 39400,"14h-22h": 39400, "22h-6h": 39400},
    "Chaîne 15": {"6h-14h": 1534, "14h-22h": 1535, "22h-6h": 1533},
    "Chaîne 16": {"6h-14h": 4672, "14h-22h": 4672, "22h-6h": 4672},
}

# Eau appoint aéro (aero compresseurs)
eau_aero = {
    "Chaîne 8":  {"6h-14h": 1800, "14h-22h": 1795, "22h-6h": 1800},
    "Chaîne 13": {"6h-14h": 1800, "14h-22h": 1795, "22h-6h": 1800},
    "Chaîne 14": {"6h-14h": 1800, "14h-22h": 1795, "22h-6h": 1800},
    "Chaîne 15": {"6h-14h": 1800, "14h-22h": 1795, "22h-6h": 1800},
    "Chaîne 16": {"6h-14h": 1800, "14h-22h": 1795, "22h-6h": 1800},
}

# CO2 par chaîne (consommation journalière / 3 quarts)
co2_journalier = {
    "Chaîne 8":  0,       # pas de données
    "Chaîne 13": 4500,    # moyenne 07-10 avril
    "Chaîne 14": 0,       # pas de données
    "Chaîne 15": 430,     # moyenne 07-09 avril
    "Chaîne 16": 1900,    # moyenne 07-10 avril
}

# Production en hl par chaîne par quart
production = {
    "Chaîne 8":  {"6h-14h": 1200, "14h-22h": 1300, "22h-6h": 1172},
    "Chaîne 13": {"6h-14h": 900,  "14h-22h": 950,  "22h-6h": 835},
    "Chaîne 14": {"6h-14h": 1080, "14h-22h": 1100, "22h-6h": 1052},
    "Chaîne 15": {"6h-14h": 980,  "14h-22h": 1000, "22h-6h": 961},
    "Chaîne 16": {"6h-14h": 1200, "14h-22h": 1250, "22h-6h": 1164},
}

# Élec simulée (kWh) basée sur production
elec_base = {
    "Chaîne 8":  {"6h-14h": 2500, "14h-22h": 2000, "22h-6h": 2640},
    "Chaîne 13": {"6h-14h": 30, "14h-22h": 20, "22h-6h": 30},
    "Chaîne 14": {"6h-14h": 1400, "14h-22h": 1000, "22h-6h": 1540},
    "Chaîne 15": {"6h-14h": 1000, "14h-22h": 1000, "22h-6h": 1220},
    "Chaîne 16": {"6h-14h": 1400, "14h-22h": 1000, "22h-6h": 1580},
}

# ── INSERTION ─────────────────────────────────────────────
dates = [
    date(2026, 4, 14),  # Lundi
    date(2026, 4, 15),  # Mardi
    date(2026, 4, 16),  # Mercredi
    date(2026, 4, 17),  # Jeudi (jusqu'à 9h = quart 6h-14h)
]

quarts = ["6h-14h", "14h-22h", "22h-6h"]
chaines = ["Chaîne 8", "Chaîne 13", "Chaîne 14", "Chaîne 15", "Chaîne 16"]

count = 0
for d in dates:
    for chaine in chaines:
        # Jeudi 16 avril : seulement quart 6h-14h (jusqu'à 9h)
        quarts_jour = ["6h-14h"] if d == date(2026, 4, 16) else quarts
        
        for quart in quarts_jour:
            # Variation légère selon le jour (+/- 2%)
            variation = 1.0 + (d.day - 13) * 0.005
            
            heure = "06:00:00" if quart == "6h-14h" else "14:00:00" if quart == "14h-22h" else "22:00:00"
            
            co2_val = round(co2_journalier[chaine] / 3 * variation, 2)
            
            cur.execute("""
                INSERT INTO lean_energie (
                    date, heure, quart, atelier,
                    index_eau_rincage, index_eau_bain,
                    index_eau_pasteur, index_eau_aero,
                    index_elec, index_co2,
                    production_hl, saisi_par, created_at
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                d,
                heure,
                quart,
                chaine,
                round(eau_rincage[chaine][quart] * variation),
                round(eau_bain[chaine][quart] * variation),
                round(eau_pasteur[chaine][quart] * variation),
                round(eau_aero[chaine][quart] * variation),
                round(elec_base[chaine][quart] * variation),
                co2_val,
                round(production[chaine][quart] * variation),
                "manager",
                datetime.now()
            ))
            count += 1

conn.commit()
cur.close()
conn.close()
print(f"✅ {count} relevés insérés avec succès !")
