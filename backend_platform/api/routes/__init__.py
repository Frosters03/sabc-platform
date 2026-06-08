from .auth         import router as auth_router
from .lean_energie import router as energie_router
from .qualite      import router as qualite_router
from .alertes      import router as alertes_router

# ── MODULE RH ─────────────────────────────────────────────
from .equipes      import router as equipes_router
from .pointages    import router as pointages_router

# from .rh_conges   import router as conges_router   # EN ATTENTE
# from .rh_salaires import router as salaires_router # EN ATTENTE

# from .analyse     import router as analyse_router  # EN ATTENTE

# ── MODULE IA — MAINTENANCE PRÉDICTIVE ───────────────────
from .maintenance  import router as maintenance_router