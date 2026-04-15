# Documentation Fonctionnelle du Projet

## Comment Démarrer le projet

### Démarrage de l'Application de SGBD POSTGRES
1. Ouvrir sa BD PostGreSql[pgAdmin4]

### Demarrage du Front-End
1. Ouvre un terminal[powershell] ou [git_bash]

2. Dans le terminal change de répertoire:
```bash
    cd frontend_platform
```

3. Si tu veux installer des dépendances [Optional]
```bash
    npm install
```

4. Démarrer le projet
```bash
    npm run start
```

### Démarrage du Back-End
1. Ouvre un terminal[powershell] ou [git_bash] Toujours au même endroit où tu as ouvert le premier

2. Dans le terminal change de répertoire:
```bash
    cd backend_platform
```

3. Activer l'environnement virtuel:
   **_WINDOWS_**

```bash
$    venv\Scripts\activate
```

4. Pour installer les modules du projets [Optional]
```bash
$    pip install -r requirements.txt
```

5. Pour mettre à jour vos modules installer [Optional]
```bash
$    pip freeze > requirements.txt
```

6. Taper la commande
```bash
$    uvicorn main:app --reload
```


# Documentation Fonctionnelle du Projet
# SABC Packaging Platform

## Prérequis
- Python 3.11
- Node.js 18+
- PostgreSQL 14+ (pgAdmin4)

---

## Configuration de la base de données

1. Ouvrir pgAdmin4
2. Créer une base de données nommée : `sabc_packaging`
3. Vérifier que PostgreSQL tourne sur le port `5432`

### Fichier `.env` (dans `backend_platform/`)
Créer le fichier `.env` avec ce contenu exact (sans guillemets) :
```
APP_NAME=SABC Platform
APP_VERSION=1.0.0
DEBUG=True

DB_TYPE=postgres
PG_HOST=localhost
PG_PORT=5432
PG_DATABASE=sabc_packaging
PG_USER=postgres
PG_PASSWORD=#Frosty2503

SECRET_KEY=sabc-ndokoti-2025-secret-key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=480
```

> **Important** : Ne pas mettre de guillemets autour des valeurs.  
> Si le fichier `.env` cause une erreur d'encodage, le recréer avec cette commande PowerShell :
> ```powershell
> Set-Content -Path .env -Encoding UTF8 -Value @"
> APP_NAME=SABC Platform
> ...
> "@
> ```

---

## Démarrage du projet

Ouvrir **deux terminaux** (PowerShell ou Git Bash) dans le dossier racine du projet.

---

### Terminal 1 — Frontend

```bash
cd frontend_platform
npm install        # optionnel — seulement si première fois
npm run start
```

L'application sera accessible sur : **http://localhost:3000**

---

### Terminal 2 — Backend

```bash
cd backend_platform

# Activer l'environnement virtuel (Windows)
venv\Scripts\activate

# Installer les dépendances (optionnel — seulement si première fois)
pip install -r requirements.txt

# Lancer le backend
uvicorn main:app --reload
```

L'API sera accessible sur : **http://localhost:8000**  
Documentation API : **http://localhost:8000/docs**

---

## Comptes utilisateurs par défaut

| Utilisateur | Mot de passe | Rôle |
|-------------|-------------|------|
| admin | sabc2026 | Administrateur |
| directeur1 | sabcndo26 | Directeur |
| chef_Guy | Chaine16 | Chef d'atelier |
| operateur1 | Maeva16 | Opérateur |
| operateur2 | Loraine641 | Opérateur |

---

## Accès mobile (via réseau local)

Pour accéder depuis un téléphone sur le même réseau WiFi :

1. Trouver l'IP locale du PC :
```powershell
ipconfig
# Chercher "Adresse IPv4" ex: 192.168.1.X
```

2. Accéder depuis le téléphone : `http://192.168.1.X:3000`

3. Pour accès externe (ngrok) :
```bash
ngrok http 8000
```
Puis mettre à jour `frontend_platform/.env.local` :
```
REACT_APP_API_URL=https://VOTRE-URL-NGROK/api
```

---

## Mettre à jour les dépendances

```bash
# Backend
pip freeze > requirements.txt

# Frontend
npm install <package>
```

---

## Structure du projet

```
sabc-project/
├── frontend_platform/     # React.js
│   ├── src/
│   ├── public/
│   └── package.json
├── backend_platform/      # FastAPI + PostgreSQL
│   ├── core/
│   ├── models/
│   ├── api/
│   ├── services/
│   ├── main.py
│   ├── .env               # Variables d'environnement (ne pas commit)
│   └── requirements.txt
└── README.md
```