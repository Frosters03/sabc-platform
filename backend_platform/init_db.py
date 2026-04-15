import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))

from core.database import SessionLocal, create_tables
from core.security import hash_password
from models.utilisateur import Utilisateur
from models.lean_energie import LeanEnergie
from models.qualite import Qualite
from datetime import date, datetime
import json

def init():
    print("Création des tables...")
    create_tables()

    db = SessionLocal()

    try:
        # ── UTILISATEURS ──────────────────────────────────
        users = [
            {"username": "manager",       "password": "sabc2026",  "role": "manager"},
            {"username": "GUY", "password": "sabcndo26", "role": "chef_atelier"},
            {"username": "contremaitre1", "password": "sabc1234",  "role": "contremaitre"},
        ]

        for u in users:
            exists = db.query(Utilisateur).filter(
                Utilisateur.username == u["username"]
            ).first()
            if not exists:
                user = Utilisateur(
                    username=u["username"],
                    password=hash_password(u["password"]),
                    role=u["role"],
                    actif=True
                )
                db.add(user)
                print(f"  ✅ Utilisateur créé : {u['username']} ({u['role']})")
            else:
                print(f"  ⚠️  Existe déjà : {u['username']}")

        db.commit()

        # ── RELEVÉS LEAN ÉNERGIE ──────────────────────────
        # Logique : index croissant de quart en quart
        # Chaîne 8 — 3 jours complets (9 relevés = 3 quarts x 3 jours)
        releves_energie = [

        # ── JOUR 1 — 01/03/2026 ───────────────────────────────
        # Quart 22h-6h (fin à 06h) — normal
            {
                "date": date(2026, 3, 1), "heure": "06:05",
                "quart": "22h-6h", "atelier": "Chaîne 8",
                "index_eau_rincage": 14_820.0, "index_eau_bain": 7_640.0,
                "index_eau_pasteur": 2_405.0,  "index_eau_aero": 601.0,
                "index_elec": 241_000.0,       "index_co2": 18_050.0,
                "production_hl": 1_020.0, "saisi_par": "operateur1"
            },
        # Quart 6h-14h (fin à 14h) — normal
           {
                "date": date(2026, 3, 1), "heure": "14:08",
                "quart": "6h-14h", "atelier": "Chaîne 8",
                "index_eau_rincage": 14_846.0, "index_eau_bain": 7_664.0,
                "index_eau_pasteur": 2_417.0,  "index_eau_aero": 613.0,
                "index_elec": 249_100.0,       "index_co2": 19_560.0,
                "production_hl": 990.0, "saisi_par": "operateur1"
            },
            # Quart 14h-22h (fin à 22h) — normal
            {
                "date": date(2026, 3, 1), "heure": "22:03",
                "quart": "14h-22h", "atelier": "Chaîne 8",
                "index_eau_rincage": 14_872.0, "index_eau_bain": 7_688.0,
                "index_eau_pasteur": 2_429.0,  "index_eau_aero": 625.0,
                "index_elec": 257_100.0,       "index_co2": 21_060.0,
                "production_hl": 1_010.0, "saisi_par": "operateur2"
            },

            # ── JOUR 2 — 02/03/2026 ───────────────────────────────
            # Quart 22h-6h — normal
            {
                "date": date(2026, 3, 2), "heure": "06:10",
                "quart": "22h-6h", "atelier": "Chaîne 8",
                "index_eau_rincage": 14_898.0, "index_eau_bain": 7_712.0,
                "index_eau_pasteur": 2_441.0,  "index_eau_aero": 637.0,
                "index_elec": 265_200.0,       "index_co2": 22_570.0,
                "production_hl": 1_005.0, "saisi_par": "operateur1"
            },
            # Quart 6h-14h — normal
            {
                "date": date(2026, 3, 2), "heure": "14:02",
                "quart": "6h-14h", "atelier": "Chaîne 8",
                "index_eau_rincage": 14_924.0, "index_eau_bain": 7_736.0,
                "index_eau_pasteur": 2_453.0,  "index_eau_aero": 649.0,
                "index_elec": 273_200.0,       "index_co2": 24_070.0,
                "production_hl": 1_015.0, "saisi_par": "operateur1"
            },
            # Quart 14h-22h — début anomalie (conso eau commence à monter)
            {
                "date": date(2026, 3, 2), "heure": "22:07",
                "quart": "14h-22h", "atelier": "Chaîne 8",
                "index_eau_rincage": 14_958.0, "index_eau_bain": 7_768.0,
                "index_eau_pasteur": 2_465.0,  "index_eau_aero": 661.0,
                "index_elec": 281_300.0,       "index_co2": 25_585.0,
                "production_hl": 995.0, "saisi_par": "operateur2"
            },

            # ── JOUR 3 — 03/03/2026 ───────────────────────────────
            # Quart 22h-6h — anomalie qui s'accentue
            {
                "date": date(2026, 3, 3), "heure": "06:12",
                "quart": "22h-6h", "atelier": "Chaîne 8",
                "index_eau_rincage": 14_998.0, "index_eau_bain": 7_806.0,
                "index_eau_pasteur": 2_477.0,  "index_eau_aero": 673.0,
                "index_elec": 289_400.0,       "index_co2": 27_085.0,
                "production_hl": 980.0, "saisi_par": "operateur1"
            },
            # Quart 6h-14h — anomalie critique (ratio laveuse > 0.6 L/bte → alerte rouge)
            {
                "date": date(2026, 3, 3), "heure": "14:05",
                "quart": "6h-14h", "atelier": "Chaîne 8",
                "index_eau_rincage": 15_052.0, "index_eau_bain": 7_858.0,
                "index_eau_pasteur": 2_489.0,  "index_eau_aero": 685.0,
                "index_elec": 297_600.0,       "index_co2": 28_600.0,
                "production_hl": 950.0, "saisi_par": "operateur1"
            },
            # Quart 14h-22h — retour à la normale (après intervention)
            {
                "date": date(2026, 3, 3), "heure": "22:09",
                "quart": "14h-22h", "atelier": "Chaîne 8",
                "index_eau_rincage": 15_078.0, "index_eau_bain": 7_882.0,
                "index_eau_pasteur": 2_501.0,  "index_eau_aero": 697.0,
                "index_elec": 305_600.0,       "index_co2": 30_100.0,
                "production_hl": 1_000.0, "saisi_par": "operateur2"
            },
        ]

        for r in releves_energie:
            releve = LeanEnergie(**r)
            db.add(releve)

        print(f"  ✅ {len(releves_energie)} relevés Lean Énergie créés (Chaîne 8 — 3 jours)")

        # ── RELEVÉS QUALITÉ ───────────────────────────────
        # Chaîne 8 → 20 cases de sertissage
        sert_normal  = json.dumps([1.12, 1.15, 1.10, 1.13, 1.11,
                                   1.14, 1.09, 1.12, 1.15, 1.11,
                                   1.10, 1.13, 1.14, 1.12, 1.11,
                                   1.10, 1.15, 1.13, 1.12, 1.11])

        sert_anomalie = json.dumps([1.12, 1.15, 1.10, 1.13, 1.11,
                                    1.14, 1.09, 1.18, 1.15, 1.11,
                                    1.10, 1.19, 1.14, 1.12, 1.11,
                                    1.10, 1.15, 1.20, 1.12, 1.11])

        releves_qualite = [
            # Jour 1 — normal
            {
                "date": date(2026, 3, 1), "heure": "07:00",
                "quart": "6h-14h", "atelier": "Chaîne 8",
                "sertissage_data": sert_normal,
                "brix": 10.8, "co2_qualite": 5.2, "bo2": 0.05,
                "saisi_par": "operateur1"
            },
            # Jour 2 — normal
            {
                "date": date(2026, 3, 2), "heure": "07:10",
                "quart": "6h-14h", "atelier": "Chaîne 8",
                "sertissage_data": sert_normal,
                "brix": 10.9, "co2_qualite": 5.3, "bo2": 0.06,
                "saisi_par": "operateur1"
            },
            # Jour 3 — anomalie Brix + BO2
            {
                "date": date(2026, 3, 3), "heure": "07:05",
                "quart": "6h-14h", "atelier": "Chaîne 8",
                "sertissage_data": sert_anomalie,
                "brix": 11.4, "co2_qualite": 5.1, "bo2": 0.32,
                "saisi_par": "operateur1"
            },
        ]

        for r in releves_qualite:
            releve = Qualite(**r)
            db.add(releve)

        print(f"  ✅ {len(releves_qualite)} relevés Qualité créés")

        db.commit()

        print("\n Base de données initialisée avec succès !")
        print("\nComptes disponibles (mot de passe : plusieurs) :")
        print("  admin       → accès total")
        print("  Relou       → accès total")
        print("  directeur1  → dashboard + analyses")
        print("  chef_Guy     → saisie + analyses")
        print("  operateur1  → saisie uniquement")
        print("  operateur2  → saisie uniquement")

    except Exception as e:
        print(f"❌ Erreur : {e}")
        import traceback
        traceback.print_exc()
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    init()