# ============================================================
# schemas/__init__.py — Registre des schémas actifs
# ============================================================

from .auth    import LoginRequest, TokenResponse
from .auth    import UtilisateurCreate, UtilisateurUpdate, UtilisateurResponse
from .donnees import LeanEnergieCreate, LeanEnergieResponse
from .donnees import QualiteCreate, QualiteResponse
from .donnees import AlerteResponse, MessageResponse

# from .rh    import PointageCreate, PointageResponse  # EN ATTENTE


