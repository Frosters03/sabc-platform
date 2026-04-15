Voici le contenu prêt à coller dans ton fichier README.md :
Markdown
Copier le code

# SABC Packaging App

## 🏭 Description du projet

SABC Packaging App est une application de supervision industrielle développée pour SABC Packaging.  
Elle permet de saisir et suivre les relevés Lean Énergie et Qualité pour plusieurs lignes de production.  
L'application est modulable, sécurisée, et compatible PC et mobile.

L'objectif principal est de digitaliser les relevés manuels, faciliter le suivi en temps réel, et préparer le projet pour une exploitation industrielle complète avec tableaux de bord, alertes et analyses.

---

## ⚙️ Installation

1. Cloner le projet sur votre machine locale :

```bash
$   git clone <lien_du_projet>
$   cd sabc_packaging_app
```

2. Creer un environnement virtuel (optionnel mais recommandé):

```bash
$   python -m venv venv
```

3. Activer l'environnement virtuel:
   **_WINDOWS_**

```bash
$    venv\Scripts\activate
```

**_MAC OS_**

```bash
$    source venv/bin/activate
```

4. Pour installer les modules du projets

```bash
$    pip install -r requirements.txt
```

5. Pour mettre à jour vos modules installer

```bash
$    pip freeze > requirements.txt
```

## 🚀 Lancement de l'application

### Version PC

```bash
$    uvicorn main:app --reload
```

ou

```bash
$    python -m uvicorn main:app --reload
```

### Version MOBILE/TABLETTE

```bash
$    uvicorn main:app --reload
```

Même comme c'est la même version mais qui s'adapte selon l'appareil...

### UTILISATION À DISTANCE

Pour un accès mobile à distance, utiliser ngrok ou un serveur accessible depuis internet.
🔐 Gestion des utilisateurs (admin)
L'application dispose d'un compte super administrateur par défaut :
Copier le code

```
    Username : admin
    Password : sabc2024
    Role : admin
```

Seuls les administrateurs peuvent :
Ajouter / supprimer des utilisateurs
Attribuer des rôles (admin / user)
Les utilisateurs standards peuvent uniquement saisir des relevés et visualiser les données autorisées.

## 📝 Modules principaux

### 1️⃣ Relevés des compteurs

Lean Énergie
Champs : Date, Heure, Ligne, Eau rinçage laveuse, Eau bain laveuse, Eau pasteurisateur, Compteur électricité, CO2 soutireuse, Quantité colle, Quantité lubrifiant, Quantité CO2
Validation : pas de valeurs négatives ou nulles
Qualité
Champs : Date, Heure, Ligne, Données sertissage (JSON selon le nombre de cases de la ligne), Brix, CO2, BO2
Validation : toutes les valeurs > 0

### 2️⃣ Exploitation

Module prévu pour le suivi industriel, dashboards et statistiques
À développer ultérieurement

### 3️⃣ Suivi des pointages

Module prévu pour le suivi des opérateurs et cycles de production
À développer ultérieurement

## 💡 Fonctionnalités prévues / évolutions futures

Export Excel / PDF des relevés
Alertes automatiques si seuils dépassés
Dashboard de visualisation en temps réel
Interface mobile dédiée
Sécurisation avancée des mots de passe (hash)
Thèmes clair / sombre, couleurs corporate SABC (blanc, rouge, noir, or)
Modules supplémentaires : Maintenance, TRS, OEE, Stock, API PowerBI

## 🧰 Dépendances Python

Toutes les dépendances sont listées dans requirements.txt.
Exemple typique :
streamlit : pour l’interface graphique
pandas : manipulation des données
sqlite3 : gestion base de données
json : stockage des données structurées

## 📌 Bonnes pratiques

Toujours remplir toutes les données correctement (>0) avant d’envoyer
Ne pas modifier directement la base SQLite sans passer par les fonctions dédiées

Utiliser l’interface admin pour gérer les comptes utilisateurs
Respecter la structure des lignes et des cases de sertissage pour la Qualité

## 📄 Notes supplémentaires

L'interface peut être améliorée visuellement plus tard, après validation des fonctionnalités
L’application est modulaire : chaque module peut être développé ou amélioré indépendamment
Le projet est prêt pour scalabilité industrielle et extensions futures
