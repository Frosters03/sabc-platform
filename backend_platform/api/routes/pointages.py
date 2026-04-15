from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import date, timedelta
import io

from core.database import get_db
from models.pointage import Pointage, LignePointage
from models.equipe import Equipe
from models.utilisateur import Utilisateur
from schemas.pointage import PointageCreate, PointageResponse
from .auth import get_current_user, require_role, log_action

router = APIRouter(prefix="/pointages", tags=["Pointages"])

HEURES_QUART = {
    "7h-19h":  12,
    "19h-7h":  12,
    "7h-14h":  7,
    "14h-21h": 7,
    "21h-7h":  10,
}


@router.post("/", response_model=PointageResponse)
def creer_pointage(
    data: PointageCreate,
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    # Vérifier double saisie
    existant = db.query(Pointage).filter(
        Pointage.date      == data.date,
        Pointage.equipe_id == data.equipe_id,
        Pointage.quart     == data.quart,
    ).first()
    if existant:
        raise HTTPException(
            status_code=400,
            detail=f"Pointage déjà saisi pour cette équipe le {data.date} — quart {data.quart}"
        )

    pointage = Pointage(
        date       = data.date,
        chaine     = data.chaine,
        equipe_id  = data.equipe_id,
        equipe_nom = data.equipe_nom,
        quart      = data.quart,
        saisi_par  = current_user.username,
    )
    db.add(pointage)
    db.flush()

    heures_quart = HEURES_QUART.get(data.quart, 8)

    for ligne in data.lignes:
        heures_N = heures_quart if ligne.presence == "P" else 0
        ligne_db = LignePointage(
            pointage_id     = pointage.id,
            membre_id       = ligne.membre_id,
            fonction        = ligne.fonction,
            nom_prenom      = ligne.nom_prenom,
            statut_emploi   = ligne.statut_emploi,
            presence        = ligne.presence,
            heures_N        = heures_N,
            heures_F        = ligne.heures_F,
            heures_PN       = ligne.heures_PN,
            est_occasionnel = ligne.est_occasionnel,
        )
        db.add(ligne_db)

    db.commit()
    db.refresh(pointage)
    log_action(db, current_user.username, "INSERT", "pointages",
               f"Pointage {data.date} — {data.equipe_nom} — {data.quart}")
    return pointage


@router.get("/", response_model=List[PointageResponse])
def get_pointages(
    equipe_id:  Optional[int]  = Query(None),
    chaine:     Optional[str]  = Query(None),
    date_debut: Optional[date] = Query(None),
    date_fin:   Optional[date] = Query(None),
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    query = db.query(Pointage)
    if equipe_id:  query = query.filter(Pointage.equipe_id == equipe_id)
    if chaine:     query = query.filter(Pointage.chaine    == chaine)
    if date_debut: query = query.filter(Pointage.date      >= date_debut)
    if date_fin:   query = query.filter(Pointage.date      <= date_fin)
    return query.order_by(Pointage.date.desc()).all()


@router.get("/verifier")
def verifier_pointage(
    date:       date = Query(...),
    equipe_id:  int  = Query(...),
    quart:      str  = Query(...),
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    existant = db.query(Pointage).filter(
        Pointage.date      == date,
        Pointage.equipe_id == equipe_id,
        Pointage.quart     == quart,
    ).first()
    return {"existe": existant is not None, "id": existant.id if existant else None}


@router.get("/export-excel")
def export_excel_semaine(
    equipe_id:  int  = Query(...),
    date_lundi: date = Query(...),
    db: Session = Depends(get_db)
):
    import openpyxl
    from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
    from openpyxl.utils import get_column_letter
    from datetime import timedelta
    import io

    date_dimanche = date_lundi + timedelta(days=6)
    equipe = db.query(Equipe).filter(Equipe.id == equipe_id).first()
    if not equipe:
        raise HTTPException(status_code=404, detail="Équipe non trouvée")

    pointages = db.query(Pointage).filter(
        Pointage.equipe_id == equipe_id,
        Pointage.date      >= date_lundi,
        Pointage.date      <= date_dimanche,
    ).all()

    par_date = {}
    for p in pointages:
        d = p.date
        par_date[d] = p

    membres = sorted(equipe.membres, key=lambda m: m.ordre)

    wb = openpyxl.Workbook()
    ws = wb.active
    sem_num = date_lundi.isocalendar()[1]
    ws.title = f"SEM{sem_num:02d}"

    # ── STYLES ────────────────────────────────────────────
    thin  = Side(style="thin",   color="000000")
    thick = Side(style="medium", color="000000")
    b_all   = Border(top=thick,  bottom=thick,  left=thick,  right=thick)
    b_thick = Border(top=thick, bottom=thick, left=thick, right=thick)
    dashed = Side(style="dashed", color="000000")  # trait interrompu
    none  = Side(style=None)

    def st(cell, bold=False, size=10, color="000000", fill=None,
           halign="center", valign="center", border=None, wrap=False, italic=False):
        cell.font      = Font(bold=True, size=size, name="Arial",
                              color=color, italic=italic)
        cell.alignment = Alignment(horizontal=halign, vertical=valign,
                                   wrap_text=wrap)
        if fill:
            cell.fill = PatternFill("solid", fgColor=fill)
        if border:
            cell.border = border

    def mc(r1, c1, r2, c2, value="", **kwargs):
        # 1. Fusionner les cellules
        ws.merge_cells(start_row=r1, start_column=c1,
                    end_row=r2,   end_column=c2)

        # 2. Écrire la valeur dans la première cellule
        cell_top = ws.cell(row=r1, column=c1, value=value)
        st(cell_top, **kwargs)   # style sur la première cellule

        # 3. Appliquer le style (surtout les bordures) à toutes les cellules de la plage
        for row in range(r1, r2 + 1):
            for col in range(c1, c2 + 1):
                cell = ws.cell(row=row, column=col)
                # On applique le même style (sauf la valeur) pour assurer la continuité
                st(cell, **kwargs)

        return cell_top

    def wc(r, c, value="", **kwargs):
        """Write + style single cell"""
        cell = ws.cell(row=r, column=c, value=value)
        st(cell, **kwargs)
        return cell

    # ── LARGEURS COLONNES (fidèles au modèle) ─────────────
    ws.column_dimensions["A"].width  = 8.7
    ws.column_dimensions["B"].width  = 23.0
    for col_letter in ["C","D","E","F","G","H","I","J","K",
                       "L","M","N","O","P","Q","R","S","T","U","V"]:
        ws.column_dimensions[col_letter].width = 6.5
    ws.column_dimensions["W"].width  = 9.5
    ws.column_dimensions["X"].width  = 7.5
    ws.column_dimensions["Y"].width  = 7.5
    ws.column_dimensions["Z"].width  = 5.5
    ws.column_dimensions["AA"].width = 5.5
    ws.column_dimensions["AB"].width = 7.7

    # ── HAUTEURS LIGNES ───────────────────────────────────
    for r in range(1, 7):
        ws.row_dimensions[6].height = 0
    ws.row_dimensions[7].height  = 20.25
    ws.row_dimensions[8].height  = 15.75
    ws.row_dimensions[9].height  = 15.75
    ws.row_dimensions[10].height = 15.75
    for r in range(11, 32):
        ws.row_dimensions[r].height = 16.5
    ws.row_dimensions[32].height = 17.25
    ws.row_dimensions[33].height = 17.25
    ws.row_dimensions[34].height = 15.75
    for r in range(35, 40):
        ws.row_dimensions[r].height = 15.75
    ws.row_dimensions[39].height = 39.75

    # ── LIGNE 1-5 : En-têtes titre (comme sur la photo) ───
    # USINES DE DOUALA — col A-B lignes 1-4
    mc(1,1, 4,2, "USINES DE DOUALA",
       bold=True, size=10, halign="center", wrap=True, border=b_thick)

    # POINTAGE PERSONNEL — centré lignes 1-2
    mc(1,3, 2,28, "POINTAGE PERSONNEL",
       bold=True, size=20, halign="center", border=Border(top=thick, bottom=none, left=thick, right=thick))

    # Service + Atelier — ligne 3
    mc(3,3, 3,28,
       "Service : conditionnement                    Atelier : usine",
       size=10, halign="center", border=Border(top=none, bottom=none, left=thick, right=thick))

    # ── LIGNE 4 : NDOKOTI + Chaîne + Équipe ──────────────
    mc(4,3, 4,13,
       f"NDOKOTI {equipe.chaine}",
       bold=True, size=10, halign="center", border=Border(top=none, bottom=thick, left=thick, right=none))
    mc(4,14, 4,28,
       f"Equipe : {equipe.nom}",
       bold=True, size=10, halign="center", border=Border(top=none, bottom=thick, left=none, right=thick))

    # ── LIGNE 5 : SEM + Mois + Semaine du ────────────────
    mois_fr = ["","Janvier","Février","Mars","Avril","Mai","Juin",
               "Juillet","Août","Septembre","Octobre","Novembre","Décembre"]
    wc(5,1, f"SEM:{sem_num:02d}", bold=True, size=9, halign="center")

    mc(5,3, 5,8,  "Mois",  size=9, halign="center")
    mc(5,9, 5,12,
       mois_fr[date_lundi.month],
       bold=True, size=9, halign="center")
    mc(5,13, 5,28,
       f"Semaine du : {date_lundi.strftime('%d/%m/%Y')}  {date_dimanche.strftime('%d/%m/%Y')}",
       bold=True, size=9, halign="center")

    # ── LIGNE 6 : séparateur vide ─────────────────────────
    mc(6,1, 6,28, "", border=none)

    # ── LIGNE 7-8-9 : En-têtes tableau ────────────────
    # MAT. — A7:A9
    mc(7,1, 9,1, "MAT.", bold=True, size=9,
       halign="center", border=b_thick)
    # NOMS ET PRENOMS — B7:B9
    mc(7,2, 9,2, "NOMS ET PRENOMS", bold=True, size=9,
       halign="left", border=b_thick, wrap=True)

    # Jours : C=3, F=6, I=9, L=12, O=15, R=18, U=21
    jours_cols = [
        ("lundi",     3,  5,  date_lundi + timedelta(days=0)),
        ("mardi",     6,  8,  date_lundi + timedelta(days=1)),
        ("mercredi",  9,  11, date_lundi + timedelta(days=2)),
        ("jeudi",     12, 14, date_lundi + timedelta(days=3)),
        ("vendredi",  15, 17, date_lundi + timedelta(days=4)),
        ("samedi",    18, 20, date_lundi + timedelta(days=5)),
        ("dimanche",  21, 22, date_lundi + timedelta(days=6)),
    ]

    for jour, c1, c2, d in jours_cols:
        # Ligne 7 : nom du jour fusionné
        mc(7, c1, 7, c2, jour.capitalize(),
           bold=True, size=9, halign="center", border=Border(top=thick, bottom=dashed, left=thick, right=thick))
        # Ligne 8 : date fusionnée
        mc(8, c1, 8, c2, d.strftime("%d/%m/%Y"),
           bold=True, size=8, halign="center", border=Border(top=dashed, bottom=dashed, left=thick, right=thick))
        # Ligne 9 : N/F/PN (dimanche = F/PN seulement)
        if jour == "dimanche":
            wc(9, c1, "F",  bold=True, size=9,
               halign="center", border=Border(top=dashed, bottom=thick, left=thick, right=dashed))
            wc(9, c2, "PN", bold=True, size=9,
               halign="center", border=Border(top=dashed, bottom=thick, left=dashed, right=thick))
        else:
            wc(9, c1,   "N",  bold=True, size=9, halign="center", border=Border(top=dashed, bottom=thick, left=thick, right=dashed))
            wc(9, c1+1, "F",  bold=True, size=9, halign="center", border=Border(top=dashed, bottom=thick, left=dashed, right=dashed))
            wc(9, c2,   "PN", bold=True, size=9, halign="center", border=Border(top=dashed, bottom=thick, left=dashed, right=thick))

    # REPARTITION — W7:AB7
    mc(7, 23, 7, 28, "REPARTITION",
       bold=True, size=9, halign="center", border=b_thick)

    # Sous-en-têtes répartition — lignes 8-9
    rep = [
        (23, "Heures\ntravaillées"),
        (24, "Heures\npayées"),
        (25, "Heures\nnorm"),
        (26, "HS"),
        (27, "PN"),
        (28, "Taux HS"),
    ]
    for col, lbl in rep:
        mc(8, col, 9, col, lbl,
           bold=True, size=8, halign="center",
           border=b_thick, wrap=True)

    # ── LIGNES MEMBRES 10-29 ──────────────────────────────
    ROW_S = 10
    ROW_E = 29

    for idx in range(20):
        r = ROW_S + idx
        # Appliquer borders sur toutes les cellules de la ligne
        for col in range(1, 29):
            ws.cell(row=r, column=col).border = b_all

        if idx < len(membres):
            m = membres[idx]

            # Récupérer présences par jour
            presences = {}
            for j_idx, (_, c1, c2, d) in enumerate(jours_cols):
                ptg = par_date.get(d.date() if hasattr(d,'date') else d)
                if ptg:
                    for lg in ptg.lignes:
                        if lg.membre_id == m.id and not lg.est_occasionnel:
                            presences[j_idx] = lg
                            break

            wc(r, 1, m.matricule or "", size=9, halign="center", border=Border(top=dashed, bottom=dashed, left=thick, right=thick))
            wc(r, 2, m.nom_prenom,      size=9, halign="left",   border=Border(top=dashed, bottom=dashed, left=thick, right=thick))

            for j_idx, (jour, c1, c2, d) in enumerate(jours_cols):
                lg = presences.get(j_idx)
                if jour == "dimanche":
                    f_val  = lg.heures_F  if lg and lg.heures_F  else ""
                    pn_val = lg.heures_PN if lg and lg.heures_PN else ""
                    wc(r, c1, f_val,  size=9, halign="center", border=Border(top=thick, bottom=thick, left=thick, right=dashed))
                    wc(r, c2, pn_val, size=9, halign="center", border=Border(top=thick, bottom=thick, left=dashed, right=thick))
                else:
                    if lg:
                        n_val  = lg.presence if lg.presence in ("AA","AB","R","RM","CP") \
                                 else (lg.heures_N if lg.heures_N else "")
                        f_val  = lg.heures_F  if lg.heures_F  else ""
                        pn_val = lg.heures_PN if lg.heures_PN else ""
                    else:
                        n_val = f_val = pn_val = ""
                    wc(r, c1,   n_val,  size=9, halign="center", border=Border(top=thick, bottom=thick, left=thick, right=dashed))
                    wc(r, c1+1, f_val,  size=9, halign="center", border=Border(top=thick, bottom=thick, left=dashed, right=dashed))
                    wc(r, c2,   pn_val, size=9, halign="center", border=Border(top=thick, bottom=thick, left=dashed, right=thick))
        else:
            wc(r, 1, "", border=b_all)
            wc(r, 2, "", border=b_all)
            for _, c1, c2, _ in jours_cols:
                for ci in range(c1, c2+1):
                    wc(r, ci, "", border=b_all)

        # Formules répartition
        rs = str(r)
        ws.cell(r,23).value = f"=SUM(C{rs}:D{rs},F{rs}:G{rs},I{rs}:J{rs},L{rs}:M{rs},O{rs}:P{rs},R{rs}:S{rs},U{rs})"
        ws.cell(r,24).value = f"=W{rs}+(0.5*(SUM(D{rs},G{rs},J{rs},M{rs},P{rs},S{rs},U{rs})))"
        ws.cell(r,25).value = f"=X{rs}-Z{rs}"
        ws.cell(r,26).value = f'=IF(X{rs}-40<0,"0",X{rs}-40)'
        ws.cell(r,27).value = f"=SUM(V{rs},E{rs},Q{rs},N{rs},K{rs},H{rs},T{rs})"
        ws.cell(r,28).value = f"=+Z{rs}/40"
        ws.cell(r,28).number_format = "0%"
        for ci in range(23, 29):
            st(ws.cell(r,ci), size=9, halign="center", border=b_all)

    # ── LIGNE 30 : TOTAUX ─────────────────────────────────
    R_T = 30
    mc(R_T, 1, R_T, 2, "", border=b_thick)
    for col in range(3, 29):
        cl = get_column_letter(col)
        ws.cell(R_T, col).value = f"=SUM({cl}{ROW_S}:{cl}{ROW_E})"
        st(ws.cell(R_T,col), bold=True, size=9,
           halign="center", border=b_thick)

    # ── LIGNES 31-32 : LÉGENDE ────────────────────────────
    mc(31,1,  31,2,  "RM=Maladie",              size=8, halign="left")
    mc(31,3,  31,8,  "CE= Congé événement familial", size=8, halign="left")
    mc(31,21, 31,22, "TAUX H.S",                bold=True, size=8, halign="center")
    mc(31,23, 31,28, f"=Z{R_T}/Y{R_T}",
       bold=True, size=9, halign="center")
    ws.cell(31,23).number_format = "0%"

    mc(32,1,  32,2,  "A=Absence",   size=8, halign="left")
    mc(32,3,  32,8,  "F=S150=Férié", size=8, halign="left")

    # ── LIGNES 33-38 : OBSERVATIONS + VISAS ──────────────
    mc(33,1,  38,16, "Observations", bold=True, size=9,
       halign="left", valign="top", border=b_thick)
    mc(33,17, 33,20, "Visa Contremaître",      size=8, halign="center", border=b_thick)
    mc(33,21, 33,23, "Visa Adj. Chef Service", size=8, halign="center", border=b_thick)
    mc(33,24, 33,28, "Visa Chef Service",      size=8, halign="center", border=b_thick)
    mc(34,17, 38,20, "", border=b_thick)
    mc(34,21, 38,23, "", border=b_thick)
    mc(34,24, 38,28, "", border=b_thick)

    # ── MISE EN PAGE ──────────────────────────────────────
    ws.page_setup.orientation = "landscape"
    ws.page_setup.paperSize   = ws.PAPERSIZE_A3
    ws.page_setup.fitToPage   = True
    ws.page_setup.fitToWidth  = 1
    ws.page_setup.fitToHeight = 0
    ws.print_area = "A1:AB39"

    buf = io.BytesIO()
    wb.save(buf)
    buf.seek(0)

    filename = (f"Pointage_{equipe.nom}_{equipe.chaine}_"
                f"SEM{sem_num:02d}_{date_lundi.strftime('%Y-%m-%d')}.xlsx")
    return StreamingResponse(
        buf,
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": f"attachment; filename={filename}"}
    )

@router.get("/export-excel-am")
def export_excel_am(
    equipe_id:  int  = Query(...),
    date_lundi: date = Query(...),
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    import openpyxl
    from openpyxl.styles import Font, Alignment, Border, Side, PatternFill
    from openpyxl.utils import get_column_letter
    from datetime import timedelta
    import io

    date_dimanche = date_lundi + timedelta(days=6)
    equipe = db.query(Equipe).filter(Equipe.id == equipe_id).first()
    if not equipe:
        raise HTTPException(status_code=404, detail="Équipe non trouvée")

    pointages = db.query(Pointage).filter(
        Pointage.equipe_id == equipe_id,
        Pointage.date      >= date_lundi,
        Pointage.date      <= date_dimanche,
    ).all()

    par_date = {p.date: p for p in pointages}

    # Seulement les AM
    membres_am = sorted(
        [m for m in equipe.membres if m.statut == 'am'],
        key=lambda m: m.ordre
    )

    wb = openpyxl.Workbook()
    ws = wb.active
    sem_num = date_lundi.isocalendar()[1]
    ws.title = f"SEM{sem_num:02d}"

    # ── STYLES ────────────────────────────────────────────
    thick = Side(style="medium", color="000000")
    thin  = Side(style="thin",   color="000000")
    none  = Side(style=None)
    b_all   = Border(top=thick, bottom=thick, left=thick, right=thick)
    b_thin  = Border(top=thin,  bottom=thin,  left=thin,  right=thin)

    def st(cell, bold=False, size=10, halign="center", valign="center",
           border=None, wrap=False):
        cell.font      = Font(bold=bold, size=size, name="Arial")
        cell.alignment = Alignment(horizontal=halign, vertical=valign,
                                   wrap_text=wrap)
        if border:
            cell.border = border

    def mc(r1, c1, r2, c2, value="", **kwargs):
        ws.merge_cells(start_row=r1, start_column=c1,
                       end_row=r2,   end_column=c2)
        c = ws.cell(row=r1, column=c1, value=value)
        st(c, **kwargs)
        return c

    def wc(r, c, value="", **kwargs):
        cell = ws.cell(row=r, column=c, value=value)
        st(cell, **kwargs)
        return cell

    # ── LARGEURS COLONNES ─────────────────────────────────
    ws.column_dimensions["A"].width = 10   # MATRICULE
    ws.column_dimensions["B"].width = 25   # NOMS
    ws.column_dimensions["C"].width = 2    # vide
    for col in ["D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V"]:
        ws.column_dimensions[col].width = 5
    ws.column_dimensions["W"].width = 2    # vide
    ws.column_dimensions["X"].width = 7   # HN
    ws.column_dimensions["Y"].width = 7   # HS
    ws.column_dimensions["Z"].width = 7   # TOTAL
    ws.column_dimensions["AA"].width = 7  # PN
    ws.column_dimensions["AB"].width = 15 # OBSERVATIONS

    # ── EN-TÊTES ──────────────────────────────────────────
    mois_fr = ["","Janvier","Février","Mars","Avril","Mai","Juin",
               "Juillet","Août","Septembre","Octobre","Novembre","Décembre"]

    # Ligne 1 : vide
    # Ligne 2 : Titre
    mc(2,1, 2,28, "POINTAGE HEBDOMADAIRE DU PERSONNEL AGENT DE MAITRISE",
       bold=True, size=14, halign="center", border=b_all)

    # Ligne 3-5 : infos
    mc(3,1, 3,5, "USINE/SITE :", bold=True, size=10, halign="left")
    mc(3,6, 3,10, "NDOKOTI", bold=True, size=10, halign="left")

    mc(4,1, 4,5, "SERVICE :", bold=True, size=10, halign="left")
    mc(4,6, 4,10, "CONDITIONNEMENT", bold=True, size=10, halign="left")

    mc(5,1, 5,5, f"ATELIER : CHAINE :", bold=True, size=10, halign="left")
    mc(5,6, 5,10, str(equipe.chaine), bold=True, size=10, halign="left")

    # Ligne 6 : CODE + SEMAINE + Du ... Au ...
    mc(6,1, 6,3, "CODE :", bold=True, size=9, halign="left")
    mc(6,4, 6,8, f"SEMAINE {sem_num}", bold=True, size=9, halign="center", border=b_all)
    mc(6,9, 6,11, "Du", size=9, halign="center")
    mc(6,12, 6,16, date_lundi.strftime("%d/%m/%Y"), bold=True, size=9,
       halign="center", border=b_all)
    mc(6,17, 6,19, "Au", size=9, halign="center")
    mc(6,20, 6,24, date_dimanche.strftime("%d/%m/%Y"), bold=True, size=9,
       halign="center", border=b_all)

    # Ligne 7 : Équipe
    mc(7,1, 7,10, f"Équipe : {equipe.nom}", bold=True, size=10,
       halign="left", border=b_all)

    # ── LIGNE 13-14 : En-têtes tableau ────────────────────
    jours_cols = [
        ("Lun",  4,  6,  date_lundi + timedelta(days=0)),
        ("Mar",  7,  9,  date_lundi + timedelta(days=1)),
        ("Mer",  10, 12, date_lundi + timedelta(days=2)),
        ("Jeu",  13, 15, date_lundi + timedelta(days=3)),
        ("Ven",  16, 18, date_lundi + timedelta(days=4)),
        ("Sam",  19, 21, date_lundi + timedelta(days=5)),
        ("Dim",  22, 23, date_lundi + timedelta(days=6)),
    ]

    mc(13,1, 14,1, "MATRICULE",     bold=True, size=9, halign="center", border=b_all)
    mc(13,2, 14,2, "NOMS ET PRENOMS", bold=True, size=9, halign="center",
       border=b_all, wrap=True)

    for jour, c1, c2, d in jours_cols:
        mc(13, c1, 13, c2, jour, bold=True, size=9,
           halign="center", border=b_all)
        if jour == "Dim":
            wc(14, c1, "F",  bold=True, size=9, halign="center", border=b_all)
            wc(14, c2, "PN", bold=True, size=9, halign="center", border=b_all)
        else:
            wc(14, c1,   "N",  bold=True, size=9, halign="center", border=b_all)
            wc(14, c1+1, "F",  bold=True, size=9, halign="center", border=b_all)
            wc(14, c2,   "PN", bold=True, size=9, halign="center", border=b_all)

    mc(13,24, 14,24, "HN",    bold=True, size=9, halign="center", border=b_all)
    mc(13,25, 14,25, "HS",    bold=True, size=9, halign="center", border=b_all)
    mc(13,26, 14,26, "TOTAL", bold=True, size=9, halign="center", border=b_all)
    mc(13,27, 14,27, "PN",    bold=True, size=9, halign="center", border=b_all)
    mc(13,28, 14,28, "OBSERVATIONS", bold=True, size=9,
       halign="center", border=b_all, wrap=True)

    # ── LIGNES AM (15 à 18 max) ───────────────────────────
    ROW_S = 15
    ROW_E = ROW_S + 3  # max 4 AM

    for idx in range(4):
        r = ROW_S + idx
        for col in range(1, 29):
            ws.cell(row=r, column=col).border = b_thin

        if idx < len(membres_am):
            m = membres_am[idx]
            presences = {}
            for j_idx, (_, c1, c2, d) in enumerate(jours_cols):
                d_key = d.date() if hasattr(d,'date') else d
                ptg = par_date.get(d_key)
                if ptg:
                    for lg in ptg.lignes:
                        if lg.membre_id == m.id:
                            presences[j_idx] = lg
                            break

            wc(r, 1, m.matricule or "", size=9, halign="center", border=b_thin)
            wc(r, 2, m.nom_prenom,      size=9, halign="left",   border=b_thin)

            for j_idx, (jour, c1, c2, d) in enumerate(jours_cols):
                lg = presences.get(j_idx)
                if jour == "Dim":
                    f_val  = lg.heures_F  if lg and lg.heures_F  else ""
                    pn_val = lg.heures_PN if lg and lg.heures_PN else ""
                    wc(r, c1, f_val,  size=9, halign="center", border=b_thin)
                    wc(r, c2, pn_val, size=9, halign="center", border=b_thin)
                else:
                    if lg:
                        n_val  = lg.presence if lg.presence in ("AA","AB","R","RM","CP","CD","CN","CM") \
                                 else (lg.heures_N if lg.heures_N else "")
                        f_val  = lg.heures_F  if lg.heures_F  else ""
                        pn_val = lg.heures_PN if lg.heures_PN else ""
                    else:
                        n_val = f_val = pn_val = ""
                    wc(r, c1,   n_val,  size=9, halign="center", border=b_thin)
                    wc(r, c1+1, f_val,  size=9, halign="center", border=b_thin)
                    wc(r, c2,   pn_val, size=9, halign="center", border=b_thin)
        else:
            wc(r, 1, "", border=b_thin)
            wc(r, 2, "", border=b_thin)

        # Formules HN/HS/TOTAL/PN
        rs = str(r)
        ws.cell(r,24).value = (
            f"=IF(SUM(D{rs},E{rs},G{rs},H{rs},J{rs},K{rs},M{rs},N{rs},"
            f"P{rs},Q{rs},S{rs},T{rs})>50,50,"
            f"SUM(D{rs},E{rs},G{rs},H{rs},J{rs},K{rs},M{rs},N{rs},"
            f"P{rs},Q{rs},S{rs},T{rs}))"
        )
        ws.cell(r,25).value = (
            f"=SUM(D{rs},E{rs},G{rs},H{rs},J{rs},K{rs},M{rs},N{rs},"
            f"P{rs},Q{rs})+SUM(S{rs},T{rs},V{rs})-X{rs}"
        ).replace("X", "24").replace("D","D").replace("X{rs}", f"X{rs}")
        # Correction formule HS
        ws.cell(r,25).value = (
            f"=SUM(D{rs},E{rs},G{rs},H{rs},J{rs},K{rs},M{rs},N{rs},"
            f"P{rs},Q{rs},S{rs},T{rs},V{rs})-X{rs}"
        )
        ws.cell(r,26).value = f"=SUM(X{rs}:Y{rs})"
        ws.cell(r,27).value = f"=SUM(F{rs},I{rs},L{rs},O{rs},R{rs},U{rs},W{rs})"
        for ci in [24,25,26,27,28]:
            st(ws.cell(r,ci), size=9, halign="center", border=b_thin)

    # ── LIGNE TOTAL ───────────────────────────────────────
    R_TOT = ROW_E + 1
    mc(R_TOT, 19, R_TOT, 22, "TOTAL", bold=True, size=9,
       halign="center", border=b_all)
    for ci in [24, 25, 26]:
        cl = get_column_letter(ci)
        ws.cell(R_TOT, ci).value = f"=SUM({cl}{ROW_S}:{cl}{ROW_E})"
        st(ws.cell(R_TOT,ci), bold=True, size=9,
           halign="center", border=b_all)

    # TAUX H.S
    R_TAUX = R_TOT + 1
    mc(R_TAUX, 4, R_TAUX, 7, "SEM-" + f"{sem_num:02d}",
       bold=True, size=9, halign="center")
    mc(R_TAUX, 19, R_TAUX, 22, "TAUX H.S",
       bold=True, size=9, halign="center")
    ws.cell(R_TAUX, 24).value = f"=(Y{R_TOT})/Z{R_TOT}"
    ws.cell(R_TAUX, 24).number_format = "0%"
    st(ws.cell(R_TAUX,24), bold=True, size=9, halign="center")

    # ── LÉGENDE ───────────────────────────────────────────
    R_LEG = R_TAUX + 2
    legendes = [
        (R_LEG,   1,  "N=Normal"),
        (R_LEG,   4,  "PN= Panier de nuit"),
        (R_LEG,   16, "F= FERIEE"),
        (R_LEG+1, 1,  "A=Absence injustifié"),
        (R_LEG+1, 4,  "CD= Congé décès"),
        (R_LEG+1, 16, "CN= Congé naissance"),
        (R_LEG+1, 28, "R=Repos"),
        (R_LEG+2, 1,  "AA=Absence autorisé"),
        (R_LEG+2, 4,  "CM= Congé mariage"),
        (R_LEG+2, 16, "CP= Congé payé"),
        (R_LEG+2, 28, "RM=Maladie"),
    ]
    for row, col, txt in legendes:
        wc(row, col, txt, size=8, halign="left")

    # ── VISAS + OBSERVATIONS ──────────────────────────────
    R_VIS = R_LEG + 4
    mc(R_VIS, 1,  R_VIS+4, 9,  "Observations :", bold=True, size=9,
       halign="left", valign="top", border=b_all)
    mc(R_VIS, 11, R_VIS,   14, "Visa AM",               size=8, halign="center", border=b_all)
    mc(R_VIS, 22, R_VIS,   24, "Visa Chef d'Atelier",   size=8, halign="center", border=b_all)
    mc(R_VIS, 25, R_VIS,   28, "Visa Chef de Service",  size=8, halign="center", border=b_all)
    mc(R_VIS+1, 11, R_VIS+4, 14, "", border=b_all)
    mc(R_VIS+1, 22, R_VIS+4, 24, "", border=b_all)
    mc(R_VIS+1, 25, R_VIS+4, 28, "", border=b_all)

    # Taux d'heures
    R_TAUX2 = R_VIS + 6
    infos_taux = [
        "Taux d'heures prévu :",
        "Taux d'heures réalisé :",
        "Ecart :",
        "Correspondant à :",
        "Justifiées par :",
    ]
    for i, txt in enumerate(infos_taux):
        wc(R_TAUX2+i, 1, txt, size=9, halign="left")
        wc(R_TAUX2+i, 7, "%" if i < 3 else ("H" if i==3 else ""), size=9)

    # ── MISE EN PAGE ──────────────────────────────────────
    ws.page_setup.orientation = "landscape"
    ws.page_setup.paperSize   = ws.PAPERSIZE_A3
    ws.page_setup.fitToPage   = True
    ws.page_setup.fitToWidth  = 1

    buf = io.BytesIO()
    wb.save(buf)
    buf.seek(0)

    filename = (f"Pointage_AM_{equipe.nom}_{equipe.chaine}_"
                f"SEM{sem_num:02d}_{date_lundi.strftime('%Y-%m-%d')}.xlsx")
    return StreamingResponse(
        buf,
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": f"attachment; filename={filename}"}
    )

@router.get("/rapport-ab")
def rapport_absences_non_justifiees(
    date_debut: date = Query(...),
    date_fin:   date = Query(...),
    chaine:     Optional[str] = Query(None),
    equipe_id:  Optional[int] = Query(None),
    db: Session = Depends(get_db),
    current_user: Utilisateur = Depends(get_current_user)
):
    """Rapport des absences non justifiées (AB) sur une période"""
    query = db.query(Pointage).filter(
        Pointage.date >= date_debut,
        Pointage.date <= date_fin,
    )
    if chaine:    query = query.filter(Pointage.chaine    == chaine)
    if equipe_id: query = query.filter(Pointage.equipe_id == equipe_id)
    
    pointages = query.all()
    
    # Regrouper les AB par membre
    rapport = {}
    for ptg in pointages:
        for lg in ptg.lignes:
            if lg.presence == "AB" and not lg.est_occasionnel:
                cle = f"{lg.nom_prenom}_{lg.membre_id}"
                if cle not in rapport:
                    rapport[cle] = {
                        "nom_prenom":   lg.nom_prenom,
                        "membre_id":    lg.membre_id,
                        "fonction":     lg.fonction,
                        "chaine":       ptg.chaine,
                        "equipe_nom":   ptg.equipe_nom,
                        "nb_absences":  0,
                        "heures_total": 0,
                        "details":      [],
                    }
                rapport[cle]["nb_absences"]  += 1
                rapport[cle]["heures_total"] += ptg.quart and {
                    "7h-19h": 12, "19h-7h": 12,
                    "7h-14h": 7,  "14h-21h": 7, "21h-7h": 10,
                }.get(ptg.quart, 8) or 8
                rapport[cle]["details"].append({
                    "date":  str(ptg.date),
                    "quart": ptg.quart,
                    "jour":  ptg.date.strftime("%A %d/%m/%Y"),
                })
    
    # Trier par nb absences décroissant
    result = sorted(rapport.values(), key=lambda x: x["nb_absences"], reverse=True)
    return result