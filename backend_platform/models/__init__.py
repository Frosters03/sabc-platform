# ============================================================
# models/__init__.py — Registre des modules actifs
# ============================================================

from .utilisateur  import Utilisateur    # MODULE : Utilisateurs  [ACTIF]
from .lean_energie import LeanEnergie    # MODULE : Lean Énergie  [ACTIF]
from .qualite      import Qualite        # MODULE : Qualité       [ACTIF]
from .alerte       import Alerte         # MODULE : Alertes IA    [ACTIF]
from .log_activite import LogActivite    # MODULE : Logs          [ACTIF]
from .equipe       import Equipe, MembreEquipe   # MODULE : RH — Équipes    [ACTIF]
from .pointage     import Pointage, LignePointage # MODULE : RH — Pointages  [ACTIF]
from .maintenance_predictive import ResultatAnomalie, ScoreSante, PrevisionEnergie, OEEJournalier
from .qualite_a import QualiteA

# from .temperature import Temperature   # MODULE : Température   [EN ATTENTE]