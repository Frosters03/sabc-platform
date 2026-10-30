"""Restaure backup_local.sql dans la base Neon (données uniquement).
Usage :  python restore_neon.py "postgresql://...neon.tech/neondb?sslmode=require"
Les tables doivent déjà exister (le backend les crée au démarrage)."""
import re, sys, io
import psycopg2

if len(sys.argv) != 2:
    sys.exit('Usage: python restore_neon.py "<DATABASE_URL Neon>"')

SAUTER = {"lean_energie_archive", "qualite_archive"}   # anciennes tables, absentes du modèle actuel
sql = open("backup_local.sql", encoding="utf-8").read()
blocs, courant = [], None
for ligne in sql.split("\n"):
    if courant is None:
        m = re.match(r"COPY public\.(\w+) \((.*)\) FROM stdin;$", ligne)
        if m:
            courant = [m.group(1), m.group(2), []]
    elif ligne == "\\.":
        blocs.append((courant[0], courant[1], "\n".join(courant[2])))
        courant = None
    else:
        courant[2].append(ligne)

ORDRE = ["equipes", "membres_equipe", "pointages", "lignes_pointage"]   # respecte les clés étrangères
blocs.sort(key=lambda b: ORDRE.index(b[0]) if b[0] in ORDRE else len(ORDRE))

conn = psycopg2.connect(sys.argv[1])
cur = conn.cursor()
tables = [t for t, _, _ in blocs if t not in SAUTER]
cur.execute("TRUNCATE " + ", ".join(tables) + " RESTART IDENTITY CASCADE")
for t, cols, data in blocs:
    if t in SAUTER:
        continue
    cur.copy_expert(f"COPY {t} ({cols}) FROM STDIN", io.StringIO(data + "\n" if data else ""))
    cur.execute("SELECT pg_get_serial_sequence(%s, 'id')", (t,))
    seq = cur.fetchone()[0]
    if seq:
        cur.execute(f"SELECT setval(%s, COALESCE((SELECT MAX(id) FROM {t}), 1), (SELECT COUNT(*) > 0 FROM {t}))", (seq,))
    cur.execute(f"SELECT COUNT(*) FROM {t}")
    print(f"{t:22s} {cur.fetchone()[0]} lignes")
conn.commit()
print("Restauration terminée.")
