#!/usr/bin/env python3
"""
╔══════════════════════════════════════════════════════════════════╗
║  SABC Ndokoti — Script de simulation (VERSION FINALE CORRIGÉE)  ║
║  Période  : 14 mai 2026 → 14 juillet 2026                       ║
║  Chaînes  : 8=4000 · 13=1200 · 14=3500 · 15=3500 · 16=3000 hl  ║
╠══════════════════════════════════════════════════════════════════╣
║  RATIOS CIBLES (zone verte confirmée) :                          ║
║  rLav   = (ba+ri)*3*1000/(obj*100/65cl)  → 0.15  [seuil 0.30]  ║
║  rPasto = (pa+ae)*3/24                   → 0.80  [seuil 1.50]  ║
║  rElec  = el*3/obj                       → 0.60  [seuil 2.00]  ║
║  rCo2   = co*3/obj                       → 0.040 [seuil 0.30]  ║
╚══════════════════════════════════════════════════════════════════╝
"""

import os, sys, json, random
import numpy as np
from datetime import date, timedelta
from psycopg2.extras import execute_values
import psycopg2

random.seed(42)
np.random.seed(42)

DATABASE_URL = os.environ.get(
    'DATABASE_URL',
    'postgresql://postgres:#Frosty2503@localhost:5432/sabc_packaging'
)

DATE_DEBUT = date(2026, 4, 23)
DATE_FIN   = date(2026, 7, 23)

# ══════════════════════════════════════════════════════════════════
# PARAMÈTRES CHAÎNES — Valeurs de base calculées analytiquement
# ══════════════════════════════════════════════════════════════════
#
#  Ch.8  : nb_bte/j = 4000*100/0.65 = 615 385
#          rLav  = (10+21)*3*1000/615385 = 0.151 L/bte  ✓ VERT
#          rPasto= (5.0+1.4)*3/24       = 0.800 m³/h   ✓ VERT
#          rElec = 800*3/4000           = 0.600 kWh/hl  ✓ VERT
#          rCo2  = 53*3/4000            = 0.040 kg/hl   ✓ VERT
#
#  Ch.14 : nb_bte/j = 3500*100/0.65 = 538 462
#          rLav  = (9+18)*3*1000/538462 = 0.150 L/bte  ✓ VERT
#          rPasto= (5.0+1.4)*3/24       = 0.800 m³/h   ✓ VERT
#          rElec = 700*3/3500           = 0.600 kWh/hl  ✓ VERT
#          rCo2  = 47*3/3500            = 0.040 kg/hl   ✓ VERT
#
#  Ch.16 : nb_bte/j = 3000*100/0.65 = 461 538
#          rLav  = (8+15)*3*1000/461538 = 0.149 L/bte  ✓ VERT
#          rPasto= (4.7+1.3)*3/24       = 0.750 m³/h   ✓ VERT
#          rElec = 600*3/3000           = 0.600 kWh/hl  ✓ VERT
#          rCo2  = 40*3/3000            = 0.040 kg/hl   ✓ VERT

CHAINES = {
    'Chaîne 8':  {
        'obj': 4000, 'laveuse': True,  'format_cl': 65, 'entretien': 0,
        'base': {'ri':21,  'ba':10, 'pa':5.0, 'ae':1.4, 'el':800, 'co':53},
        'idx0': {'ri':12500,'ba':4200,'pa':6800,'ae':1800,'el':185000,'co':8500},
    },
    'Chaine 13': {
        'obj': 1200, 'laveuse': False, 'format_cl': 50, 'entretien': 2,
        'base': {'ri':0,   'ba':0,  'pa':4.5, 'ae':1.1, 'el':240, 'co':16},
        'idx0': {'ri':0,   'ba':0,  'pa':2200,'ae':650, 'el':48000, 'co':2800},
    },
    'Chaîne 14': {
        'obj': 3500, 'laveuse': True,  'format_cl': 65, 'entretien': 1,
        'base': {'ri':18,  'ba':9,  'pa':5.0, 'ae':1.4, 'el':700, 'co':47},
        'idx0': {'ri':10800,'ba':3600,'pa':5900,'ae':1550,'el':162000,'co':7400},
    },
    'Chaîne 15': {
        'obj': 3500, 'laveuse': True,  'format_cl': 65, 'entretien': 3,
        'base': {'ri':18,  'ba':9,  'pa':5.0, 'ae':1.4, 'el':700, 'co':47},
        'idx0': {'ri':10200,'ba':3400,'pa':5600,'ae':1480,'el':155000,'co':7100},
    },
    'Chaîne 16': {
        'obj': 3000, 'laveuse': True,  'format_cl': 65, 'entretien': 4,
        'base': {'ri':15,  'ba':8,  'pa':4.7, 'ae':1.3, 'el':600, 'co':40},
        'idx0': {'ri':8800, 'ba':2950,'pa':4800,'ae':1280,'el':133000,'co':6100},
    },
}

QUARTS         = [('22h-6h','22:00'), ('6h-14h','06:00'), ('14h-22h','14:00')]
QUARTS_QUALITE = [('6h-14h','08:00'), ('14h-22h','16:00'), ('22h-6h','23:00')]

# 10 anomalies sur 61 jours ≈ 8% (calibré sur contamination=0.08 Isolation Forest)
ANOMALIES = {
    (date(2026, 5,20), 'Chaine 13'):  'chute_prod',
    (date(2026, 5,22), 'Chaîne 8'):   'surconso_elec',
    (date(2026, 5,28), 'Chaîne 14'):  'fuite_pasteur',
    (date(2026, 6, 5), 'Chaîne 16'):  'chute_prod',
    (date(2026, 6,12), 'Chaîne 8'):   'fuite_bain',
    (date(2026, 6,18), 'Chaîne 15'):  'usure_sertissage',
    (date(2026, 6,24), 'Chaîne 14'):  'surconso_elec',
    (date(2026, 6,30), 'Chaîne 15'):  'surconso_elec',
    (date(2026, 7, 2), 'Chaîne 16'):  'fuite_pasteur',
    (date(2026, 7, 8), 'Chaîne 8'):   'chute_prod',
    (date(2026, 4,29), 'Chaîne 14'):  'usure_sertissage',  
    (date(2026, 5, 5), 'Chaîne 16'):  'surconso_elec',     
    (date(2026, 5,10), 'Chaîne 8'):   'fuite_pasteur',     
    (date(2026, 7,16), 'Chaine 13'):  'chute_prod',        
    (date(2026, 7,20), 'Chaîne 14'):  'fuite_bain',
}

# ── Produits pour qualite_a (tous les 10, paramètres spécifiques) ──
SPECS_BIERES = {
    'Castle Milk Stout': {'d':14.40,'td':0.25,'c':4.90,'tc':0.20},
    '33 Export':         {'d':11.85,'td':0.15,'c':5.50,'tc':0.20},
    'Castel Beer':       {'d':12.00,'td':0.20,'c':6.00,'tc':0.20},
    'Mutzig':            {'d':12.20,'td':0.20,'c':5.30,'tc':0.20},
    'IsenBock':          {'d':11.40,'td':0.20,'c':5.90,'tc':0.20},
    'Beaufort Light':    {'d': 9.70,'td':0.20,'c':5.50,'tc':0.20},
    'Beaufort Lager':    {'d':11.00,'td':0.20,'c':5.80,'tc':0.20},
    'Manyan':            {'d':11.60,'td':0.20,'c':6.00,'tc':0.20},
    'Doppel Munich':     {'d':13.40,'td':0.20,'c':6.00,'tc':0.20},
    'Chill Citron':      {'d':10.40,'td':0.30,'c':5.50,'tc':0.20},
}

# Pour la table qualite.brix → seuils QUALITE : warning 11.0–13.0, critique 10.0–14.0
# Seuls les produits avec densité dans 11.0–13.0 → graphes verts
PRODUITS_BRIX_VERT = ['33 Export','Castel Beer','Mutzig','IsenBock','Beaufort Lager','Manyan']
SPECS_BRIX_VERT    = {k: SPECS_BIERES[k] for k in PRODUITS_BRIX_VERT}

PRODUITS_BRSA = ['Top Grenadine','Top Ananas','Top Pamplemousse','Top Orange','Djino','XXL']
PRODUITS_AM   = ['Booster Cola','Booster Gin Tonic']


# ══════════════════════════════════════════════════════════════════
def log(msg): print(msg, flush=True)

def vider_tables(cur):
    tables = [
        'previsions_energie','scores_sante','resultats_anomalies',
        'oee_journalier','qualite_a','qualite','lean_energie','alertes',
    ]
    for t in tables:
        try:
            cur.execute(f"DELETE FROM {t}")
            log(f"   🗑️  {t}")
        except Exception as e:
            log(f"   ⚠️  {t} ignorée ({e})")
    log("✅ Tables vidées\n")


# ══════════════════════════════════════════════════════════════════
# ÉTAPE 1 — RELEVÉS ÉNERGIE (lean_energie)
# ══════════════════════════════════════════════════════════════════
def generer_energie(cur):
    rows = []
    idx  = {ch: dict(CHAINES[ch]['idx0']) for ch in CHAINES}

    d = DATE_DEBUT
    while d <= DATE_FIN:
        for atelier, cfg in CHAINES.items():
            est_entretien = (d.weekday() == cfg['entretien'])
            anomalie      = ANOMALIES.get((d, atelier))

            for quart, heure in QUARTS:
                b = cfg['base']

                if est_entretien:
                    # Jour entretien : machines en veille, production nulle
                    prod = 0.0
                    idx[atelier]['el'] += random.uniform(25, 50)
                    idx[atelier]['pa'] += random.uniform(0.2, 0.5)
                    idx[atelier]['ae'] += random.uniform(0.1, 0.3)
                    idx[atelier]['co'] += random.uniform(0.0, 0.2)
                else:
                    # Production ~1/3 objectif ± 8%
                    prod = cfg['obj'] / 3 * random.uniform(0.90, 1.08)
                    # Variation normale ± 8%
                    f = {k: random.uniform(0.92, 1.08) for k in b}

                    # ── Anomalies : facteurs calculés pour dépasser les seuils ──
                    if anomalie == 'surconso_elec':
                        # rElec_anomalie = 0.60 × 3.8 = 2.28 > warning(2.00) ✓
                        f['el'] = random.uniform(3.6, 4.0)
                        f['co'] = random.uniform(1.8, 2.2)

                    elif anomalie == 'fuite_pasteur':
                        # rPasto_anomalie = (pa×3.2+ae)*3/24 = (16+1.4)*3/24 = 2.18 > critique(2.00) ✓
                        f['pa'] = random.uniform(3.0, 3.5)

                    elif anomalie == 'fuite_bain' and cfg['laveuse']:
                        # rLav_anomalie = (ba×4+ri×2.5)*3*1000/nb_bte
                        # Ch.8 : (40+52.5)*3*1000/615385 = 0.451 > warning(0.30) ✓
                        f['ba'] = random.uniform(3.8, 4.2)
                        f['ri'] = random.uniform(2.3, 2.7)

                    elif anomalie == 'chute_prod':
                        # Production réduite de 50% → TRG divisé par 2
                        prod *= random.uniform(0.45, 0.55)

                    # usure_sertissage → géré dans qualite/qualite_a

                    # Accumulation des index
                    for k in b:
                        if k in ('ri', 'ba') and not cfg['laveuse']:
                            continue  # Ch.13 : pas de laveuse
                        idx[atelier][k] += max(0.0, b[k] * f[k])

                rows.append((
                    d, heure, quart, atelier,
                    round(idx[atelier]['ri'], 2),
                    round(idx[atelier]['ba'], 2),
                    round(idx[atelier]['pa'], 2),
                    round(idx[atelier]['ae'], 2),
                    round(idx[atelier]['el'], 1),
                    round(idx[atelier]['co'], 1),
                    round(prod, 1),
                    False,
                    'simulation'
                ))
        d += timedelta(days=1)

    execute_values(cur, """
        INSERT INTO lean_energie
        (date,heure,quart,atelier,
         index_eau_rincage,index_eau_bain,index_eau_pasteur,
         index_eau_aero,index_elec,index_co2,
         production_hl,arret_planifie,saisi_par)
        VALUES %s
    """, rows)
    log(f"✅ lean_energie       : {len(rows)} relevés")
    # Vérification analytique
    b8  = CHAINES['Chaîne 8']['base']
    obj8 = 4000
    nb8  = obj8*100/0.65
    log(f"   Vérif Ch.8 → rLav={((b8['ba']+b8['ri'])*3*1000/nb8):.3f} "
        f"rPasto={(b8['pa']+b8['ae'])*3/24:.2f} "
        f"rElec={b8['el']*3/obj8:.2f} rCo2={b8['co']*3/obj8:.3f}")


# ══════════════════════════════════════════════════════════════════
# ÉTAPE 2 — QUALITÉ BIÈRE SPÉCIALISÉE (qualite_a)
# Paramètres : densité, saturation CO₂, O₂, sertissage 24 cases
# ══════════════════════════════════════════════════════════════════
def generer_qualite_a(cur):
    rows = []
    chaines_biere = ['Chaîne 8','Chaîne 14','Chaîne 15','Chaîne 16']

    d = DATE_DEBUT
    while d <= DATE_FIN:
        for atelier in chaines_biere:
            if d.weekday() == CHAINES[atelier]['entretien']:
                continue
            anomalie = ANOMALIES.get((d, atelier))
            produit  = random.choice(list(SPECS_BIERES.keys()))
            sp       = SPECS_BIERES[produit]

            for quart, heure in QUARTS_QUALITE:
                # ── Densité et saturation conformes à ~92% ──────────
                den   = round(sp['d'] + random.gauss(0, sp['td']*0.30), 3)
                co2s  = round(sp['c'] + random.gauss(0, sp['tc']*0.30), 3)
                den_e = round(den  - sp['d'], 3)
                co2_e = round(co2s - sp['c'], 3)

                # ── Autres paramètres mesurés ─────────────────────────
                sat_p  = round(max(1.5, random.gauss(1.80, 0.07)), 2)   # bar
                sat_t  = round(max(0.5, random.gauss(2.00, 0.20)), 1)   # °C
                sat_air= round(max(0.0, random.gauss(0.15, 0.05)), 2)   # % vol
                o2     = round(max(0.01,random.gauss(0.040, 0.008)), 3) # mg/L < 0.09 LS
                gaz_et = round(max(0.05,random.gauss(0.30,  0.08)),  2) # vol  < 1.0 LS
                bilan  = round(max(0.01,random.gauss(0.070, 0.015)), 3) # mg/L < 0.15 LS
                b_col  = round(max(0.0, random.gauss(0.025, 0.006)), 3)
                b_rep  = round(max(0.0, random.gauss(0.018, 0.005)), 3)
                b_bln  = round(max(0.0, random.gauss(0.015, 0.004)), 3)
                b_es   = round(max(0.0, random.gauss(0.008, 0.003)), 3)
                pres_p = round(max(1.2, random.gauss(1.50, 0.06)),  2)  # bar
                cont_p = round(max(1.1, random.gauss(1.42, 0.05)),  2)  # bar
                cadence= int(max(30000, random.gauss(36000, 900)))       # bte/h
                deb_co2= round(max(8.0,  random.gauss(12.0, 1.0)),   1) # m³/h

                # ── Sertissage 24 cases ───────────────────────────────
                # Anomalie usure → 20% hors tolérance ; normal → 2%
                pct_hors = 0.20 if anomalie == 'usure_sertissage' else random.uniform(0.01, 0.03)
                sert = []
                for _ in range(24):
                    if random.random() < pct_hors:
                        v = random.choice([random.uniform(0.85, 1.03), random.uniform(1.21, 1.38)])
                    else:
                        v = round(1.12 + random.gauss(0, 0.022), 3)
                    sert.append(round(v, 3))

                rows.append((
                    d, heure, quart, atelier, produit,
                    den, den_e, co2s, co2_e,
                    sat_p, sat_t, sat_air,
                    o2, gaz_et, bilan,
                    b_col, b_rep, b_bln, b_es,
                    pres_p, cont_p, cadence, deb_co2,
                    json.dumps(sert), 'simulation'
                ))
        d += timedelta(days=1)

    execute_values(cur, """
        INSERT INTO qualite_a
        (date,heure,quart,atelier,produit,
         densite_valeur,densite_ecart,saturation_valeur,saturation_ecart,
         saturation_pression,saturation_temperature,saturation_air_total,
         o2_dissous,gaz_etranger,bilan_o2_total,
         bilan_o2_col,bilan_o2_reprise,bilan_o2_bln,bilan_o2_es,
         pression_pissette,contre_pression,cadence_soutireuse,debit_co2_balayage,
         sertissage_data,saisi_par)
        VALUES %s
    """, rows)
    log(f"✅ qualite_a          : {len(rows)} relevés bières (10 produits × 4 chaînes × 3 quarts/j)")


# ══════════════════════════════════════════════════════════════════
# ÉTAPE 3 — QUALITÉ TOUTES CHAÎNES (qualite)
# Alimente les graphes SPC et conformité brix/CO₂
# ══════════════════════════════════════════════════════════════════
def generer_qualite(cur):
    rows = []

    d = DATE_DEBUT
    while d <= DATE_FIN:

        # ── Chaînes bières (Volet Bière) ─────────────────────────
        for atelier in ['Chaîne 8','Chaîne 14','Chaîne 15','Chaîne 16']:
            if d.weekday() == CHAINES[atelier]['entretien']:
                continue
            anomalie = ANOMALIES.get((d, atelier))

            for quart, heure in QUARTS_QUALITE:
                # Produit compatible avec SEUILS_QUALITE.brix (11.0–13.0)
                produit = random.choice(PRODUITS_BRIX_VERT)
                sp      = SPECS_BRIX_VERT[produit]

                # Brix dans 11.0–13.0 → conformité ~96%
                brix = round(max(10.5, min(13.4, sp['d'] + random.gauss(0, sp['td']*0.28))), 2)
                # CO₂ dans 5.0–6.0 → conformité ~95%
                co2q = round(max(4.8, min(6.2, sp['c'] + random.gauss(0, sp['tc']*0.28))), 2)

                # Sertissage 24 cases
                pct_hors = 0.20 if anomalie == 'usure_sertissage' else random.uniform(0.01, 0.03)
                sert = []
                for _ in range(24):
                    if random.random() < pct_hors:
                        v = random.choice([random.uniform(0.85, 1.03), random.uniform(1.21, 1.38)])
                    else:
                        v = round(1.12 + random.gauss(0, 0.022), 3)
                    sert.append(round(v, 3))

                rows.append((
                    d, heure, quart, atelier, 'Bière', produit,
                    brix, co2q, json.dumps(sert), 'simulation'
                ))

        # ── Ch.13 : BRSA et Alcool Mix ───────────────────────────
        if d.weekday() != CHAINES['Chaine 13']['entretien']:
            for quart, heure in QUARTS_QUALITE:
                for type_volet, produits in [('BRSA',PRODUITS_BRSA),('Alcool Mix',PRODUITS_AM)]:
                    produit = random.choice(produits)
                    # Brix BRSA/AM : cible ~11.5, dans 11.0–13.0 → vert
                    brix = round(max(10.5, min(12.8, random.gauss(11.5, 0.28))), 2)
                    # CO₂ : cible ~5.5, dans 5.0–6.0 → vert
                    co2q = round(max(4.8, min(6.1, random.gauss(5.5, 0.18))), 2)
                    # Sertissage 20 cases
                    sert = [round(1.0 + random.gauss(0, 0.035), 3) for _ in range(20)]
                    rows.append((
                        d, heure, quart, 'Chaine 13', type_volet, produit,
                        brix, co2q, json.dumps(sert), 'simulation'
                    ))

        d += timedelta(days=1)

    execute_values(cur, """
        INSERT INTO qualite
        (date,heure,quart,atelier,type_volet,produit,
         brix,co2_qualite,sertissage_data,saisi_par)
        VALUES %s
    """, rows)
    nb_b  = sum(1 for r in rows if r[4]=='Bière')
    nb_am = sum(1 for r in rows if r[4]=='Alcool Mix')
    nb_br = sum(1 for r in rows if r[4]=='BRSA')
    log(f"✅ qualite            : {len(rows)} relevés (Bière:{nb_b} AM:{nb_am} BRSA:{nb_br})")


# ══════════════════════════════════════════════════════════════════
# ÉTAPE 4 — OEE / TRS / TRG
# ══════════════════════════════════════════════════════════════════
def generer_oee(cur):
    rows = []
    d = DATE_DEBUT
    while d <= DATE_FIN:
        for atelier, cfg in CHAINES.items():
            est_entretien = (d.weekday() == cfg['entretien'])
            anomalie      = ANOMALIES.get((d, atelier))
            obj           = cfg['obj']

            if est_entretien:
                prod = 0.0
                dispo = 0.0
            elif anomalie == 'chute_prod':
                prod  = round(obj * random.uniform(0.45, 0.55), 1)
                dispo = 1.0
            else:
                prod  = round(obj * random.uniform(0.90, 1.03), 1)
                dispo = 1.0

            perf = min(prod / obj, 1.0) if obj > 0 and not est_entretien else 0.0

            # Qualité : intègre sertissage
            if anomalie == 'usure_sertissage':
                qual = round(random.uniform(0.79, 0.85), 4)
            else:
                qual = round(random.uniform(0.94, 0.99), 4)

            trs      = round(dispo * perf * qual * 100, 2)
            oee      = trs  # OEE = TRS dans ce système
            cadence  = obj / 24  # hl/h
            bonnes   = prod * qual
            trg      = round((bonnes / (cadence * 24)) * 100, 2) if cadence > 0 else 0.0
            taux_util= round(6/7*100, 2)  # 85.7% — 1 jour entretien/semaine

            rows.append((
                d, atelier,
                round(dispo*100,2), round(perf*100,2), round(qual*100,2),
                round(oee,2), round(prod,1), obj,
                round(trs,2), round(taux_util,2),
            ))
        d += timedelta(days=1)

    execute_values(cur, """
        INSERT INTO oee_journalier
        (date,atelier,disponibilite,performance,qualite_oee,oee,
         production_reelle,production_cible,trs,taux_utilisation)
        VALUES %s
    """, rows)
    log(f"✅ oee_journalier     : {len(rows)} entrées")


# ══════════════════════════════════════════════════════════════════
# ÉTAPE 5 — RÉSULTATS ANOMALIES IA
# ══════════════════════════════════════════════════════════════════
def generer_anomalies(cur):
    cur.execute("""
        SELECT date,quart,atelier,
               index_elec,index_eau_rincage,index_eau_bain,
               index_eau_pasteur,index_eau_aero,index_co2,production_hl
        FROM lean_energie
        ORDER BY atelier,date,
                 CASE quart WHEN '6h-14h' THEN 1 WHEN '14h-22h' THEN 2 ELSE 3 END
    """)
    releves = cur.fetchall()
    rows, prev = [], {}

    for r in releves:
        d_rel,quart,atelier = r[0],r[1],r[2]
        el,ri,ba,pa,ae,co,prod = (float(x) for x in r[3:])

        if atelier not in prev:
            prev[atelier] = {'el':el,'ri':ri,'ba':ba,'pa':pa,'ae':ae,'co':co,'prod':prod}
            continue

        p = prev[atelier]
        b = CHAINES[atelier]['base']

        # Consommations du quart (delta)
        d_el = max(0, el - p['el'])
        d_ri = max(0, ri - p['ri'])
        d_ba = max(0, ba - p['ba'])
        d_pa = max(0, pa - p['pa'])
        d_ae = max(0, ae - p['ae'])

        def ep(val, base):
            return round((val-base)/base*100, 1) if base > 0 else 0.0

        e_el   = ep(d_el, b['el'])
        e_ri   = ep(d_ri, b['ri']) if b['ri'] > 0 else 0.0
        e_ba   = ep(d_ba, b['ba']) if b['ba'] > 0 else 0.0
        e_pa   = ep(d_pa, b['pa'])
        e_ae   = ep(d_ae, b['ae'])
        e_prod = ep(prod, p['prod']) if p['prod'] > 0 else 0.0

        anomalie     = ANOMALIES.get((d_rel, atelier))
        est_anomalie = (anomalie is not None)
        # Score Isolation Forest simulé : anomalie → vers -1, normal → vers 0
        score = round(random.uniform(-0.88,-0.62) if est_anomalie else random.uniform(-0.18,0.05), 4)

        # Messages XAI en français
        if anomalie == 'surconso_elec':
            msg = (f"⚠️ Surconsommation électrique : +{abs(e_el):.0f}% vs baseline "
                   f"→ Vérifier l'état des moteurs et compresseurs de {atelier}")
        elif anomalie == 'fuite_pasteur':
            msg = (f"⚠️ Eau pasteurisateur +{abs(e_pa):.0f}% vs normale "
                   f"→ Suspecter fuite circuit pasteurisateur {atelier}")
        elif anomalie == 'fuite_bain':
            msg = (f"⚠️ Consommation eau laveuse (bain+rinçage) +{abs(e_ba):.0f}% "
                   f"→ Inspecter les joints et buses de la laveuse {atelier}")
        elif anomalie == 'chute_prod':
            msg = (f"⚠️ Chute de production {atelier} : {prod:.0f} hl ({e_prod:+.0f}%) "
                   f"→ Vérifier disponibilité ligne et approvisionnement matières premières")
        elif anomalie == 'usure_sertissage':
            msg = (f"⚠️ Sertissage hors tolérance : ~20% non-conformes sur {atelier} "
                   f"→ Usure des rouleaux probable — programmer remplacement avant arrêt total")
        else:
            msg = "✓ Tous les paramètres dans les normes — aucune action requise"

        pct_sert = round(random.uniform(18,24) if anomalie=='usure_sertissage' else random.uniform(1,3), 2)
        brix_v   = round(random.gauss(12.0, 0.3), 2)
        co2_v    = round(max(4.8, random.gauss(5.6, 0.2)), 2)
        bo2_v    = round(max(0.01, random.gauss(0.038, 0.008)), 3)

        rows.append((
            d_rel, atelier, quart,
            score, est_anomalie,
            round(el,1), round(ri,2), round(ba,2),
            round(pa,2), round(ae,2), round(co,1), round(prod,1),
            brix_v, co2_v, bo2_v,
            round(e_el,1), round(e_ri,1), round(e_ba,1),
            round(e_pa,1), round(e_ae,1), round(e_prod,1),
            msg, pct_sert
        ))
        prev[atelier] = {'el':el,'ri':ri,'ba':ba,'pa':pa,'ae':ae,'co':co,'prod':prod}

    nb_anom = sum(1 for r in rows if r[4])
    execute_values(cur, """
        INSERT INTO resultats_anomalies
        (date,atelier,quart,score_anomalie,est_anomalie,
         index_elec,index_eau_rincage,index_eau_bain,
         index_eau_pasteur,index_eau_aero,index_co2,production_hl,
         brix,co2_qualite,bo2,
         ecart_elec_pct,ecart_eau_rincage_pct,ecart_eau_bain_pct,
         ecart_eau_pasteur_pct,ecart_eau_aero_pct,ecart_production_pct,
         message_xai,pct_hors_sertissage)
        VALUES %s
    """, rows)
    log(f"✅ resultats_anomalies: {len(rows)} entrées "
        f"({nb_anom} anomalies = {nb_anom/len(rows)*100:.1f}%)")


# ══════════════════════════════════════════════════════════════════
# VÉRIFICATION FINALE
# ══════════════════════════════════════════════════════════════════
def verifier(cur):
    log("\n" + "─"*60)
    log("📊 TRG / TRS moyens par chaîne (jours production) :")
    cur.execute("""
        SELECT atelier,
               ROUND(AVG(CASE WHEN production_reelle>0 THEN oee  END)::numeric,1) trg,
               ROUND(AVG(CASE WHEN production_reelle>0 THEN trs  END)::numeric,1) trs,
               ROUND(AVG(CASE WHEN production_reelle>0 THEN production_reelle END)::numeric,0) prod
        FROM oee_journalier
        GROUP BY atelier ORDER BY atelier
    """)
    for row in cur.fetchall():
        status = "✓" if (row[1] or 0) >= 75 else "⚠"
        log(f"   {status} {row[0]:<12} TRG={row[1]}%  TRS={row[2]}%  "
            f"Prod moy={row[3]} hl/j")

    log("\n📊 Ratios énergie confirmés (Ch.8, valeurs nominales) :")
    b = CHAINES['Chaîne 8']['base']
    o = 4000
    n = o * 100 / 0.65
    log(f"   rLav   = {(b['ba']+b['ri'])*3*1000/n:.3f} L/bte   [seuil warning 0.30]")
    log(f"   rPasto = {(b['pa']+b['ae'])*3/24:.3f} m³/h   [seuil warning 1.50]")
    log(f"   rElec  = {b['el']*3/o:.3f} kWh/hl  [seuil warning 2.00]")
    log(f"   rCo2   = {b['co']*3/o:.4f} kg/hl   [seuil warning 0.30]")

    log("\n📊 Qualité brix (conformité attendue ~96%) :")
    cur.execute("""
        SELECT atelier,
               COUNT(*) total,
               SUM(CASE WHEN brix BETWEEN 11.0 AND 13.0 THEN 1 ELSE 0 END) conformes
        FROM qualite WHERE type_volet='Bière'
        GROUP BY atelier ORDER BY atelier
    """)
    for row in cur.fetchall():
        pct = row[2]/row[1]*100 if row[1] > 0 else 0
        log(f"   {row[0]:<12} : {pct:.1f}% conformes ({row[2]}/{row[1]})")


# ══════════════════════════════════════════════════════════════════
# MAIN
# ══════════════════════════════════════════════════════════════════
def main():
    log("="*60)
    log("  SABC Ndokoti — Simulation données (VERSION FINALE)")
    log(f"  Période  : {DATE_DEBUT} → {DATE_FIN}")
    log(f"  Objectifs: Ch.8=4000 Ch.13=1200 Ch.14=3500 Ch.15=3500 Ch.16=3000 hl/j")
    log("="*60 + "\n")

    if 'USER:PASSWORD' in DATABASE_URL:
        log("❌ Remplace DATABASE_URL dans le script !")
        sys.exit(1)

    conn = psycopg2.connect(DATABASE_URL)
    cur  = conn.cursor()

    try:
        log("🗑️  Nettoyage des données existantes...")
        vider_tables(cur)
        conn.commit()

        log("⚡ Génération relevés énergie...")
        generer_energie(cur)
        conn.commit()

        log("🔬 Génération qualité bière (qualite_a)...")
        generer_qualite_a(cur)
        conn.commit()

        log("📊 Génération qualité toutes chaînes (qualite)...")
        generer_qualite(cur)
        conn.commit()

        log("📈 Calcul OEE / TRS / TRG journalier...")
        generer_oee(cur)
        conn.commit()

        log("🤖 Génération résultats anomalies IA...")
        generer_anomalies(cur)
        conn.commit()

        verifier(cur)

        log("\n" + "="*60)
        log("✅ SIMULATION TERMINÉE AVEC SUCCÈS !")
        log("")
        log("ÉTAPE SUIVANTE :")
        log("→ Lance l'application (backend + frontend)")
        log("→ Va dans Maintenance IA → 'Lancer l'analyse'")
        log("→ Cela recalcule les scores de santé et prévisions Prophet")
        log("="*60)

    except Exception as e:
        conn.rollback()
        log(f"\n❌ Erreur : {e}")
        import traceback; traceback.print_exc()
        sys.exit(1)
    finally:
        cur.close()
        conn.close()


if __name__ == '__main__':
    main()
