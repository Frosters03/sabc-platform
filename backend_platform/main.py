from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from core.database import create_tables
from core.config import settings
from api.routes import (
    auth_router,
    energie_router,
    qualite_router,
    alertes_router,
    equipes_router,
    pointages_router,
)

# ── Création de l'application ─────────────────────────────
app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    description="Plateforme de monitoring et maintenance prédictive — SABC Ndokoti"
)

# ── CORS ──────────────────────────────────────────────────
# Permet à React (frontend) de communiquer avec FastAPI
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En production, mettre l'URL exacte de React
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["Content-Disposition"],
)

# ── Création des tables au démarrage ──────────────────────
@app.on_event("startup")
def startup():
    from core.database import SessionLocal
    from models.utilisateur import Utilisateur
    from core.security import hash_password

    # Crée les tables si elles n'existent pas (sans effacer)
    create_tables()

    # Crée les utilisateurs par défaut s'ils n'existent pas
    db = SessionLocal()
    try:
        users_defaut = [
            {"username": "manager",       "password": "sabc2026",  "role": "manager"},
            {"username": "GUY", "password": "sabcndo26", "role": "chef_atelier"},
            {"username": "contremaitre1", "password": "sabc1234",  "role": "contremaitre"},
        ]
        for u in users_defaut:
            existe = db.query(Utilisateur).filter(
                Utilisateur.username == u["username"]
            ).first()
            if not existe:
                nouveau = Utilisateur(
                    username=u["username"],
                    password=hash_password(u["password"]),
                    role=u["role"],
                    actif=True,
                )
                db.add(nouveau)
        db.commit()
    except Exception as e:
        print(f"Erreur startup: {e}")
        db.rollback()
    finally:
        db.close()

# ── Branchement des routes ────────────────────────────────
# C'est ici qu'on branche les modules.
# Ton encadreur dit "ajoute le module RH" ?
# → Tu crées routes/rh.py
# → Tu importes rh_router dans api/routes/__init__.py
# → Tu ajoutes app.include_router(rh_router) ici
# ── Routes principales ────────────────────────────────────
app.include_router(auth_router,      prefix="/api")
app.include_router(energie_router,   prefix="/api")
app.include_router(qualite_router,   prefix="/api")
app.include_router(alertes_router,   prefix="/api")

# ── Module RH ─────────────────────────────────────────────
app.include_router(equipes_router,   prefix="/api")
app.include_router(pointages_router, prefix="/api")

# app.include_router(rh_router, prefix="/api")  # EN ATTENTE

# from .api.routes import rh_router
# app.include_router(rh_router, prefix="/api")  # EN ATTENTE

# ── Route de test ─────────────────────────────────────────
@app.get("/")
def root():
    return {
        "app": settings.APP_NAME,
        "version": settings.APP_VERSION,
        "status": "running",
        "docs": "/docs"
    }
    