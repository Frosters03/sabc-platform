--
-- PostgreSQL database dump
--

\restrict Z8gc2cY1eBFf063Ik5Zj4klZ5J3cY9T8d2xISmFCLhQwhgaLwIZyZ3hKXTsXmfB

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alertes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alertes (
    id integer NOT NULL,
    source character varying(50) NOT NULL,
    niveau character varying(20) NOT NULL,
    atelier character varying(50),
    message text NOT NULL,
    valeur double precision,
    seuil double precision,
    recommandation text,
    lu boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.alertes OWNER TO postgres;

--
-- Name: alertes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alertes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alertes_id_seq OWNER TO postgres;

--
-- Name: alertes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alertes_id_seq OWNED BY public.alertes.id;


--
-- Name: equipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipes (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    chaine character varying(50) NOT NULL,
    actif boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.equipes OWNER TO postgres;

--
-- Name: equipes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipes_id_seq OWNER TO postgres;

--
-- Name: equipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipes_id_seq OWNED BY public.equipes.id;


--
-- Name: lean_energie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lean_energie (
    id integer CONSTRAINT lean_energie_id_not_null1 NOT NULL,
    date date NOT NULL,
    heure character varying(10) NOT NULL,
    quart character varying(20) NOT NULL,
    atelier character varying(50) NOT NULL,
    index_eau_rincage double precision,
    index_eau_bain double precision,
    index_eau_pasteur double precision,
    index_eau_aero double precision,
    index_elec double precision,
    index_co2 double precision,
    production_hl double precision,
    saisi_par character varying(100),
    created_at timestamp without time zone,
    arret_planifie boolean DEFAULT false
);


ALTER TABLE public.lean_energie OWNER TO postgres;

--
-- Name: lean_energie_archive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lean_energie_archive (
    id integer CONSTRAINT lean_energie_id_not_null NOT NULL,
    date date,
    heure time without time zone,
    ligne character varying(50),
    eau_rincage numeric,
    eau_bain numeric,
    eau_pasteur numeric,
    elec numeric,
    co2_sout numeric,
    colle numeric,
    lubrifiant numeric,
    qte_co2 numeric,
    eau_aero numeric,
    eau_mixeur numeric
);


ALTER TABLE public.lean_energie_archive OWNER TO postgres;

--
-- Name: lean_energie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lean_energie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lean_energie_id_seq OWNER TO postgres;

--
-- Name: lean_energie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lean_energie_id_seq OWNED BY public.lean_energie.id;


--
-- Name: lignes_pointage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lignes_pointage (
    id integer NOT NULL,
    pointage_id integer NOT NULL,
    membre_id integer,
    fonction character varying(100) NOT NULL,
    nom_prenom character varying(150) NOT NULL,
    statut_emploi character varying(20) NOT NULL,
    presence character varying(10) NOT NULL,
    "heures_N" double precision,
    "heures_F" double precision,
    "heures_PN" double precision,
    est_occasionnel boolean
);


ALTER TABLE public.lignes_pointage OWNER TO postgres;

--
-- Name: lignes_pointage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lignes_pointage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lignes_pointage_id_seq OWNER TO postgres;

--
-- Name: lignes_pointage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lignes_pointage_id_seq OWNED BY public.lignes_pointage.id;


--
-- Name: logs_activite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs_activite (
    id integer NOT NULL,
    utilisateur character varying(100) NOT NULL,
    action character varying(50) NOT NULL,
    table_concernee character varying(50),
    details text,
    created_at timestamp without time zone
);


ALTER TABLE public.logs_activite OWNER TO postgres;

--
-- Name: logs_activite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_activite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_activite_id_seq OWNER TO postgres;

--
-- Name: logs_activite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_activite_id_seq OWNED BY public.logs_activite.id;


--
-- Name: membres_equipe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membres_equipe (
    id integer NOT NULL,
    equipe_id integer NOT NULL,
    fonction character varying(100) NOT NULL,
    nom_prenom character varying(150) NOT NULL,
    matricule character varying(50),
    statut character varying(20),
    ordre integer,
    actif boolean DEFAULT true,
    date_naissance character varying(50),
    lieu_naissance character varying(100),
    cnps character varying(50),
    categorie_pro character varying(100),
    salaire_horaire double precision
);


ALTER TABLE public.membres_equipe OWNER TO postgres;

--
-- Name: membres_equipe_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.membres_equipe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membres_equipe_id_seq OWNER TO postgres;

--
-- Name: membres_equipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.membres_equipe_id_seq OWNED BY public.membres_equipe.id;


--
-- Name: oee_journalier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oee_journalier (
    id integer NOT NULL,
    date date NOT NULL,
    atelier character varying(50) NOT NULL,
    disponibilite double precision,
    performance double precision,
    qualite_oee double precision,
    oee double precision,
    production_reelle double precision,
    production_cible double precision,
    created_at timestamp without time zone,
    trs double precision,
    taux_utilisation double precision
);


ALTER TABLE public.oee_journalier OWNER TO postgres;

--
-- Name: oee_journalier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.oee_journalier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.oee_journalier_id_seq OWNER TO postgres;

--
-- Name: oee_journalier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.oee_journalier_id_seq OWNED BY public.oee_journalier.id;


--
-- Name: pointages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pointages (
    id integer NOT NULL,
    date date NOT NULL,
    chaine character varying(50) NOT NULL,
    equipe_id integer NOT NULL,
    equipe_nom character varying(100) NOT NULL,
    quart character varying(20) NOT NULL,
    saisi_par character varying(100) NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.pointages OWNER TO postgres;

--
-- Name: pointages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pointages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pointages_id_seq OWNER TO postgres;

--
-- Name: pointages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pointages_id_seq OWNED BY public.pointages.id;


--
-- Name: previsions_energie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.previsions_energie (
    id integer NOT NULL,
    atelier character varying(50) NOT NULL,
    date_prevision date NOT NULL,
    date_calcul date NOT NULL,
    valeur_predite double precision NOT NULL,
    borne_inf double precision,
    borne_sup double precision,
    created_at timestamp without time zone
);


ALTER TABLE public.previsions_energie OWNER TO postgres;

--
-- Name: previsions_energie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.previsions_energie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.previsions_energie_id_seq OWNER TO postgres;

--
-- Name: previsions_energie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.previsions_energie_id_seq OWNED BY public.previsions_energie.id;


--
-- Name: qualite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qualite (
    id integer CONSTRAINT qualite_id_not_null1 NOT NULL,
    date date NOT NULL,
    heure character varying(10) NOT NULL,
    quart character varying(20) NOT NULL,
    atelier character varying(50) NOT NULL,
    sertissage_data text,
    brix double precision,
    co2_qualite double precision,
    bo2 double precision,
    saisi_par character varying(100),
    created_at timestamp without time zone,
    type_volet character varying(10) DEFAULT 'AM'::character varying,
    produit character varying(50)
);


ALTER TABLE public.qualite OWNER TO postgres;

--
-- Name: qualite_a; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qualite_a (
    id integer NOT NULL,
    date date NOT NULL,
    heure character varying(10) NOT NULL,
    quart character varying(20) NOT NULL,
    atelier character varying(50) NOT NULL,
    produit character varying(50),
    densite_valeur double precision,
    densite_ecart double precision,
    saturation_valeur double precision,
    saturation_ecart double precision,
    saturation_pression double precision,
    saturation_temperature double precision,
    saturation_air_total double precision,
    o2_dissous double precision,
    gaz_etranger double precision,
    bilan_o2_total double precision,
    bilan_o2_col double precision,
    bilan_o2_reprise double precision,
    bilan_o2_bln double precision,
    bilan_o2_es double precision,
    pression_pissette double precision,
    contre_pression double precision,
    cadence_soutireuse double precision,
    debit_co2_balayage double precision,
    sertissage_data text,
    saisi_par character varying(100),
    created_at timestamp without time zone
);


ALTER TABLE public.qualite_a OWNER TO postgres;

--
-- Name: qualite_a_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qualite_a_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.qualite_a_id_seq OWNER TO postgres;

--
-- Name: qualite_a_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qualite_a_id_seq OWNED BY public.qualite_a.id;


--
-- Name: qualite_archive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qualite_archive (
    id integer CONSTRAINT qualite_id_not_null NOT NULL,
    date date,
    heure time without time zone,
    ligne character varying(50),
    sertissage_data text,
    brix numeric,
    co2 numeric,
    bo2 numeric
);


ALTER TABLE public.qualite_archive OWNER TO postgres;

--
-- Name: qualite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qualite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.qualite_id_seq OWNER TO postgres;

--
-- Name: qualite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qualite_id_seq OWNED BY public.qualite.id;


--
-- Name: resultats_anomalies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultats_anomalies (
    id integer NOT NULL,
    date date NOT NULL,
    atelier character varying(50) NOT NULL,
    quart character varying(20),
    score_anomalie double precision NOT NULL,
    est_anomalie boolean,
    index_elec double precision,
    index_eau_rincage double precision,
    index_eau_bain double precision,
    index_eau_pasteur double precision,
    index_eau_aero double precision,
    index_co2 double precision,
    production_hl double precision,
    brix double precision,
    co2_qualite double precision,
    bo2 double precision,
    ecart_elec_pct double precision,
    ecart_eau_rincage_pct double precision,
    ecart_eau_bain_pct double precision,
    ecart_eau_pasteur_pct double precision,
    ecart_eau_aero_pct double precision,
    ecart_production_pct double precision,
    message_xai text,
    created_at timestamp without time zone,
    pct_hors_sertissage double precision
);


ALTER TABLE public.resultats_anomalies OWNER TO postgres;

--
-- Name: resultats_anomalies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resultats_anomalies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resultats_anomalies_id_seq OWNER TO postgres;

--
-- Name: resultats_anomalies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resultats_anomalies_id_seq OWNED BY public.resultats_anomalies.id;


--
-- Name: scores_sante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scores_sante (
    id integer NOT NULL,
    date date NOT NULL,
    atelier character varying(50) NOT NULL,
    score double precision NOT NULL,
    niveau character varying(10) NOT NULL,
    taux_anomalies double precision,
    ecart_baseline double precision,
    taux_qualite double precision,
    created_at timestamp without time zone
);


ALTER TABLE public.scores_sante OWNER TO postgres;

--
-- Name: scores_sante_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scores_sante_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scores_sante_id_seq OWNER TO postgres;

--
-- Name: scores_sante_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scores_sante_id_seq OWNED BY public.scores_sante.id;


--
-- Name: utilisateurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilisateurs (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    actif boolean,
    created_at timestamp without time zone,
    last_login timestamp without time zone
);


ALTER TABLE public.utilisateurs OWNER TO postgres;

--
-- Name: utilisateurs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.utilisateurs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.utilisateurs_id_seq OWNER TO postgres;

--
-- Name: utilisateurs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.utilisateurs_id_seq OWNED BY public.utilisateurs.id;


--
-- Name: alertes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertes ALTER COLUMN id SET DEFAULT nextval('public.alertes_id_seq'::regclass);


--
-- Name: equipes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipes ALTER COLUMN id SET DEFAULT nextval('public.equipes_id_seq'::regclass);


--
-- Name: lean_energie id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lean_energie ALTER COLUMN id SET DEFAULT nextval('public.lean_energie_id_seq'::regclass);


--
-- Name: lignes_pointage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lignes_pointage ALTER COLUMN id SET DEFAULT nextval('public.lignes_pointage_id_seq'::regclass);


--
-- Name: logs_activite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs_activite ALTER COLUMN id SET DEFAULT nextval('public.logs_activite_id_seq'::regclass);


--
-- Name: membres_equipe id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membres_equipe ALTER COLUMN id SET DEFAULT nextval('public.membres_equipe_id_seq'::regclass);


--
-- Name: oee_journalier id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oee_journalier ALTER COLUMN id SET DEFAULT nextval('public.oee_journalier_id_seq'::regclass);


--
-- Name: pointages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pointages ALTER COLUMN id SET DEFAULT nextval('public.pointages_id_seq'::regclass);


--
-- Name: previsions_energie id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.previsions_energie ALTER COLUMN id SET DEFAULT nextval('public.previsions_energie_id_seq'::regclass);


--
-- Name: qualite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualite ALTER COLUMN id SET DEFAULT nextval('public.qualite_id_seq'::regclass);


--
-- Name: qualite_a id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualite_a ALTER COLUMN id SET DEFAULT nextval('public.qualite_a_id_seq'::regclass);


--
-- Name: resultats_anomalies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultats_anomalies ALTER COLUMN id SET DEFAULT nextval('public.resultats_anomalies_id_seq'::regclass);


--
-- Name: scores_sante id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scores_sante ALTER COLUMN id SET DEFAULT nextval('public.scores_sante_id_seq'::regclass);


--
-- Name: utilisateurs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs ALTER COLUMN id SET DEFAULT nextval('public.utilisateurs_id_seq'::regclass);


--
-- Data for Name: alertes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alertes (id, source, niveau, atelier, message, valeur, seuil, recommandation, lu, created_at) FROM stdin;
2	auto	critique	Chaîne 16	Ratio eau pasteurisateur élevé : 12574.708 m³/h (limite : 2.0)	12574.708	2	Inspection immédiate du circuit eau pasteurisateur. Risque de surconsommation critique.	t	2026-04-13 09:57:31.445824
1	auto	critique	Chaîne 16	Ratio eau laveuse élevé : 19.123 L/bte (limite : 0.6)	19.123	0.6	Arrêt recommandé pour inspection complète de la laveuse. Contacter la maintenance.	t	2026-04-13 09:57:31.406455
\.


--
-- Data for Name: equipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipes (id, nom, chaine, actif, created_at) FROM stdin;
1	Equipe BOSS Xavier	Chaîne 15	t	2026-03-25 07:12:51.337467
2		Chaîne 8	f	2026-03-30 14:19:01.731112
3	cnb	Chaîne 8	t	2026-04-14 07:49:22.778868
\.


--
-- Data for Name: lean_energie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lean_energie (id, date, heure, quart, atelier, index_eau_rincage, index_eau_bain, index_eau_pasteur, index_eau_aero, index_elec, index_co2, production_hl, saisi_par, created_at, arret_planifie) FROM stdin;
10	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-09 14:21:38.481403	f
11	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-09 14:21:38.481403	f
12	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-09 14:21:38.481403	f
13	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-09 14:21:38.481403	f
14	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-09 14:21:38.481403	f
15	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-09 14:21:38.481403	f
16	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-09 14:21:38.481403	f
17	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-09 14:21:38.481403	f
18	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-09 14:21:38.481403	f
19	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-09 14:41:44.61836	f
20	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-09 14:41:44.61836	f
21	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-09 14:41:44.61836	f
22	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-09 14:41:44.61836	f
23	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-09 14:41:44.61836	f
24	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-09 14:41:44.61836	f
25	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-09 14:41:44.61836	f
26	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-09 14:41:44.61836	f
27	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-09 14:41:44.61836	f
28	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-09 15:01:47.892097	f
29	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-09 15:01:47.892097	f
30	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-09 15:01:47.892097	f
31	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-09 15:01:47.892097	f
32	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-09 15:01:47.892097	f
33	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-09 15:01:47.892097	f
34	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-09 15:01:47.892097	f
35	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-09 15:01:47.892097	f
36	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-09 15:01:47.892097	f
37	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-10 07:17:09.127719	f
38	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-10 07:17:09.127719	f
39	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-10 07:17:09.127719	f
40	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-10 07:17:09.127719	f
41	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-10 07:17:09.127719	f
42	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-10 07:17:09.127719	f
43	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-10 07:17:09.127719	f
44	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-10 07:17:09.127719	f
45	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-10 07:17:09.127719	f
46	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-10 10:02:03.260452	f
47	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-10 10:02:03.260452	f
48	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-10 10:02:03.260452	f
49	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-10 10:02:03.260452	f
50	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-10 10:02:03.260452	f
51	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-10 10:02:03.260452	f
52	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-10 10:02:03.260452	f
53	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-10 10:02:03.260452	f
54	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-10 10:02:03.260452	f
55	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-10 10:56:06.858011	f
56	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-10 10:56:06.858011	f
57	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-10 10:56:06.858011	f
58	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-10 10:56:06.858011	f
59	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-10 10:56:06.858011	f
60	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-10 10:56:06.858011	f
61	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-10 10:56:06.858011	f
62	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-10 10:56:06.858011	f
63	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-10 10:56:06.858011	f
64	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-11 00:53:45.391321	f
65	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-11 00:53:45.391321	f
66	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-11 00:53:45.391321	f
67	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-11 00:53:45.391321	f
68	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-11 00:53:45.391321	f
69	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-11 00:53:45.391321	f
70	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-11 00:53:45.391321	f
71	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-11 00:53:45.391321	f
72	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-11 00:53:45.391321	f
73	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-11 07:26:12.584834	f
74	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-11 07:26:12.584834	f
75	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-11 07:26:12.584834	f
76	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-11 07:26:12.584834	f
77	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-11 07:26:12.584834	f
78	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-11 07:26:12.584834	f
79	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-11 07:26:12.584834	f
80	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-11 07:26:12.584834	f
81	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-11 07:26:12.584834	f
82	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-11 11:22:53.818659	f
83	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-11 11:22:53.818659	f
84	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-11 11:22:53.818659	f
85	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-11 11:22:53.818659	f
86	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-11 11:22:53.818659	f
87	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-11 11:22:53.818659	f
88	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-11 11:22:53.818659	f
89	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-11 11:22:53.818659	f
90	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-11 11:22:53.818659	f
91	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-13 11:36:11.264033	f
92	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-13 11:36:11.264033	f
93	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-13 11:36:11.264033	f
94	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-13 11:36:11.264033	f
95	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-13 11:36:11.264033	f
96	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-13 11:36:11.264033	f
97	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-13 11:36:11.264033	f
98	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-13 11:36:11.264033	f
99	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-13 11:36:11.264033	f
100	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-16 13:03:24.045441	f
101	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-16 13:03:24.045441	f
102	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-16 13:03:24.045441	f
103	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-16 13:03:24.045441	f
104	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-16 13:03:24.045441	f
105	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-16 13:03:24.045441	f
106	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-16 13:03:24.045441	f
107	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-16 13:03:24.045441	f
108	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-16 13:03:24.045441	f
109	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-23 09:32:04.403036	f
110	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-23 09:32:04.403036	f
111	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-23 09:32:04.403036	f
112	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-23 09:32:04.403036	f
113	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-23 09:32:04.403036	f
114	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-23 09:32:04.403036	f
115	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-23 09:32:04.403036	f
116	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-23 09:32:04.403036	f
117	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-23 09:32:04.403036	f
118	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-23 09:32:09.001322	f
119	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-23 09:32:09.001322	f
120	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-23 09:32:09.001322	f
121	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-23 09:32:09.001322	f
122	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-23 09:32:09.001322	f
123	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-23 09:32:09.001322	f
124	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-23 09:32:09.001322	f
125	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-23 09:32:09.001322	f
126	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-23 09:32:09.001322	f
127	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-25 09:21:15.368803	f
128	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-25 09:21:15.368803	f
129	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-25 09:21:15.368803	f
130	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-25 09:21:15.368803	f
131	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-25 09:21:15.368803	f
132	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-25 09:21:15.368803	f
133	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-25 09:21:15.368803	f
134	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-25 09:21:15.368803	f
135	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-25 09:21:15.368803	f
136	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-25 09:21:47.050751	f
137	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-25 09:21:47.050751	f
138	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-25 09:21:47.050751	f
139	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-25 09:21:47.050751	f
140	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-25 09:21:47.050751	f
141	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-25 09:21:47.050751	f
142	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-25 09:21:47.050751	f
143	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-25 09:21:47.050751	f
144	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-25 09:21:47.050751	f
145	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-26 11:17:40.752843	f
146	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-26 11:17:40.752843	f
147	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-26 11:17:40.752843	f
148	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-26 11:17:40.752843	f
149	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-26 11:17:40.752843	f
150	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-26 11:17:40.752843	f
151	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-26 11:17:40.752843	f
152	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-26 11:17:40.752843	f
153	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-26 11:17:40.752843	f
154	2026-03-01	06:05	22h-6h	Chaîne 8	14820	7640	2405	601	241000	18050	1020	operateur1	2026-03-30 07:48:17.94224	f
155	2026-03-01	14:08	6h-14h	Chaîne 8	14846	7664	2417	613	249100	19560	990	operateur1	2026-03-30 07:48:17.94224	f
156	2026-03-01	22:03	14h-22h	Chaîne 8	14872	7688	2429	625	257100	21060	1010	operateur2	2026-03-30 07:48:17.94224	f
157	2026-03-02	06:10	22h-6h	Chaîne 8	14898	7712	2441	637	265200	22570	1005	operateur1	2026-03-30 07:48:17.94224	f
158	2026-03-02	14:02	6h-14h	Chaîne 8	14924	7736	2453	649	273200	24070	1015	operateur1	2026-03-30 07:48:17.94224	f
159	2026-03-02	22:07	14h-22h	Chaîne 8	14958	7768	2465	661	281300	25585	995	operateur2	2026-03-30 07:48:17.94224	f
160	2026-03-03	06:12	22h-6h	Chaîne 8	14998	7806	2477	673	289400	27085	980	operateur1	2026-03-30 07:48:17.94224	f
161	2026-03-03	14:05	6h-14h	Chaîne 8	15052	7858	2489	685	297600	28600	950	operateur1	2026-03-30 07:48:17.94224	f
162	2026-03-03	22:09	14h-22h	Chaîne 8	15078	7882	2501	697	305600	30100	1000	operateur2	2026-03-30 07:48:17.94224	f
163	2026-04-06	08:00	6h-14h	Chaîne 16	133	130	99	200	245	128.88	2166.055	admin	2026-04-13 09:18:46.275763	f
164	2026-04-06	08:00	6h-14h	Chaîne 16	133	130	99	200	2454	128.88	2166.055	admin	2026-04-13 09:18:55.289129	f
165	2026-04-06	08:00	6h-14h	Chaîne 16	133	1300	995	200	2454	128.88	2166.055	admin	2026-04-13 09:19:32.582791	f
166	2026-04-06	08:00	6h-14h	Chaîne 16	133	1300	995	200	2454	128.88	2166.055	admin	2026-04-13 09:19:40.592789	f
167	2026-04-06	08:00	6h-14h	Chaîne 16	133	1300	995	200	2454	128.88	2166.055	admin	2026-04-13 09:20:21.89337	f
168	2026-04-06	08:00	6h-14h	Chaîne 16	21421	13002	99542	20023	24542	263096.81	2166.055	admin	2026-04-13 09:23:13.13141	f
169	2026-04-06	08:00	6h-14h	Chaîne 16	21421	13002	99542	20023	24542	263096.81	2166.055	admin	2026-04-13 09:23:36.754864	f
170	2026-04-13	09:24	6h-14h	Chaîne 16	3523532	235325	325325	23532	32532	574845	235325	admin	2026-04-13 09:25:36.289371	f
171	2026-04-13	09:24	6h-14h	Chaîne 16	3523532	235325	325325	23532	32532	574845	235325	admin	2026-04-13 09:33:30.264261	f
172	2026-04-13	09:56	6h-14h	Chaîne 16	235325	325325	3523	325325	32523	3523	23532	admin	2026-04-13 09:57:31.316166	f
173	2026-02-20	6h	6h-14h	Chaîne 8	990.15	204.33	9377.82	500.82	2684.17	183.82	1275.3	simulation	2026-05-21 00:11:47.614469	f
174	2026-02-20	14h	14h-22h	Chaîne 8	1152.93	225.38	10455.72	489.5	3024.71	200.14	1395.89	simulation	2026-05-21 00:11:47.614469	f
175	2026-02-20	22h	22h-6h	Chaîne 8	945.62	201.32	9220.85	471.54	2538.38	169.1	1042.71	simulation	2026-05-21 00:11:47.614469	f
176	2026-02-20	6h	6h-14h	Chaîne 14	644.71	244.27	8648.45	409.37	2264.7	155.76	1165.73	simulation	2026-05-21 00:11:47.614469	f
177	2026-02-20	14h	14h-22h	Chaîne 14	668.87	248	8533.64	454.52	2408.7	165	1172.02	simulation	2026-05-21 00:11:47.614469	f
178	2026-02-20	22h	22h-6h	Chaîne 14	604.31	213.77	7838.11	403.65	2091.35	147.17	931.58	simulation	2026-05-21 00:11:47.614469	f
179	2026-02-20	6h	6h-14h	Chaîne 15	549.63	23.15	1547.08	394.7	2082.07	145.82	1028.22	simulation	2026-05-21 00:11:47.614469	f
180	2026-02-20	14h	14h-22h	Chaîne 15	567.91	23.42	1511.92	399.12	2337.9	139.1	1000.25	simulation	2026-05-21 00:11:47.614469	f
181	2026-02-20	22h	22h-6h	Chaîne 15	515.76	20.69	1446.11	364.71	2058.1	129.63	896.99	simulation	2026-05-21 00:11:47.614469	f
182	2026-02-20	6h	6h-14h	Chaîne 16	700.71	101.96	4918.08	463.72	2740.46	591.39	1124.55	simulation	2026-05-21 00:11:47.614469	f
183	2026-02-20	14h	14h-22h	Chaîne 16	699.62	101.65	4993.6	512.28	2686.55	687.44	1356.38	simulation	2026-05-21 00:11:47.614469	f
184	2026-02-20	22h	22h-6h	Chaîne 16	652.13	97.26	4202.93	425.27	2370.38	538.35	1052.77	simulation	2026-05-21 00:11:47.614469	f
185	2026-02-21	6h	6h-14h	Chaîne 8	1071.5	206.58	9199.45	496.6	2716.65	176.33	1164.27	simulation	2026-05-21 00:11:47.614469	f
186	2026-02-21	14h	14h-22h	Chaîne 8	1176.01	232.37	9501.83	471.99	2907.81	199.27	1354.2	simulation	2026-05-21 00:11:47.614469	f
187	2026-02-21	22h	22h-6h	Chaîne 8	981.11	200.38	8534.1	439.28	2304.29	170.52	1082.37	simulation	2026-05-21 00:11:47.614469	f
188	2026-02-21	6h	6h-14h	Chaîne 14	621.26	237.14	8351.16	418.07	2310.91	161.68	1115.67	simulation	2026-05-21 00:11:47.614469	f
189	2026-02-21	14h	14h-22h	Chaîne 14	666.05	236.59	8604.79	437.25	2482.06	154.94	1092.58	simulation	2026-05-21 00:11:47.614469	f
190	2026-02-21	22h	22h-6h	Chaîne 14	601.5	209.35	7711.56	378.59	2217.1	143.9	1056.61	simulation	2026-05-21 00:11:47.614469	f
191	2026-02-21	6h	6h-14h	Chaîne 15	607.07	20.97	1446.69	387.06	2238.61	144	1051.84	simulation	2026-05-21 00:11:47.614469	f
192	2026-02-21	14h	14h-22h	Chaîne 15	613.48	23.57	1562.6	400.8	2182.09	150.95	982.2	simulation	2026-05-21 00:11:47.614469	f
193	2026-02-21	22h	22h-6h	Chaîne 15	514.19	20.93	1392.54	371.88	1870.01	127.93	898.15	simulation	2026-05-21 00:11:47.614469	f
194	2026-02-21	6h	6h-14h	Chaîne 16	685.8	104.42	4666.89	506.69	2702.54	625.51	1194.12	simulation	2026-05-21 00:11:47.614469	f
195	2026-02-21	14h	14h-22h	Chaîne 16	771.7	100.39	4600.19	504.22	2885.81	631.8	1208.46	simulation	2026-05-21 00:11:47.614469	f
196	2026-02-21	22h	22h-6h	Chaîne 16	683.74	98.92	4345.21	450.71	2435.66	530.79	1002.82	simulation	2026-05-21 00:11:47.614469	f
197	2026-02-22	6h	6h-14h	Chaîne 8	940.18	185.22	9758.31	484.36	2186.97	149.59	991.16	simulation	2026-05-21 00:11:47.614469	f
198	2026-02-22	14h	14h-22h	Chaîne 8	907.15	202.01	10384.26	494.44	2495.17	161.3	1187	simulation	2026-05-21 00:11:47.614469	f
199	2026-02-22	22h	22h-6h	Chaîne 8	757.17	170.74	8853.34	455.73	2035.38	139.85	919.85	simulation	2026-05-21 00:11:47.614469	f
200	2026-02-22	6h	6h-14h	Chaîne 14	533.92	204.33	8367.91	430.42	2073.51	141.86	894.29	simulation	2026-05-21 00:11:47.614469	f
201	2026-02-22	14h	14h-22h	Chaîne 14	555.44	212.92	9335.68	416.63	2191.95	144.55	922.17	simulation	2026-05-21 00:11:47.614469	f
202	2026-02-22	22h	22h-6h	Chaîne 14	488.25	180	8204.22	408.46	1754.14	120.63	798.35	simulation	2026-05-21 00:11:47.614469	f
203	2026-02-22	6h	6h-14h	Chaîne 15	506.28	18.94	1506.82	402.49	1785.58	121.59	856.69	simulation	2026-05-21 00:11:47.614469	f
204	2026-02-22	14h	14h-22h	Chaîne 15	481.18	21.06	1633.36	414.79	2013.35	132.04	931.82	simulation	2026-05-21 00:11:47.614469	f
205	2026-02-22	22h	22h-6h	Chaîne 15	473.18	16.63	1417.76	375.81	1590.34	112.27	813.88	simulation	2026-05-21 00:11:47.614469	f
206	2026-02-22	6h	6h-14h	Chaîne 16	591.52	81.18	4708.2	459.89	2321.23	543.77	972.21	simulation	2026-05-21 00:11:47.614469	f
207	2026-02-22	14h	14h-22h	Chaîne 16	588.4	91.44	4975.3	495.97	2511.69	557.26	1164.21	simulation	2026-05-21 00:11:47.614469	f
208	2026-02-22	22h	22h-6h	Chaîne 16	564.41	79.04	4133.84	447.09	1985.34	484.5	901.64	simulation	2026-05-21 00:11:47.614469	f
209	2026-02-23	6h	6h-14h	Chaîne 8	0	64.99	0	73.7	311.77	0	0	simulation	2026-05-21 00:11:47.614469	t
210	2026-02-23	14h	14h-22h	Chaîne 8	0	68.73	0	77.21	355.85	0	0	simulation	2026-05-21 00:11:47.614469	t
211	2026-02-23	22h	22h-6h	Chaîne 8	0	65.38	0	74.3	321.18	0	0	simulation	2026-05-21 00:11:47.614469	t
212	2026-02-23	6h	6h-14h	Chaîne 14	667.7	245.33	8486.38	415.43	2240.93	161.84	1046.99	simulation	2026-05-21 00:11:47.614469	f
213	2026-02-23	14h	14h-22h	Chaîne 14	671.63	238.11	9077.64	439.88	2503.3	163.08	1081.28	simulation	2026-05-21 00:11:47.614469	f
214	2026-02-23	22h	22h-6h	Chaîne 14	592.6	215.77	8443.68	416.52	2121.08	135.87	1034.99	simulation	2026-05-21 00:11:47.614469	f
215	2026-02-23	6h	6h-14h	Chaîne 15	567.81	21.5	1504.46	388.07	2162.2	135.38	981.64	simulation	2026-05-21 00:11:47.614469	f
216	2026-02-23	14h	14h-22h	Chaîne 15	577.6	22.83	1482.31	404.28	2228.44	143.54	1012.15	simulation	2026-05-21 00:11:47.614469	f
217	2026-02-23	22h	22h-6h	Chaîne 15	510.18	20.15	1388.55	364.25	1971.39	125.85	907.73	simulation	2026-05-21 00:11:47.614469	f
218	2026-02-23	6h	6h-14h	Chaîne 16	730.58	99.08	4594.54	477	2648.36	596.21	1145.12	simulation	2026-05-21 00:11:47.614469	f
219	2026-02-23	14h	14h-22h	Chaîne 16	735.35	101.66	4941.93	492.86	2787.81	685.42	1248.04	simulation	2026-05-21 00:11:47.614469	f
220	2026-02-23	22h	22h-6h	Chaîne 16	631.94	93.95	4207.2	477.82	2246.45	550.54	1000.8	simulation	2026-05-21 00:11:47.614469	f
221	2026-02-24	6h	6h-14h	Chaîne 8	989.07	210.39	9399.62	466.17	2670.65	178.47	1222.04	simulation	2026-05-21 00:11:47.614469	f
222	2026-02-24	14h	14h-22h	Chaîne 8	1128.2	232.84	9508.24	513.38	2757.69	198.06	1367.45	simulation	2026-05-21 00:11:47.614469	f
223	2026-02-24	22h	22h-6h	Chaîne 8	974.04	197.23	9533.82	452.7	2467.54	163.63	1163.96	simulation	2026-05-21 00:11:47.614469	f
224	2026-02-24	6h	6h-14h	Chaîne 14	0	69.64	0	67.14	289.82	0	0	simulation	2026-05-21 00:11:47.614469	t
225	2026-02-24	14h	14h-22h	Chaîne 14	0	75.91	0	62.02	296.65	0	0	simulation	2026-05-21 00:11:47.614469	t
226	2026-02-24	22h	22h-6h	Chaîne 14	0	71.95	0	61.18	281.26	0	0	simulation	2026-05-21 00:11:47.614469	t
227	2026-02-24	6h	6h-14h	Chaîne 15	594.22	21.65	1512.44	399.2	2044.03	142.78	1008.08	simulation	2026-05-21 00:11:47.614469	f
228	2026-02-24	14h	14h-22h	Chaîne 15	578.79	23.03	1483.96	405.96	2337.04	153.78	1077.34	simulation	2026-05-21 00:11:47.614469	f
229	2026-02-24	22h	22h-6h	Chaîne 15	556.09	21.15	1449.61	354.22	1929.34	135.52	884.09	simulation	2026-05-21 00:11:47.614469	f
230	2026-02-24	6h	6h-14h	Chaîne 16	678.84	101.7	4715.04	493.8	2490.59	639.86	1183.98	simulation	2026-05-21 00:11:47.614469	f
231	2026-02-24	14h	14h-22h	Chaîne 16	713.92	102.59	4831.42	479.76	2669.29	687.81	1205.58	simulation	2026-05-21 00:11:47.614469	f
232	2026-02-24	22h	22h-6h	Chaîne 16	643.27	94.53	4122.6	451.28	2401.82	576.66	1044.37	simulation	2026-05-21 00:11:47.614469	f
233	2026-02-25	6h	6h-14h	Chaîne 8	1076.3	204.95	10067.53	479.31	2650.25	183.75	1292.14	simulation	2026-05-21 00:11:47.614469	f
234	2026-02-25	14h	14h-22h	Chaîne 8	1147.65	221.99	10220.47	521.81	2795.18	207.8	1376.04	simulation	2026-05-21 00:11:47.614469	f
235	2026-02-25	22h	22h-6h	Chaîne 8	952.88	195.56	8857.33	476.48	2313.32	169.48	1050.45	simulation	2026-05-21 00:11:47.614469	f
236	2026-02-25	6h	6h-14h	Chaîne 14	645.51	223.33	8639.17	443.27	2384.85	150.43	1126.79	simulation	2026-05-21 00:11:47.614469	f
237	2026-02-25	14h	14h-22h	Chaîne 14	632.3	257.13	9435.85	435.19	2581.62	164.13	1200.38	simulation	2026-05-21 00:11:47.614469	f
238	2026-02-25	22h	22h-6h	Chaîne 14	594.88	223.29	8184.94	414.16	2070.98	137.64	1034.11	simulation	2026-05-21 00:11:47.614469	f
239	2026-02-25	6h	6h-14h	Chaîne 15	0	6.45	0	58.73	246.87	0	0	simulation	2026-05-21 00:11:47.614469	t
240	2026-02-25	14h	14h-22h	Chaîne 15	0	7.23	0	60.85	264.08	0	0	simulation	2026-05-21 00:11:47.614469	t
241	2026-02-25	22h	22h-6h	Chaîne 15	0	6.3	0	62.37	247.93	0	0	simulation	2026-05-21 00:11:47.614469	t
242	2026-02-25	6h	6h-14h	Chaîne 16	727.88	96.63	4466.56	464.82	2575.07	638.43	1220.3	simulation	2026-05-21 00:11:47.614469	f
243	2026-02-25	14h	14h-22h	Chaîne 16	733.52	103.5	4512.53	492.47	2789.33	683.19	1320.55	simulation	2026-05-21 00:11:47.614469	f
244	2026-02-25	22h	22h-6h	Chaîne 16	641.98	94.35	4360	463.38	2338.22	540.33	996.52	simulation	2026-05-21 00:11:47.614469	f
245	2026-02-26	6h	6h-14h	Chaîne 8	994.11	210.1	9454.7	505.45	2755.23	185	1165.23	simulation	2026-05-21 00:11:47.614469	f
246	2026-02-26	14h	14h-22h	Chaîne 8	1118.43	233.81	9657.42	509.11	3006.26	206.2	1413.99	simulation	2026-05-21 00:11:47.614469	f
247	2026-02-26	22h	22h-6h	Chaîne 8	875.91	210.44	9521.21	432.11	2529.03	173.49	1086.28	simulation	2026-05-21 00:11:47.614469	f
248	2026-02-26	6h	6h-14h	Chaîne 14	641.03	233.67	8365.87	423.18	2499.96	155.72	1137.61	simulation	2026-05-21 00:11:47.614469	f
249	2026-02-26	14h	14h-22h	Chaîne 14	671.18	252.57	8810.99	458.75	2600.27	158.93	1159.19	simulation	2026-05-21 00:11:47.614469	f
250	2026-02-26	22h	22h-6h	Chaîne 14	550.44	206.67	7818.76	403.04	2050.53	148.64	941.94	simulation	2026-05-21 00:11:47.614469	f
251	2026-02-26	6h	6h-14h	Chaîne 15	579.54	22.95	1459.51	397.34	2229.57	133.26	934.75	simulation	2026-05-21 00:11:47.614469	f
252	2026-02-26	14h	14h-22h	Chaîne 15	625.27	22.2	1553.88	420.34	2244.21	144.07	1063.9	simulation	2026-05-21 00:11:47.614469	f
253	2026-02-26	22h	22h-6h	Chaîne 15	512	20.33	1435.06	364.22	1879.32	121.04	872.84	simulation	2026-05-21 00:11:47.614469	f
254	2026-02-26	6h	6h-14h	Chaîne 16	0	31.62	0	71.29	309.37	0	0	simulation	2026-05-21 00:11:47.614469	t
255	2026-02-26	14h	14h-22h	Chaîne 16	0	31.72	0	71.26	334.76	0	0	simulation	2026-05-21 00:11:47.614469	t
256	2026-02-26	22h	22h-6h	Chaîne 16	0	31.45	0	75.89	301.23	0	0	simulation	2026-05-21 00:11:47.614469	t
257	2026-02-27	6h	6h-14h	Chaîne 8	1004.15	205.48	10220.63	469.52	2790.23	175.99	1289.2	simulation	2026-05-21 00:11:47.614469	f
258	2026-02-27	14h	14h-22h	Chaîne 8	1121.91	227.99	9587.71	506.2	2885.39	204.04	1387.33	simulation	2026-05-21 00:11:47.614469	f
259	2026-02-27	22h	22h-6h	Chaîne 8	922.24	188.21	8759.83	453.49	2531.53	164.05	1104	simulation	2026-05-21 00:11:47.614469	f
260	2026-02-27	6h	6h-14h	Chaîne 14	605.67	245.89	8885.01	441.18	2464.44	151.64	1163.62	simulation	2026-05-21 00:11:47.614469	f
261	2026-02-27	14h	14h-22h	Chaîne 14	626.46	255.73	8570.1	431.44	2338.83	163.38	1079.34	simulation	2026-05-21 00:11:47.614469	f
262	2026-02-27	22h	22h-6h	Chaîne 14	572.78	206.38	8005.6	386.61	2154.82	145.55	1008.64	simulation	2026-05-21 00:11:47.614469	f
263	2026-02-27	6h	6h-14h	Chaîne 15	542.63	22.69	1495.73	385.3	2048.03	141.64	927.98	simulation	2026-05-21 00:11:47.614469	f
264	2026-02-27	14h	14h-22h	Chaîne 15	581	24.05	1590.65	387.73	2267.68	140.52	972.12	simulation	2026-05-21 00:11:47.614469	f
265	2026-02-27	22h	22h-6h	Chaîne 15	526.48	20.34	1448.55	385.08	1911.46	122.07	895.96	simulation	2026-05-21 00:11:47.614469	f
266	2026-02-27	6h	6h-14h	Chaîne 16	714.52	95.49	4872.51	481.58	2729.94	582.85	1287.94	simulation	2026-05-21 00:11:47.614469	f
267	2026-02-27	14h	14h-22h	Chaîne 16	700.03	98.68	4698.57	508.4	2778.85	627.48	1236.92	simulation	2026-05-21 00:11:47.614469	f
268	2026-02-27	22h	22h-6h	Chaîne 16	675.75	95.14	4490.41	461.36	2396.99	582.26	1109.96	simulation	2026-05-21 00:11:47.614469	f
269	2026-02-28	6h	6h-14h	Chaîne 8	994.62	217.29	9707.69	494.51	2494.22	180.02	1183.76	simulation	2026-05-21 00:11:47.614469	f
270	2026-02-28	14h	14h-22h	Chaîne 8	1154.54	230.88	9442.17	509.13	2850.44	203.71	1254.68	simulation	2026-05-21 00:11:47.614469	f
271	2026-02-28	22h	22h-6h	Chaîne 8	938.25	205.3	8726.99	453.39	2283.29	154.72	1153.25	simulation	2026-05-21 00:11:47.614469	f
272	2026-02-28	6h	6h-14h	Chaîne 14	618.41	245.77	8549.08	434.75	2366.05	148.67	1028.28	simulation	2026-05-21 00:11:47.614469	f
273	2026-02-28	14h	14h-22h	Chaîne 14	685.45	251.47	8481.4	442.22	2514.99	159.06	1120.57	simulation	2026-05-21 00:11:47.614469	f
274	2026-02-28	22h	22h-6h	Chaîne 14	565.62	223.55	8314.46	413.11	2090.3	140.09	942.66	simulation	2026-05-21 00:11:47.614469	f
275	2026-02-28	6h	6h-14h	Chaîne 15	563.12	20.92	1487.65	389.14	2242.91	141.23	1007.78	simulation	2026-05-21 00:11:47.614469	f
276	2026-02-28	14h	14h-22h	Chaîne 15	579.64	22.17	1558.37	387.83	2332.69	148.18	1072.5	simulation	2026-05-21 00:11:47.614469	f
277	2026-02-28	22h	22h-6h	Chaîne 15	558.3	20.47	1406.59	354.13	1962.41	125.55	853.55	simulation	2026-05-21 00:11:47.614469	f
278	2026-02-28	6h	6h-14h	Chaîne 16	756.56	100.76	4707.38	466.86	2703.54	656.31	1273.27	simulation	2026-05-21 00:11:47.614469	f
279	2026-02-28	14h	14h-22h	Chaîne 16	702.26	109.64	4932.33	522.05	2682.63	670.72	1208.54	simulation	2026-05-21 00:11:47.614469	f
280	2026-02-28	22h	22h-6h	Chaîne 16	698.62	89.29	4453.91	458.58	2286.81	584.86	1073.28	simulation	2026-05-21 00:11:47.614469	f
281	2026-03-01	6h	6h-14h	Chaîne 8	897.54	187.03	9226.37	492.5	2306.47	155.09	1017.18	simulation	2026-05-21 00:11:47.614469	f
282	2026-03-01	14h	14h-22h	Chaîne 8	899.42	183.21	9646.82	471.82	2390.26	176.04	1092.54	simulation	2026-05-21 00:11:47.614469	f
283	2026-03-01	22h	22h-6h	Chaîne 8	782.78	170.68	9418.17	451.54	2115.77	145.5	922.95	simulation	2026-05-21 00:11:47.614469	f
284	2026-03-01	6h	6h-14h	Chaîne 14	511.71	197.91	8622.47	422.99	2119.98	130.69	911.85	simulation	2026-05-21 00:11:47.614469	f
285	2026-03-01	14h	14h-22h	Chaîne 14	528.18	202.47	8524.04	446.39	2125.57	142.83	883.32	simulation	2026-05-21 00:11:47.614469	f
286	2026-03-01	22h	22h-6h	Chaîne 14	500.28	176.53	7837.72	417.38	1810.95	125.26	866.13	simulation	2026-05-21 00:11:47.614469	f
287	2026-03-01	6h	6h-14h	Chaîne 15	496.69	17.86	1447.59	389.94	1833.73	121.2	790.03	simulation	2026-05-21 00:11:47.614469	f
288	2026-03-01	14h	14h-22h	Chaîne 15	531.04	20.28	1551.38	397.93	1862.87	122.58	832.6	simulation	2026-05-21 00:11:47.614469	f
289	2026-03-01	22h	22h-6h	Chaîne 15	461.97	17.85	1452.28	390.26	1703.31	105.94	749.77	simulation	2026-05-21 00:11:47.614469	f
290	2026-03-01	6h	6h-14h	Chaîne 16	631.4	83.28	4537.76	473.01	2192.05	549.21	1015.19	simulation	2026-05-21 00:11:47.614469	f
291	2026-03-01	14h	14h-22h	Chaîne 16	642.26	88.32	4916.16	470.24	2289.43	567.78	1106.9	simulation	2026-05-21 00:11:47.614469	f
292	2026-03-01	22h	22h-6h	Chaîne 16	594.92	78.49	4182.51	475.3	1986.26	498.93	905.92	simulation	2026-05-21 00:11:47.614469	f
293	2026-03-02	6h	6h-14h	Chaîne 8	0	61.26	0	73.98	322.98	0	0	simulation	2026-05-21 00:11:47.614469	t
294	2026-03-02	14h	14h-22h	Chaîne 8	0	68.62	0	69.59	328.26	0	0	simulation	2026-05-21 00:11:47.614469	t
295	2026-03-02	22h	22h-6h	Chaîne 8	0	61.54	0	69.67	317.48	0	0	simulation	2026-05-21 00:11:47.614469	t
296	2026-03-02	6h	6h-14h	Chaîne 14	612.04	227.5	8481.71	433.2	2263.74	152.34	1115.15	simulation	2026-05-21 00:11:47.614469	f
297	2026-03-02	14h	14h-22h	Chaîne 14	655.08	233.04	8557	416.29	2407.98	160.09	1176.14	simulation	2026-05-21 00:11:47.614469	f
298	2026-03-02	22h	22h-6h	Chaîne 14	599.28	219.61	8408.17	383.1	2242.58	146.59	909.27	simulation	2026-05-21 00:11:47.614469	f
299	2026-03-02	6h	6h-14h	Chaîne 15	589.12	22.47	1583.25	399.64	2107.94	142.1	1054.93	simulation	2026-05-21 00:11:47.614469	f
300	2026-03-02	14h	14h-22h	Chaîne 15	588.7	24.31	1555.95	421.2	2172.64	145.95	957.77	simulation	2026-05-21 00:11:47.614469	f
301	2026-03-02	22h	22h-6h	Chaîne 15	561.61	19.95	1429.45	377.21	2043.85	121.34	845.71	simulation	2026-05-21 00:11:47.614469	f
302	2026-03-02	6h	6h-14h	Chaîne 16	754.29	96.13	4716.04	498.41	2642.64	592.35	1178.38	simulation	2026-05-21 00:11:47.614469	f
303	2026-03-02	14h	14h-22h	Chaîne 16	772.64	104.09	4876.56	484.16	2855.52	628.51	1244.86	simulation	2026-05-21 00:11:47.614469	f
304	2026-03-02	22h	22h-6h	Chaîne 16	687.16	94.62	4208.14	466.44	2486	578.97	1045.74	simulation	2026-05-21 00:11:47.614469	f
305	2026-03-03	6h	6h-14h	Chaîne 8	1040.99	211.43	9269.4	491.91	2601.1	174.71	1167.47	simulation	2026-05-21 00:11:47.614469	f
306	2026-03-03	14h	14h-22h	Chaîne 8	1084.09	231.2	9930.21	526.34	2868.47	206.63	1428.08	simulation	2026-05-21 00:11:47.614469	f
307	2026-03-03	22h	22h-6h	Chaîne 8	892.88	210.9	9062.11	426.13	2526.49	155.15	1119.67	simulation	2026-05-21 00:11:47.614469	f
308	2026-03-03	6h	6h-14h	Chaîne 14	0	66.7	0	66.15	282.83	0	0	simulation	2026-05-21 00:11:47.614469	t
309	2026-03-03	14h	14h-22h	Chaîne 14	0	73.22	0	65.72	291.61	0	0	simulation	2026-05-21 00:11:47.614469	t
310	2026-03-03	22h	22h-6h	Chaîne 14	0	70.31	0	66.36	286.21	0	0	simulation	2026-05-21 00:11:47.614469	t
311	2026-03-03	6h	6h-14h	Chaîne 15	604.54	20.96	1586.81	386.56	2045.42	134	1021.6	simulation	2026-05-21 00:11:47.614469	f
312	2026-03-03	14h	14h-22h	Chaîne 15	585.4	23.87	1568.06	387.49	2201.95	141.96	1074.63	simulation	2026-05-21 00:11:47.614469	f
313	2026-03-03	22h	22h-6h	Chaîne 15	527.38	19.24	1382.26	355.97	1922.69	132.03	884.6	simulation	2026-05-21 00:11:47.614469	f
314	2026-03-03	6h	6h-14h	Chaîne 16	715.6	103.3	4596.77	468.9	2798	640.25	1244.78	simulation	2026-05-21 00:11:47.614469	f
315	2026-03-03	14h	14h-22h	Chaîne 16	728.37	98.38	5040.27	484.26	2794.79	675.03	1279.36	simulation	2026-05-21 00:11:47.614469	f
316	2026-03-03	22h	22h-6h	Chaîne 16	646.13	97.44	4459.8	450.05	2272.65	557.51	1032.41	simulation	2026-05-21 00:11:47.614469	f
317	2026-03-04	6h	6h-14h	Chaîne 8	1020.33	215.65	15666.06	484.28	3008.57	181.96	1148.12	simulation	2026-05-21 00:11:47.614469	f
318	2026-03-04	14h	14h-22h	Chaîne 8	1177.21	213.19	15292.81	499.35	3387.91	193.12	1221.08	simulation	2026-05-21 00:11:47.614469	f
319	2026-03-04	22h	22h-6h	Chaîne 8	884.37	191.44	13732.04	449.4	2698.26	155.12	1041.44	simulation	2026-05-21 00:11:47.614469	f
320	2026-03-04	6h	6h-14h	Chaîne 14	653.05	223.78	8300.66	420.83	2381.06	164.25	1151.71	simulation	2026-05-21 00:11:47.614469	f
321	2026-03-04	14h	14h-22h	Chaîne 14	662.89	252.73	9179.72	465.03	2606.45	163.41	1114.95	simulation	2026-05-21 00:11:47.614469	f
322	2026-03-04	22h	22h-6h	Chaîne 14	568.29	225.97	7893.92	423.32	2145.97	146.37	1042.53	simulation	2026-05-21 00:11:47.614469	f
323	2026-03-04	6h	6h-14h	Chaîne 15	0	6.98	0	62.23	258.48	0	0	simulation	2026-05-21 00:11:47.614469	t
324	2026-03-04	14h	14h-22h	Chaîne 15	0	6.89	0	62.85	275.68	0	0	simulation	2026-05-21 00:11:47.614469	t
325	2026-03-04	22h	22h-6h	Chaîne 15	0	6.43	0	57.42	266.34	0	0	simulation	2026-05-21 00:11:47.614469	t
326	2026-03-04	6h	6h-14h	Chaîne 16	679.59	103.59	4659.85	487.37	2664.29	620.18	1179.59	simulation	2026-05-21 00:11:47.614469	f
327	2026-03-04	14h	14h-22h	Chaîne 16	712.14	100.74	4726.68	487.63	2670.32	630.92	1368.67	simulation	2026-05-21 00:11:47.614469	f
328	2026-03-04	22h	22h-6h	Chaîne 16	643.62	94.79	4422.72	433.43	2514.09	577.73	1057.42	simulation	2026-05-21 00:11:47.614469	f
329	2026-03-05	6h	6h-14h	Chaîne 8	1010.17	197.98	9965.13	496.47	2612.75	189.51	1238.53	simulation	2026-05-21 00:11:47.614469	f
330	2026-03-05	14h	14h-22h	Chaîne 8	1118.79	237.19	9942.18	483.17	2856.01	197.58	1425.62	simulation	2026-05-21 00:11:47.614469	f
331	2026-03-05	22h	22h-6h	Chaîne 8	927.44	188.17	8945.69	441.66	2526.13	158.4	1004.02	simulation	2026-05-21 00:11:47.614469	f
332	2026-03-05	6h	6h-14h	Chaîne 14	617.64	239.48	8402.93	407.09	2409.57	149.46	1086.04	simulation	2026-05-21 00:11:47.614469	f
333	2026-03-05	14h	14h-22h	Chaîne 14	655.54	235.76	9269.55	457.42	2341.44	170.69	1054.13	simulation	2026-05-21 00:11:47.614469	f
334	2026-03-05	22h	22h-6h	Chaîne 14	557.55	225.79	8473.2	388.15	2187.79	136.57	999.17	simulation	2026-05-21 00:11:47.614469	f
335	2026-03-05	6h	6h-14h	Chaîne 15	588.89	22.77	1465.12	383.3	2193.4	149.15	1025.25	simulation	2026-05-21 00:11:47.614469	f
336	2026-03-05	14h	14h-22h	Chaîne 15	569.28	22.11	1632.74	417.3	2211.43	142.28	1056.07	simulation	2026-05-21 00:11:47.614469	f
337	2026-03-05	22h	22h-6h	Chaîne 15	513.37	20.44	1492.37	349.72	2067.52	132.98	830.91	simulation	2026-05-21 00:11:47.614469	f
338	2026-03-05	6h	6h-14h	Chaîne 16	0	28.8	0	69.96	331.35	0	0	simulation	2026-05-21 00:11:47.614469	t
339	2026-03-05	14h	14h-22h	Chaîne 16	0	30	0	69.77	326.1	0	0	simulation	2026-05-21 00:11:47.614469	t
340	2026-03-05	22h	22h-6h	Chaîne 16	0	30.09	0	71.46	325.7	0	0	simulation	2026-05-21 00:11:47.614469	t
341	2026-03-06	6h	6h-14h	Chaîne 8	1111.92	205.58	9550.68	502.44	2581.44	178.5	1243.37	simulation	2026-05-21 00:11:47.614469	f
342	2026-03-06	14h	14h-22h	Chaîne 8	1179.35	215.1	9345.16	488.14	2936.92	190.27	1297.8	simulation	2026-05-21 00:11:47.614469	f
343	2026-03-06	22h	22h-6h	Chaîne 8	971.05	208.82	8725.17	461.21	2373.52	165.69	1004.76	simulation	2026-05-21 00:11:47.614469	f
344	2026-03-06	6h	6h-14h	Chaîne 14	655.87	225.53	8347.49	435.07	2376.52	157.77	1106.31	simulation	2026-05-21 00:11:47.614469	f
345	2026-03-06	14h	14h-22h	Chaîne 14	629.94	231.43	9244.58	424.76	2451.28	161.73	1168.27	simulation	2026-05-21 00:11:47.614469	f
346	2026-03-06	22h	22h-6h	Chaîne 14	592.26	203.29	8199.77	409.64	2059.4	135.37	926.75	simulation	2026-05-21 00:11:47.614469	f
347	2026-03-06	6h	6h-14h	Chaîne 15	577.18	21.17	1534.12	394	2250.89	148.21	904.97	simulation	2026-05-21 00:11:47.614469	f
348	2026-03-06	14h	14h-22h	Chaîne 15	573.17	22.48	1654.11	423.78	2170.6	143.87	1026.89	simulation	2026-05-21 00:11:47.614469	f
349	2026-03-06	22h	22h-6h	Chaîne 15	559.62	19.9	1473.44	350.9	2059	123.48	931.26	simulation	2026-05-21 00:11:47.614469	f
350	2026-03-06	6h	6h-14h	Chaîne 16	749.63	99.88	4573.83	482.53	2793.85	601.16	1181.73	simulation	2026-05-21 00:11:47.614469	f
351	2026-03-06	14h	14h-22h	Chaîne 16	742.3	98.48	4775.14	473.46	2778.9	685	1265.15	simulation	2026-05-21 00:11:47.614469	f
352	2026-03-06	22h	22h-6h	Chaîne 16	658.17	96.95	4559.91	454.59	2347.06	569.63	1021.91	simulation	2026-05-21 00:11:47.614469	f
353	2026-03-07	6h	6h-14h	Chaîne 8	1090.98	198.63	9290.57	495.96	2658.23	169.99	1267.94	simulation	2026-05-21 00:11:47.614469	f
354	2026-03-07	14h	14h-22h	Chaîne 8	1072.8	229.64	9626.17	498.35	2844.68	199.49	1367.55	simulation	2026-05-21 00:11:47.614469	f
355	2026-03-07	22h	22h-6h	Chaîne 8	874.38	188.53	9156.81	432.14	2535.42	170.52	1142.2	simulation	2026-05-21 00:11:47.614469	f
356	2026-03-07	6h	6h-14h	Chaîne 14	646.1	235.48	8863.26	452.32	2460.75	158.7	1051.51	simulation	2026-05-21 00:11:47.614469	f
357	2026-03-07	14h	14h-22h	Chaîne 14	649.18	247.6	9294.19	453.94	2489.43	168.27	1088.7	simulation	2026-05-21 00:11:47.614469	f
358	2026-03-07	22h	22h-6h	Chaîne 14	597.59	206.52	8481.13	417.29	2158.12	150.75	1006.02	simulation	2026-05-21 00:11:47.614469	f
359	2026-03-07	6h	6h-14h	Chaîne 15	559.59	21.52	1523.16	377.83	2076.46	135.07	944.51	simulation	2026-05-21 00:11:47.614469	f
360	2026-03-07	14h	14h-22h	Chaîne 15	606.71	23.94	1571.99	426.88	2329.48	151.39	1014.4	simulation	2026-05-21 00:11:47.614469	f
361	2026-03-07	22h	22h-6h	Chaîne 15	552.23	21.19	1395.9	374.88	1872.34	132.84	898.41	simulation	2026-05-21 00:11:47.614469	f
362	2026-03-07	6h	6h-14h	Chaîne 16	741.38	98.55	4668.8	494.32	2739.5	589.54	1260.87	simulation	2026-05-21 00:11:47.614469	f
363	2026-03-07	14h	14h-22h	Chaîne 16	750.23	108.04	4684.95	516.15	2654.58	687.83	1220.99	simulation	2026-05-21 00:11:47.614469	f
364	2026-03-07	22h	22h-6h	Chaîne 16	661.79	90.32	4349.87	453.87	2411.58	555.58	1057.46	simulation	2026-05-21 00:11:47.614469	f
365	2026-03-08	6h	6h-14h	Chaîne 8	906.82	184.89	9481.75	460.86	2130.39	150.13	1065.46	simulation	2026-05-21 00:11:47.614469	f
366	2026-03-08	14h	14h-22h	Chaîne 8	928.28	182.33	9633.95	518.07	2584.19	159.21	1057.05	simulation	2026-05-21 00:11:47.614469	f
367	2026-03-08	22h	22h-6h	Chaîne 8	803.99	175.17	8605.31	434.84	2000.02	137.44	897.02	simulation	2026-05-21 00:11:47.614469	f
368	2026-03-08	6h	6h-14h	Chaîne 14	549.75	197.98	9016.15	444.91	1922.24	138.08	931.03	simulation	2026-05-21 00:11:47.614469	f
369	2026-03-08	14h	14h-22h	Chaîne 14	568.48	213.28	8498.53	459.49	2211.56	133.39	977.56	simulation	2026-05-21 00:11:47.614469	f
370	2026-03-08	22h	22h-6h	Chaîne 14	465.73	193.42	7889.62	398.9	1792.48	121.62	888.63	simulation	2026-05-21 00:11:47.614469	f
371	2026-03-08	6h	6h-14h	Chaîne 15	500.48	19.61	1547.74	396.73	1781.24	126.18	831.76	simulation	2026-05-21 00:11:47.614469	f
372	2026-03-08	14h	14h-22h	Chaîne 15	526.78	20.25	1539.26	383.8	1952.24	126.84	899.64	simulation	2026-05-21 00:11:47.614469	f
373	2026-03-08	22h	22h-6h	Chaîne 15	450.6	18.26	1347.98	377.18	1701.97	104.25	719.83	simulation	2026-05-21 00:11:47.614469	f
374	2026-03-08	6h	6h-14h	Chaîne 16	624.68	85.54	4637.61	509.77	2221.15	497.95	954.71	simulation	2026-05-21 00:11:47.614469	f
375	2026-03-08	14h	14h-22h	Chaîne 16	602.76	84.37	4782.71	470.7	2242.5	550.8	1129.03	simulation	2026-05-21 00:11:47.614469	f
376	2026-03-08	22h	22h-6h	Chaîne 16	573.89	78.17	4187.89	460.62	2078.26	465.15	961.21	simulation	2026-05-21 00:11:47.614469	f
377	2026-03-09	6h	6h-14h	Chaîne 8	0	65.19	0	74.26	320.74	0	0	simulation	2026-05-21 00:11:47.614469	t
378	2026-03-09	14h	14h-22h	Chaîne 8	0	63.39	0	77.17	347.79	0	0	simulation	2026-05-21 00:11:47.614469	t
379	2026-03-09	22h	22h-6h	Chaîne 8	0	61.3	0	76.18	322.54	0	0	simulation	2026-05-21 00:11:47.614469	t
380	2026-03-09	6h	6h-14h	Chaîne 14	672.77	238.59	9083.03	420.55	2372.92	162.36	1120.81	simulation	2026-05-21 00:11:47.614469	f
381	2026-03-09	14h	14h-22h	Chaîne 14	619.41	251.61	9385.38	421.22	2485.72	160.2	1148.5	simulation	2026-05-21 00:11:47.614469	f
382	2026-03-09	22h	22h-6h	Chaîne 14	573.32	209.8	8553.52	403.81	2031.35	148.28	1023.39	simulation	2026-05-21 00:11:47.614469	f
383	2026-03-09	6h	6h-14h	Chaîne 15	605.3	22.21	1618.51	382.21	2150.44	145.15	936.95	simulation	2026-05-21 00:11:47.614469	f
384	2026-03-09	14h	14h-22h	Chaîne 15	591.34	24.52	1569.59	410.09	2297.07	143.23	1096.63	simulation	2026-05-21 00:11:47.614469	f
385	2026-03-09	22h	22h-6h	Chaîne 15	522.58	20.35	1368.61	387.02	1859.22	131.6	863.02	simulation	2026-05-21 00:11:47.614469	f
386	2026-03-09	6h	6h-14h	Chaîne 16	703.46	102.47	4657.37	472.77	2790.67	653.03	1292.29	simulation	2026-05-21 00:11:47.614469	f
387	2026-03-09	14h	14h-22h	Chaîne 16	716.34	105.35	5019	518.95	2702.15	647.93	1203.18	simulation	2026-05-21 00:11:47.614469	f
388	2026-03-09	22h	22h-6h	Chaîne 16	660.49	98.6	4300.39	454.07	2264.11	573.03	1126.73	simulation	2026-05-21 00:11:47.614469	f
389	2026-03-10	6h	6h-14h	Chaîne 8	1058.26	219.28	9848.99	485.6	2665.68	184.2	1126.96	simulation	2026-05-21 00:11:47.614469	f
390	2026-03-10	14h	14h-22h	Chaîne 8	1146.9	219.04	10114.17	507.97	3031.61	189.25	1342.98	simulation	2026-05-21 00:11:47.614469	f
391	2026-03-10	22h	22h-6h	Chaîne 8	908.97	196.65	9364.2	474.09	2391.65	165.6	1135.93	simulation	2026-05-21 00:11:47.614469	f
392	2026-03-10	6h	6h-14h	Chaîne 14	0	72.22	0	66.78	270.28	0	0	simulation	2026-05-21 00:11:47.614469	t
393	2026-03-10	14h	14h-22h	Chaîne 14	0	75.63	0	62.51	300.24	0	0	simulation	2026-05-21 00:11:47.614469	t
394	2026-03-10	22h	22h-6h	Chaîne 14	0	66.97	0	63.65	291.05	0	0	simulation	2026-05-21 00:11:47.614469	t
395	2026-03-10	6h	6h-14h	Chaîne 15	598.86	23.17	1616.61	388.77	2050.13	135.26	980.1	simulation	2026-05-21 00:11:47.614469	f
396	2026-03-10	14h	14h-22h	Chaîne 15	563.94	22.44	1614.98	413.84	2142.65	147.89	945.03	simulation	2026-05-21 00:11:47.614469	f
397	2026-03-10	22h	22h-6h	Chaîne 15	504.17	21.63	1398.08	372.48	2078.76	135.9	839.79	simulation	2026-05-21 00:11:47.614469	f
398	2026-03-10	6h	6h-14h	Chaîne 16	728.51	95.16	4434.58	499.64	2529.99	639.91	1256.2	simulation	2026-05-21 00:11:47.614469	f
399	2026-03-10	14h	14h-22h	Chaîne 16	738.71	103.74	4968.08	495.1	2867.4	650.33	1273.92	simulation	2026-05-21 00:11:47.614469	f
400	2026-03-10	22h	22h-6h	Chaîne 16	696.86	94.7	4554.25	438.42	2370.56	572.07	1097.76	simulation	2026-05-21 00:11:47.614469	f
401	2026-03-11	6h	6h-14h	Chaîne 8	1029.44	199.1	10050.58	485.55	2511.61	173.73	1256.77	simulation	2026-05-21 00:11:47.614469	f
402	2026-03-11	14h	14h-22h	Chaîne 8	1130.9	227.81	9920.44	488.65	2894	190.49	1251.84	simulation	2026-05-21 00:11:47.614469	f
403	2026-03-11	22h	22h-6h	Chaîne 8	903.04	207.23	9192.76	435.3	2292.94	170.6	1170.84	simulation	2026-05-21 00:11:47.614469	f
404	2026-03-11	6h	6h-14h	Chaîne 14	606.22	244.69	8551.16	436.37	2301.32	155.91	1122.92	simulation	2026-05-21 00:11:47.614469	f
405	2026-03-11	14h	14h-22h	Chaîne 14	620.09	258.51	9017.67	458.7	2563.59	167.42	1201.14	simulation	2026-05-21 00:11:47.614469	f
406	2026-03-11	22h	22h-6h	Chaîne 14	605.55	226.53	8246.87	420.05	2077.23	147.8	963.69	simulation	2026-05-21 00:11:47.614469	f
407	2026-03-11	6h	6h-14h	Chaîne 15	0	6.71	0	60.33	244.81	0	0	simulation	2026-05-21 00:11:47.614469	t
408	2026-03-11	14h	14h-22h	Chaîne 15	0	6.6	0	58.69	273.22	0	0	simulation	2026-05-21 00:11:47.614469	t
409	2026-03-11	22h	22h-6h	Chaîne 15	0	6.45	0	56.42	257.59	0	0	simulation	2026-05-21 00:11:47.614469	t
410	2026-03-11	6h	6h-14h	Chaîne 16	719.41	105.64	4857.36	500.32	2531.6	645.81	1235.66	simulation	2026-05-21 00:11:47.614469	f
411	2026-03-11	14h	14h-22h	Chaîne 16	720.75	109.62	4546.62	507.68	2666.68	653.79	1360.68	simulation	2026-05-21 00:11:47.614469	f
412	2026-03-11	22h	22h-6h	Chaîne 16	683.21	96.04	4456.19	462.33	2331.21	574.77	1040.3	simulation	2026-05-21 00:11:47.614469	f
413	2026-03-12	6h	6h-14h	Chaîne 8	992.56	200.62	10132.64	506.57	2518.62	185.35	1281.84	simulation	2026-05-21 00:11:47.614469	f
414	2026-03-12	14h	14h-22h	Chaîne 8	1102.68	230.03	9876.43	496.32	2756.45	207.15	1403.84	simulation	2026-05-21 00:11:47.614469	f
415	2026-03-12	22h	22h-6h	Chaîne 8	967.61	191.64	8567.49	470.88	2527.36	166.81	1081.95	simulation	2026-05-21 00:11:47.614469	f
416	2026-03-12	6h	6h-14h	Chaîne 14	661.85	226.45	9022.8	420.85	2258.87	162.79	1106.62	simulation	2026-05-21 00:11:47.614469	f
417	2026-03-12	14h	14h-22h	Chaîne 14	621.62	240.15	8865.62	426.06	2446.49	167.89	1060.08	simulation	2026-05-21 00:11:47.614469	f
418	2026-03-12	22h	22h-6h	Chaîne 14	583.21	209.37	7880.07	381.6	2193.56	143.28	917.93	simulation	2026-05-21 00:11:47.614469	f
419	2026-03-12	6h	6h-14h	Chaîne 15	577.37	20.7	1463.44	380.4	2054.15	140.61	1010.08	simulation	2026-05-21 00:11:47.614469	f
420	2026-03-12	14h	14h-22h	Chaîne 15	567.9	22.48	1603.76	426.4	2115.23	146.38	1078.72	simulation	2026-05-21 00:11:47.614469	f
421	2026-03-12	22h	22h-6h	Chaîne 15	530.26	20.45	1500.79	361.51	1946.47	131.38	825.21	simulation	2026-05-21 00:11:47.614469	f
422	2026-03-12	6h	6h-14h	Chaîne 16	0	29.7	0	77.06	301.63	0	0	simulation	2026-05-21 00:11:47.614469	t
423	2026-03-12	14h	14h-22h	Chaîne 16	0	29.53	0	68.8	322.22	0	0	simulation	2026-05-21 00:11:47.614469	t
424	2026-03-12	22h	22h-6h	Chaîne 16	0	31.68	0	71.5	289.55	0	0	simulation	2026-05-21 00:11:47.614469	t
425	2026-03-13	6h	6h-14h	Chaîne 8	1091.32	219.94	9155.21	461.5	2531.85	178.5	1222.57	simulation	2026-05-21 00:11:47.614469	f
426	2026-03-13	14h	14h-22h	Chaîne 8	1068.87	227.9	10334.33	521.24	2756.86	190.71	1281.9	simulation	2026-05-21 00:11:47.614469	f
427	2026-03-13	22h	22h-6h	Chaîne 8	963.68	197.87	8922.83	450.67	2319.34	170.6	1141.34	simulation	2026-05-21 00:11:47.614469	f
428	2026-03-13	6h	6h-14h	Chaîne 14	620.09	242.87	9158.71	406.49	2391.29	153.82	1084.8	simulation	2026-05-21 00:11:47.614469	f
429	2026-03-13	14h	14h-22h	Chaîne 14	625.75	246.32	8927.4	454.23	2404.4	157.52	1037.25	simulation	2026-05-21 00:11:47.614469	f
430	2026-03-13	22h	22h-6h	Chaîne 14	583.01	225.97	8243.36	403.36	2278.3	144.86	954.93	simulation	2026-05-21 00:11:47.614469	f
431	2026-03-13	6h	6h-14h	Chaîne 15	576.81	22.23	1537.49	391	2122.18	137	979.82	simulation	2026-05-21 00:11:47.614469	f
432	2026-03-13	14h	14h-22h	Chaîne 15	590.6	24.28	1498.46	408.26	2191.02	138.92	1084.34	simulation	2026-05-21 00:11:47.614469	f
433	2026-03-13	22h	22h-6h	Chaîne 15	561.2	21.42	1466.05	374.73	1975.69	133.98	923.36	simulation	2026-05-21 00:11:47.614469	f
434	2026-03-13	6h	6h-14h	Chaîne 16	676.92	99.24	4624.31	505.93	2754.67	606.41	1153.38	simulation	2026-05-21 00:11:47.614469	f
435	2026-03-13	14h	14h-22h	Chaîne 16	729.27	102.88	4756.39	489.21	2657.11	637.87	1353.78	simulation	2026-05-21 00:11:47.614469	f
436	2026-03-13	22h	22h-6h	Chaîne 16	694.94	92.58	4267.49	458.21	2409.7	564.64	1084.31	simulation	2026-05-21 00:11:47.614469	f
437	2026-03-14	6h	6h-14h	Chaîne 8	1100.58	214.35	9598.92	510.1	2632.56	184.39	1250.39	simulation	2026-05-21 00:11:47.614469	f
438	2026-03-14	14h	14h-22h	Chaîne 8	1066.79	227.45	9660.32	509.72	2867.43	192.56	1324.69	simulation	2026-05-21 00:11:47.614469	f
439	2026-03-14	22h	22h-6h	Chaîne 8	895.61	204.22	9553.55	463.4	2478.75	164.33	1046.87	simulation	2026-05-21 00:11:47.614469	f
440	2026-03-14	6h	6h-14h	Chaîne 14	653.09	249.54	8650.19	409.94	2240.67	153.26	1022.02	simulation	2026-05-21 00:11:47.614469	f
441	2026-03-14	14h	14h-22h	Chaîne 14	664.13	232.62	8435.17	415.96	2505.53	160.54	1184.42	simulation	2026-05-21 00:11:47.614469	f
442	2026-03-14	22h	22h-6h	Chaîne 14	586.74	211.61	8545.22	415.4	2250.14	142.43	951.47	simulation	2026-05-21 00:11:47.614469	f
443	2026-03-14	6h	6h-14h	Chaîne 15	601.58	22.73	1469.1	386.91	2107.15	138.34	959.43	simulation	2026-05-21 00:11:47.614469	f
444	2026-03-14	14h	14h-22h	Chaîne 15	571.94	22.7	1588.98	391.27	2110.36	151.01	1093.86	simulation	2026-05-21 00:11:47.614469	f
445	2026-03-14	22h	22h-6h	Chaîne 15	550.31	19.5	1500.3	359.67	1937.46	124.34	937.99	simulation	2026-05-21 00:11:47.614469	f
446	2026-03-14	6h	6h-14h	Chaîne 16	692.95	94.98	4655.55	494.52	2762.23	587.63	1201.65	simulation	2026-05-21 00:11:47.614469	f
447	2026-03-14	14h	14h-22h	Chaîne 16	719.32	105.09	4745.57	501.89	2786.32	653.08	1268.38	simulation	2026-05-21 00:11:47.614469	f
448	2026-03-14	22h	22h-6h	Chaîne 16	686.96	98.58	4088.71	440.2	2453.86	580.55	1131.56	simulation	2026-05-21 00:11:47.614469	f
449	2026-03-15	6h	6h-14h	Chaîne 8	939.98	168	10061.31	506.54	2143.92	150.06	1006.8	simulation	2026-05-21 00:11:47.614469	f
450	2026-03-15	14h	14h-22h	Chaîne 8	907.15	181.68	9956.82	468.85	2597.08	172.9	1125.05	simulation	2026-05-21 00:11:47.614469	f
451	2026-03-15	22h	22h-6h	Chaîne 8	800.34	178.91	9115.71	453.04	2031.74	142.21	893.18	simulation	2026-05-21 00:11:47.614469	f
452	2026-03-15	6h	6h-14h	Chaîne 14	566.36	192.98	8801.88	426.48	2009.38	141.48	879.77	simulation	2026-05-21 00:11:47.614469	f
453	2026-03-15	14h	14h-22h	Chaîne 14	530.57	212.94	9171.46	434.36	2088.61	143.71	1007.99	simulation	2026-05-21 00:11:47.614469	f
454	2026-03-15	22h	22h-6h	Chaîne 14	466.77	189.2	8291.72	385.05	1805.26	119.66	793.91	simulation	2026-05-21 00:11:47.614469	f
455	2026-03-15	6h	6h-14h	Chaîne 15	517.45	18.33	1477.33	404.03	1815.38	115.83	883.95	simulation	2026-05-21 00:11:47.614469	f
456	2026-03-15	14h	14h-22h	Chaîne 15	532.01	18.99	1572.5	427.7	1930.03	130.1	821.42	simulation	2026-05-21 00:11:47.614469	f
457	2026-03-15	22h	22h-6h	Chaîne 15	428.29	17.13	1390.89	352.89	1695.13	105.22	703.5	simulation	2026-05-21 00:11:47.614469	f
458	2026-03-15	6h	6h-14h	Chaîne 16	578.81	81.86	4747.33	464.14	2343.6	508.29	953.38	simulation	2026-05-21 00:11:47.614469	f
459	2026-03-15	14h	14h-22h	Chaîne 16	648.95	91.18	5006.49	500.35	2350.32	536.75	1123.05	simulation	2026-05-21 00:11:47.614469	f
460	2026-03-15	22h	22h-6h	Chaîne 16	550.91	83.8	4460.84	451.57	2008.99	474.44	947.89	simulation	2026-05-21 00:11:47.614469	f
461	2026-03-16	6h	6h-14h	Chaîne 8	0	65.49	0	70.88	313.87	0	0	simulation	2026-05-21 00:11:47.614469	t
462	2026-03-16	14h	14h-22h	Chaîne 8	0	69.7	0	74.44	335.05	0	0	simulation	2026-05-21 00:11:47.614469	t
463	2026-03-16	22h	22h-6h	Chaîne 8	0	63.01	0	72.28	305.01	0	0	simulation	2026-05-21 00:11:47.614469	t
464	2026-03-16	6h	6h-14h	Chaîne 14	652.35	224.36	8872.66	446.34	2483.32	155.05	1018.26	simulation	2026-05-21 00:11:47.614469	f
465	2026-03-16	14h	14h-22h	Chaîne 14	633.08	231.84	8565.58	454.34	2561.52	159.48	1194.22	simulation	2026-05-21 00:11:47.614469	f
466	2026-03-16	22h	22h-6h	Chaîne 14	544.26	218.43	8593.27	414.36	2157.79	150.65	974.17	simulation	2026-05-21 00:11:47.614469	f
467	2026-03-16	6h	6h-14h	Chaîne 15	559.78	22.53	1591.99	389.75	2251.47	143	1004.91	simulation	2026-05-21 00:11:47.614469	f
468	2026-03-16	14h	14h-22h	Chaîne 15	616.93	23.47	1495.78	418.31	2263.36	143.38	1048.24	simulation	2026-05-21 00:11:47.614469	f
469	2026-03-16	22h	22h-6h	Chaîne 15	559.52	21.11	1442.91	374.64	2053.77	126.45	924.82	simulation	2026-05-21 00:11:47.614469	f
470	2026-03-16	6h	6h-14h	Chaîne 16	726.76	96.67	4613.31	487.23	2646.26	617.07	1131.78	simulation	2026-05-21 00:11:47.614469	f
471	2026-03-16	14h	14h-22h	Chaîne 16	764.48	100.03	4758.29	488.28	2654.39	697.22	1307.49	simulation	2026-05-21 00:11:47.614469	f
472	2026-03-16	22h	22h-6h	Chaîne 16	686.6	88.4	4462.77	455.15	2452.72	570.89	1167.13	simulation	2026-05-21 00:11:47.614469	f
473	2026-03-17	6h	6h-14h	Chaîne 8	1021.68	213.86	9545.56	464.79	2687.62	170.98	1197.93	simulation	2026-05-21 00:11:47.614469	f
474	2026-03-17	14h	14h-22h	Chaîne 8	1124.54	226.68	10147.78	514.03	2913.2	189.93	1379.67	simulation	2026-05-21 00:11:47.614469	f
475	2026-03-17	22h	22h-6h	Chaîne 8	961.56	203.77	8961.38	457.1	2403.13	167.51	1093.91	simulation	2026-05-21 00:11:47.614469	f
476	2026-03-17	6h	6h-14h	Chaîne 14	0	72.45	0	65.08	282.57	0	0	simulation	2026-05-21 00:11:47.614469	t
477	2026-03-17	14h	14h-22h	Chaîne 14	0	74.01	0	68.65	275.43	0	0	simulation	2026-05-21 00:11:47.614469	t
478	2026-03-17	22h	22h-6h	Chaîne 14	0	67.03	0	63.81	284.24	0	0	simulation	2026-05-21 00:11:47.614469	t
479	2026-03-17	6h	6h-14h	Chaîne 15	597.12	22.28	1519.22	379.53	2196.7	149.33	969.59	simulation	2026-05-21 00:11:47.614469	f
480	2026-03-17	14h	14h-22h	Chaîne 15	599.23	24.58	1503.84	425.56	2257.88	144.93	994.73	simulation	2026-05-21 00:11:47.614469	f
481	2026-03-17	22h	22h-6h	Chaîne 15	552.01	19.98	1486.92	388.05	2056	126.9	866.95	simulation	2026-05-21 00:11:47.614469	f
482	2026-03-17	6h	6h-14h	Chaîne 16	750.77	100.34	4733.22	491.25	2742.44	654.57	1233.51	simulation	2026-05-21 00:11:47.614469	f
483	2026-03-17	14h	14h-22h	Chaîne 16	723.16	101.53	4724.46	475.83	2712.8	683.55	1195.17	simulation	2026-05-21 00:11:47.614469	f
484	2026-03-17	22h	22h-6h	Chaîne 16	647.5	97.54	4187.71	462.22	2522.99	579.72	1117.36	simulation	2026-05-21 00:11:47.614469	f
485	2026-03-18	6h	6h-14h	Chaîne 8	1084.08	200.68	9537.7	505.12	2697.96	185.25	1217.07	simulation	2026-05-21 00:11:47.614469	f
486	2026-03-18	14h	14h-22h	Chaîne 8	1150.49	234.94	10201.93	517.37	2888.57	200.34	1293.61	simulation	2026-05-21 00:11:47.614469	f
487	2026-03-18	22h	22h-6h	Chaîne 8	917.75	202.52	8703.74	425.93	2415.52	165.09	1106.02	simulation	2026-05-21 00:11:47.614469	f
488	2026-03-18	6h	6h-14h	Chaîne 14	645.11	249.37	8546.21	455.14	2418.38	165.28	1039.23	simulation	2026-05-21 00:11:47.614469	f
489	2026-03-18	14h	14h-22h	Chaîne 14	666.14	236.17	8842.82	431.35	2505.79	158.39	1145.3	simulation	2026-05-21 00:11:47.614469	f
490	2026-03-18	22h	22h-6h	Chaîne 14	553.72	213.85	8075.08	408.76	2071.41	141.54	1013.47	simulation	2026-05-21 00:11:47.614469	f
491	2026-03-18	6h	6h-14h	Chaîne 15	0	6.27	0	56.83	269.67	0	0	simulation	2026-05-21 00:11:47.614469	t
492	2026-03-18	14h	14h-22h	Chaîne 15	0	7.22	0	61.65	272.23	0	0	simulation	2026-05-21 00:11:47.614469	t
493	2026-03-18	22h	22h-6h	Chaîne 15	0	6.58	0	57.57	247.82	0	0	simulation	2026-05-21 00:11:47.614469	t
494	2026-03-18	6h	6h-14h	Chaîne 16	697.96	100.52	4403.57	458.49	2653.79	623.32	1123.69	simulation	2026-05-21 00:11:47.614469	f
495	2026-03-18	14h	14h-22h	Chaîne 16	725.79	108.95	4872.47	502.11	2697.75	642.08	1351.58	simulation	2026-05-21 00:11:47.614469	f
496	2026-03-18	22h	22h-6h	Chaîne 16	678.69	89.85	4576.48	473.87	2410.81	551.1	1091.07	simulation	2026-05-21 00:11:47.614469	f
497	2026-03-19	6h	6h-14h	Chaîne 8	1013.55	203.06	9987.5	464.63	2615	184.23	1131.47	simulation	2026-05-21 00:11:47.614469	f
498	2026-03-19	14h	14h-22h	Chaîne 8	1056.46	213.93	9371.6	505.23	2967.91	201.39	1256.75	simulation	2026-05-21 00:11:47.614469	f
499	2026-03-19	22h	22h-6h	Chaîne 8	927.48	203.61	8918.27	446.41	2452.9	154.93	1067.55	simulation	2026-05-21 00:11:47.614469	f
500	2026-03-19	6h	6h-14h	Chaîne 14	671.62	243.13	9210.58	432.01	2321.43	154.48	1061.1	simulation	2026-05-21 00:11:47.614469	f
501	2026-03-19	14h	14h-22h	Chaîne 14	672.23	234.25	9138.14	466.73	2384.17	164.25	1210.37	simulation	2026-05-21 00:11:47.614469	f
502	2026-03-19	22h	22h-6h	Chaîne 14	565.24	225.28	8408.63	420.81	2220.79	143.2	971.29	simulation	2026-05-21 00:11:47.614469	f
503	2026-03-19	6h	6h-14h	Chaîne 15	587.46	21.84	1536.3	401.92	2186.96	137.85	914.69	simulation	2026-05-21 00:11:47.614469	f
504	2026-03-19	14h	14h-22h	Chaîne 15	584.61	22.23	1536.09	408.98	2225.99	141.82	1059.38	simulation	2026-05-21 00:11:47.614469	f
505	2026-03-19	22h	22h-6h	Chaîne 15	511.79	19.36	1493.26	365.12	2058.75	135.48	864.69	simulation	2026-05-21 00:11:47.614469	f
506	2026-03-19	6h	6h-14h	Chaîne 16	0	29.15	0	74.69	323.41	0	0	simulation	2026-05-21 00:11:47.614469	t
507	2026-03-19	14h	14h-22h	Chaîne 16	0	32.23	0	75.87	349.33	0	0	simulation	2026-05-21 00:11:47.614469	t
508	2026-03-19	22h	22h-6h	Chaîne 16	0	30.81	0	73.43	312.27	0	0	simulation	2026-05-21 00:11:47.614469	t
509	2026-03-20	6h	6h-14h	Chaîne 8	1080.96	202.13	9928.66	503.04	2493.16	182.18	1145.5	simulation	2026-05-21 00:11:47.614469	f
510	2026-03-20	14h	14h-22h	Chaîne 8	1093.06	228.7	10108.05	504.73	2894.75	203.72	1418.91	simulation	2026-05-21 00:11:47.614469	f
511	2026-03-20	22h	22h-6h	Chaîne 8	925.98	209.74	9177.81	468.38	2482.05	161.63	1166.63	simulation	2026-05-21 00:11:47.614469	f
512	2026-03-20	6h	6h-14h	Chaîne 14	600.83	248.23	8655.73	454.78	2345.58	155.92	1119.42	simulation	2026-05-21 00:11:47.614469	f
513	2026-03-20	14h	14h-22h	Chaîne 14	661.35	258.68	8981.32	415.54	2503.38	168.83	1208.78	simulation	2026-05-21 00:11:47.614469	f
514	2026-03-20	22h	22h-6h	Chaîne 14	553.6	209.6	7807.75	381.39	2054.58	149.14	1042.97	simulation	2026-05-21 00:11:47.614469	f
515	2026-03-20	6h	6h-14h	Chaîne 15	609.15	22.26	1442.88	397.03	2116.36	136.85	920.67	simulation	2026-05-21 00:11:47.614469	f
516	2026-03-20	14h	14h-22h	Chaîne 15	612.41	23.71	1502.88	389.66	2137.07	150.79	1009.14	simulation	2026-05-21 00:11:47.614469	f
517	2026-03-20	22h	22h-6h	Chaîne 15	520.12	19.26	1457.9	377.86	1882.28	123.93	903.38	simulation	2026-05-21 00:11:47.614469	f
518	2026-03-20	6h	6h-14h	Chaîne 16	742.41	100.91	4394.29	482.78	2487.25	592.55	1289.64	simulation	2026-05-21 00:11:47.614469	f
519	2026-03-20	14h	14h-22h	Chaîne 16	752.07	100.62	4529.85	508	2926.64	683.61	1339.49	simulation	2026-05-21 00:11:47.614469	f
520	2026-03-20	22h	22h-6h	Chaîne 16	689.59	93.74	4132.13	465.46	2319.01	573.11	1057.06	simulation	2026-05-21 00:11:47.614469	f
521	2026-03-21	6h	6h-14h	Chaîne 8	1037.43	199.13	9610.48	497.89	2545.92	189.75	1214.83	simulation	2026-05-21 00:11:47.614469	f
522	2026-03-21	14h	14h-22h	Chaîne 8	1078.46	218.37	10021.57	497.85	2808.49	189.57	1230.5	simulation	2026-05-21 00:11:47.614469	f
523	2026-03-21	22h	22h-6h	Chaîne 8	943.63	205.69	9402.66	463.12	2514.86	157.2	1121.6	simulation	2026-05-21 00:11:47.614469	f
524	2026-03-21	6h	6h-14h	Chaîne 14	655.97	224.67	9048.36	423.48	2448.7	157.82	1054.21	simulation	2026-05-21 00:11:47.614469	f
525	2026-03-21	14h	14h-22h	Chaîne 14	620.87	247.08	9113.83	436.98	2426.1	158.43	1048.27	simulation	2026-05-21 00:11:47.614469	f
526	2026-03-21	22h	22h-6h	Chaîne 14	552.29	223.41	8183.85	415.86	2238.32	140.59	917.34	simulation	2026-05-21 00:11:47.614469	f
527	2026-03-21	6h	6h-14h	Chaîne 15	550	23	1586.51	396.09	2039.55	148.76	989.53	simulation	2026-05-21 00:11:47.614469	f
528	2026-03-21	14h	14h-22h	Chaîne 15	621.92	23.35	1506.21	417.61	2189.43	152.76	954.07	simulation	2026-05-21 00:11:47.614469	f
529	2026-03-21	22h	22h-6h	Chaîne 15	553.61	19.44	1386.37	389.77	1970.27	122.29	907.22	simulation	2026-05-21 00:11:47.614469	f
530	2026-03-21	6h	6h-14h	Chaîne 16	677.04	100.07	4610.73	509.8	2514.42	605.11	1196.87	simulation	2026-05-21 00:11:47.614469	f
531	2026-03-21	14h	14h-22h	Chaîne 16	698.98	102.66	4811.5	467.04	2732.1	670.81	1307.07	simulation	2026-05-21 00:11:47.614469	f
532	2026-03-21	22h	22h-6h	Chaîne 16	676.22	90.33	4453.67	451.43	2513.93	569.59	1040.82	simulation	2026-05-21 00:11:47.614469	f
533	2026-03-22	6h	6h-14h	Chaîne 8	879.04	181.31	9152.29	467.95	2228.25	145.8	1011.76	simulation	2026-05-21 00:11:47.614469	f
534	2026-03-22	14h	14h-22h	Chaîne 8	979.83	191.38	9526.11	479.3	2615.82	175.71	1127.25	simulation	2026-05-21 00:11:47.614469	f
535	2026-03-22	22h	22h-6h	Chaîne 8	765.97	170.32	9141.43	442.71	2046.33	141.11	933.28	simulation	2026-05-21 00:11:47.614469	f
536	2026-03-22	6h	6h-14h	Chaîne 14	534.32	206.36	9179.8	452.09	1915.57	133.96	863.58	simulation	2026-05-21 00:11:47.614469	f
537	2026-03-22	14h	14h-22h	Chaîne 14	534.07	213.11	8957.54	420.31	2067.23	133.19	971.35	simulation	2026-05-21 00:11:47.614469	f
538	2026-03-22	22h	22h-6h	Chaîne 14	497.73	191.99	8604.17	383.91	1788.42	120.24	852.57	simulation	2026-05-21 00:11:47.614469	f
539	2026-03-22	6h	6h-14h	Chaîne 15	515.18	18.67	1456.4	415.58	1812.99	124.76	835.8	simulation	2026-05-21 00:11:47.614469	f
540	2026-03-22	14h	14h-22h	Chaîne 15	518.73	20.99	1642.74	416.25	1800.12	122.39	912.52	simulation	2026-05-21 00:11:47.614469	f
541	2026-03-22	22h	22h-6h	Chaîne 15	439.92	18.43	1472.11	359.26	1707.73	110.02	703.59	simulation	2026-05-21 00:11:47.614469	f
542	2026-03-22	6h	6h-14h	Chaîne 16	590.34	81.68	4880.13	494.08	2242.63	510.09	1045.23	simulation	2026-05-21 00:11:47.614469	f
543	2026-03-22	14h	14h-22h	Chaîne 16	612.07	93.48	4992.69	487.26	2414.85	589.82	1048.04	simulation	2026-05-21 00:11:47.614469	f
544	2026-03-22	22h	22h-6h	Chaîne 16	593.36	82.7	4400.8	459.67	1932.46	476.25	893.19	simulation	2026-05-21 00:11:47.614469	f
545	2026-03-23	6h	6h-14h	Chaîne 8	0	63.8	0	75.64	323.11	0	0	simulation	2026-05-21 00:11:47.614469	t
546	2026-03-23	14h	14h-22h	Chaîne 8	0	62.97	0	72.25	336.68	0	0	simulation	2026-05-21 00:11:47.614469	t
547	2026-03-23	22h	22h-6h	Chaîne 8	0	61.78	0	73	309.55	0	0	simulation	2026-05-21 00:11:47.614469	t
548	2026-03-23	6h	6h-14h	Chaîne 14	612	226.94	8681.88	414.73	2484.76	156.46	1125.88	simulation	2026-05-21 00:11:47.614469	f
549	2026-03-23	14h	14h-22h	Chaîne 14	626.93	251.33	8449.13	462.89	2500.61	173.09	1195.72	simulation	2026-05-21 00:11:47.614469	f
550	2026-03-23	22h	22h-6h	Chaîne 14	559.88	215.59	7678.81	402.61	2222.52	143.65	979.65	simulation	2026-05-21 00:11:47.614469	f
551	2026-03-23	6h	6h-14h	Chaîne 15	559.73	20.93	2183.98	396.41	3104.5	135.4	650.06	simulation	2026-05-21 00:11:47.614469	f
552	2026-03-23	14h	14h-22h	Chaîne 15	603.04	24.52	2340.53	410.44	3239.19	138.21	658.12	simulation	2026-05-21 00:11:47.614469	f
553	2026-03-23	22h	22h-6h	Chaîne 15	561.09	20.85	2045.95	363.78	2615.09	122.61	561.49	simulation	2026-05-21 00:11:47.614469	f
554	2026-03-23	6h	6h-14h	Chaîne 16	747.13	98.75	4794.12	472.79	2793.72	594.81	1175.78	simulation	2026-05-21 00:11:47.614469	f
555	2026-03-23	14h	14h-22h	Chaîne 16	736.02	109.27	4534.16	499.94	2886.68	650.31	1342.62	simulation	2026-05-21 00:11:47.614469	f
556	2026-03-23	22h	22h-6h	Chaîne 16	665.88	89.52	4246.21	431.77	2366.61	567.64	1010.4	simulation	2026-05-21 00:11:47.614469	f
557	2026-03-24	6h	6h-14h	Chaîne 8	1056.91	216.04	9971.29	511.62	2634.61	178.4	1118.88	simulation	2026-05-21 00:11:47.614469	f
558	2026-03-24	14h	14h-22h	Chaîne 8	1093.75	229.38	10253.52	523.68	2800.26	195.83	1348.17	simulation	2026-05-21 00:11:47.614469	f
559	2026-03-24	22h	22h-6h	Chaîne 8	912.7	188.29	8688.28	441.18	2507.83	171.76	1077.08	simulation	2026-05-21 00:11:47.614469	f
560	2026-03-24	6h	6h-14h	Chaîne 14	0	66.57	0	62.71	275.17	0	0	simulation	2026-05-21 00:11:47.614469	t
561	2026-03-24	14h	14h-22h	Chaîne 14	0	75.71	0	65.69	280.52	0	0	simulation	2026-05-21 00:11:47.614469	t
562	2026-03-24	22h	22h-6h	Chaîne 14	0	69.4	0	60.91	265.8	0	0	simulation	2026-05-21 00:11:47.614469	t
563	2026-03-24	6h	6h-14h	Chaîne 15	607.42	21.04	1590.56	392.46	2046.77	140.52	949.04	simulation	2026-05-21 00:11:47.614469	f
564	2026-03-24	14h	14h-22h	Chaîne 15	599.9	24.52	1644.73	388.94	2223.56	144.66	1090.7	simulation	2026-05-21 00:11:47.614469	f
565	2026-03-24	22h	22h-6h	Chaîne 15	506.67	20.14	1445.01	377.71	1976.78	131.51	847.53	simulation	2026-05-21 00:11:47.614469	f
566	2026-03-24	6h	6h-14h	Chaîne 16	697.89	96.07	4416.63	491.32	2528.33	634.04	1182.58	simulation	2026-05-21 00:11:47.614469	f
567	2026-03-24	14h	14h-22h	Chaîne 16	753.29	101.67	4696.42	482.06	2888.28	641.44	1288.27	simulation	2026-05-21 00:11:47.614469	f
568	2026-03-24	22h	22h-6h	Chaîne 16	649.23	94.08	4194.13	435.8	2451.22	542.89	1155.6	simulation	2026-05-21 00:11:47.614469	f
569	2026-03-25	6h	6h-14h	Chaîne 8	1078.14	212.54	9679.7	481.22	2558.77	170.07	1282.37	simulation	2026-05-21 00:11:47.614469	f
570	2026-03-25	14h	14h-22h	Chaîne 8	1108	223.34	10082.31	478.88	2863.33	191.07	1285.16	simulation	2026-05-21 00:11:47.614469	f
571	2026-03-25	22h	22h-6h	Chaîne 8	949.5	208.89	9125.94	454.76	2335.16	160.67	1119.59	simulation	2026-05-21 00:11:47.614469	f
572	2026-03-25	6h	6h-14h	Chaîne 14	610.58	233.12	8748.17	411.6	2505.73	163.81	1053.44	simulation	2026-05-21 00:11:47.614469	f
573	2026-03-25	14h	14h-22h	Chaîne 14	674.64	254.91	9408.71	420.11	2551.64	157.89	1108.37	simulation	2026-05-21 00:11:47.614469	f
574	2026-03-25	22h	22h-6h	Chaîne 14	596.98	203.42	7892.13	391.79	2197.21	141.79	970.03	simulation	2026-05-21 00:11:47.614469	f
575	2026-03-25	6h	6h-14h	Chaîne 15	0	6.24	0	58.16	260.86	0	0	simulation	2026-05-21 00:11:47.614469	t
576	2026-03-25	14h	14h-22h	Chaîne 15	0	6.99	0	61	249.37	0	0	simulation	2026-05-21 00:11:47.614469	t
577	2026-03-25	22h	22h-6h	Chaîne 15	0	6.28	0	59.49	263.19	0	0	simulation	2026-05-21 00:11:47.614469	t
578	2026-03-25	6h	6h-14h	Chaîne 16	704.02	101.64	4560.99	479.22	2711.41	596.48	1247.38	simulation	2026-05-21 00:11:47.614469	f
579	2026-03-25	14h	14h-22h	Chaîne 16	712.57	103.57	4931.42	502.71	2857.92	627.07	1218.86	simulation	2026-05-21 00:11:47.614469	f
580	2026-03-25	22h	22h-6h	Chaîne 16	670.11	91.72	4475.76	448.42	2452.61	556.74	1022.92	simulation	2026-05-21 00:11:47.614469	f
581	2026-03-26	6h	6h-14h	Chaîne 8	1066.41	214.14	9917.49	494.78	2725.69	182.94	1200.44	simulation	2026-05-21 00:11:47.614469	f
582	2026-03-26	14h	14h-22h	Chaîne 8	1131.5	221.94	9327.47	503.29	2770.35	190.94	1352.63	simulation	2026-05-21 00:11:47.614469	f
583	2026-03-26	22h	22h-6h	Chaîne 8	925.69	203.34	9349.75	471.27	2304.58	170.99	1161.27	simulation	2026-05-21 00:11:47.614469	f
584	2026-03-26	6h	6h-14h	Chaîne 14	627.34	248.1	8865.42	428.89	2244.82	163.45	1011.51	simulation	2026-05-21 00:11:47.614469	f
585	2026-03-26	14h	14h-22h	Chaîne 14	653.98	237.69	8664.5	416.09	2418.24	157.13	1125.91	simulation	2026-05-21 00:11:47.614469	f
586	2026-03-26	22h	22h-6h	Chaîne 14	544.59	212.24	8127.27	419.61	2061.21	143.51	974.76	simulation	2026-05-21 00:11:47.614469	f
587	2026-03-26	6h	6h-14h	Chaîne 15	548.75	21.2	1533.78	399.3	2215.19	143.35	903.51	simulation	2026-05-21 00:11:47.614469	f
588	2026-03-26	14h	14h-22h	Chaîne 15	575.8	24.14	1609.54	424.15	2180.92	154.04	960.03	simulation	2026-05-21 00:11:47.614469	f
589	2026-03-26	22h	22h-6h	Chaîne 15	526.03	19.9	1448.12	360.71	1907.45	128.08	862.81	simulation	2026-05-21 00:11:47.614469	f
590	2026-03-26	6h	6h-14h	Chaîne 16	0	29.9	0	74.36	326.93	0	0	simulation	2026-05-21 00:11:47.614469	t
591	2026-03-26	14h	14h-22h	Chaîne 16	0	29.54	0	74.25	346.93	0	0	simulation	2026-05-21 00:11:47.614469	t
592	2026-03-26	22h	22h-6h	Chaîne 16	0	29.18	0	71.84	300.82	0	0	simulation	2026-05-21 00:11:47.614469	t
593	2026-03-27	6h	6h-14h	Chaîne 8	1006.9	214.1	9497.09	487.96	2536.02	179.43	1218.28	simulation	2026-05-21 00:11:47.614469	f
594	2026-03-27	14h	14h-22h	Chaîne 8	1143.82	217.83	10288.83	468.35	2812.96	197.17	1301.05	simulation	2026-05-21 00:11:47.614469	f
595	2026-03-27	22h	22h-6h	Chaîne 8	923.09	194.77	8990.52	473.61	2408.44	155.31	1173.18	simulation	2026-05-21 00:11:47.614469	f
596	2026-03-27	6h	6h-14h	Chaîne 14	614.25	232.1	8414.66	456.44	2325.04	153.43	1097.9	simulation	2026-05-21 00:11:47.614469	f
597	2026-03-27	14h	14h-22h	Chaîne 14	625.7	246.51	8490.36	422.57	2342.68	164.49	1185.1	simulation	2026-05-21 00:11:47.614469	f
598	2026-03-27	22h	22h-6h	Chaîne 14	564.15	218.96	8011.68	378.07	2126.57	140.17	923.65	simulation	2026-05-21 00:11:47.614469	f
599	2026-03-27	6h	6h-14h	Chaîne 15	545.28	22.98	1612.87	403.52	2116.81	135.95	927.2	simulation	2026-05-21 00:11:47.614469	f
600	2026-03-27	14h	14h-22h	Chaîne 15	626.77	23.22	1511.28	384.09	2205.87	147	1016.41	simulation	2026-05-21 00:11:47.614469	f
601	2026-03-27	22h	22h-6h	Chaîne 15	502.53	20.7	1376.05	378.88	1958.9	125.15	910.54	simulation	2026-05-21 00:11:47.614469	f
602	2026-03-27	6h	6h-14h	Chaîne 16	704.96	96.67	4627.08	459.76	2513.32	654.87	1193.17	simulation	2026-05-21 00:11:47.614469	f
603	2026-03-27	14h	14h-22h	Chaîne 16	752.58	101.56	4885.79	492.45	2721.08	666.1	1278.45	simulation	2026-05-21 00:11:47.614469	f
604	2026-03-27	22h	22h-6h	Chaîne 16	662.92	96.69	4426.02	451.83	2313.94	548.02	1168.55	simulation	2026-05-21 00:11:47.614469	f
605	2026-03-28	6h	6h-14h	Chaîne 8	1051.37	200.97	9910.19	503.12	2762.17	173.49	1246.96	simulation	2026-05-21 00:11:47.614469	f
606	2026-03-28	14h	14h-22h	Chaîne 8	1107.16	224.99	9800.52	495.34	2882.5	194.65	1373	simulation	2026-05-21 00:11:47.614469	f
607	2026-03-28	22h	22h-6h	Chaîne 8	919	205.37	9114.02	462.28	2294.09	157.9	1027.6	simulation	2026-05-21 00:11:47.614469	f
608	2026-03-28	6h	6h-14h	Chaîne 14	650.98	246.35	8716.7	421.17	2281.47	158.43	1008.91	simulation	2026-05-21 00:11:47.614469	f
609	2026-03-28	14h	14h-22h	Chaîne 14	674.72	244.38	8996.26	425.91	2324.12	162.91	1079.95	simulation	2026-05-21 00:11:47.614469	f
610	2026-03-28	22h	22h-6h	Chaîne 14	593.61	203.85	8262.2	398.88	2233.44	142.55	1035.25	simulation	2026-05-21 00:11:47.614469	f
611	2026-03-28	6h	6h-14h	Chaîne 15	594.58	21.54	1570.65	402.41	2098.21	145.54	926.78	simulation	2026-05-21 00:11:47.614469	f
612	2026-03-28	14h	14h-22h	Chaîne 15	568.07	22.1	1507.42	394.74	2152.23	146.99	1043.22	simulation	2026-05-21 00:11:47.614469	f
613	2026-03-28	22h	22h-6h	Chaîne 15	514.37	20.94	1377.61	384.86	1854.28	127.42	938.28	simulation	2026-05-21 00:11:47.614469	f
614	2026-03-28	6h	6h-14h	Chaîne 16	735.44	103.55	4716.27	461.52	2743.74	651.06	1293.22	simulation	2026-05-21 00:11:47.614469	f
615	2026-03-28	14h	14h-22h	Chaîne 16	767.21	98.14	4821.33	490.59	2721.53	679.82	1200.2	simulation	2026-05-21 00:11:47.614469	f
616	2026-03-28	22h	22h-6h	Chaîne 16	702.1	96.51	4257.26	429.08	2247.25	552.46	1117.32	simulation	2026-05-21 00:11:47.614469	f
617	2026-03-29	6h	6h-14h	Chaîne 8	871.75	184.93	9779.24	479.69	2197.38	145.09	966.53	simulation	2026-05-21 00:11:47.614469	f
618	2026-03-29	14h	14h-22h	Chaîne 8	964.01	183.13	9418.76	478.45	2534.08	162.07	1147.51	simulation	2026-05-21 00:11:47.614469	f
619	2026-03-29	22h	22h-6h	Chaîne 8	829.57	171.24	9239.89	454.09	2075.77	143.42	947.69	simulation	2026-05-21 00:11:47.614469	f
620	2026-03-29	6h	6h-14h	Chaîne 14	527.68	189.72	8235.49	456.2	1940.44	132.45	896.23	simulation	2026-05-21 00:11:47.614469	f
621	2026-03-29	14h	14h-22h	Chaîne 14	586.08	198.5	8680.68	462.02	2068.3	142.26	1017.06	simulation	2026-05-21 00:11:47.614469	f
622	2026-03-29	22h	22h-6h	Chaîne 14	510.78	180.69	8452.72	386.79	1721.71	125.82	798.8	simulation	2026-05-21 00:11:47.614469	f
623	2026-03-29	6h	6h-14h	Chaîne 15	474.76	19.29	1514.65	414.32	1910.78	115.57	777.89	simulation	2026-05-21 00:11:47.614469	f
624	2026-03-29	14h	14h-22h	Chaîne 15	527.09	18.88	1543.16	425.58	1898.71	124.93	828.88	simulation	2026-05-21 00:11:47.614469	f
625	2026-03-29	22h	22h-6h	Chaîne 15	426.95	17.49	1343.53	382.6	1723.69	108.78	768.36	simulation	2026-05-21 00:11:47.614469	f
626	2026-03-29	6h	6h-14h	Chaîne 16	582.84	86.29	4508.35	479.52	2375.27	551.26	1013.57	simulation	2026-05-21 00:11:47.614469	f
627	2026-03-29	14h	14h-22h	Chaîne 16	610.38	92.57	4856.74	520.65	2298.25	555.5	1160.6	simulation	2026-05-21 00:11:47.614469	f
628	2026-03-29	22h	22h-6h	Chaîne 16	596.97	78.47	4471.96	475.84	1924.85	464.12	856.25	simulation	2026-05-21 00:11:47.614469	f
629	2026-03-30	6h	6h-14h	Chaîne 8	0	65.02	0	73.81	315.92	0	0	simulation	2026-05-21 00:11:47.614469	t
630	2026-03-30	14h	14h-22h	Chaîne 8	0	64.91	0	72.53	363.29	0	0	simulation	2026-05-21 00:11:47.614469	t
631	2026-03-30	22h	22h-6h	Chaîne 8	0	64.09	0	68.84	312.03	0	0	simulation	2026-05-21 00:11:47.614469	t
632	2026-03-30	6h	6h-14h	Chaîne 14	648.09	231.58	8562.15	410.49	2373.65	155.53	1024.23	simulation	2026-05-21 00:11:47.614469	f
633	2026-03-30	14h	14h-22h	Chaîne 14	695.96	256.68	8395.38	431.05	2472.38	157.66	1148.82	simulation	2026-05-21 00:11:47.614469	f
634	2026-03-30	22h	22h-6h	Chaîne 14	569.79	212.31	8131.16	425.56	2092.7	141.92	1010.81	simulation	2026-05-21 00:11:47.614469	f
635	2026-03-30	6h	6h-14h	Chaîne 15	546.53	20.88	1575.07	407.24	2087.94	138.31	1044.12	simulation	2026-05-21 00:11:47.614469	f
636	2026-03-30	14h	14h-22h	Chaîne 15	598.12	24.48	1554.9	404.29	2306.36	139.47	1097.39	simulation	2026-05-21 00:11:47.614469	f
637	2026-03-30	22h	22h-6h	Chaîne 15	548.28	20.29	1455.46	385.9	1862.31	127.51	961.96	simulation	2026-05-21 00:11:47.614469	f
638	2026-03-30	6h	6h-14h	Chaîne 16	688.08	102.85	4607.84	511.17	2628.72	647.78	1255.35	simulation	2026-05-21 00:11:47.614469	f
639	2026-03-30	14h	14h-22h	Chaîne 16	772.17	106.61	4827.1	473.42	2672.38	660.4	1273.82	simulation	2026-05-21 00:11:47.614469	f
640	2026-03-30	22h	22h-6h	Chaîne 16	691.28	96.17	4554.49	476.24	2336.22	577.82	1095.04	simulation	2026-05-21 00:11:47.614469	f
641	2026-03-31	6h	6h-14h	Chaîne 8	1065.2	211.56	10030.21	513.69	2594.43	179.67	1164.32	simulation	2026-05-21 00:11:47.614469	f
642	2026-03-31	14h	14h-22h	Chaîne 8	1114.82	221.22	9486.74	493.41	3089.77	194.46	1418.69	simulation	2026-05-21 00:11:47.614469	f
643	2026-03-31	22h	22h-6h	Chaîne 8	954.86	205.08	9017.4	476.11	2400.91	156.61	1020.6	simulation	2026-05-21 00:11:47.614469	f
644	2026-03-31	6h	6h-14h	Chaîne 14	0	72.48	0	64.63	290.01	0	0	simulation	2026-05-21 00:11:47.614469	t
645	2026-03-31	14h	14h-22h	Chaîne 14	0	74.23	0	68.3	274.45	0	0	simulation	2026-05-21 00:11:47.614469	t
646	2026-03-31	22h	22h-6h	Chaîne 14	0	66.57	0	63.4	292.82	0	0	simulation	2026-05-21 00:11:47.614469	t
647	2026-03-31	6h	6h-14h	Chaîne 15	584.27	21.72	1535.89	386	2126.9	132.94	1013.67	simulation	2026-05-21 00:11:47.614469	f
648	2026-03-31	14h	14h-22h	Chaîne 15	624.81	23.94	1616.43	389.6	2229.34	140.05	1001.63	simulation	2026-05-21 00:11:47.614469	f
649	2026-03-31	22h	22h-6h	Chaîne 15	535.84	19.93	1508.97	384.07	1964.06	124.47	910.37	simulation	2026-05-21 00:11:47.614469	f
650	2026-03-31	6h	6h-14h	Chaîne 16	733.67	94.36	4913.66	483.63	2717.38	583.87	1120.53	simulation	2026-05-21 00:11:47.614469	f
651	2026-03-31	14h	14h-22h	Chaîne 16	727.79	97.82	4851.32	516.87	2715.74	685.44	1261.81	simulation	2026-05-21 00:11:47.614469	f
652	2026-03-31	22h	22h-6h	Chaîne 16	698.57	92.05	4271.27	449.24	2410.93	575.95	1145.18	simulation	2026-05-21 00:11:47.614469	f
653	2026-04-01	6h	6h-14h	Chaîne 8	1079.21	217.48	9756.4	480.86	2518.64	183.39	1179.42	simulation	2026-05-21 00:11:47.614469	f
654	2026-04-01	14h	14h-22h	Chaîne 8	1094.5	216.51	10283.02	507.5	2747.85	188.57	1315.94	simulation	2026-05-21 00:11:47.614469	f
655	2026-04-01	22h	22h-6h	Chaîne 8	980.12	204.39	9556.46	446.39	2507.05	172.77	1135.14	simulation	2026-05-21 00:11:47.614469	f
656	2026-04-01	6h	6h-14h	Chaîne 14	617.84	237.84	9045.65	433.85	2285.11	162.25	1037.35	simulation	2026-05-21 00:11:47.614469	f
657	2026-04-01	14h	14h-22h	Chaîne 14	686.76	247.25	8897.5	451.95	2386.48	170.3	1202.43	simulation	2026-05-21 00:11:47.614469	f
658	2026-04-01	22h	22h-6h	Chaîne 14	589.89	215.1	8125.83	389.38	2249.58	150.57	921.62	simulation	2026-05-21 00:11:47.614469	f
659	2026-04-01	6h	6h-14h	Chaîne 15	0	6.62	0	57.73	243.57	0	0	simulation	2026-05-21 00:11:47.614469	t
660	2026-04-01	14h	14h-22h	Chaîne 15	0	6.74	0	61.62	264.97	0	0	simulation	2026-05-21 00:11:47.614469	t
661	2026-04-01	22h	22h-6h	Chaîne 15	0	6.4	0	59.26	248.19	0	0	simulation	2026-05-21 00:11:47.614469	t
662	2026-04-01	6h	6h-14h	Chaîne 16	732.13	99.74	4511.73	465.93	2549.26	623.95	1224.39	simulation	2026-05-21 00:11:47.614469	f
663	2026-04-01	14h	14h-22h	Chaîne 16	771.85	104.16	4711.99	516.78	2798.05	669.62	1222.23	simulation	2026-05-21 00:11:47.614469	f
664	2026-04-01	22h	22h-6h	Chaîne 16	638.67	92.09	4444.77	476.77	2463.42	561.13	1102.68	simulation	2026-05-21 00:11:47.614469	f
665	2026-04-02	6h	6h-14h	Chaîne 8	1052.53	200.35	9959.27	474.81	2628.18	174.54	1218.84	simulation	2026-05-21 00:11:47.614469	f
666	2026-04-02	14h	14h-22h	Chaîne 8	1111.3	218.09	10465.77	504.38	2921.09	198.65	1242.85	simulation	2026-05-21 00:11:47.614469	f
667	2026-04-02	22h	22h-6h	Chaîne 8	958.09	210.22	8862.47	438.58	2427.36	154.31	1104.63	simulation	2026-05-21 00:11:47.614469	f
668	2026-04-02	6h	6h-14h	Chaîne 14	630.9	228.42	9093.81	427.26	2475.67	156.94	1019.59	simulation	2026-05-21 00:11:47.614469	f
669	2026-04-02	14h	14h-22h	Chaîne 14	650.32	236.51	8747.81	428.7	2370.17	168.46	1193.53	simulation	2026-05-21 00:11:47.614469	f
670	2026-04-02	22h	22h-6h	Chaîne 14	554.73	208.49	8202.19	402.59	2090.01	143.75	930.73	simulation	2026-05-21 00:11:47.614469	f
671	2026-04-02	6h	6h-14h	Chaîne 15	583.35	22.19	1586.11	413.67	2252.19	147.21	1017.8	simulation	2026-05-21 00:11:47.614469	f
672	2026-04-02	14h	14h-22h	Chaîne 15	616.2	22.73	1586.17	397.48	2235.67	151.87	1013.86	simulation	2026-05-21 00:11:47.614469	f
673	2026-04-02	22h	22h-6h	Chaîne 15	504.73	21.67	1484.19	351.29	1856.65	134.56	876.94	simulation	2026-05-21 00:11:47.614469	f
674	2026-04-02	6h	6h-14h	Chaîne 16	0	29.46	0	76.32	312.01	0	0	simulation	2026-05-21 00:11:47.614469	t
675	2026-04-02	14h	14h-22h	Chaîne 16	0	31.97	0	69.07	345.33	0	0	simulation	2026-05-21 00:11:47.614469	t
676	2026-04-02	22h	22h-6h	Chaîne 16	0	31.47	0	73.2	299.72	0	0	simulation	2026-05-21 00:11:47.614469	t
677	2026-04-03	6h	6h-14h	Chaîne 8	1110.65	218.75	9196.87	477.15	2494.44	175.9	1201.29	simulation	2026-05-21 00:11:47.614469	f
678	2026-04-03	14h	14h-22h	Chaîne 8	1189.14	215.06	10279.53	486.62	2919.28	204.01	1375.1	simulation	2026-05-21 00:11:47.614469	f
679	2026-04-03	22h	22h-6h	Chaîne 8	976.33	191.93	9207.86	431.94	2316.72	167.01	1144.32	simulation	2026-05-21 00:11:47.614469	f
680	2026-04-03	6h	6h-14h	Chaîne 14	652.09	233.3	9203.62	421.65	2375.68	164.88	1012	simulation	2026-05-21 00:11:47.614469	f
681	2026-04-03	14h	14h-22h	Chaîne 14	650.47	242.81	8812.94	465.93	2337.15	160.94	1098.73	simulation	2026-05-21 00:11:47.614469	f
682	2026-04-03	22h	22h-6h	Chaîne 14	608.61	223.36	8311.2	384.98	2254.43	135.51	973.85	simulation	2026-05-21 00:11:47.614469	f
683	2026-04-03	6h	6h-14h	Chaîne 15	558.95	21.45	1596.01	375.65	2153.51	142.91	923.33	simulation	2026-05-21 00:11:47.614469	f
684	2026-04-03	14h	14h-22h	Chaîne 15	566.59	24.86	1495.45	414.72	2345.02	143.05	992.7	simulation	2026-05-21 00:11:47.614469	f
685	2026-04-03	22h	22h-6h	Chaîne 15	542.07	21.58	1468.72	384.55	2014.95	123.47	946.52	simulation	2026-05-21 00:11:47.614469	f
686	2026-04-03	6h	6h-14h	Chaîne 16	720.48	101.09	4911.16	467.35	2605.37	640.07	1244.4	simulation	2026-05-21 00:11:47.614469	f
687	2026-04-03	14h	14h-22h	Chaîne 16	707.91	108.05	4616.17	465.15	2713.86	623.16	1188.53	simulation	2026-05-21 00:11:47.614469	f
688	2026-04-03	22h	22h-6h	Chaîne 16	702.28	96.53	4172.39	439.81	2267.25	542.64	1023.95	simulation	2026-05-21 00:11:47.614469	f
689	2026-04-04	6h	6h-14h	Chaîne 8	998.6	201.85	10056.88	489.65	2594.46	174.61	1107.5	simulation	2026-05-21 00:11:47.614469	f
690	2026-04-04	14h	14h-22h	Chaîne 8	1186.11	230.99	10291.16	522.6	2986.29	205.6	1338.19	simulation	2026-05-21 00:11:47.614469	f
691	2026-04-04	22h	22h-6h	Chaîne 8	887.56	207.41	9330.76	460.41	2472.8	158.69	1096.43	simulation	2026-05-21 00:11:47.614469	f
692	2026-04-04	6h	6h-14h	Chaîne 14	604.53	225.05	9227.23	445.89	2404.38	154.56	1014.98	simulation	2026-05-21 00:11:47.614469	f
693	2026-04-04	14h	14h-22h	Chaîne 14	625.77	239.9	9162.22	421.44	2580.36	156.23	1201.83	simulation	2026-05-21 00:11:47.614469	f
694	2026-04-04	22h	22h-6h	Chaîne 14	600.82	220.48	7864.21	397.32	2213.45	146.34	1037.07	simulation	2026-05-21 00:11:47.614469	f
695	2026-04-04	6h	6h-14h	Chaîne 15	540.6	20.98	1550.7	407.73	2183.23	144.24	992.01	simulation	2026-05-21 00:11:47.614469	f
696	2026-04-04	14h	14h-22h	Chaîne 15	603.18	24.47	1499.17	398.55	2183.43	141.38	1047.07	simulation	2026-05-21 00:11:47.614469	f
697	2026-04-04	22h	22h-6h	Chaîne 15	510.29	19.77	1494.95	346.94	1940.21	124.25	891.71	simulation	2026-05-21 00:11:47.614469	f
698	2026-04-04	6h	6h-14h	Chaîne 16	676.61	103.22	4823.2	480.33	2528.83	608.19	1196.36	simulation	2026-05-21 00:11:47.614469	f
699	2026-04-04	14h	14h-22h	Chaîne 16	729.47	104.48	4901.89	471.11	2651.47	697.65	1284.91	simulation	2026-05-21 00:11:47.614469	f
700	2026-04-04	22h	22h-6h	Chaîne 16	645.01	92.94	4256.71	428.79	2472.35	564.49	1156.1	simulation	2026-05-21 00:11:47.614469	f
701	2026-04-05	6h	6h-14h	Chaîne 8	912.5	171.09	9191.64	510.44	2190.03	152.52	939.64	simulation	2026-05-21 00:11:47.614469	f
702	2026-04-05	14h	14h-22h	Chaîne 8	961.4	201.12	9804.82	503.35	2489.39	175.04	1087.28	simulation	2026-05-21 00:11:47.614469	f
703	2026-04-05	22h	22h-6h	Chaîne 8	765.06	162.34	9462.67	453.37	2047.45	140.91	983.45	simulation	2026-05-21 00:11:47.614469	f
704	2026-04-05	6h	6h-14h	Chaîne 14	509.31	206.99	9023.38	446.27	2103.75	137.38	971.3	simulation	2026-05-21 00:11:47.614469	f
705	2026-04-05	14h	14h-22h	Chaîne 14	587.01	211.72	9174.44	427.99	2001.25	132.64	1001.43	simulation	2026-05-21 00:11:47.614469	f
706	2026-04-05	22h	22h-6h	Chaîne 14	467.42	188.32	7899.77	384.88	1859.22	119.95	781.44	simulation	2026-05-21 00:11:47.614469	f
707	2026-04-05	6h	6h-14h	Chaîne 15	504.72	19.33	1617.41	412.92	1942.28	120.22	783.12	simulation	2026-05-21 00:11:47.614469	f
708	2026-04-05	14h	14h-22h	Chaîne 15	504.17	20.29	1597.07	394.59	1959.13	121.82	800.51	simulation	2026-05-21 00:11:47.614469	f
709	2026-04-05	22h	22h-6h	Chaîne 15	461.32	17.33	1392.8	381.19	1717.09	113.84	761.25	simulation	2026-05-21 00:11:47.614469	f
710	2026-04-05	6h	6h-14h	Chaîne 16	638.38	81.15	4800.08	502.85	2267.46	546.35	953.1	simulation	2026-05-21 00:11:47.614469	f
711	2026-04-05	14h	14h-22h	Chaîne 16	638.96	88.69	4484.31	519.13	2464.05	540.5	1001.66	simulation	2026-05-21 00:11:47.614469	f
712	2026-04-05	22h	22h-6h	Chaîne 16	577.07	80.56	4141.02	439.8	2114.56	459.77	924.54	simulation	2026-05-21 00:11:47.614469	f
713	2026-04-06	6h	6h-14h	Chaîne 8	0	66.53	0	75.19	314.09	0	0	simulation	2026-05-21 00:11:47.614469	t
714	2026-04-06	14h	14h-22h	Chaîne 8	0	62.8	0	75.21	344	0	0	simulation	2026-05-21 00:11:47.614469	t
715	2026-04-06	22h	22h-6h	Chaîne 8	0	67.18	0	76.9	306.63	0	0	simulation	2026-05-21 00:11:47.614469	t
716	2026-04-06	6h	6h-14h	Chaîne 14	822.1	402.22	8622.97	437.57	2249.23	164.03	1125.4	simulation	2026-05-21 00:11:47.614469	f
717	2026-04-06	14h	14h-22h	Chaîne 14	838.29	372.97	8419.61	426.56	2483.3	161.74	1162.19	simulation	2026-05-21 00:11:47.614469	f
718	2026-04-06	22h	22h-6h	Chaîne 14	741.69	378.38	8560.52	420.59	2169.96	136.49	1031.46	simulation	2026-05-21 00:11:47.614469	f
719	2026-04-06	6h	6h-14h	Chaîne 15	606.74	23.02	1463.65	379.01	2258.78	144.3	997.25	simulation	2026-05-21 00:11:47.614469	f
720	2026-04-06	14h	14h-22h	Chaîne 15	575.06	23.58	1516.96	418.28	2161.07	143.54	1021.47	simulation	2026-05-21 00:11:47.614469	f
721	2026-04-06	22h	22h-6h	Chaîne 15	538.76	21.34	1395.13	366.21	1917.19	132.55	945.62	simulation	2026-05-21 00:11:47.614469	f
722	2026-04-06	6h	6h-14h	Chaîne 16	679.03	95.93	4783.72	490.92	2603.4	640.02	1154.6	simulation	2026-05-21 00:11:47.614469	f
723	2026-04-06	14h	14h-22h	Chaîne 16	747.27	99.45	4763.01	499.06	2809.47	646.66	1197.74	simulation	2026-05-21 00:11:47.614469	f
724	2026-04-06	22h	22h-6h	Chaîne 16	628.8	90.11	4132.37	450.59	2292.17	580.44	1088.8	simulation	2026-05-21 00:11:47.614469	f
725	2026-04-07	6h	6h-14h	Chaîne 8	1067.22	207.55	10197.15	464.73	2654.13	179.53	1115.73	simulation	2026-05-21 00:11:47.614469	f
726	2026-04-07	14h	14h-22h	Chaîne 8	1131.35	230.66	9921.11	512.84	2834.9	191.12	1428.2	simulation	2026-05-21 00:11:47.614469	f
727	2026-04-07	22h	22h-6h	Chaîne 8	954.19	193.97	9528.77	460.97	2460.6	159.72	1108.38	simulation	2026-05-21 00:11:47.614469	f
728	2026-04-07	6h	6h-14h	Chaîne 14	0	67.21	0	65.69	281.03	0	0	simulation	2026-05-21 00:11:47.614469	t
729	2026-04-07	14h	14h-22h	Chaîne 14	0	73.41	0	64.5	298.05	0	0	simulation	2026-05-21 00:11:47.614469	t
730	2026-04-07	22h	22h-6h	Chaîne 14	0	69.54	0	65.13	281.36	0	0	simulation	2026-05-21 00:11:47.614469	t
731	2026-04-07	6h	6h-14h	Chaîne 15	580.15	21.83	1533.49	412.42	2248.37	146.7	921.9	simulation	2026-05-21 00:11:47.614469	f
732	2026-04-07	14h	14h-22h	Chaîne 15	573.94	24.68	1545.63	408.46	2210.21	141.52	996.01	simulation	2026-05-21 00:11:47.614469	f
733	2026-04-07	22h	22h-6h	Chaîne 15	525.81	20.68	1488.71	356.01	1983.82	128.8	934.01	simulation	2026-05-21 00:11:47.614469	f
734	2026-04-07	6h	6h-14h	Chaîne 16	689.12	96.39	4858.71	475.32	2671.36	600.36	1256.34	simulation	2026-05-21 00:11:47.614469	f
735	2026-04-07	14h	14h-22h	Chaîne 16	756.65	100.01	4698.49	496.43	2666.03	698.26	1315	simulation	2026-05-21 00:11:47.614469	f
736	2026-04-07	22h	22h-6h	Chaîne 16	668.56	99.38	4549.96	439.12	2440.64	567.8	1122.86	simulation	2026-05-21 00:11:47.614469	f
737	2026-04-08	6h	6h-14h	Chaîne 8	1028.07	205.4	9360.51	476.71	2518.26	179.58	1204.18	simulation	2026-05-21 00:11:47.614469	f
738	2026-04-08	14h	14h-22h	Chaîne 8	1187.27	229.88	10391.76	484.1	3038.31	209.63	1234.68	simulation	2026-05-21 00:11:47.614469	f
739	2026-04-08	22h	22h-6h	Chaîne 8	919.29	204.9	9199.79	435.35	2474.34	157.41	1063.82	simulation	2026-05-21 00:11:47.614469	f
740	2026-04-08	6h	6h-14h	Chaîne 14	631.74	227.93	8670.18	443.26	2283.49	152.64	1091.14	simulation	2026-05-21 00:11:47.614469	f
741	2026-04-08	14h	14h-22h	Chaîne 14	644.09	240.8	9400.57	455.94	2585.91	171.23	1129.21	simulation	2026-05-21 00:11:47.614469	f
742	2026-04-08	22h	22h-6h	Chaîne 14	585.65	224.77	8199.05	377.78	2253.58	144.44	968.99	simulation	2026-05-21 00:11:47.614469	f
743	2026-04-08	6h	6h-14h	Chaîne 15	0	6.78	0	61.01	254.51	0	0	simulation	2026-05-21 00:11:47.614469	t
744	2026-04-08	14h	14h-22h	Chaîne 15	0	6.64	0	56.1	249.88	0	0	simulation	2026-05-21 00:11:47.614469	t
745	2026-04-08	22h	22h-6h	Chaîne 15	0	6.81	0	59.32	239.81	0	0	simulation	2026-05-21 00:11:47.614469	t
746	2026-04-08	6h	6h-14h	Chaîne 16	734.03	99.59	4673.94	506.16	2738.47	615.41	1235.25	simulation	2026-05-21 00:11:47.614469	f
747	2026-04-08	14h	14h-22h	Chaîne 16	696.64	107.52	4847.16	474.96	2949.25	692.67	1365.13	simulation	2026-05-21 00:11:47.614469	f
748	2026-04-08	22h	22h-6h	Chaîne 16	636.9	96.99	4435.39	430.26	2278.73	551.05	1014.02	simulation	2026-05-21 00:11:47.614469	f
749	2026-04-09	6h	6h-14h	Chaîne 8	1057.36	207.35	9728.89	511.66	2488.79	187.77	1214.67	simulation	2026-05-21 00:11:47.614469	f
750	2026-04-09	14h	14h-22h	Chaîne 8	1115.77	214.76	9526.84	522.68	2822.28	200.09	1334.41	simulation	2026-05-21 00:11:47.614469	f
751	2026-04-09	22h	22h-6h	Chaîne 8	888.71	208.59	9054.61	477.1	2372.32	155.96	1058.47	simulation	2026-05-21 00:11:47.614469	f
752	2026-04-09	6h	6h-14h	Chaîne 14	661.18	248.62	8469.44	449.71	2314.71	151.11	1133.58	simulation	2026-05-21 00:11:47.614469	f
753	2026-04-09	14h	14h-22h	Chaîne 14	675.8	240.87	8485.09	445.54	2349.16	171.48	1051.66	simulation	2026-05-21 00:11:47.614469	f
754	2026-04-09	22h	22h-6h	Chaîne 14	573.95	211.85	8469.06	410.26	2027.4	142.31	1010.2	simulation	2026-05-21 00:11:47.614469	f
755	2026-04-09	6h	6h-14h	Chaîne 15	550.04	22.93	1445.45	374.98	2088.87	137.04	966.64	simulation	2026-05-21 00:11:47.614469	f
756	2026-04-09	14h	14h-22h	Chaîne 15	599.33	22.16	1582.54	411.02	2178.17	148.61	1019.5	simulation	2026-05-21 00:11:47.614469	f
757	2026-04-09	22h	22h-6h	Chaîne 15	518.5	20.63	1359.64	373.17	1987.48	133.07	831.81	simulation	2026-05-21 00:11:47.614469	f
758	2026-04-09	6h	6h-14h	Chaîne 16	0	30.02	0	77.05	317.29	0	0	simulation	2026-05-21 00:11:47.614469	t
759	2026-04-09	14h	14h-22h	Chaîne 16	0	32.07	0	76.22	333.35	0	0	simulation	2026-05-21 00:11:47.614469	t
760	2026-04-09	22h	22h-6h	Chaîne 16	0	30.1	0	68.58	291.96	0	0	simulation	2026-05-21 00:11:47.614469	t
761	2026-04-10	6h	6h-14h	Chaîne 8	1050.46	212.21	9455.29	496.44	2746.53	169.86	1261.51	simulation	2026-05-21 00:11:47.614469	f
762	2026-04-10	14h	14h-22h	Chaîne 8	1078.89	216.02	9969.31	484.79	3032.3	196.59	1382.14	simulation	2026-05-21 00:11:47.614469	f
763	2026-04-10	22h	22h-6h	Chaîne 8	886.75	198.2	9014.89	455.73	2420.84	158.73	1087.78	simulation	2026-05-21 00:11:47.614469	f
764	2026-04-10	6h	6h-14h	Chaîne 14	635.89	226.14	8671.28	414.01	2309.18	154.93	1060.29	simulation	2026-05-21 00:11:47.614469	f
765	2026-04-10	14h	14h-22h	Chaîne 14	696.39	245.6	9013.53	417.81	2365.12	154.8	1181.78	simulation	2026-05-21 00:11:47.614469	f
766	2026-04-10	22h	22h-6h	Chaîne 14	607.5	211.13	8129.66	396.97	2087.1	148.03	1009.72	simulation	2026-05-21 00:11:47.614469	f
767	2026-04-10	6h	6h-14h	Chaîne 15	576.09	22.53	1551.4	399.48	2043.54	141.79	908.16	simulation	2026-05-21 00:11:47.614469	f
768	2026-04-10	14h	14h-22h	Chaîne 15	605	24.49	1533.26	408.2	2262.1	155.32	1069.54	simulation	2026-05-21 00:11:47.614469	f
769	2026-04-10	22h	22h-6h	Chaîne 15	538.31	20.16	1341.46	347.28	1925.36	130.74	904.08	simulation	2026-05-21 00:11:47.614469	f
770	2026-04-10	6h	6h-14h	Chaîne 16	758.04	96.31	4675.6	491.32	2724.9	614.43	1150.56	simulation	2026-05-21 00:11:47.614469	f
771	2026-04-10	14h	14h-22h	Chaîne 16	716.19	98.64	4495.38	469.71	2681.92	641.6	1373.63	simulation	2026-05-21 00:11:47.614469	f
772	2026-04-10	22h	22h-6h	Chaîne 16	691.18	97.91	4417.22	446.99	2444.12	535.27	1015.13	simulation	2026-05-21 00:11:47.614469	f
773	2026-04-11	6h	6h-14h	Chaîne 8	1106.02	203.81	9877.88	474.45	2491.56	179.29	1246.04	simulation	2026-05-21 00:11:47.614469	f
774	2026-04-11	14h	14h-22h	Chaîne 8	1080.48	233.36	9940.18	507.77	2801.58	206.53	1410.38	simulation	2026-05-21 00:11:47.614469	f
775	2026-04-11	22h	22h-6h	Chaîne 8	952.32	203.17	8592.15	429.49	2518.62	171	1079.59	simulation	2026-05-21 00:11:47.614469	f
776	2026-04-11	6h	6h-14h	Chaîne 14	621.32	240.07	8335.4	433.9	2440.44	166.73	1082.16	simulation	2026-05-21 00:11:47.614469	f
777	2026-04-11	14h	14h-22h	Chaîne 14	636.79	253.91	9291.25	466.36	2395.47	165.02	1205.21	simulation	2026-05-21 00:11:47.614469	f
778	2026-04-11	22h	22h-6h	Chaîne 14	603.93	226.74	8325.14	404.51	2067.42	138.27	922.9	simulation	2026-05-21 00:11:47.614469	f
779	2026-04-11	6h	6h-14h	Chaîne 15	553.57	21.69	1459.07	375.17	2238.23	144.8	1042.37	simulation	2026-05-21 00:11:47.614469	f
780	2026-04-11	14h	14h-22h	Chaîne 15	608.79	23.12	1628.47	395.75	2198.07	153.98	945.92	simulation	2026-05-21 00:11:47.614469	f
781	2026-04-11	22h	22h-6h	Chaîne 15	512.96	20.59	1404.8	378.25	1947.07	129.33	880.18	simulation	2026-05-21 00:11:47.614469	f
782	2026-04-11	6h	6h-14h	Chaîne 16	714.08	105.56	4684.32	488.44	2794.68	647.73	1176.99	simulation	2026-05-21 00:11:47.614469	f
783	2026-04-11	14h	14h-22h	Chaîne 16	700.53	101.12	4572.56	500.82	2772.29	657.14	1277.49	simulation	2026-05-21 00:11:47.614469	f
784	2026-04-11	22h	22h-6h	Chaîne 16	655.09	91.4	4111.81	433.28	2440.07	580.88	1044.15	simulation	2026-05-21 00:11:47.614469	f
785	2026-04-12	6h	6h-14h	Chaîne 8	919.6	169.05	9253.22	479.51	2282.1	143.84	967.45	simulation	2026-05-21 00:11:47.614469	f
786	2026-04-12	14h	14h-22h	Chaîne 8	996.87	192.43	9671.1	509.34	2525.34	173.1	1077.87	simulation	2026-05-21 00:11:47.614469	f
787	2026-04-12	22h	22h-6h	Chaîne 8	746.44	166.54	8646.15	467.84	2104.78	141.87	912.13	simulation	2026-05-21 00:11:47.614469	f
788	2026-04-12	6h	6h-14h	Chaîne 14	542.47	193.26	8524.29	415.25	1971.03	139.14	900.76	simulation	2026-05-21 00:11:47.614469	f
789	2026-04-12	14h	14h-22h	Chaîne 14	527.94	218.99	9334.49	431.36	1974.7	131.92	973.38	simulation	2026-05-21 00:11:47.614469	f
790	2026-04-12	22h	22h-6h	Chaîne 14	486.15	186.06	8527.49	392.85	1858.6	127.87	800.74	simulation	2026-05-21 00:11:47.614469	f
791	2026-04-12	6h	6h-14h	Chaîne 15	512.59	18.36	1588.85	404.86	1927.27	121.12	825.02	simulation	2026-05-21 00:11:47.614469	f
792	2026-04-12	14h	14h-22h	Chaîne 15	489.43	19.05	1477.66	390.08	1820.08	118.04	882.48	simulation	2026-05-21 00:11:47.614469	f
793	2026-04-12	22h	22h-6h	Chaîne 15	454.74	16.5	1406.33	365.59	1753.1	105.98	793.5	simulation	2026-05-21 00:11:47.614469	f
794	2026-04-12	6h	6h-14h	Chaîne 16	594.62	84.59	4534.51	489.78	2214.69	535.08	1046.36	simulation	2026-05-21 00:11:47.614469	f
795	2026-04-12	14h	14h-22h	Chaîne 16	610.14	93.48	5001.1	484.85	2497.66	585.38	1094.6	simulation	2026-05-21 00:11:47.614469	f
796	2026-04-12	22h	22h-6h	Chaîne 16	590.86	77.21	4476.32	424.32	2097.63	457.36	949.65	simulation	2026-05-21 00:11:47.614469	f
797	2026-04-13	6h	6h-14h	Chaîne 8	0	64.58	0	75.25	317.44	0	0	simulation	2026-05-21 00:11:47.614469	t
798	2026-04-13	14h	14h-22h	Chaîne 8	0	69.3	0	72.86	354.45	0	0	simulation	2026-05-21 00:11:47.614469	t
799	2026-04-13	22h	22h-6h	Chaîne 8	0	66.04	0	76.19	319.22	0	0	simulation	2026-05-21 00:11:47.614469	t
800	2026-04-13	6h	6h-14h	Chaîne 14	671.51	239.08	8368.13	453.18	2252.59	157.61	1023.39	simulation	2026-05-21 00:11:47.614469	f
801	2026-04-13	14h	14h-22h	Chaîne 14	640.43	259.12	9070.05	452.86	2346.56	172.59	1186.67	simulation	2026-05-21 00:11:47.614469	f
802	2026-04-13	22h	22h-6h	Chaîne 14	608.33	220.82	7732.34	395.63	2115.65	137.96	1040.74	simulation	2026-05-21 00:11:47.614469	f
803	2026-04-13	6h	6h-14h	Chaîne 15	585.47	23.3	1458.46	404.68	2203.55	146.3	1054.99	simulation	2026-05-21 00:11:47.614469	f
804	2026-04-13	14h	14h-22h	Chaîne 15	584.02	24.74	1636.53	381.65	2370.48	142.19	1002.7	simulation	2026-05-21 00:11:47.614469	f
805	2026-04-13	22h	22h-6h	Chaîne 15	516.37	21.16	1454	386.83	2076.59	132.02	956.77	simulation	2026-05-21 00:11:47.614469	f
806	2026-04-13	6h	6h-14h	Chaîne 16	751.51	102	4596.13	469.63	2505.81	355.94	826.39	simulation	2026-05-21 00:11:47.614469	f
807	2026-04-13	14h	14h-22h	Chaîne 16	690.36	106.51	4484.04	484.73	2429.07	367.14	820	simulation	2026-05-21 00:11:47.614469	f
808	2026-04-13	22h	22h-6h	Chaîne 16	670.48	96.03	4147.86	474.87	2125.67	369.29	572.07	simulation	2026-05-21 00:11:47.614469	f
809	2026-04-14	6h	6h-14h	Chaîne 8	1066.29	206.4	9295.51	483.45	2774.64	180.8	1108.72	simulation	2026-05-21 00:11:47.614469	f
810	2026-04-14	14h	14h-22h	Chaîne 8	1121.24	215.37	9342.01	474.19	2985.16	195.99	1293.3	simulation	2026-05-21 00:11:47.614469	f
811	2026-04-14	22h	22h-6h	Chaîne 8	941.54	192.14	8790.78	472.09	2510.79	167.44	1147.21	simulation	2026-05-21 00:11:47.614469	f
812	2026-04-14	6h	6h-14h	Chaîne 14	0	69.56	0	67.49	281.58	0	0	simulation	2026-05-21 00:11:47.614469	t
813	2026-04-14	14h	14h-22h	Chaîne 14	0	72.46	0	67.86	301.68	0	0	simulation	2026-05-21 00:11:47.614469	t
814	2026-04-14	22h	22h-6h	Chaîne 14	0	70.1	0	68.39	279.62	0	0	simulation	2026-05-21 00:11:47.614469	t
815	2026-04-14	6h	6h-14h	Chaîne 15	606.99	21.98	1588.07	402.19	2209.32	148.16	1021.09	simulation	2026-05-21 00:11:47.614469	f
816	2026-04-14	14h	14h-22h	Chaîne 15	581.22	22.21	1506.15	422.75	2307.08	155.57	993.49	simulation	2026-05-21 00:11:47.614469	f
817	2026-04-14	22h	22h-6h	Chaîne 15	532.52	19.94	1408.46	371.41	2004.03	131.73	916.16	simulation	2026-05-21 00:11:47.614469	f
818	2026-04-14	6h	6h-14h	Chaîne 16	744.14	103.73	4401.86	465.72	2500.67	655.44	1232	simulation	2026-05-21 00:11:47.614469	f
819	2026-04-14	14h	14h-22h	Chaîne 16	728.88	102.03	4809.34	496.51	2894.08	668.54	1305.34	simulation	2026-05-21 00:11:47.614469	f
820	2026-04-14	22h	22h-6h	Chaîne 16	678.96	97.31	4232.39	424.36	2319.65	528.74	1020.22	simulation	2026-05-21 00:11:47.614469	f
821	2026-04-15	6h	6h-14h	Chaîne 8	1045.51	199.39	10145.5	490.82	2540.67	176.93	1213.31	simulation	2026-05-21 00:11:47.614469	f
822	2026-04-15	14h	14h-22h	Chaîne 8	1088.07	237.12	10195.24	519.07	2972.32	209.45	1281.9	simulation	2026-05-21 00:11:47.614469	f
823	2026-04-15	22h	22h-6h	Chaîne 8	940.41	199.96	8618.63	465.03	2318.29	168.07	1040.87	simulation	2026-05-21 00:11:47.614469	f
824	2026-04-15	6h	6h-14h	Chaîne 14	657.89	225.58	9020.97	408.01	2329.43	148.71	1045.75	simulation	2026-05-21 00:11:47.614469	f
825	2026-04-15	14h	14h-22h	Chaîne 14	645.06	250.02	8873.99	414.32	2418.27	172.89	1206.53	simulation	2026-05-21 00:11:47.614469	f
826	2026-04-15	22h	22h-6h	Chaîne 14	546.08	209.25	7933.82	391.77	2214.22	139.18	932.64	simulation	2026-05-21 00:11:47.614469	f
827	2026-04-15	6h	6h-14h	Chaîne 15	0	6.24	0	62.15	261.28	0	0	simulation	2026-05-21 00:11:47.614469	t
828	2026-04-15	14h	14h-22h	Chaîne 15	0	7.02	0	62.77	268.87	0	0	simulation	2026-05-21 00:11:47.614469	t
829	2026-04-15	22h	22h-6h	Chaîne 15	0	6.43	0	59.16	251.8	0	0	simulation	2026-05-21 00:11:47.614469	t
830	2026-04-15	6h	6h-14h	Chaîne 16	678.15	96.49	4570.26	464.93	2541.26	622.72	1255.94	simulation	2026-05-21 00:11:47.614469	f
831	2026-04-15	14h	14h-22h	Chaîne 16	699.22	109.05	4927.45	486.7	2883.79	683.89	1262.26	simulation	2026-05-21 00:11:47.614469	f
832	2026-04-15	22h	22h-6h	Chaîne 16	707.76	96.98	4131.64	462.83	2450.72	589.62	1110.56	simulation	2026-05-21 00:11:47.614469	f
833	2026-04-16	6h	6h-14h	Chaîne 8	1046.11	201.14	9706.74	512.2	2731.43	173.09	1164.8	simulation	2026-05-21 00:11:47.614469	f
834	2026-04-16	14h	14h-22h	Chaîne 8	1147.36	222.14	10390.54	503.55	2863.52	202.95	1408.92	simulation	2026-05-21 00:11:47.614469	f
835	2026-04-16	22h	22h-6h	Chaîne 8	924.91	191.88	8870.22	441.46	2317.07	156.69	1068.28	simulation	2026-05-21 00:11:47.614469	f
836	2026-04-16	6h	6h-14h	Chaîne 14	597.69	232.44	8921.83	445.79	2462.8	161.5	1005.93	simulation	2026-05-21 00:11:47.614469	f
837	2026-04-16	14h	14h-22h	Chaîne 14	619.81	232.48	8797.07	442.9	2488.32	157.16	1140.78	simulation	2026-05-21 00:11:47.614469	f
838	2026-04-16	22h	22h-6h	Chaîne 14	555.72	218.93	7920.79	414.49	2189.66	137.72	967.63	simulation	2026-05-21 00:11:47.614469	f
839	2026-04-16	6h	6h-14h	Chaîne 15	606.03	21.14	1456	407.84	2065.92	141.19	1044.55	simulation	2026-05-21 00:11:47.614469	f
840	2026-04-16	14h	14h-22h	Chaîne 15	608.41	23.14	1547.24	425.52	2197.49	145.11	989.12	simulation	2026-05-21 00:11:47.614469	f
841	2026-04-16	22h	22h-6h	Chaîne 15	548.58	20.68	1441.78	373.27	1884.26	129.5	897.57	simulation	2026-05-21 00:11:47.614469	f
842	2026-04-16	6h	6h-14h	Chaîne 16	0	30.68	0	76.46	311.3	0	0	simulation	2026-05-21 00:11:47.614469	t
843	2026-04-16	14h	14h-22h	Chaîne 16	0	31.03	0	74.15	343.56	0	0	simulation	2026-05-21 00:11:47.614469	t
844	2026-04-16	22h	22h-6h	Chaîne 16	0	30.71	0	68.91	309.7	0	0	simulation	2026-05-21 00:11:47.614469	t
845	2026-04-17	6h	6h-14h	Chaîne 8	1074.89	201.53	9650.4	483.27	2607.72	174.47	1147.61	simulation	2026-05-21 00:11:47.614469	f
846	2026-04-17	14h	14h-22h	Chaîne 8	1054.79	212.94	9484.45	497.09	3014.16	190.71	1410.88	simulation	2026-05-21 00:11:47.614469	f
847	2026-04-17	22h	22h-6h	Chaîne 8	945.04	210.37	9045.52	472.27	2301.75	169.83	1045.9	simulation	2026-05-21 00:11:47.614469	f
848	2026-04-17	6h	6h-14h	Chaîne 14	655.1	239.16	8576.95	449.08	2385.66	151.14	1071.05	simulation	2026-05-21 00:11:47.614469	f
849	2026-04-17	14h	14h-22h	Chaîne 14	642.47	252.57	8983.77	435.16	2613.09	154.79	1032.93	simulation	2026-05-21 00:11:47.614469	f
850	2026-04-17	22h	22h-6h	Chaîne 14	594.64	216.7	8151.26	425.73	2076.16	139.66	991.55	simulation	2026-05-21 00:11:47.614469	f
851	2026-04-17	6h	6h-14h	Chaîne 15	559.17	22.88	1507.97	377.2	2167.48	136.29	988.83	simulation	2026-05-21 00:11:47.614469	f
852	2026-04-17	14h	14h-22h	Chaîne 15	611.38	23.05	1509.96	423.85	2348.64	154.82	1001.62	simulation	2026-05-21 00:11:47.614469	f
853	2026-04-17	22h	22h-6h	Chaîne 15	538.44	21.54	1407.45	358.3	1907.53	125.92	882.57	simulation	2026-05-21 00:11:47.614469	f
854	2026-04-17	6h	6h-14h	Chaîne 16	699.78	103.43	4600.44	468.87	2577.77	615.32	1136.78	simulation	2026-05-21 00:11:47.614469	f
855	2026-04-17	14h	14h-22h	Chaîne 16	744.89	106.93	4832.62	498.01	2727.82	675.71	1238.53	simulation	2026-05-21 00:11:47.614469	f
856	2026-04-17	22h	22h-6h	Chaîne 16	686.31	97.91	4238.49	469.09	2488.58	582.01	1016.54	simulation	2026-05-21 00:11:47.614469	f
857	2026-04-18	6h	6h-14h	Chaîne 8	1008.94	211.09	9346.49	474.45	2593.31	181.18	1139.32	simulation	2026-05-21 00:11:47.614469	f
858	2026-04-18	14h	14h-22h	Chaîne 8	1108.2	236.04	10472.13	480.32	2949.58	206.39	1248.89	simulation	2026-05-21 00:11:47.614469	f
859	2026-04-18	22h	22h-6h	Chaîne 8	906.62	194.85	9183.97	446.92	2444.6	168.32	1092.51	simulation	2026-05-21 00:11:47.614469	f
860	2026-04-18	6h	6h-14h	Chaîne 14	647.22	240.6	8867.45	409.92	2387.07	151.13	1084.98	simulation	2026-05-21 00:11:47.614469	f
861	2026-04-18	14h	14h-22h	Chaîne 14	632.81	236.51	8402.04	442.13	2351.34	161.1	1110.23	simulation	2026-05-21 00:11:47.614469	f
862	2026-04-18	22h	22h-6h	Chaîne 14	547.01	210.99	8177.62	398.16	2143.76	141.9	932.61	simulation	2026-05-21 00:11:47.614469	f
863	2026-04-18	6h	6h-14h	Chaîne 15	599.68	21.01	1547.53	394.78	2090.96	134.81	1037.41	simulation	2026-05-21 00:11:47.614469	f
864	2026-04-18	14h	14h-22h	Chaîne 15	573.52	23.05	1621.78	382.61	2217.33	138.19	992.89	simulation	2026-05-21 00:11:47.614469	f
865	2026-04-18	22h	22h-6h	Chaîne 15	537.99	21.68	1451.38	364.3	1885.43	125.92	857.89	simulation	2026-05-21 00:11:47.614469	f
866	2026-04-18	6h	6h-14h	Chaîne 16	692.89	95.61	4872.27	506.67	2635.76	602.39	1153.76	simulation	2026-05-21 00:11:47.614469	f
867	2026-04-18	14h	14h-22h	Chaîne 16	709.26	108.18	4667.45	509.46	2924.72	655.26	1345.56	simulation	2026-05-21 00:11:47.614469	f
868	2026-04-18	22h	22h-6h	Chaîne 16	665.73	88.45	4215.17	436.57	2319.99	525.96	998.08	simulation	2026-05-21 00:11:47.614469	f
869	2026-04-19	6h	6h-14h	Chaîne 8	914.36	169.93	9368.37	473.6	2268.66	162.14	977.6	simulation	2026-05-21 00:11:47.614469	f
870	2026-04-19	14h	14h-22h	Chaîne 8	898.08	198.35	10124.21	507.08	2386.05	162.42	1054.91	simulation	2026-05-21 00:11:47.614469	f
871	2026-04-19	22h	22h-6h	Chaîne 8	794.65	160.4	8846.68	451.59	2015.72	136.01	861.23	simulation	2026-05-21 00:11:47.614469	f
872	2026-04-19	6h	6h-14h	Chaîne 14	563.72	205.65	8498.82	427.21	1959.95	128.04	917.41	simulation	2026-05-21 00:11:47.614469	f
873	2026-04-19	14h	14h-22h	Chaîne 14	586.82	202.33	8458.25	464.66	2017.84	146.52	978.77	simulation	2026-05-21 00:11:47.614469	f
874	2026-04-19	22h	22h-6h	Chaîne 14	502.14	178.34	7967.84	411.02	1932.5	122.97	811.75	simulation	2026-05-21 00:11:47.614469	f
875	2026-04-19	6h	6h-14h	Chaîne 15	471.97	18.43	2429.76	372.7	2090.07	120.22	807.94	simulation	2026-05-21 00:11:47.614469	f
876	2026-04-19	14h	14h-22h	Chaîne 15	514.1	20.52	2777.62	397.1	2194.31	122.28	919.53	simulation	2026-05-21 00:11:47.614469	f
877	2026-04-19	22h	22h-6h	Chaîne 15	476.19	18.16	2136.5	367.4	2111.92	105.92	728.67	simulation	2026-05-21 00:11:47.614469	f
878	2026-04-19	6h	6h-14h	Chaîne 16	615.77	85.99	4550.56	507.73	2210.36	512.67	1004.4	simulation	2026-05-21 00:11:47.614469	f
879	2026-04-19	14h	14h-22h	Chaîne 16	611.94	93.43	4714.88	474.5	2467.13	589.02	1056.78	simulation	2026-05-21 00:11:47.614469	f
880	2026-04-19	22h	22h-6h	Chaîne 16	543.29	75.88	4131.05	471.56	1961.87	498.32	876.05	simulation	2026-05-21 00:11:47.614469	f
881	2026-04-20	6h	6h-14h	Chaîne 8	0	62.11	0	77.14	321.89	0	0	simulation	2026-05-21 00:11:47.614469	t
882	2026-04-20	14h	14h-22h	Chaîne 8	0	62.74	0	70.74	327.02	0	0	simulation	2026-05-21 00:11:47.614469	t
883	2026-04-20	22h	22h-6h	Chaîne 8	0	66.2	0	75.67	304.38	0	0	simulation	2026-05-21 00:11:47.614469	t
884	2026-04-20	6h	6h-14h	Chaîne 14	670.36	230.59	9091.78	419.53	2513.72	155.15	1159.68	simulation	2026-05-21 00:11:47.614469	f
885	2026-04-20	14h	14h-22h	Chaîne 14	640.22	232.36	9360.44	460.7	2573.83	171.78	1105.62	simulation	2026-05-21 00:11:47.614469	f
886	2026-04-20	22h	22h-6h	Chaîne 14	562.62	208.24	7684.03	412.66	2103.78	149.73	1018.1	simulation	2026-05-21 00:11:47.614469	f
887	2026-04-20	6h	6h-14h	Chaîne 15	593.91	22.12	1456.74	379.21	2185.1	136.75	1036	simulation	2026-05-21 00:11:47.614469	f
888	2026-04-20	14h	14h-22h	Chaîne 15	558.18	24.05	1481.33	409.31	2175.91	154.83	1007.58	simulation	2026-05-21 00:11:47.614469	f
889	2026-04-20	22h	22h-6h	Chaîne 15	548.68	20.59	1347.95	379.29	2042.14	134.26	930.58	simulation	2026-05-21 00:11:47.614469	f
890	2026-04-20	6h	6h-14h	Chaîne 16	739.08	99.66	4828.64	490.75	2622.15	586.98	1147.53	simulation	2026-05-21 00:11:47.614469	f
891	2026-04-20	14h	14h-22h	Chaîne 16	736.67	107.59	4745.72	522.62	2879.99	621.87	1207.62	simulation	2026-05-21 00:11:47.614469	f
892	2026-04-20	22h	22h-6h	Chaîne 16	702.96	98.93	4130.9	426.96	2438.03	533.14	1066.34	simulation	2026-05-21 00:11:47.614469	f
893	2026-04-21	6h	6h-14h	Chaîne 8	988.95	219.03	9172.53	463.68	2505.23	188.89	1176.39	simulation	2026-05-21 00:11:47.614469	f
894	2026-04-21	14h	14h-22h	Chaîne 8	1169.87	214.23	9861.3	499.83	3017.75	194.63	1382.21	simulation	2026-05-21 00:11:47.614469	f
895	2026-04-21	22h	22h-6h	Chaîne 8	968.23	196.83	8783.04	467.76	2471.88	163.06	1009.16	simulation	2026-05-21 00:11:47.614469	f
896	2026-04-21	6h	6h-14h	Chaîne 14	0	72.55	0	66.14	296.98	0	0	simulation	2026-05-21 00:11:47.614469	t
897	2026-04-21	14h	14h-22h	Chaîne 14	0	69.08	0	62.26	286.33	0	0	simulation	2026-05-21 00:11:47.614469	t
898	2026-04-21	22h	22h-6h	Chaîne 14	0	71.7	0	66.24	269.67	0	0	simulation	2026-05-21 00:11:47.614469	t
899	2026-04-21	6h	6h-14h	Chaîne 15	550.68	21.87	1544.12	411.87	2130.86	149.41	971.96	simulation	2026-05-21 00:11:47.614469	f
900	2026-04-21	14h	14h-22h	Chaîne 15	598.08	22.71	1482.57	395.9	2376.93	144.6	976.8	simulation	2026-05-21 00:11:47.614469	f
901	2026-04-21	22h	22h-6h	Chaîne 15	515.44	21.15	1384.57	383.53	2051.58	127.98	945.25	simulation	2026-05-21 00:11:47.614469	f
902	2026-04-21	6h	6h-14h	Chaîne 16	746.91	105.46	4396.09	489.92	2779.39	642.8	1139.94	simulation	2026-05-21 00:11:47.614469	f
903	2026-04-21	14h	14h-22h	Chaîne 16	706.76	102.96	4741.9	480.08	2833.04	641.5	1290.82	simulation	2026-05-21 00:11:47.614469	f
904	2026-04-21	22h	22h-6h	Chaîne 16	640.5	94.75	4512.98	436.01	2484.96	569.14	1047.61	simulation	2026-05-21 00:11:47.614469	f
905	2026-04-22	6h	6h-14h	Chaîne 8	1055.75	214.16	10191.63	490.8	2535.34	187.4	1136.98	simulation	2026-05-21 00:11:47.614469	f
906	2026-04-22	14h	14h-22h	Chaîne 8	1169.6	212.53	10034.33	510.41	2858.17	210.58	1280.11	simulation	2026-05-21 00:11:47.614469	f
907	2026-04-22	22h	22h-6h	Chaîne 8	888.3	211.13	8771.44	440.42	2320	157.04	1103.87	simulation	2026-05-21 00:11:47.614469	f
908	2026-04-22	6h	6h-14h	Chaîne 14	657.62	238.43	8395.62	429.22	2410.82	161.85	1010.86	simulation	2026-05-21 00:11:47.614469	f
909	2026-04-22	14h	14h-22h	Chaîne 14	670.52	255.94	9334.57	430.88	2495.97	157.08	1043.21	simulation	2026-05-21 00:11:47.614469	f
910	2026-04-22	22h	22h-6h	Chaîne 14	552.56	220.74	7876.62	383.98	2179.26	151.31	978.63	simulation	2026-05-21 00:11:47.614469	f
911	2026-04-22	6h	6h-14h	Chaîne 15	0	6.99	0	58.9	261.48	0	0	simulation	2026-05-21 00:11:47.614469	t
912	2026-04-22	14h	14h-22h	Chaîne 15	0	7.21	0	62.56	251.18	0	0	simulation	2026-05-21 00:11:47.614469	t
913	2026-04-22	22h	22h-6h	Chaîne 15	0	6.57	0	59.71	243.51	0	0	simulation	2026-05-21 00:11:47.614469	t
914	2026-04-22	6h	6h-14h	Chaîne 16	712.25	94.69	4683.08	492.95	2573.42	641.25	1172.98	simulation	2026-05-21 00:11:47.614469	f
915	2026-04-22	14h	14h-22h	Chaîne 16	704.53	106.9	4859.05	502.75	2672.48	632.67	1353.12	simulation	2026-05-21 00:11:47.614469	f
916	2026-04-22	22h	22h-6h	Chaîne 16	662.16	90.38	4333.08	439.42	2404.8	528.03	1120.14	simulation	2026-05-21 00:11:47.614469	f
917	2026-04-23	6h	6h-14h	Chaîne 8	1003.35	204.49	9942.94	499.46	2619.7	176.85	1106.83	simulation	2026-05-21 00:11:47.614469	f
918	2026-04-23	14h	14h-22h	Chaîne 8	1070.34	231.1	9846.23	494.59	3028.21	202.68	1302.31	simulation	2026-05-21 00:11:47.614469	f
919	2026-04-23	22h	22h-6h	Chaîne 8	878.8	192	9086.34	449.94	2454.31	159.1	1049.38	simulation	2026-05-21 00:11:47.614469	f
920	2026-04-23	6h	6h-14h	Chaîne 14	601.72	222.18	9209.04	436.96	2434.76	152.83	1144.7	simulation	2026-05-21 00:11:47.614469	f
921	2026-04-23	14h	14h-22h	Chaîne 14	635.96	244.95	9339	428.05	2348.1	158.55	1041.44	simulation	2026-05-21 00:11:47.614469	f
922	2026-04-23	22h	22h-6h	Chaîne 14	600.43	222.14	8188.32	422.89	2157.05	137.19	974.51	simulation	2026-05-21 00:11:47.614469	f
923	2026-04-23	6h	6h-14h	Chaîne 15	557.45	20.75	1530.88	393.15	2179.84	136.11	1029.77	simulation	2026-05-21 00:11:47.614469	f
924	2026-04-23	14h	14h-22h	Chaîne 15	599.97	24.44	1613.79	427.55	2248.05	138.49	1076.11	simulation	2026-05-21 00:11:47.614469	f
925	2026-04-23	22h	22h-6h	Chaîne 15	537.08	19.67	1483.34	383.28	2070.65	121.87	964.54	simulation	2026-05-21 00:11:47.614469	f
926	2026-04-23	6h	6h-14h	Chaîne 16	0	30.67	0	73.97	310.22	0	0	simulation	2026-05-21 00:11:47.614469	t
927	2026-04-23	14h	14h-22h	Chaîne 16	0	29.18	0	71.52	337.62	0	0	simulation	2026-05-21 00:11:47.614469	t
928	2026-04-23	22h	22h-6h	Chaîne 16	0	32.04	0	72.31	309.74	0	0	simulation	2026-05-21 00:11:47.614469	t
929	2026-04-24	6h	6h-14h	Chaîne 8	1062.45	199	9513.74	489.26	2796.46	173.3	1174.63	simulation	2026-05-21 00:11:47.614469	f
930	2026-04-24	14h	14h-22h	Chaîne 8	1100.96	228.31	9988.86	511.98	2979.44	208.52	1230.91	simulation	2026-05-21 00:11:47.614469	f
931	2026-04-24	22h	22h-6h	Chaîne 8	970.06	198.85	8915.03	454.47	2502.89	165.66	1075.07	simulation	2026-05-21 00:11:47.614469	f
932	2026-04-24	6h	6h-14h	Chaîne 14	605.3	244.49	8631.68	412.95	2343.18	159.09	1085.25	simulation	2026-05-21 00:11:47.614469	f
933	2026-04-24	14h	14h-22h	Chaîne 14	624.84	230.43	9167.87	457.06	2586.88	172.7	1057.84	simulation	2026-05-21 00:11:47.614469	f
934	2026-04-24	22h	22h-6h	Chaîne 14	596.11	209.09	7941.82	418.37	2056.95	149.95	948.36	simulation	2026-05-21 00:11:47.614469	f
935	2026-04-24	6h	6h-14h	Chaîne 15	609.37	21.34	1509.97	416.86	2174.1	139.31	925.48	simulation	2026-05-21 00:11:47.614469	f
936	2026-04-24	14h	14h-22h	Chaîne 15	623.45	23.65	1548.45	388.85	2369.62	144.14	1038	simulation	2026-05-21 00:11:47.614469	f
937	2026-04-24	22h	22h-6h	Chaîne 15	520.94	20.71	1467.78	389.32	1906.34	129.87	844.36	simulation	2026-05-21 00:11:47.614469	f
938	2026-04-24	6h	6h-14h	Chaîne 16	677.78	101.35	4635.43	474.94	2630.52	632.75	1161.05	simulation	2026-05-21 00:11:47.614469	f
939	2026-04-24	14h	14h-22h	Chaîne 16	763.76	102.82	4554.83	465.27	2855.17	656.85	1247.36	simulation	2026-05-21 00:11:47.614469	f
940	2026-04-24	22h	22h-6h	Chaîne 16	643.42	90.21	4343.05	476.53	2378.93	529.56	1068.5	simulation	2026-05-21 00:11:47.614469	f
941	2026-04-25	6h	6h-14h	Chaîne 8	1026.72	199.06	10245.54	458.08	2726.95	187.28	1183.4	simulation	2026-05-21 00:11:47.614469	f
942	2026-04-25	14h	14h-22h	Chaîne 8	1065.32	230.77	9413.67	520.3	2932.82	197.75	1277.47	simulation	2026-05-21 00:11:47.614469	f
943	2026-04-25	22h	22h-6h	Chaîne 8	934.42	204.29	9116.87	447.13	2277.12	157.01	1166.65	simulation	2026-05-21 00:11:47.614469	f
944	2026-04-25	6h	6h-14h	Chaîne 14	612.15	248.25	8839.89	430.36	2352.48	153.52	997.17	simulation	2026-05-21 00:11:47.614469	f
945	2026-04-25	14h	14h-22h	Chaîne 14	635.98	232.81	9097.74	462.34	2403.87	170.34	1100.2	simulation	2026-05-21 00:11:47.614469	f
946	2026-04-25	22h	22h-6h	Chaîne 14	609.83	212.22	7903.12	400.81	2145.83	146.63	1023.75	simulation	2026-05-21 00:11:47.614469	f
947	2026-04-25	6h	6h-14h	Chaîne 15	563.04	22.68	1511.16	372.37	2073.16	136.47	903.73	simulation	2026-05-21 00:11:47.614469	f
948	2026-04-25	14h	14h-22h	Chaîne 15	559.21	22.39	1502.74	418.73	2167.62	142.25	943.1	simulation	2026-05-21 00:11:47.614469	f
949	2026-04-25	22h	22h-6h	Chaîne 15	502.84	19.93	1435.41	372.92	2072.61	131.32	954.61	simulation	2026-05-21 00:11:47.614469	f
950	2026-04-25	6h	6h-14h	Chaîne 16	721.6	94.37	4397.56	482.03	2525.81	630.44	1249.49	simulation	2026-05-21 00:11:47.614469	f
951	2026-04-25	14h	14h-22h	Chaîne 16	721.41	101.1	4905.74	477.71	2655.76	673.15	1238.25	simulation	2026-05-21 00:11:47.614469	f
952	2026-04-25	22h	22h-6h	Chaîne 16	665.23	97	4590.31	477.78	2345.79	571.95	1142.72	simulation	2026-05-21 00:11:47.614469	f
953	2026-04-26	6h	6h-14h	Chaîne 8	866.61	177.2	16208.01	494.13	3338.07	156.84	598.54	simulation	2026-05-21 00:11:47.614469	f
954	2026-04-26	14h	14h-22h	Chaîne 8	945.97	193.61	16321.4	521.39	3733.21	168.92	657.36	simulation	2026-05-21 00:11:47.614469	f
955	2026-04-26	22h	22h-6h	Chaîne 8	823.41	176.27	12939.83	477.65	2701.95	135.16	627.32	simulation	2026-05-21 00:11:47.614469	f
956	2026-04-26	6h	6h-14h	Chaîne 14	566.32	196.5	8508.24	454.44	2058.51	129.92	846.95	simulation	2026-05-21 00:11:47.614469	f
957	2026-04-26	14h	14h-22h	Chaîne 14	582.52	214.93	8932.76	462.27	2096.05	133.37	946.11	simulation	2026-05-21 00:11:47.614469	f
958	2026-04-26	22h	22h-6h	Chaîne 14	463.64	187.35	8133.82	410.76	1778.95	123.54	840.57	simulation	2026-05-21 00:11:47.614469	f
959	2026-04-26	6h	6h-14h	Chaîne 15	499.56	18.49	1493.09	395.96	1883.72	125.99	892.58	simulation	2026-05-21 00:11:47.614469	f
960	2026-04-26	14h	14h-22h	Chaîne 15	490.56	19.09	1631.09	389.46	1901.06	125.29	924.17	simulation	2026-05-21 00:11:47.614469	f
961	2026-04-26	22h	22h-6h	Chaîne 15	461.28	16.37	1471.91	374.38	1613.48	113.33	756.71	simulation	2026-05-21 00:11:47.614469	f
962	2026-04-26	6h	6h-14h	Chaîne 16	598.35	88.35	4818.48	458.53	2114.43	536.98	1008.93	simulation	2026-05-21 00:11:47.614469	f
963	2026-04-26	14h	14h-22h	Chaîne 16	623.51	87.64	4632.37	518.98	2329.54	561.61	1024.61	simulation	2026-05-21 00:11:47.614469	f
964	2026-04-26	22h	22h-6h	Chaîne 16	581.19	78.73	4179.05	455.94	2010.73	484.05	941.08	simulation	2026-05-21 00:11:47.614469	f
965	2026-04-27	6h	6h-14h	Chaîne 8	0	60.94	0	74.62	331.39	0	0	simulation	2026-05-21 00:11:47.614469	t
966	2026-04-27	14h	14h-22h	Chaîne 8	0	62.32	0	75.79	346.22	0	0	simulation	2026-05-21 00:11:47.614469	t
967	2026-04-27	22h	22h-6h	Chaîne 8	0	63.95	0	75.89	319.12	0	0	simulation	2026-05-21 00:11:47.614469	t
968	2026-04-27	6h	6h-14h	Chaîne 14	651.34	239.62	8675.55	440.87	2482.33	158.99	1133.55	simulation	2026-05-21 00:11:47.614469	f
969	2026-04-27	14h	14h-22h	Chaîne 14	623.01	247.18	8765.25	466.42	2466.66	169.39	1144.83	simulation	2026-05-21 00:11:47.614469	f
970	2026-04-27	22h	22h-6h	Chaîne 14	549.88	225.56	8164.52	385.11	2109.08	144.37	1023.62	simulation	2026-05-21 00:11:47.614469	f
971	2026-04-27	6h	6h-14h	Chaîne 15	567.25	22.28	1484.48	385.3	2170.19	144.49	1005.52	simulation	2026-05-21 00:11:47.614469	f
972	2026-04-27	14h	14h-22h	Chaîne 15	610.6	23.29	1641.81	397.01	2292.83	149.41	1024.05	simulation	2026-05-21 00:11:47.614469	f
973	2026-04-27	22h	22h-6h	Chaîne 15	534.12	19.42	1346.56	374.42	2068.5	134.17	886.63	simulation	2026-05-21 00:11:47.614469	f
974	2026-04-27	6h	6h-14h	Chaîne 16	705.51	105.34	4596.9	497.01	2756.77	594.72	1278.72	simulation	2026-05-21 00:11:47.614469	f
975	2026-04-27	14h	14h-22h	Chaîne 16	706.64	101.44	4699.28	492.98	2793.75	639.52	1209.04	simulation	2026-05-21 00:11:47.614469	f
976	2026-04-27	22h	22h-6h	Chaîne 16	632.37	94.95	4510.4	435	2438.62	558.05	1073.82	simulation	2026-05-21 00:11:47.614469	f
977	2026-04-28	6h	6h-14h	Chaîne 8	1107.02	197.44	10278.95	501.41	2612.71	188.97	1157.35	simulation	2026-05-21 00:11:47.614469	f
978	2026-04-28	14h	14h-22h	Chaîne 8	1109.02	218.32	9332.3	476.72	2838.81	192.82	1402.03	simulation	2026-05-21 00:11:47.614469	f
979	2026-04-28	22h	22h-6h	Chaîne 8	916.12	209.09	9358.63	441.97	2450.85	154.74	1040.49	simulation	2026-05-21 00:11:47.614469	f
980	2026-04-28	6h	6h-14h	Chaîne 14	0	68.7	0	63.72	276	0	0	simulation	2026-05-21 00:11:47.614469	t
981	2026-04-28	14h	14h-22h	Chaîne 14	0	74.06	0	61.56	286.15	0	0	simulation	2026-05-21 00:11:47.614469	t
982	2026-04-28	22h	22h-6h	Chaîne 14	0	67.87	0	67.36	283.9	0	0	simulation	2026-05-21 00:11:47.614469	t
983	2026-04-28	6h	6h-14h	Chaîne 15	546.9	21.37	1585.85	394	2065.14	141.29	994.06	simulation	2026-05-21 00:11:47.614469	f
984	2026-04-28	14h	14h-22h	Chaîne 15	557.15	24.3	1486.34	401.79	2363.91	138.87	1047.97	simulation	2026-05-21 00:11:47.614469	f
985	2026-04-28	22h	22h-6h	Chaîne 15	501.25	20.03	1482.31	353.62	2062.74	132.05	835.94	simulation	2026-05-21 00:11:47.614469	f
986	2026-04-28	6h	6h-14h	Chaîne 16	727.82	94.56	4434.02	500.03	2691.72	601.85	1162.9	simulation	2026-05-21 00:11:47.614469	f
987	2026-04-28	14h	14h-22h	Chaîne 16	739.68	102.25	4729.57	491.96	2882.31	672.36	1300.52	simulation	2026-05-21 00:11:47.614469	f
988	2026-04-28	22h	22h-6h	Chaîne 16	690.4	92.46	4214.2	469.94	2315.02	572.21	1023.5	simulation	2026-05-21 00:11:47.614469	f
989	2026-04-29	6h	6h-14h	Chaîne 8	1068.25	220.94	10224.85	501.31	2626.59	181.02	1147.12	simulation	2026-05-21 00:11:47.614469	f
990	2026-04-29	14h	14h-22h	Chaîne 8	1175.44	224.81	9533.94	494.47	2777.7	187.66	1224.83	simulation	2026-05-21 00:11:47.614469	f
991	2026-04-29	22h	22h-6h	Chaîne 8	923.53	192.37	9175.2	471.3	2478.96	168.56	1175.67	simulation	2026-05-21 00:11:47.614469	f
992	2026-04-29	6h	6h-14h	Chaîne 14	631.96	239.41	8679.19	440.93	2316.73	156.33	1147.22	simulation	2026-05-21 00:11:47.614469	f
993	2026-04-29	14h	14h-22h	Chaîne 14	671	254.59	9072.14	425.05	2461.36	167.88	1128.01	simulation	2026-05-21 00:11:47.614469	f
994	2026-04-29	22h	22h-6h	Chaîne 14	547.05	210.88	8507.59	385.44	2222.17	150.3	923.65	simulation	2026-05-21 00:11:47.614469	f
995	2026-04-29	6h	6h-14h	Chaîne 15	0	6.25	0	58.11	248.04	0	0	simulation	2026-05-21 00:11:47.614469	t
996	2026-04-29	14h	14h-22h	Chaîne 15	0	6.54	0	59.24	250.53	0	0	simulation	2026-05-21 00:11:47.614469	t
997	2026-04-29	22h	22h-6h	Chaîne 15	0	6.28	0	61.8	268.42	0	0	simulation	2026-05-21 00:11:47.614469	t
998	2026-04-29	6h	6h-14h	Chaîne 16	683.51	105.05	4605.93	460.55	2775.64	641.37	1122.99	simulation	2026-05-21 00:11:47.614469	f
999	2026-04-29	14h	14h-22h	Chaîne 16	773.64	103.75	4771.2	494.16	2841.21	642.68	1260.46	simulation	2026-05-21 00:11:47.614469	f
1000	2026-04-29	22h	22h-6h	Chaîne 16	641.07	91.94	4479.3	450.88	2337.26	546.31	1008.92	simulation	2026-05-21 00:11:47.614469	f
1001	2026-04-30	6h	6h-14h	Chaîne 8	1098.7	218.86	9332.45	495.07	2641.54	171.07	1133.96	simulation	2026-05-21 00:11:47.614469	f
1002	2026-04-30	14h	14h-22h	Chaîne 8	1055.14	228.12	10265.3	491.33	3049.16	201.27	1362.56	simulation	2026-05-21 00:11:47.614469	f
1003	2026-04-30	22h	22h-6h	Chaîne 8	877.77	194.5	8521.97	466.57	2425.01	159.12	1108.33	simulation	2026-05-21 00:11:47.614469	f
1004	2026-04-30	6h	6h-14h	Chaîne 14	671.62	238.8	8692.66	418.54	2372.97	150.94	1086.99	simulation	2026-05-21 00:11:47.614469	f
1005	2026-04-30	14h	14h-22h	Chaîne 14	628.6	231.18	8461.15	441.17	2582.08	165.31	1141.79	simulation	2026-05-21 00:11:47.614469	f
1006	2026-04-30	22h	22h-6h	Chaîne 14	585.14	203.17	8425.13	404.29	2208.96	151.09	1043.32	simulation	2026-05-21 00:11:47.614469	f
1007	2026-04-30	6h	6h-14h	Chaîne 15	563.38	21.89	1484.95	408.17	2039.18	138.82	1041.73	simulation	2026-05-21 00:11:47.614469	f
1008	2026-04-30	14h	14h-22h	Chaîne 15	608.92	24.59	1504.47	394.3	2158.96	138.15	943.61	simulation	2026-05-21 00:11:47.614469	f
1009	2026-04-30	22h	22h-6h	Chaîne 15	514.23	19.44	1449.65	386.91	1890.83	122.78	877.55	simulation	2026-05-21 00:11:47.614469	f
1010	2026-04-30	6h	6h-14h	Chaîne 16	0	28.65	0	71.48	306.2	0	0	simulation	2026-05-21 00:11:47.614469	t
1011	2026-04-30	14h	14h-22h	Chaîne 16	0	29.56	0	75.71	311.51	0	0	simulation	2026-05-21 00:11:47.614469	t
1012	2026-04-30	22h	22h-6h	Chaîne 16	0	30.3	0	71.02	310.51	0	0	simulation	2026-05-21 00:11:47.614469	t
1013	2026-05-01	6h	6h-14h	Chaîne 8	1090.49	197.59	9294.02	482.21	2728.78	183.7	1113.36	simulation	2026-05-21 00:11:47.614469	f
1014	2026-05-01	14h	14h-22h	Chaîne 8	1132.69	227.68	10367.15	480.46	2996.7	193.78	1385.33	simulation	2026-05-21 00:11:47.614469	f
1015	2026-05-01	22h	22h-6h	Chaîne 8	982.9	198.22	8935.18	449	2446.47	155.01	1033.6	simulation	2026-05-21 00:11:47.614469	f
1016	2026-05-01	6h	6h-14h	Chaîne 14	622.45	225.68	8414.07	431.29	2355.35	158.74	1094.82	simulation	2026-05-21 00:11:47.614469	f
1017	2026-05-01	14h	14h-22h	Chaîne 14	690.1	234.47	8630.29	451.07	2479.62	158.45	1078.85	simulation	2026-05-21 00:11:47.614469	f
1018	2026-05-01	22h	22h-6h	Chaîne 14	550.58	209.93	8480.16	416.92	2033.55	148.44	925.71	simulation	2026-05-21 00:11:47.614469	f
1019	2026-05-01	6h	6h-14h	Chaîne 15	607.94	21.37	1523.19	386.19	2185.39	139.75	927.42	simulation	2026-05-21 00:11:47.614469	f
1020	2026-05-01	14h	14h-22h	Chaîne 15	574.38	24.52	1634.55	383.22	2318.76	148.21	987.55	simulation	2026-05-21 00:11:47.614469	f
1021	2026-05-01	22h	22h-6h	Chaîne 15	543.49	21.56	1508.67	352.55	1954.88	124.38	885.82	simulation	2026-05-21 00:11:47.614469	f
1022	2026-05-01	6h	6h-14h	Chaîne 16	718.29	97.22	4609.04	470.63	2645.7	654.57	1208.28	simulation	2026-05-21 00:11:47.614469	f
1023	2026-05-01	14h	14h-22h	Chaîne 16	764.62	99.62	4835	510.35	2654.2	626.78	1288.04	simulation	2026-05-21 00:11:47.614469	f
1024	2026-05-01	22h	22h-6h	Chaîne 16	654.91	96.04	4518.92	434.32	2494.23	567.94	1013.76	simulation	2026-05-21 00:11:47.614469	f
1025	2026-05-02	6h	6h-14h	Chaîne 8	1041.93	200.09	9718.57	480.53	2703.91	190.39	1203.33	simulation	2026-05-21 00:11:47.614469	f
1026	2026-05-02	14h	14h-22h	Chaîne 8	1104.45	220.76	9584.61	481.69	2794.66	202.63	1383.38	simulation	2026-05-21 00:11:47.614469	f
1027	2026-05-02	22h	22h-6h	Chaîne 8	958.34	198.27	9086.14	460.92	2305.12	158.87	1014.91	simulation	2026-05-21 00:11:47.614469	f
1028	2026-05-02	6h	6h-14h	Chaîne 14	657.35	235.13	9169.84	455.33	2504.34	150.72	1145.46	simulation	2026-05-21 00:11:47.614469	f
1029	2026-05-02	14h	14h-22h	Chaîne 14	645.96	249.46	9277.27	450.78	2605.93	163.18	1116.55	simulation	2026-05-21 00:11:47.614469	f
1030	2026-05-02	22h	22h-6h	Chaîne 14	597.83	203.23	8230.93	395.33	2073.2	137.4	1029.1	simulation	2026-05-21 00:11:47.614469	f
1031	2026-05-02	6h	6h-14h	Chaîne 15	548.37	21.98	1559.87	377.67	2039.59	147.9	953.15	simulation	2026-05-21 00:11:47.614469	f
1032	2026-05-02	14h	14h-22h	Chaîne 15	574	22.73	1640.15	404.18	2133.94	145.35	1041.8	simulation	2026-05-21 00:11:47.614469	f
1033	2026-05-02	22h	22h-6h	Chaîne 15	503.21	19.98	1467.82	381.09	1940.33	125.56	906.49	simulation	2026-05-21 00:11:47.614469	f
1034	2026-05-02	6h	6h-14h	Chaîne 16	684.74	94.04	4918.97	505.58	2622.06	622.36	1112.61	simulation	2026-05-21 00:11:47.614469	f
1035	2026-05-02	14h	14h-22h	Chaîne 16	774.91	107.3	4652.84	492.26	2754.1	674.53	1225.31	simulation	2026-05-21 00:11:47.614469	f
1036	2026-05-02	22h	22h-6h	Chaîne 16	656.2	88.62	4464.08	445.94	2448.45	557.98	1078.87	simulation	2026-05-21 00:11:47.614469	f
1037	2026-05-03	6h	6h-14h	Chaîne 8	907.88	169.62	9577.98	505.53	2161.79	146.92	1028.21	simulation	2026-05-21 00:11:47.614469	f
1038	2026-05-03	14h	14h-22h	Chaîne 8	1002.26	200.32	10417.82	484.28	2425.19	174.61	1056.65	simulation	2026-05-21 00:11:47.614469	f
1039	2026-05-03	22h	22h-6h	Chaîne 8	809.85	163.45	9505.85	456.23	1981.61	145.62	904.17	simulation	2026-05-21 00:11:47.614469	f
1040	2026-05-03	6h	6h-14h	Chaîne 14	543.69	197.82	9134.83	406.79	2759.12	141.59	774.47	simulation	2026-05-21 00:11:47.614469	f
1041	2026-05-03	14h	14h-22h	Chaîne 14	554.46	209.3	8943.56	457.7	2928.6	137.14	816.57	simulation	2026-05-21 00:11:47.614469	f
1042	2026-05-03	22h	22h-6h	Chaîne 14	464.06	172.92	8337.19	392.39	2958.77	126.12	717.89	simulation	2026-05-21 00:11:47.614469	f
1043	2026-05-03	6h	6h-14h	Chaîne 15	460.78	17.99	1545.47	387.05	1940.9	117.6	884.28	simulation	2026-05-21 00:11:47.614469	f
1044	2026-05-03	14h	14h-22h	Chaîne 15	479.39	18.87	1540.05	390.52	1945.82	120.24	896.81	simulation	2026-05-21 00:11:47.614469	f
1045	2026-05-03	22h	22h-6h	Chaîne 15	479.17	16.64	1355.01	360.21	1648.11	108.77	815.99	simulation	2026-05-21 00:11:47.614469	f
1046	2026-05-03	6h	6h-14h	Chaîne 16	576.06	83.27	4736.78	490.25	2193.04	504.41	1072.37	simulation	2026-05-21 00:11:47.614469	f
1047	2026-05-03	14h	14h-22h	Chaîne 16	604.23	88.13	4918.19	491.23	2271.83	557.83	1102.2	simulation	2026-05-21 00:11:47.614469	f
1048	2026-05-03	22h	22h-6h	Chaîne 16	542.14	83.7	4584.77	467.77	2016.62	498.45	877.98	simulation	2026-05-21 00:11:47.614469	f
1049	2026-05-04	6h	6h-14h	Chaîne 8	0	64.73	0	71.94	321.31	0	0	simulation	2026-05-21 00:11:47.614469	t
1050	2026-05-04	14h	14h-22h	Chaîne 8	0	64.05	0	71.45	330.7	0	0	simulation	2026-05-21 00:11:47.614469	t
1051	2026-05-04	22h	22h-6h	Chaîne 8	0	68.28	0	68.72	291.18	0	0	simulation	2026-05-21 00:11:47.614469	t
1052	2026-05-04	6h	6h-14h	Chaîne 14	625.65	244.69	8461.85	431.71	2454.73	160.14	1146.88	simulation	2026-05-21 00:11:47.614469	f
1053	2026-05-04	14h	14h-22h	Chaîne 14	629.97	253.28	8949.16	419.29	2530.89	155.85	1075.97	simulation	2026-05-21 00:11:47.614469	f
1054	2026-05-04	22h	22h-6h	Chaîne 14	604.94	220.22	8141.28	412.54	2211.73	145.58	934.88	simulation	2026-05-21 00:11:47.614469	f
1055	2026-05-04	6h	6h-14h	Chaîne 15	594.36	23.23	1610.08	393.94	2212.21	139.88	943.78	simulation	2026-05-21 00:11:47.614469	f
1056	2026-05-04	14h	14h-22h	Chaîne 15	604.69	22.38	1613.66	403.97	2229.5	145.39	961.47	simulation	2026-05-21 00:11:47.614469	f
1057	2026-05-04	22h	22h-6h	Chaîne 15	524.38	20.45	1375.19	355.84	1940.3	125.21	919.47	simulation	2026-05-21 00:11:47.614469	f
1058	2026-05-04	6h	6h-14h	Chaîne 16	721.56	99.84	4729.94	493.19	2490.57	612.68	1147.59	simulation	2026-05-21 00:11:47.614469	f
1059	2026-05-04	14h	14h-22h	Chaîne 16	727.65	105.08	5045.02	488.79	2817.28	623.61	1341.79	simulation	2026-05-21 00:11:47.614469	f
1060	2026-05-04	22h	22h-6h	Chaîne 16	667.14	95.42	4441.27	475.82	2362.49	572.78	1066.31	simulation	2026-05-21 00:11:47.614469	f
1061	2026-05-05	6h	6h-14h	Chaîne 8	1001.34	202.62	10076.32	486.98	2702.63	178.4	1198.8	simulation	2026-05-21 00:11:47.614469	f
1062	2026-05-05	14h	14h-22h	Chaîne 8	1084.96	229.65	10373.43	515.83	2858.71	192.56	1346.73	simulation	2026-05-21 00:11:47.614469	f
1063	2026-05-05	22h	22h-6h	Chaîne 8	921.18	192.26	9491.96	470.24	2395.68	173.33	1126	simulation	2026-05-21 00:11:47.614469	f
1064	2026-05-05	6h	6h-14h	Chaîne 14	0	72.46	0	63.29	288.1	0	0	simulation	2026-05-21 00:11:47.614469	t
1065	2026-05-05	14h	14h-22h	Chaîne 14	0	72.69	0	64.53	303.71	0	0	simulation	2026-05-21 00:11:47.614469	t
1066	2026-05-05	22h	22h-6h	Chaîne 14	0	73.06	0	61.16	282	0	0	simulation	2026-05-21 00:11:47.614469	t
1067	2026-05-05	6h	6h-14h	Chaîne 15	582.68	22.97	1571.3	394.14	2281.55	143.3	1041.47	simulation	2026-05-21 00:11:47.614469	f
1068	2026-05-05	14h	14h-22h	Chaîne 15	613.56	23.21	1643.18	388.64	2171.17	142.2	989.43	simulation	2026-05-21 00:11:47.614469	f
1069	2026-05-05	22h	22h-6h	Chaîne 15	539.15	20.65	1357.78	368.06	1912.69	123.6	899.33	simulation	2026-05-21 00:11:47.614469	f
1070	2026-05-05	6h	6h-14h	Chaîne 16	725.16	105.24	4629.07	465.98	2602.49	595.29	1170.62	simulation	2026-05-21 00:11:47.614469	f
1071	2026-05-05	14h	14h-22h	Chaîne 16	721.02	109.52	4901.3	487.65	2706.94	690.75	1224.9	simulation	2026-05-21 00:11:47.614469	f
1072	2026-05-05	22h	22h-6h	Chaîne 16	647.61	93.11	4555.76	471.27	2486.23	553.7	1052.51	simulation	2026-05-21 00:11:47.614469	f
1073	2026-05-06	6h	6h-14h	Chaîne 8	1044.65	218.9	9865.84	508.75	2703.61	187.92	1187.18	simulation	2026-05-21 00:11:47.614469	f
1074	2026-05-06	14h	14h-22h	Chaîne 8	1094.07	226.1	10159.01	477.71	2914.19	193.75	1263.94	simulation	2026-05-21 00:11:47.614469	f
1075	2026-05-06	22h	22h-6h	Chaîne 8	966.99	200.84	8661.41	443.73	2274.43	162.61	1055.2	simulation	2026-05-21 00:11:47.614469	f
1076	2026-05-06	6h	6h-14h	Chaîne 14	621.52	231.77	8226.05	449.62	2343.31	148.93	1007.33	simulation	2026-05-21 00:11:47.614469	f
1077	2026-05-06	14h	14h-22h	Chaîne 14	630.01	257.88	9168.91	425.6	2417.32	160.36	1082.73	simulation	2026-05-21 00:11:47.614469	f
1078	2026-05-06	22h	22h-6h	Chaîne 14	563.18	212.07	8081.44	398.29	2138.2	146.23	1039.44	simulation	2026-05-21 00:11:47.614469	f
1079	2026-05-06	6h	6h-14h	Chaîne 15	0	6.67	0	61.88	253.58	0	0	simulation	2026-05-21 00:11:47.614469	t
1080	2026-05-06	14h	14h-22h	Chaîne 15	0	6.87	0	57.64	262.29	0	0	simulation	2026-05-21 00:11:47.614469	t
1081	2026-05-06	22h	22h-6h	Chaîne 15	0	6.23	0	61.21	263.6	0	0	simulation	2026-05-21 00:11:47.614469	t
1082	2026-05-06	6h	6h-14h	Chaîne 16	708.46	99.04	4658.16	457.36	2557.64	647.69	1108.33	simulation	2026-05-21 00:11:47.614469	f
1083	2026-05-06	14h	14h-22h	Chaîne 16	745.96	103.07	4620.19	521.64	2906.15	691.64	1349.44	simulation	2026-05-21 00:11:47.614469	f
1084	2026-05-06	22h	22h-6h	Chaîne 16	698.73	93.96	4474.72	448.23	2267.92	587.71	1065.51	simulation	2026-05-21 00:11:47.614469	f
1085	2026-05-07	6h	6h-14h	Chaîne 8	1075.37	214.83	9122.2	468.33	2709.17	184.41	1199.3	simulation	2026-05-21 00:11:47.614469	f
1086	2026-05-07	14h	14h-22h	Chaîne 8	1094.97	219.08	9452.57	478.14	2833.59	201.42	1279.75	simulation	2026-05-21 00:11:47.614469	f
1087	2026-05-07	22h	22h-6h	Chaîne 8	913.86	196.92	8769.35	477.08	2256.18	162.08	1058.27	simulation	2026-05-21 00:11:47.614469	f
1088	2026-05-07	6h	6h-14h	Chaîne 14	671.04	224.97	8688.85	445.37	2472.8	151.89	1086.57	simulation	2026-05-21 00:11:47.614469	f
1089	2026-05-07	14h	14h-22h	Chaîne 14	666.45	240.98	8865.4	458.68	2350.75	173.64	1184.29	simulation	2026-05-21 00:11:47.614469	f
1090	2026-05-07	22h	22h-6h	Chaîne 14	565.08	203.08	8061.37	381.89	2038.11	146.87	1039.99	simulation	2026-05-21 00:11:47.614469	f
1091	2026-05-07	6h	6h-14h	Chaîne 15	599.68	22.26	1504.78	374.86	2269.52	137.73	914.46	simulation	2026-05-21 00:11:47.614469	f
1092	2026-05-07	14h	14h-22h	Chaîne 15	568.21	24.25	1628.76	407.24	2281.17	144.79	962.23	simulation	2026-05-21 00:11:47.614469	f
1093	2026-05-07	22h	22h-6h	Chaîne 15	535.57	21.54	1364.91	361.64	2037.99	125.19	848.87	simulation	2026-05-21 00:11:47.614469	f
1094	2026-05-07	6h	6h-14h	Chaîne 16	0	31.33	0	73.92	298.68	0	0	simulation	2026-05-21 00:11:47.614469	t
1095	2026-05-07	14h	14h-22h	Chaîne 16	0	30.91	0	71.27	348.69	0	0	simulation	2026-05-21 00:11:47.614469	t
1096	2026-05-07	22h	22h-6h	Chaîne 16	0	30.98	0	70.17	303.34	0	0	simulation	2026-05-21 00:11:47.614469	t
1097	2026-05-08	6h	6h-14h	Chaîne 8	1036.01	213.2	9530.54	504.84	2511.31	173.96	1211.3	simulation	2026-05-21 00:11:47.614469	f
1098	2026-05-08	14h	14h-22h	Chaîne 8	1134	228.85	9831.33	519.52	2910.9	204.95	1350.48	simulation	2026-05-21 00:11:47.614469	f
1099	2026-05-08	22h	22h-6h	Chaîne 8	972.71	210.92	8922.32	437.42	2423.01	154.96	1101.19	simulation	2026-05-21 00:11:47.614469	f
1100	2026-05-08	6h	6h-14h	Chaîne 14	665.56	243.37	8322.26	417.4	2437.84	153.17	1029.83	simulation	2026-05-21 00:11:47.614469	f
1101	2026-05-08	14h	14h-22h	Chaîne 14	624.69	240.61	8584.75	463.78	2419.44	160.72	1094.1	simulation	2026-05-21 00:11:47.614469	f
1102	2026-05-08	22h	22h-6h	Chaîne 14	551.93	218.79	8112.1	390.05	2216.11	138.48	996.07	simulation	2026-05-21 00:11:47.614469	f
1103	2026-05-08	6h	6h-14h	Chaîne 15	543.1	22.68	1502.21	394.83	2076.23	143.36	928.66	simulation	2026-05-21 00:11:47.614469	f
1104	2026-05-08	14h	14h-22h	Chaîne 15	612.51	23.54	1546.96	415.89	2174.53	139.91	994.85	simulation	2026-05-21 00:11:47.614469	f
1105	2026-05-08	22h	22h-6h	Chaîne 15	543.63	21.2	1402.5	348.06	1995.87	135.75	947.99	simulation	2026-05-21 00:11:47.614469	f
1106	2026-05-08	6h	6h-14h	Chaîne 16	742.23	100.75	4710.97	461.72	2507.64	620.36	1191.57	simulation	2026-05-21 00:11:47.614469	f
1107	2026-05-08	14h	14h-22h	Chaîne 16	745.42	106.64	4844.73	483.18	2842.95	697.19	1261.11	simulation	2026-05-21 00:11:47.614469	f
1108	2026-05-08	22h	22h-6h	Chaîne 16	648.74	95.77	4511.1	459.67	2414.47	571.96	1079.71	simulation	2026-05-21 00:11:47.614469	f
1109	2026-05-09	6h	6h-14h	Chaîne 8	1091.94	206.53	9701.85	495.98	2670.98	177.89	1133.83	simulation	2026-05-21 00:11:47.614469	f
1110	2026-05-09	14h	14h-22h	Chaîne 8	1165.15	217.55	9645.68	500.08	3025.49	204	1341.26	simulation	2026-05-21 00:11:47.614469	f
1111	2026-05-09	22h	22h-6h	Chaîne 8	952.4	192.23	9052.4	442.79	2409.91	155.78	1160.39	simulation	2026-05-21 00:11:47.614469	f
1112	2026-05-09	6h	6h-14h	Chaîne 14	603.41	227.89	9045.17	448.6	2310.45	162.8	1099.37	simulation	2026-05-21 00:11:47.614469	f
1113	2026-05-09	14h	14h-22h	Chaîne 14	633.9	252.66	9410.44	449.5	2605.62	167.46	1196.35	simulation	2026-05-21 00:11:47.614469	f
1114	2026-05-09	22h	22h-6h	Chaîne 14	578.92	222.58	8012.06	422.92	2059.44	136.41	1026.93	simulation	2026-05-21 00:11:47.614469	f
1115	2026-05-09	6h	6h-14h	Chaîne 15	571.65	21.38	1557.77	390.18	2222.95	138.84	935.28	simulation	2026-05-21 00:11:47.614469	f
1116	2026-05-09	14h	14h-22h	Chaîne 15	575.94	23.45	1486.84	398.2	2319.02	140.44	942.95	simulation	2026-05-21 00:11:47.614469	f
1117	2026-05-09	22h	22h-6h	Chaîne 15	530.89	20.84	1458.03	349.09	1936.1	127.05	959.29	simulation	2026-05-21 00:11:47.614469	f
1118	2026-05-09	6h	6h-14h	Chaîne 16	743.51	100.83	4932.84	497.76	2770.43	638.65	1227.87	simulation	2026-05-21 00:11:47.614469	f
1119	2026-05-09	14h	14h-22h	Chaîne 16	688.72	99.97	4721.66	508.65	2771.85	679.22	1285.28	simulation	2026-05-21 00:11:47.614469	f
1120	2026-05-09	22h	22h-6h	Chaîne 16	634.21	88.82	4505.45	428.77	2285.39	586.49	1038.27	simulation	2026-05-21 00:11:47.614469	f
1121	2026-05-10	6h	6h-14h	Chaîne 8	863.78	181.38	9764.35	476.53	2255.01	148.21	1001.26	simulation	2026-05-21 00:11:47.614469	f
1122	2026-05-10	14h	14h-22h	Chaîne 8	962.87	188.91	10284.28	510.17	2383.52	165.68	1173.07	simulation	2026-05-21 00:11:47.614469	f
1123	2026-05-10	22h	22h-6h	Chaîne 8	777.21	171.58	9442.94	469.36	2133.53	137.68	869.75	simulation	2026-05-21 00:11:47.614469	f
1124	2026-05-10	6h	6h-14h	Chaîne 14	541.59	196.96	8642.91	449.77	2064.5	132.35	931.24	simulation	2026-05-21 00:11:47.614469	f
1125	2026-05-10	14h	14h-22h	Chaîne 14	535.35	201.16	8870.87	423.92	2180.07	143.7	993.19	simulation	2026-05-21 00:11:47.614469	f
1126	2026-05-10	22h	22h-6h	Chaîne 14	470.63	185.97	8536.93	389.81	1730.85	119.97	869.86	simulation	2026-05-21 00:11:47.614469	f
1127	2026-05-10	6h	6h-14h	Chaîne 15	501.38	17.69	1586.55	413.18	1775.96	116.47	837.14	simulation	2026-05-21 00:11:47.614469	f
1128	2026-05-10	14h	14h-22h	Chaîne 15	499.64	19.69	1599.28	381.72	1938.88	128.18	929.56	simulation	2026-05-21 00:11:47.614469	f
1129	2026-05-10	22h	22h-6h	Chaîne 15	469.39	17.34	1454.18	363.52	1605.68	106.48	750.81	simulation	2026-05-21 00:11:47.614469	f
1130	2026-05-10	6h	6h-14h	Chaîne 16	637.72	83.16	4806.4	501.29	2221.13	517.86	1004.62	simulation	2026-05-21 00:11:47.614469	f
1131	2026-05-10	14h	14h-22h	Chaîne 16	658.02	90.23	4495.36	472.68	2521.93	531.42	1019.71	simulation	2026-05-21 00:11:47.614469	f
1132	2026-05-10	22h	22h-6h	Chaîne 16	574.48	80	4368.64	461.5	1934.65	456.72	942.69	simulation	2026-05-21 00:11:47.614469	f
1133	2026-05-11	6h	6h-14h	Chaîne 8	0	60.17	0	72.79	322.15	0	0	simulation	2026-05-21 00:11:47.614469	t
1134	2026-05-11	14h	14h-22h	Chaîne 8	0	69.65	0	74.16	358.2	0	0	simulation	2026-05-21 00:11:47.614469	t
1135	2026-05-11	22h	22h-6h	Chaîne 8	0	65.02	0	68.75	317.56	0	0	simulation	2026-05-21 00:11:47.614469	t
1136	2026-05-11	6h	6h-14h	Chaîne 14	650.16	235.52	8706.83	412.69	2252.21	165.19	1063.67	simulation	2026-05-21 00:11:47.614469	f
1137	2026-05-11	14h	14h-22h	Chaîne 14	627.4	243.63	9246.1	435.14	2599.98	172.33	1078.67	simulation	2026-05-21 00:11:47.614469	f
1138	2026-05-11	22h	22h-6h	Chaîne 14	588.69	211.18	8038.29	397.68	2271.54	146.55	1023.37	simulation	2026-05-21 00:11:47.614469	f
1139	2026-05-11	6h	6h-14h	Chaîne 15	598.63	21.75	1601.13	402.89	2138.49	137.63	972.41	simulation	2026-05-21 00:11:47.614469	f
1140	2026-05-11	14h	14h-22h	Chaîne 15	617.52	24.28	1601.19	388.14	2290.28	146.33	1051.65	simulation	2026-05-21 00:11:47.614469	f
1141	2026-05-11	22h	22h-6h	Chaîne 15	504.68	19.35	1382.67	352.02	1924.54	122.12	826.28	simulation	2026-05-21 00:11:47.614469	f
1142	2026-05-11	6h	6h-14h	Chaîne 16	747.68	103.87	4802.49	507.46	2667.37	650.01	1171.06	simulation	2026-05-21 00:11:47.614469	f
1143	2026-05-11	14h	14h-22h	Chaîne 16	765.11	106	4989.48	507.53	2862.68	638.16	1199.81	simulation	2026-05-21 00:11:47.614469	f
1144	2026-05-11	22h	22h-6h	Chaîne 16	686.38	95.06	4337.45	451.78	2481.64	558.99	1012.92	simulation	2026-05-21 00:11:47.614469	f
1145	2026-05-12	6h	6h-14h	Chaîne 8	1106.61	215.41	9300.27	457.88	2485.41	182.99	1210.36	simulation	2026-05-21 00:11:47.614469	f
1146	2026-05-12	14h	14h-22h	Chaîne 8	1128.55	222.02	10359.06	482.45	2841.61	198.44	1339.64	simulation	2026-05-21 00:11:47.614469	f
1147	2026-05-12	22h	22h-6h	Chaîne 8	954.53	191.19	9052.67	477.98	2295.85	162.28	1135.03	simulation	2026-05-21 00:11:47.614469	f
1148	2026-05-12	6h	6h-14h	Chaîne 14	0	67.04	0	63.57	268.83	0	0	simulation	2026-05-21 00:11:47.614469	t
1149	2026-05-12	14h	14h-22h	Chaîne 14	0	67.95	0	68.64	293.53	0	0	simulation	2026-05-21 00:11:47.614469	t
1150	2026-05-12	22h	22h-6h	Chaîne 14	0	70.98	0	65.47	285.01	0	0	simulation	2026-05-21 00:11:47.614469	t
1151	2026-05-12	6h	6h-14h	Chaîne 15	554.91	22.92	1515.86	394.02	2169.08	141.35	976.6	simulation	2026-05-21 00:11:47.614469	f
1152	2026-05-12	14h	14h-22h	Chaîne 15	569.92	22.33	1585.55	397.99	2243.07	140.63	963.73	simulation	2026-05-21 00:11:47.614469	f
1153	2026-05-12	22h	22h-6h	Chaîne 15	534.66	19.51	1370.89	371.78	1858.31	128.15	901.36	simulation	2026-05-21 00:11:47.614469	f
1154	2026-05-12	6h	6h-14h	Chaîne 16	756.17	104.05	4880.27	509.06	2494.76	585.15	1133.28	simulation	2026-05-21 00:11:47.614469	f
1155	2026-05-12	14h	14h-22h	Chaîne 16	736.95	107.5	4645.05	522.53	2774.44	636.82	1189.01	simulation	2026-05-21 00:11:47.614469	f
1156	2026-05-12	22h	22h-6h	Chaîne 16	664.44	90.69	4095.62	429.65	2472.48	579.68	1057.18	simulation	2026-05-21 00:11:47.614469	f
1157	2026-05-13	6h	6h-14h	Chaîne 8	1066.39	221.68	9200.42	506.49	2540.47	169.57	1136.22	simulation	2026-05-21 00:11:47.614469	f
1158	2026-05-13	14h	14h-22h	Chaîne 8	1108.54	227.08	10341.38	489.5	3074.93	202.14	1343.8	simulation	2026-05-21 00:11:47.614469	f
1159	2026-05-13	22h	22h-6h	Chaîne 8	933.1	190.61	9437.73	449.78	2264.32	165.13	1135.11	simulation	2026-05-21 00:11:47.614469	f
1160	2026-05-13	6h	6h-14h	Chaîne 14	648.69	245.02	8967.69	424.75	2370.31	165.71	1145.05	simulation	2026-05-21 00:11:47.614469	f
1161	2026-05-13	14h	14h-22h	Chaîne 14	639.98	244.66	9142.65	463.33	2590.75	158.23	1166.21	simulation	2026-05-21 00:11:47.614469	f
1162	2026-05-13	22h	22h-6h	Chaîne 14	570.86	227.08	8051.11	395.27	2259.81	144.24	915.94	simulation	2026-05-21 00:11:47.614469	f
1163	2026-05-13	6h	6h-14h	Chaîne 15	0	6.44	0	62.8	246.35	0	0	simulation	2026-05-21 00:11:47.614469	t
1164	2026-05-13	14h	14h-22h	Chaîne 15	0	6.78	0	55.87	268.62	0	0	simulation	2026-05-21 00:11:47.614469	t
1165	2026-05-13	22h	22h-6h	Chaîne 15	0	6.68	0	57.53	265.06	0	0	simulation	2026-05-21 00:11:47.614469	t
1166	2026-05-13	6h	6h-14h	Chaîne 16	715.88	104.08	4447.21	487.39	2691.14	612.2	1287.12	simulation	2026-05-21 00:11:47.614469	f
1167	2026-05-13	14h	14h-22h	Chaîne 16	696.13	100.68	4506.32	508.94	2683.59	659.87	1306.65	simulation	2026-05-21 00:11:47.614469	f
1168	2026-05-13	22h	22h-6h	Chaîne 16	676.23	89.72	4121.71	477.64	2358.58	562.08	1148.13	simulation	2026-05-21 00:11:47.614469	f
1169	2026-05-14	6h	6h-14h	Chaîne 8	995.53	211.8	9383.53	468.28	2664.52	176.62	1255.37	simulation	2026-05-21 00:11:47.614469	f
1170	2026-05-14	14h	14h-22h	Chaîne 8	1112.47	229.88	9944.02	497.17	3003.66	207.78	1407.43	simulation	2026-05-21 00:11:47.614469	f
1171	2026-05-14	22h	22h-6h	Chaîne 8	885.13	191.6	9251.84	440.22	2356.21	161.52	1043.81	simulation	2026-05-21 00:11:47.614469	f
1172	2026-05-14	6h	6h-14h	Chaîne 14	620.97	231.65	8797.39	439.44	2476.57	151.29	1117.98	simulation	2026-05-21 00:11:47.614469	f
1173	2026-05-14	14h	14h-22h	Chaîne 14	681.31	246.06	8756.6	464.76	2381.91	155	1202.38	simulation	2026-05-21 00:11:47.614469	f
1174	2026-05-14	22h	22h-6h	Chaîne 14	563.93	211.85	7810.93	400.41	2219.81	134.74	996.7	simulation	2026-05-21 00:11:47.614469	f
1175	2026-05-14	6h	6h-14h	Chaîne 15	601.57	20.77	1463.1	386.67	2274.23	141.64	941.73	simulation	2026-05-21 00:11:47.614469	f
1176	2026-05-14	14h	14h-22h	Chaîne 15	617.95	24.05	1513.3	400.14	2272.58	153.93	1007.97	simulation	2026-05-21 00:11:47.614469	f
1177	2026-05-14	22h	22h-6h	Chaîne 15	508.32	19.47	1401.51	360.23	1848.91	120.92	909.44	simulation	2026-05-21 00:11:47.614469	f
1178	2026-05-14	6h	6h-14h	Chaîne 16	0	28.83	0	71.35	335.62	0	0	simulation	2026-05-21 00:11:47.614469	t
1179	2026-05-14	14h	14h-22h	Chaîne 16	0	29.49	0	71.56	344.67	0	0	simulation	2026-05-21 00:11:47.614469	t
1180	2026-05-14	22h	22h-6h	Chaîne 16	0	28.8	0	76.37	317.34	0	0	simulation	2026-05-21 00:11:47.614469	t
1181	2026-05-15	6h	6h-14h	Chaîne 8	1089.95	205.45	9916.3	506.57	2727.53	179.2	1239.19	simulation	2026-05-21 00:11:47.614469	f
1182	2026-05-15	14h	14h-22h	Chaîne 8	1084.33	236.71	9690.35	508.19	3089.31	194.01	1374.97	simulation	2026-05-21 00:11:47.614469	f
1183	2026-05-15	22h	22h-6h	Chaîne 8	917.62	201.14	9539.43	471.87	2278.94	172.87	1102.24	simulation	2026-05-21 00:11:47.614469	f
1184	2026-05-15	6h	6h-14h	Chaîne 14	667.06	229.79	9151.66	444.47	2429.28	162.7	1119.83	simulation	2026-05-21 00:11:47.614469	f
1185	2026-05-15	14h	14h-22h	Chaîne 14	647.28	248.99	9378.38	459.72	2363.4	164.46	1124.25	simulation	2026-05-21 00:11:47.614469	f
1186	2026-05-15	22h	22h-6h	Chaîne 14	575.86	226.13	8274.24	419.58	2094.35	139.95	917.36	simulation	2026-05-21 00:11:47.614469	f
1187	2026-05-15	6h	6h-14h	Chaîne 15	554.94	22.29	1502.59	402.02	2264.56	144.56	990.61	simulation	2026-05-21 00:11:47.614469	f
1188	2026-05-15	14h	14h-22h	Chaîne 15	562.77	24.65	1591.41	389.05	2367.14	149.66	1043.16	simulation	2026-05-21 00:11:47.614469	f
1189	2026-05-15	22h	22h-6h	Chaîne 15	507.63	20.76	1366.82	372.44	1926.15	121.47	842.2	simulation	2026-05-21 00:11:47.614469	f
1190	2026-05-15	6h	6h-14h	Chaîne 16	696.4	101.95	4443.96	492.85	2656.16	618.33	1244.62	simulation	2026-05-21 00:11:47.614469	f
1191	2026-05-15	14h	14h-22h	Chaîne 16	731.24	104.53	4938.15	483.52	2804.91	682.13	1220.35	simulation	2026-05-21 00:11:47.614469	f
1192	2026-05-15	22h	22h-6h	Chaîne 16	630.65	95.55	4561.86	425.27	2459.83	573.77	1161.53	simulation	2026-05-21 00:11:47.614469	f
1193	2026-05-16	6h	6h-14h	Chaîne 8	1047.53	201.42	10188.47	460.24	2552.67	170.4	1211.37	simulation	2026-05-21 00:11:47.614469	f
1194	2026-05-16	14h	14h-22h	Chaîne 8	1111.42	226.47	9363.3	484.29	3091.12	196.89	1308.83	simulation	2026-05-21 00:11:47.614469	f
1195	2026-05-16	22h	22h-6h	Chaîne 8	923.47	207.4	9236.5	440.55	2328.74	160.11	1084.4	simulation	2026-05-21 00:11:47.614469	f
1196	2026-05-16	6h	6h-14h	Chaîne 14	646.09	248.5	8241.06	426.15	2373.92	162.12	1087.39	simulation	2026-05-21 00:11:47.614469	f
1197	2026-05-16	14h	14h-22h	Chaîne 14	671.5	238.05	9266.26	456.07	2611.46	156.04	1140.66	simulation	2026-05-21 00:11:47.614469	f
1198	2026-05-16	22h	22h-6h	Chaîne 14	559.45	213.81	8165.64	395.64	2037.93	142.23	959.47	simulation	2026-05-21 00:11:47.614469	f
1199	2026-05-16	6h	6h-14h	Chaîne 15	724.03	32.71	1567.63	380.59	2204.14	133.93	1056.79	simulation	2026-05-21 00:11:47.614469	f
1200	2026-05-16	14h	14h-22h	Chaîne 15	676.99	38.52	1629.11	395.21	2291.41	146.82	952.83	simulation	2026-05-21 00:11:47.614469	f
1201	2026-05-16	22h	22h-6h	Chaîne 15	659.54	31.2	1374.12	358.34	1860.4	135.07	898.29	simulation	2026-05-21 00:11:47.614469	f
1202	2026-05-16	6h	6h-14h	Chaîne 16	703.87	94.57	4543.85	502.5	2539.63	629.04	1276.23	simulation	2026-05-21 00:11:47.614469	f
1203	2026-05-16	14h	14h-22h	Chaîne 16	741.33	100.07	4738.95	504.41	2747.2	624.45	1315.45	simulation	2026-05-21 00:11:47.614469	f
1204	2026-05-16	22h	22h-6h	Chaîne 16	669.22	98.06	4588.87	429.52	2414.11	527.75	1118.3	simulation	2026-05-21 00:11:47.614469	f
1205	2026-05-17	6h	6h-14h	Chaîne 8	924.41	187.2	9602.45	476.42	2254.66	160.01	994.98	simulation	2026-05-21 00:11:47.614469	f
1206	2026-05-17	14h	14h-22h	Chaîne 8	978.28	191.33	9668.61	498.94	2506.2	176.99	1216.1	simulation	2026-05-21 00:11:47.614469	f
1207	2026-05-17	22h	22h-6h	Chaîne 8	825.85	169.56	8901.06	448.97	2023.85	139.82	950.69	simulation	2026-05-21 00:11:47.614469	f
1208	2026-05-17	6h	6h-14h	Chaîne 14	531.22	194.41	9139.31	415.07	2052.71	141.62	863.52	simulation	2026-05-21 00:11:47.614469	f
1209	2026-05-17	14h	14h-22h	Chaîne 14	527.18	213.3	9213.05	416.41	2204.59	143.39	900.66	simulation	2026-05-21 00:11:47.614469	f
1210	2026-05-17	22h	22h-6h	Chaîne 14	479.03	191.53	8080.16	403.09	1891.63	126.72	896.34	simulation	2026-05-21 00:11:47.614469	f
1211	2026-05-17	6h	6h-14h	Chaîne 15	460.04	19.48	1606.01	383.6	1818.9	121.5	891.65	simulation	2026-05-21 00:11:47.614469	f
1212	2026-05-17	14h	14h-22h	Chaîne 15	519.46	18.93	1573.37	380.5	1996.12	119.11	911.2	simulation	2026-05-21 00:11:47.614469	f
1213	2026-05-17	22h	22h-6h	Chaîne 15	459.18	16.63	1461.63	349.85	1618.98	104.05	761.37	simulation	2026-05-21 00:11:47.614469	f
1214	2026-05-17	6h	6h-14h	Chaîne 16	595.35	81.42	4842.34	458.25	2188.9	546.4	960.51	simulation	2026-05-21 00:11:47.614469	f
1215	2026-05-17	14h	14h-22h	Chaîne 16	644.71	84.07	4794.99	467.32	2267.02	574.76	1111.5	simulation	2026-05-21 00:11:47.614469	f
1216	2026-05-17	22h	22h-6h	Chaîne 16	580.22	79.19	4175.98	448.98	2048.96	477.76	859.37	simulation	2026-05-21 00:11:47.614469	f
1217	2026-05-18	6h	6h-14h	Chaîne 8	0	63.57	0	73.84	301.89	0	0	simulation	2026-05-21 00:11:47.614469	t
1218	2026-05-18	14h	14h-22h	Chaîne 8	0	62.6	0	70.57	343.74	0	0	simulation	2026-05-21 00:11:47.614469	t
1219	2026-05-18	22h	22h-6h	Chaîne 8	0	68.09	0	75.04	302.71	0	0	simulation	2026-05-21 00:11:47.614469	t
1220	2026-05-18	6h	6h-14h	Chaîne 14	604.07	249	8450.82	428.43	2431.94	164.87	1062.49	simulation	2026-05-21 00:11:47.614469	f
1221	2026-05-18	14h	14h-22h	Chaîne 14	630.97	252.54	9424.03	428.61	2381.3	170.11	1138.59	simulation	2026-05-21 00:11:47.614469	f
1222	2026-05-18	22h	22h-6h	Chaîne 14	578.28	219.45	8341.12	382.13	2073.47	151.34	1005.26	simulation	2026-05-21 00:11:47.614469	f
1223	2026-05-18	6h	6h-14h	Chaîne 15	567.89	22.49	1487.16	406.25	2243.27	149.24	940.46	simulation	2026-05-21 00:11:47.614469	f
1224	2026-05-18	14h	14h-22h	Chaîne 15	598.68	22.07	1580.31	388.72	2235.42	147.31	1083.54	simulation	2026-05-21 00:11:47.614469	f
1225	2026-05-18	22h	22h-6h	Chaîne 15	534	19.31	1459.03	364.36	2072.86	127.4	896.43	simulation	2026-05-21 00:11:47.614469	f
1226	2026-05-18	6h	6h-14h	Chaîne 16	693.37	98.55	4430.05	480	2580.32	611.16	1123.58	simulation	2026-05-21 00:11:47.614469	f
1227	2026-05-18	14h	14h-22h	Chaîne 16	758.66	101.2	4871.8	481.69	2734.34	646.11	1288.59	simulation	2026-05-21 00:11:47.614469	f
1228	2026-05-18	22h	22h-6h	Chaîne 16	703.18	91.96	4438.38	448.4	2488.84	591.11	1097.32	simulation	2026-05-21 00:11:47.614469	f
1229	2026-05-19	6h	6h-14h	Chaîne 8	1029.26	215.29	9472.88	468.37	2690.93	189.82	1152.98	simulation	2026-05-21 00:11:47.614469	f
1230	2026-05-19	14h	14h-22h	Chaîne 8	1116.74	228.77	9638.22	511.72	2837	200.93	1269.62	simulation	2026-05-21 00:11:47.614469	f
1231	2026-05-19	22h	22h-6h	Chaîne 8	878.77	194.45	9561.26	477.18	2466.14	164.98	1100.33	simulation	2026-05-21 00:11:47.614469	f
1232	2026-05-19	6h	6h-14h	Chaîne 14	0	67.73	0	67.8	269.66	0	0	simulation	2026-05-21 00:11:47.614469	t
1233	2026-05-19	14h	14h-22h	Chaîne 14	0	73.19	0	68.3	286.16	0	0	simulation	2026-05-21 00:11:47.614469	t
1234	2026-05-19	22h	22h-6h	Chaîne 14	0	72.34	0	63.57	276.76	0	0	simulation	2026-05-21 00:11:47.614469	t
1235	2026-05-19	6h	6h-14h	Chaîne 15	601.46	22.6	1453.88	397.17	2171.62	149.26	975.1	simulation	2026-05-21 00:11:47.614469	f
1236	2026-05-19	14h	14h-22h	Chaîne 15	603.71	24.63	1632.96	416.78	2328.37	155.17	968.55	simulation	2026-05-21 00:11:47.614469	f
1237	2026-05-19	22h	22h-6h	Chaîne 15	509.52	20.29	1495.93	383.46	2019.81	129.1	852.98	simulation	2026-05-21 00:11:47.614469	f
1238	2026-05-19	6h	6h-14h	Chaîne 16	724.9	95.97	4671.28	504.83	2737.44	638.78	1110.74	simulation	2026-05-21 00:11:47.614469	f
1239	2026-05-19	14h	14h-22h	Chaîne 16	739.92	104.02	4809.7	465.23	2787.08	692.09	1181.23	simulation	2026-05-21 00:11:47.614469	f
1240	2026-05-19	22h	22h-6h	Chaîne 16	662.35	92.16	4421.76	438.7	2334.58	552.2	1078.82	simulation	2026-05-21 00:11:47.614469	f
1241	2026-05-20	6h	6h-14h	Chaîne 8	1089.53	209.93	9323.69	477.48	2745.46	181.72	1123.59	simulation	2026-05-21 00:11:47.614469	f
1242	2026-05-20	14h	14h-22h	Chaîne 8	1140.12	237.01	9452.19	505.42	2870.69	208.23	1352.72	simulation	2026-05-21 00:11:47.614469	f
1243	2026-05-20	22h	22h-6h	Chaîne 8	962.54	199.08	9203.64	449.38	2454.14	154.45	1038.73	simulation	2026-05-21 00:11:47.614469	f
1244	2026-05-20	6h	6h-14h	Chaîne 14	615.04	224.52	8740.28	445.35	2339.59	164.15	1066.28	simulation	2026-05-21 00:11:47.614469	f
1245	2026-05-20	14h	14h-22h	Chaîne 14	672	242.7	8522.41	445.06	2488.61	168.64	1048.22	simulation	2026-05-21 00:11:47.614469	f
1246	2026-05-20	22h	22h-6h	Chaîne 14	582.37	211.82	8399.37	391.44	2024.76	140.85	1021.99	simulation	2026-05-21 00:11:47.614469	f
1247	2026-05-20	6h	6h-14h	Chaîne 15	0	6.76	0	57.16	249.56	0	0	simulation	2026-05-21 00:11:47.614469	t
1248	2026-05-20	14h	14h-22h	Chaîne 15	0	6.66	0	62.38	278.16	0	0	simulation	2026-05-21 00:11:47.614469	t
1249	2026-05-20	22h	22h-6h	Chaîne 15	0	6.65	0	60.1	252.22	0	0	simulation	2026-05-21 00:11:47.614469	t
1250	2026-05-20	6h	6h-14h	Chaîne 16	732.43	94.06	4445.52	463.11	2502.29	627.68	1162.05	simulation	2026-05-21 00:11:47.614469	f
1251	2026-05-20	14h	14h-22h	Chaîne 16	770.83	106.63	4858	502.92	2735.2	663.6	1175.95	simulation	2026-05-21 00:11:47.614469	f
1252	2026-05-20	22h	22h-6h	Chaîne 16	663.68	89.32	4359.91	464.78	2325.41	559.09	1165.08	simulation	2026-05-21 00:11:47.614469	f
\.


--
-- Data for Name: lean_energie_archive; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lean_energie_archive (id, date, heure, ligne, eau_rincage, eau_bain, eau_pasteur, elec, co2_sout, colle, lubrifiant, qte_co2, eau_aero, eau_mixeur) FROM stdin;
\.


--
-- Data for Name: lignes_pointage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lignes_pointage (id, pointage_id, membre_id, fonction, nom_prenom, statut_emploi, presence, "heures_N", "heures_F", "heures_PN", est_occasionnel) FROM stdin;
1	1	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
2	1	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
3	1	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
4	1	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
5	1	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
6	1	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
7	1	7	Conducteur étiquetteuse	ANNE	titulaire	A	0	0	0	f
8	1	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
9	1	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
10	1	10	Conducteur palettiseur	MARIE	titulaire	R	0	0	0	f
11	1	11	Cariste 1	JOSEPH	titulaire	CP	0	0	0	f
12	1	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
13	1	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
14	1	14	Cariste 4	ESTELLE	titulaire	RM	0	0	0	f
15	2	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
16	2	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
17	2	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
18	2	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
19	2	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
20	2	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
21	2	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
22	2	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
23	2	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
24	2	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
25	2	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
26	2	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
27	2	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
28	2	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
29	3	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
30	3	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
31	3	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
32	3	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
33	3	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
34	3	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
35	3	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
36	3	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
37	3	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
38	3	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
39	3	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
40	3	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
41	3	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
42	3	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
43	4	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
44	4	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
45	4	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
46	4	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
47	4	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
48	4	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
49	4	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
50	4	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
51	4	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
52	4	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
53	4	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
54	4	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
55	4	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
56	4	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
57	5	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
58	5	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
59	5	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
60	5	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
61	5	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
62	5	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
63	5	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
64	5	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
65	5	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
66	5	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
67	5	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
68	5	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
69	5	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
70	5	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
71	6	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
72	6	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
73	6	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
74	6	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
75	6	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
76	6	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
77	6	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
78	6	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
79	6	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
80	6	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
81	6	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
82	6	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
83	6	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
84	6	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
85	7	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
86	7	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
87	7	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
88	7	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
89	7	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
90	7	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
91	7	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
92	7	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
93	7	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
94	7	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
95	7	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
96	7	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
97	7	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
98	7	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
99	8	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
100	8	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
101	8	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
102	8	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
103	8	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
104	8	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
105	8	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
106	8	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
107	8	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
108	8	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
109	8	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
110	8	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
111	8	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
112	8	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
113	9	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
114	9	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
115	9	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
116	9	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
117	9	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
118	9	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
119	9	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
120	9	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
121	9	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
122	9	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
123	9	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
124	9	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
125	9	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
126	9	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
127	10	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
128	10	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
129	10	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
130	10	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
131	10	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
132	10	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
133	10	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
134	10	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
135	10	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
136	10	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
137	10	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
138	10	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
139	10	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
140	10	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
141	11	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
142	11	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
143	11	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
144	11	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
145	11	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
146	11	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
147	11	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
148	11	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
149	11	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
150	11	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
151	11	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
152	11	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
153	11	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
154	11	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
155	12	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
156	12	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
157	12	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
158	12	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
159	12	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
160	12	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
161	12	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
162	12	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
163	12	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
164	12	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
165	12	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
166	12	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
167	12	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
168	12	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
169	13	1	Conducteur dépalettiseur	LORAINE	titulaire	P	8	0	0	f
170	13	2	Conducteur décaisseuse	GRACE	titulaire	P	8	0	0	f
171	13	3	Conducteur laveuse	MAEVA	titulaire	P	8	0	0	f
172	13	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	8	0	0	f
173	13	5	Conducteur soutireuse	CATHERINE	titulaire	P	8	0	0	f
174	13	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	8	0	0	f
175	13	7	Conducteur étiquetteuse	ANNE	titulaire	P	8	0	0	f
176	13	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	8	0	0	f
177	13	9	Conducteur encaisseuse	XAVIER	titulaire	P	8	0	0	f
178	13	10	Conducteur palettiseur	MARIE	titulaire	P	8	0	0	f
179	13	11	Cariste 1	JOSEPH	titulaire	P	8	0	0	f
180	13	12	Cariste 2	JOYCE	titulaire	P	8	0	0	f
181	13	13	Cariste 3	URIEL	titulaire	P	8	0	0	f
182	13	14	Cariste 4	ESTELLE	titulaire	P	8	0	0	f
183	14	1	Conducteur dépalettiseur	LORAINE	titulaire	P	7	0	0	f
184	14	2	Conducteur décaisseuse	GRACE	titulaire	P	7	0	0	f
185	14	3	Conducteur laveuse	MAEVA	titulaire	P	7	0	0	f
186	14	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	7	0	0	f
187	14	5	Conducteur soutireuse	CATHERINE	titulaire	P	7	0	0	f
188	14	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	7	0	0	f
189	14	7	Conducteur étiquetteuse	ANNE	titulaire	P	7	0	0	f
190	14	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	7	0	0	f
191	14	9	Conducteur encaisseuse	XAVIER	titulaire	P	7	0	0	f
192	14	10	Conducteur palettiseur	MARIE	titulaire	P	7	0	0	f
193	14	11	Cariste 1	JOSEPH	titulaire	P	7	0	0	f
194	14	12	Cariste 2	JOYCE	titulaire	P	7	0	0	f
195	14	13	Cariste 3	URIEL	titulaire	P	7	0	0	f
196	14	14	Cariste 4	ESTELLE	titulaire	P	7	0	0	f
197	14	\N	cariste	dhfg	occasionnel	P	7	0	0	t
198	15	1	Conducteur dépalettiseur	LORAINE	titulaire	P	7	0	0	f
199	15	2	Conducteur décaisseuse	GRACE	titulaire	P	7	0	0	f
200	15	3	Conducteur laveuse	MAEVA	titulaire	P	7	0	0	f
201	15	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	7	0	0	f
202	15	5	Conducteur soutireuse	CATHERINE	titulaire	P	7	0	0	f
203	15	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	7	0	0	f
204	15	7	Conducteur étiquetteuse	ANNE	titulaire	P	7	0	0	f
205	15	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	7	0	0	f
206	15	9	Conducteur encaisseuse	XAVIER	titulaire	P	7	0	0	f
207	15	10	Conducteur palettiseur	MARIE	titulaire	P	7	0	0	f
208	15	11	Cariste 1	JOSEPH	titulaire	P	7	0	0	f
209	15	12	Cariste 2	JOYCE	titulaire	P	7	0	0	f
210	15	13	Cariste 3	URIEL	titulaire	P	7	0	0	f
211	15	14	Cariste 4	ESTELLE	titulaire	P	7	0	0	f
212	16	1	Conducteur dépalettiseur	LORAINE	titulaire	P	7	0	0	f
213	16	2	Conducteur décaisseuse	GRACE	titulaire	P	7	0	0	f
214	16	3	Conducteur laveuse	MAEVA	titulaire	P	7	0	0	f
215	16	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	7	0	0	f
216	16	5	Conducteur soutireuse	CATHERINE	titulaire	P	7	0	0	f
217	16	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	7	0	0	f
218	16	7	Conducteur étiquetteuse	ANNE	titulaire	P	7	0	0	f
219	16	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	7	0	0	f
220	16	9	Conducteur encaisseuse	XAVIER	titulaire	P	7	0	0	f
221	16	10	Conducteur palettiseur	MARIE	titulaire	P	7	0	0	f
222	16	11	Cariste 1	JOSEPH	titulaire	P	7	0	0	f
223	16	17	Agent de maîtrise	GEORGES	am	P	7	0	0	f
224	16	18	Agent de maîtrise	FROSTERS	am	P	7	0	0	f
225	17	1	Conducteur dépalettiseur	LORAINE	titulaire	P	7	0	0	f
226	17	2	Conducteur décaisseuse	GRACE	titulaire	P	7	0	0	f
227	17	3	Conducteur laveuse	MAEVA	titulaire	P	7	0	0	f
228	17	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	7	0	0	f
229	17	5	Conducteur soutireuse	CATHERINE	titulaire	P	7	0	0	f
230	17	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	7	0	0	f
231	17	7	Conducteur étiquetteuse	ANNE	titulaire	P	7	0	0	f
232	17	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	7	0	0	f
233	17	9	Conducteur encaisseuse	XAVIER	titulaire	P	7	0	0	f
234	17	10	Conducteur palettiseur	MARIE	titulaire	P	7	0	0	f
235	17	11	Cariste 1	JOSEPH	titulaire	P	7	0	0	f
236	17	17	Agent de maîtrise	GEORGES	am	P	7	0	0	f
237	17	18	Agent de maîtrise	FROSTERS	am	P	7	0	0	f
238	17	19	Agent de maîtrise	BRICEX	am	P	7	0	0	f
239	17	20	Agent de maîtrise	MIGUEL	am	P	7	0	0	f
240	17	21	Agent de maîtrise	JOREL	am	P	7	0	0	f
241	17	22	Cariste	CARLA	prestataire	P	7	0	0	f
242	17	23	Cariste	CLARA	prestataire	P	7	0	0	f
243	17	24	Cariste	FRANKLIN	pepiniere	P	7	0	0	f
244	17	25	Cariste	FRANK	pepiniere	P	7	0	0	f
245	17	26	Cariste	MARIE	occasionnel	P	7	0	0	f
246	18	1	Conducteur dépalettiseur	LORAINE	titulaire	P	7	0	0	f
247	18	2	Conducteur décaisseuse	GRACE	titulaire	P	7	0	0	f
248	18	3	Conducteur laveuse	MAEVA	titulaire	P	7	0	0	f
249	18	4	Conducteur EBI/Mireuse électronique	FRANKLIN	titulaire	P	7	0	0	f
250	18	5	Conducteur soutireuse	CATHERINE	titulaire	P	7	0	0	f
251	18	6	Conducteur pasteurisateur	SOLANGE	titulaire	P	7	0	0	f
252	18	7	Conducteur étiquetteuse	ANNE	titulaire	P	7	0	0	f
253	18	8	Assistant conducteur étiquetteuse	JUSTIN	titulaire	P	7	0	0	f
254	18	9	Conducteur encaisseuse	XAVIER	titulaire	P	7	0	0	f
255	18	10	Conducteur palettiseur	MARIE	titulaire	P	7	0	0	f
256	18	11	Cariste 1	JOSEPH	titulaire	P	7	0	0	f
257	18	17	Agent de maîtrise	GEORGES	am	P	7	0	0	f
258	18	18	Agent de maîtrise	FROSTERS	am	P	7	0	0	f
259	18	19	Agent de maîtrise	BRICEX	am	P	7	0	0	f
260	18	20	Agent de maîtrise	MIGUEL	am	P	7	0	0	f
261	18	21	Agent de maîtrise	JOREL	am	P	7	0	0	f
262	18	22	Cariste	CARLA	prestataire	P	7	0	0	f
263	18	23	Cariste	CLARA	prestataire	P	7	0	0	f
264	18	24	Cariste	FRANKLIN	pepiniere	P	7	0	0	f
265	18	25	Cariste	FRANK	pepiniere	P	7	0	0	f
266	18	26	Cariste	MARIE	occasionnel	P	7	0	0	f
\.


--
-- Data for Name: logs_activite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs_activite (id, utilisateur, action, table_concernee, details, created_at) FROM stdin;
1	admin	LOGIN	connexion	Connexion réussie	2026-03-09 13:54:58.723118
2	admin	LOGIN	connexion	Connexion réussie	2026-03-10 07:18:35.137732
3	admin	LOGIN	connexion	Connexion réussie	2026-03-10 10:17:31.800919
4	Relou	LOGIN	connexion	Connexion réussie	2026-03-10 10:17:56.652805
5	admin	LOGIN	connexion	Connexion réussie	2026-03-10 11:06:07.688343
6	admin	LOGIN	connexion	Connexion réussie	2026-03-10 11:06:42.048629
7	admin	LOGIN	connexion	Connexion réussie	2026-03-10 14:20:38.525796
8	admin	LOGIN	connexion	Connexion réussie	2026-03-11 07:38:14.635218
9	admin	LOGIN	connexion	Connexion réussie	2026-03-11 15:41:01.776733
10	admin	LOGIN	connexion	Connexion réussie	2026-03-13 11:39:16.392173
11	admin	LOGIN	connexion	Connexion réussie	2026-03-16 13:06:10.905662
12	admin	LOGIN	connexion	Connexion réussie	2026-03-17 10:24:53.449182
45	admin	LOGIN	connexion	Connexion réussie	2026-03-23 09:33:25.436467
46	admin	LOGIN	connexion	Connexion réussie	2026-03-24 11:03:23.416243
47	admin	LOGIN	connexion	Connexion réussie	2026-03-25 07:11:16.39987
48	admin	INSERT	equipes	Équipe Equipe BOSS Xavier — Chaîne 15	2026-03-25 07:12:51.542817
49	admin	INSERT	membres_equipe	Membre LORAINE — Equipe BOSS Xavier	2026-03-25 07:13:21.218621
50	admin	INSERT	membres_equipe	Membre GRACE — Equipe BOSS Xavier	2026-03-25 07:13:36.063683
51	admin	INSERT	membres_equipe	Membre MAEVA — Equipe BOSS Xavier	2026-03-25 07:13:58.777376
52	admin	INSERT	membres_equipe	Membre FRANKLIN — Equipe BOSS Xavier	2026-03-25 07:14:09.269173
53	admin	INSERT	membres_equipe	Membre CATHERINE — Equipe BOSS Xavier	2026-03-25 07:14:23.817238
54	admin	INSERT	membres_equipe	Membre SOLANGE — Equipe BOSS Xavier	2026-03-25 07:14:55.680516
55	admin	INSERT	membres_equipe	Membre ANNE — Equipe BOSS Xavier	2026-03-25 07:15:07.559507
56	admin	INSERT	membres_equipe	Membre JUSTIN — Equipe BOSS Xavier	2026-03-25 07:15:27.689198
57	admin	INSERT	membres_equipe	Membre XAVIER — Equipe BOSS Xavier	2026-03-25 07:15:42.230287
58	admin	INSERT	membres_equipe	Membre MARIE — Equipe BOSS Xavier	2026-03-25 07:15:59.680927
59	admin	INSERT	membres_equipe	Membre JOSEPH — Equipe BOSS Xavier	2026-03-25 07:16:16.077938
60	admin	INSERT	membres_equipe	Membre JOYCE — Equipe BOSS Xavier	2026-03-25 07:16:32.047703
61	admin	INSERT	membres_equipe	Membre URIEL — Equipe BOSS Xavier	2026-03-25 07:16:42.606848
62	admin	INSERT	membres_equipe	Membre ESTELLE — Equipe BOSS Xavier	2026-03-25 07:16:53.395066
63	admin	INSERT	pointages	Pointage 2026-03-25 — Equipe BOSS Xavier — 7h-14h — 7h	2026-03-25 07:24:55.132157
64	admin	INSERT	pointages	Pointage 2026-03-26 — Equipe BOSS Xavier — 19h-7h — 12h	2026-03-25 07:26:09.578109
65	admin	INSERT	pointages	Pointage 2026-03-27 — Equipe BOSS Xavier — 19h-7h — 12h	2026-03-25 07:26:33.058702
66	admin	INSERT	pointages	Pointage 2026-03-28 — Equipe BOSS Xavier — 7h-19h — 12h	2026-03-25 07:26:44.442479
67	admin	INSERT	pointages	Pointage 2026-03-29 — Equipe BOSS Xavier — 21h-7h — 10h	2026-03-25 07:26:54.567576
68	admin	INSERT	pointages	Pointage 2026-03-30 — Equipe BOSS Xavier — 21h-7h — 10h	2026-03-25 07:27:00.498064
69	admin	INSERT	pointages	Pointage 2026-03-31 — Equipe BOSS Xavier — 7h-14h — 7h	2026-03-25 07:27:08.146308
70	admin	LOGIN	connexion	Connexion réussie	2026-03-26 08:58:57.089503
71	admin	LOGIN	connexion	Connexion réussie	2026-03-30 07:49:26.22874
72	admin	INSERT	equipes	Équipe  — Chaîne 8	2026-03-30 14:19:01.850579
73	admin	LOGIN	connexion	Connexion réussie	2026-03-31 07:50:33.459563
74	admin	LOGIN	connexion	Connexion réussie	2026-03-31 09:42:40.780282
75	admin	LOGIN	connexion	Connexion réussie	2026-04-07 10:50:15.737058
76	admin	LOGIN	connexion	Connexion réussie	2026-04-08 09:36:46.95614
77	admin	LOGIN	connexion	Connexion réussie	2026-04-13 09:10:54.779546
78	admin	INSERT	lean_energie	Atelier: Chaîne 16, Quart: 6h-14h	2026-04-13 09:18:46.300217
79	admin	INSERT	lean_energie	Atelier: Chaîne 16, Quart: 6h-14h	2026-04-13 09:18:55.306066
80	admin	INSERT	lean_energie	Atelier: Chaîne 16, Quart: 6h-14h	2026-04-13 09:19:32.592219
81	admin	INSERT	lean_energie	Atelier: Chaîne 16, Quart: 6h-14h	2026-04-13 09:19:40.600515
82	admin	INSERT	lean_energie	Atelier: Chaîne 16, Quart: 6h-14h	2026-04-13 09:20:21.897869
83	admin	INSERT	lean_energie	Atelier: Chaîne 16, Quart: 6h-14h	2026-04-13 09:23:13.140043
84	admin	INSERT	lean_energie	Atelier: Chaîne 16, Quart: 6h-14h	2026-04-13 09:23:36.765617
85	admin	INSERT	lean_energie	Atelier: Chaîne 16, Quart: 6h-14h	2026-04-13 09:25:36.297813
86	admin	INSERT	lean_energie	Atelier: Chaîne 16, Quart: 6h-14h	2026-04-13 09:33:30.300999
87	admin	INSERT	lean_energie	Atelier: Chaîne 16, Quart: 6h-14h	2026-04-13 09:57:31.348471
88	admin	LOGIN	connexion	Connexion réussie	2026-04-14 07:21:21.504704
89	admin	INSERT	equipes	Équipe cnb — Chaîne 8	2026-04-14 07:49:22.804792
90	admin	LOGIN	connexion	Connexion réussie	2026-04-14 15:23:21.484698
91	admin	INSERT	pointages	Pointage 2026-04-14 — Equipe BOSS Xavier — 7h-14h — 7h	2026-04-14 15:55:21.008201
92	admin	INSERT	pointages	Pointage 2026-04-15 — Equipe BOSS Xavier — 7h-14h — 7h	2026-04-14 15:55:33.847245
93	admin	INSERT	pointages	Pointage 2026-04-16 — Equipe BOSS Xavier — 7h-14h — 7h	2026-04-14 15:55:39.468987
94	admin	INSERT	pointages	Pointage 2026-04-17 — Equipe BOSS Xavier — 7h-14h — 7h	2026-04-14 15:55:52.260406
95	admin	INSERT	pointages	Pointage 2026-04-18 — Equipe BOSS Xavier — 7h-14h — 7h	2026-04-14 15:56:10.205394
96	admin	INSERT	pointages	Pointage 2026-04-19 — Equipe BOSS Xavier — 7h-14h — 7h	2026-04-14 15:56:25.527318
97	admin	LOGIN	connexion	Connexion réussie	2026-04-15 10:56:38.226827
98	admin	INSERT	pointages	Pointage 2026-04-15 — Equipe BOSS Xavier — 7h-14h	2026-04-15 11:00:56.378812
99	admin	INSERT	pointages	Pointage 2026-04-16 — Equipe BOSS Xavier — 7h-14h	2026-04-15 11:05:22.309912
100	admin	INSERT	membres_equipe	Membre rhfdh — cnb	2026-04-15 11:06:20.280657
101	admin	INSERT	membres_equipe	Membre gdsg — cnb	2026-04-15 12:43:28.182363
102	manager	LOGIN	connexion	Connexion réussie	2026-04-15 13:52:57.170038
103	manager	LOGIN	connexion	Connexion réussie	2026-04-15 14:00:14.042337
104	manager	LOGIN	connexion	Connexion réussie	2026-04-21 10:13:45.17925
105	manager	LOGIN	connexion	Connexion réussie	2026-04-21 12:14:30.651461
106	manager	LOGIN	connexion	Connexion réussie	2026-04-21 12:16:11.256576
107	manager	INSERT	membres_equipe	Membre GEORGES — Equipe BOSS Xavier	2026-04-21 13:02:13.065199
108	manager	INSERT	membres_equipe	Membre FROSTERS — Equipe BOSS Xavier	2026-04-21 13:02:34.155761
109	manager	INSERT	pointages	Pointage 2026-04-21 — Equipe BOSS Xavier — 7h-14h	2026-04-21 13:07:26.099769
110	manager	INSERT	membres_equipe	Membre BRICEX — Equipe BOSS Xavier	2026-04-21 13:55:35.119713
111	manager	INSERT	membres_equipe	Membre MIGUEL — Equipe BOSS Xavier	2026-04-21 14:01:20.857588
112	manager	INSERT	membres_equipe	Membre JOREL — Equipe BOSS Xavier	2026-04-21 14:02:13.631365
113	manager	LOGIN	connexion	Connexion réussie	2026-04-27 07:23:51.984063
114	manager	LOGIN	connexion	Connexion réussie	2026-05-04 08:04:03.854769
115	manager	LOGIN	connexion	Connexion réussie	2026-05-18 07:22:25.777397
116	manager	INSERT	membres_equipe	Membre CARLA — Equipe BOSS Xavier	2026-05-18 13:31:59.913467
117	manager	INSERT	membres_equipe	Membre CLARA — Equipe BOSS Xavier	2026-05-18 13:32:24.663148
118	manager	INSERT	membres_equipe	Membre FRANKLIN — Equipe BOSS Xavier	2026-05-18 13:33:04.845118
119	manager	INSERT	membres_equipe	Membre FRANK — Equipe BOSS Xavier	2026-05-18 13:33:31.430148
120	manager	INSERT	membres_equipe	Membre MARIE — Equipe BOSS Xavier	2026-05-18 13:34:34.959816
121	manager	INSERT	pointages	Pointage 2026-05-18 — Equipe BOSS Xavier — 7h-14h	2026-05-18 13:46:44.54894
122	manager	LOGIN	connexion	Connexion réussie	2026-05-19 09:14:58.106973
123	manager	LOGIN	connexion	Connexion réussie	2026-05-20 22:40:07.450041
124	manager	LOGIN	connexion	Connexion réussie	2026-05-21 07:38:34.941163
125	manager	LOGIN	connexion	Connexion réussie	2026-05-21 10:00:02.203152
126	manager	LOGIN	connexion	Connexion réussie	2026-05-22 09:57:22.913031
127	manager	INSERT	pointages	Pointage 2026-05-22 — Equipe BOSS Xavier — 7h-14h	2026-05-22 14:31:03.285775
128	manager	LOGIN	connexion	Connexion réussie	2026-06-01 22:04:21.686365
129	manager	LOGIN	connexion	Connexion réussie	2026-06-02 09:59:38.645652
130	manager	LOGIN	connexion	Connexion réussie	2026-06-04 22:26:53.278593
\.


--
-- Data for Name: membres_equipe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membres_equipe (id, equipe_id, fonction, nom_prenom, matricule, statut, ordre, actif, date_naissance, lieu_naissance, cnps, categorie_pro, salaire_horaire) FROM stdin;
1	1	Conducteur dépalettiseur	LORAINE	180104	titulaire	0	t	\N	\N	\N	\N	\N
2	1	Conducteur décaisseuse	GRACE	190104	titulaire	1	t	\N	\N	\N	\N	\N
3	1	Conducteur laveuse	MAEVA	200104	titulaire	2	t	\N	\N	\N	\N	\N
4	1	Conducteur EBI/Mireuse électronique	FRANKLIN	210104	titulaire	3	t	\N	\N	\N	\N	\N
5	1	Conducteur soutireuse	CATHERINE	220104	titulaire	4	t	\N	\N	\N	\N	\N
6	1	Conducteur pasteurisateur	SOLANGE	230104	titulaire	5	t	\N	\N	\N	\N	\N
7	1	Conducteur étiquetteuse	ANNE	240104	titulaire	6	t	\N	\N	\N	\N	\N
8	1	Assistant conducteur étiquetteuse	JUSTIN	250104	titulaire	7	t	\N	\N	\N	\N	\N
9	1	Conducteur encaisseuse	XAVIER	260104	titulaire	8	t	\N	\N	\N	\N	\N
10	1	Conducteur palettiseur	MARIE	270104	titulaire	9	t	\N	\N	\N	\N	\N
11	1	Cariste 1	JOSEPH	280104	titulaire	10	t	\N	\N	\N	\N	\N
14	1	Cariste 4	ESTELLE	310104	titulaire	13	f	\N	\N	\N	\N	\N
13	1	Cariste 3	URIEL	300104	titulaire	12	f	\N	\N	\N	\N	\N
12	1	Cariste 2	JOYCE	290104	titulaire	11	f	\N	\N	\N	\N	\N
17	1	Agent de maîtrise	GEORGES	290104	am	11	t	\N	\N	\N	\N	\N
18	1	Agent de maîtrise	FROSTERS	300104	am	12	t	\N	\N	\N	\N	\N
19	1	Agent de maîtrise	BRICEX	310104	am	13	t	\N	\N	\N	\N	\N
20	1	Agent de maîtrise	MIGUEL	32014	am	14	t	\N	\N	\N	\N	\N
21	1	Agent de maîtrise	JOREL	33014	am	15	t	\N	\N	\N	\N	\N
22	1	Cariste	CARLA	18052026	prestataire	16	t	\N	\N	\N	\N	\N
23	1	Cariste	CLARA	19052026	prestataire	17	t	\N	\N	\N	\N	\N
24	1	Cariste	FRANKLIN	20052026	pepiniere	18	t	\N	\N	\N	\N	3000
25	1	Cariste	FRANK	21052026	pepiniere	19	t	\N	\N	\N	\N	3000
26	1	Cariste	MARIE	23052026	occasionnel	20	f	25/03/2004	Douala	123456789	OS1	2000
\.


--
-- Data for Name: oee_journalier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oee_journalier (id, date, atelier, disponibilite, performance, qualite_oee, oee, production_reelle, production_cible, created_at, trs, taux_utilisation) FROM stdin;
1	2026-04-21	Chaîne 8	1	0.9708	1	0.9708	3567.76	3675	2026-05-21 07:51:25.529228	\N	\N
796	2026-04-22	Chaîne 8	1	0.9581	1	0.9581	3520.96	3675	2026-05-22 14:22:13.98798	\N	\N
797	2026-04-23	Chaîne 8	1	0.9411	1	0.9411	3458.52	3675	2026-05-22 14:22:13.98798	\N	\N
798	2026-04-24	Chaîne 8	1	0.9471	1	0.9471	3480.61	3675	2026-05-22 14:22:13.98798	\N	\N
799	2026-04-25	Chaîne 8	1	0.9871	1	0.9871	3627.5200000000004	3675	2026-05-22 14:22:13.98798	\N	\N
800	2026-04-26	Chaîne 8	1	0.5124	0.6667	0.3416	1883.22	3675	2026-05-22 14:22:13.98798	\N	\N
801	2026-04-28	Chaîne 8	1	0.9796	1	0.9796	3599.87	3675	2026-05-22 14:22:13.98798	\N	\N
802	2026-04-29	Chaîne 8	1	0.9653	1	0.9653	3547.62	3675	2026-05-22 14:22:13.98798	\N	\N
803	2026-04-30	Chaîne 8	1	0.9809	1	0.9809	3604.85	3675	2026-05-22 14:22:13.98798	\N	\N
804	2026-05-01	Chaîne 8	1	0.9612	1	0.9612	3532.29	3675	2026-05-22 14:22:13.98798	\N	\N
1068	2026-05-05	Chaîne 8	1	0.9991	1	0.8742	3671.5299999999997	3675	2026-06-04 22:40:41.272547	0.9991	0.875
1069	2026-05-06	Chaîne 8	1	0.9541	1	0.8348	3506.32	3675	2026-06-04 22:40:41.272547	0.9541	0.875
1070	2026-05-07	Chaîne 8	1	0.9625	1	0.8422	3537.3199999999997	3675	2026-06-04 22:40:41.272547	0.9625	0.875
1071	2026-05-08	Chaîne 8	1	0.9967	1	0.8721	3662.9700000000003	3675	2026-06-04 22:40:41.272547	0.9967	0.875
1072	2026-05-09	Chaîne 8	1	0.9892	1	0.8655	3635.48	3675	2026-06-04 22:40:41.272547	0.9892	0.875
1073	2026-05-10	Chaîne 8	1	0.8283	1	0.7248	3044.08	3675	2026-06-04 22:40:41.272547	0.8283	0.875
1074	2026-05-12	Chaîne 8	1	1	1	0.875	3685.0299999999997	3675	2026-06-04 22:40:41.272547	1	0.875
1075	2026-05-13	Chaîne 8	1	0.9837	1	0.8607	3615.13	3675	2026-06-04 22:40:41.272547	0.9837	0.875
1076	2026-05-14	Chaîne 8	1	1	1	0.875	3706.6099999999997	3675	2026-06-04 22:40:41.272547	1	0.875
1077	2026-05-15	Chaîne 8	1	1	1	0.875	3716.4	3675	2026-06-04 22:40:41.272547	1	0.875
1078	2026-05-16	Chaîne 8	1	0.9808	1	0.8582	3604.6	3675	2026-06-04 22:40:41.272547	0.9808	0.875
1079	2026-05-17	Chaîne 8	1	0.8603	1	0.7528	3161.77	3675	2026-06-04 22:40:41.272547	0.8603	0.875
1080	2026-05-19	Chaîne 8	1	0.9586	1	0.8388	3522.93	3675	2026-06-04 22:40:41.272547	0.9586	0.875
1081	2026-05-20	Chaîne 8	1	0.9565	1	0.8369	3515.04	3675	2026-06-04 22:40:41.272547	0.9565	0.875
1095	2026-05-05	Chaîne 15	1	0.9963	1	0.8095	2930.23	2941	2026-06-04 22:40:46.694018	0.9963	0.8125
1096	2026-05-07	Chaîne 15	1	0.9267	1	0.7529	2725.56	2941	2026-06-04 22:40:46.694018	0.9267	0.8125
870	2026-04-22	Chaîne 16	1	1	1	1	3646.24	3614	2026-05-22 14:22:18.349056	\N	\N
871	2026-04-24	Chaîne 16	1	0.9621	0.6667	0.6414	3476.91	3614	2026-05-22 14:22:18.349056	\N	\N
872	2026-04-25	Chaîne 16	1	1	1	1	3630.46	3614	2026-05-22 14:22:18.349056	\N	\N
873	2026-04-26	Chaîne 16	1	0.8231	1	0.8231	2974.62	3614	2026-05-22 14:22:18.349056	\N	\N
874	2026-04-27	Chaîne 16	1	0.9855	1	0.9855	3561.58	3614	2026-05-22 14:22:18.349056	\N	\N
875	2026-04-28	Chaîne 16	1	0.9648	1	0.9648	3486.92	3614	2026-05-22 14:22:18.349056	\N	\N
876	2026-04-29	Chaîne 16	1	0.9387	1	0.9387	3392.37	3614	2026-05-22 14:22:18.349056	\N	\N
877	2026-05-01	Chaîne 16	1	0.9712	1	0.9712	3510.08	3614	2026-05-22 14:22:18.349056	\N	\N
1097	2026-05-08	Chaîne 15	1	0.9764	1	0.7933	2871.5	2941	2026-06-04 22:40:46.694018	0.9764	0.8125
1098	2026-05-09	Chaîne 15	1	0.9648	1	0.7839	2837.52	2941	2026-06-04 22:40:46.694018	0.9648	0.8125
1099	2026-05-10	Chaîne 15	1	0.856	1	0.6955	2517.5099999999998	2941	2026-06-04 22:40:46.694018	0.856	0.8125
1100	2026-05-11	Chaîne 15	1	0.9692	1	0.7875	2850.34	2941	2026-06-04 22:40:46.694018	0.9692	0.8125
1101	2026-05-12	Chaîne 15	1	0.9662	1	0.785	2841.69	2941	2026-06-04 22:40:46.694018	0.9662	0.8125
1102	2026-05-14	Chaîne 15	1	0.9722	1	0.7899	2859.1400000000003	2941	2026-06-04 22:40:46.694018	0.9722	0.8125
1103	2026-05-15	Chaîne 15	1	0.9779	1	0.7945	2875.9700000000003	2941	2026-06-04 22:40:46.694018	0.9779	0.8125
1104	2026-05-16	Chaîne 15	1	0.9887	0.8056	0.6472	2907.91	2941	2026-06-04 22:40:46.694018	0.7965	0.8125
1105	2026-05-17	Chaîne 15	1	0.8719	1	0.7084	2564.2200000000003	2941	2026-06-04 22:40:46.694018	0.8719	0.8125
1106	2026-05-18	Chaîne 15	1	0.993	1	0.8068	2920.43	2941	2026-06-04 22:40:46.694018	0.993	0.8125
1107	2026-05-19	Chaîne 15	1	0.9509	1	0.7726	2796.63	2941	2026-06-04 22:40:46.694018	0.9509	0.8125
52	2026-04-21	Chaîne 15	1	0.984	1	0.984	2894.01	2941	2026-05-21 07:51:38.09203	\N	\N
895	2026-05-02	Chaîne 8	1	0.98	1	0.8253	3601.62	3675	2026-06-01 22:05:11.179774	0.98	0.8421
896	2026-05-03	Chaîne 8	1	0.8133	1	0.6849	2989.03	3675	2026-06-01 22:05:11.179774	0.8133	0.8421
911	2026-05-02	Chaîne 14	1	1	1	0.8421	3291.1099999999997	3232	2026-06-01 22:05:20.586205	1	0.8421
912	2026-05-03	Chaîne 14	1	0.7144	0.7292	0.4387	2308.9300000000003	3232	2026-06-01 22:05:20.586205	0.5209	0.8421
913	2026-05-04	Chaîne 14	1	0.977	1	0.8227	3157.73	3232	2026-06-01 22:05:20.586205	0.977	0.8421
927	2026-05-02	Chaîne 15	1	0.9865	1	0.8307	2901.44	2941	2026-06-01 22:05:22.414386	0.9865	0.8421
928	2026-05-03	Chaîne 15	1	0.8831	1	0.7437	2597.08	2941	2026-06-01 22:05:22.414386	0.8831	0.8421
821	2026-04-22	Chaîne 14	1	0.9383	1	0.9383	3032.7000000000003	3232	2026-05-22 14:22:15.492915	\N	\N
77	2026-04-21	Chaîne 16	1	0.9625	1	0.9625	3478.37	3614	2026-05-21 07:51:39.730043	\N	\N
822	2026-04-23	Chaîne 14	1	0.9779	1	0.9779	3160.65	3232	2026-05-22 14:22:15.492915	\N	\N
823	2026-04-24	Chaîne 14	1	0.9565	1	0.9565	3091.45	3232	2026-05-22 14:22:15.492915	\N	\N
824	2026-04-25	Chaîne 14	1	0.9657	1	0.9657	3121.12	3232	2026-05-22 14:22:15.492915	\N	\N
825	2026-04-26	Chaîne 14	1	0.8149	1	0.8149	2633.63	3232	2026-05-22 14:22:15.492915	\N	\N
826	2026-04-27	Chaîne 14	1	1	1	1	3302	3232	2026-05-22 14:22:15.492915	\N	\N
827	2026-04-29	Chaîne 14	1	0.9898	1	0.9898	3198.88	3232	2026-05-22 14:22:15.492915	\N	\N
828	2026-04-30	Chaîne 14	1	1	1	1	3272.1	3232	2026-05-22 14:22:15.492915	\N	\N
829	2026-05-01	Chaîne 14	1	0.959	1	0.959	3099.38	3232	2026-05-22 14:22:15.492915	\N	\N
1082	2026-05-06	Chaîne 14	1	0.9683	1	0.7867	3129.5	3232	2026-06-04 22:40:44.755737	0.9683	0.8125
1083	2026-05-07	Chaîne 14	1	1	1	0.8125	3310.85	3232	2026-06-04 22:40:44.755737	1	0.8125
1084	2026-05-08	Chaîne 14	1	0.9653	1	0.7843	3120	3232	2026-06-04 22:40:44.755737	0.9653	0.8125
1085	2026-05-09	Chaîne 14	1	1	1	0.8125	3322.6499999999996	3232	2026-06-04 22:40:44.755737	1	0.8125
1086	2026-05-10	Chaîne 14	1	0.8646	1	0.7025	2794.29	3232	2026-06-04 22:40:44.755737	0.8646	0.8125
1087	2026-05-11	Chaîne 14	1	0.9795	1	0.7958	3165.71	3232	2026-06-04 22:40:44.755737	0.9795	0.8125
1088	2026-05-13	Chaîne 14	1	0.9985	1	0.8113	3227.2	3232	2026-06-04 22:40:44.755737	0.9985	0.8125
1089	2026-05-14	Chaîne 14	1	1	1	0.8125	3317.0600000000004	3232	2026-06-04 22:40:44.755737	1	0.8125
1090	2026-05-15	Chaîne 14	1	0.9782	1	0.7948	3161.44	3232	2026-06-04 22:40:44.755737	0.9782	0.8125
1091	2026-05-16	Chaîne 14	1	0.9862	1	0.8013	3187.5200000000004	3232	2026-06-04 22:40:44.755737	0.9862	0.8125
1092	2026-05-17	Chaîne 14	1	0.8232	1	0.6689	2660.52	3232	2026-06-04 22:40:44.755737	0.8232	0.8125
929	2026-05-04	Chaîne 15	1	0.9605	1	0.8088	2824.7200000000003	2941	2026-06-01 22:05:22.414386	0.9605	0.8421
943	2026-05-02	Chaîne 16	1	0.9454	0.6667	0.564	3416.79	3614	2026-06-01 22:05:24.06136	0.6303	0.8947
944	2026-05-03	Chaîne 16	1	0.8446	1	0.7557	3052.55	3614	2026-06-01 22:05:24.06136	0.8446	0.8947
945	2026-05-04	Chaîne 16	1	0.9839	1	0.8803	3555.6899999999996	3614	2026-06-01 22:05:24.06136	0.9839	0.8947
1093	2026-05-18	Chaîne 14	1	0.9921	1	0.8061	3206.34	3232	2026-06-04 22:40:44.755737	0.9921	0.8125
1094	2026-05-20	Chaîne 14	1	0.9704	1	0.7884	3136.49	3232	2026-06-04 22:40:44.755737	0.9704	0.8125
1108	2026-05-05	Chaîne 16	1	0.9541	1	0.8348	3448.0299999999997	3614	2026-06-04 22:40:48.669379	0.9541	0.875
1109	2026-05-06	Chaîne 16	1	0.9749	1	0.853	3523.2799999999997	3614	2026-06-04 22:40:48.669379	0.9749	0.875
1110	2026-05-08	Chaîne 16	1	0.9774	1	0.8552	3532.39	3614	2026-06-04 22:40:48.669379	0.9774	0.875
1111	2026-05-09	Chaîne 16	1	0.9827	1	0.8599	3551.42	3614	2026-06-04 22:40:48.669379	0.9827	0.875
1112	2026-05-10	Chaîne 16	1	0.821	0	0	2967.02	3614	2026-06-04 22:40:48.669379	0	0.875
1113	2026-05-11	Chaîne 16	1	0.9363	0.6667	0.5462	3383.79	3614	2026-06-04 22:40:48.669379	0.6242	0.875
1114	2026-05-12	Chaîne 16	1	0.9351	1	0.8182	3379.4700000000003	3614	2026-06-04 22:40:48.669379	0.9351	0.875
1115	2026-05-13	Chaîne 16	1	1	1	0.875	3741.9	3614	2026-06-04 22:40:48.669379	1	0.875
1116	2026-05-15	Chaîne 16	1	1	1	0.875	3626.5	3614	2026-06-04 22:40:48.669379	1	0.875
1117	2026-05-16	Chaîne 16	1	1	1	0.875	3709.98	3614	2026-06-04 22:40:48.669379	1	0.875
1118	2026-05-17	Chaîne 16	1	0.8111	1	0.7097	2931.38	3614	2026-06-04 22:40:48.669379	0.8111	0.875
1119	2026-05-18	Chaîne 16	1	0.9711	1	0.8497	3509.49	3614	2026-06-04 22:40:48.669379	0.9711	0.875
1120	2026-05-19	Chaîne 16	1	0.9327	1	0.8161	3370.79	3614	2026-06-04 22:40:48.669379	0.9327	0.875
1121	2026-05-20	Chaîne 16	1	0.9693	1	0.8481	3503.08	3614	2026-06-04 22:40:48.669379	0.9693	0.875
846	2026-04-23	Chaîne 15	1	1	1	1	3070.42	2941	2026-05-22 14:22:17.031187	\N	\N
847	2026-04-24	Chaîne 15	1	0.9547	1	0.9547	2807.84	2941	2026-05-22 14:22:17.031187	\N	\N
848	2026-04-25	Chaîne 15	1	0.9525	1	0.9525	2801.44	2941	2026-05-22 14:22:17.031187	\N	\N
849	2026-04-26	Chaîne 15	1	0.875	1	0.875	2573.46	2941	2026-05-22 14:22:17.031187	\N	\N
850	2026-04-27	Chaîne 15	1	0.9916	1	0.9916	2916.2	2941	2026-05-22 14:22:17.031187	\N	\N
851	2026-04-28	Chaîne 15	1	0.9786	1	0.9786	2877.9700000000003	2941	2026-05-22 14:22:17.031187	\N	\N
852	2026-04-30	Chaîne 15	1	0.9734	1	0.9734	2862.89	2941	2026-05-22 14:22:17.031187	\N	\N
853	2026-05-01	Chaîne 15	1	0.9523	1	0.9523	2800.79	2941	2026-05-22 14:22:17.031187	\N	\N
\.


--
-- Data for Name: pointages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pointages (id, date, chaine, equipe_id, equipe_nom, quart, saisi_par, created_at) FROM stdin;
1	2026-03-25	Chaîne 15	1	Equipe BOSS Xavier	7h-14h — 7h	admin	2026-03-25 07:24:55.061678
2	2026-03-26	Chaîne 15	1	Equipe BOSS Xavier	19h-7h — 12h	admin	2026-03-25 07:26:09.537254
3	2026-03-27	Chaîne 15	1	Equipe BOSS Xavier	19h-7h — 12h	admin	2026-03-25 07:26:33.041894
4	2026-03-28	Chaîne 15	1	Equipe BOSS Xavier	7h-19h — 12h	admin	2026-03-25 07:26:44.407554
5	2026-03-29	Chaîne 15	1	Equipe BOSS Xavier	21h-7h — 10h	admin	2026-03-25 07:26:54.536403
6	2026-03-30	Chaîne 15	1	Equipe BOSS Xavier	21h-7h — 10h	admin	2026-03-25 07:27:00.475453
7	2026-03-31	Chaîne 15	1	Equipe BOSS Xavier	7h-14h — 7h	admin	2026-03-25 07:27:08.117731
8	2026-04-14	Chaîne 15	1	Equipe BOSS Xavier	7h-14h — 7h	admin	2026-04-14 15:55:20.923105
9	2026-04-15	Chaîne 15	1	Equipe BOSS Xavier	7h-14h — 7h	admin	2026-04-14 15:55:33.82763
10	2026-04-16	Chaîne 15	1	Equipe BOSS Xavier	7h-14h — 7h	admin	2026-04-14 15:55:39.448161
11	2026-04-17	Chaîne 15	1	Equipe BOSS Xavier	7h-14h — 7h	admin	2026-04-14 15:55:52.241132
12	2026-04-18	Chaîne 15	1	Equipe BOSS Xavier	7h-14h — 7h	admin	2026-04-14 15:56:10.187923
13	2026-04-19	Chaîne 15	1	Equipe BOSS Xavier	7h-14h — 7h	admin	2026-04-14 15:56:25.510905
14	2026-04-15	Chaîne 15	1	Equipe BOSS Xavier	7h-14h	admin	2026-04-15 11:00:56.328672
15	2026-04-16	Chaîne 15	1	Equipe BOSS Xavier	7h-14h	admin	2026-04-15 11:05:22.296245
16	2026-04-21	Chaîne 15	1	Equipe BOSS Xavier	7h-14h	manager	2026-04-21 13:07:26.001869
17	2026-05-18	Chaîne 15	1	Equipe BOSS Xavier	7h-14h	manager	2026-05-18 13:46:44.418002
18	2026-05-22	Chaîne 15	1	Equipe BOSS Xavier	7h-14h	manager	2026-05-22 14:31:03.236228
\.


--
-- Data for Name: previsions_energie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.previsions_energie (id, atelier, date_prevision, date_calcul, valeur_predite, borne_inf, borne_sup, created_at) FROM stdin;
1	Chaîne 8	2026-05-22	2026-05-21	-903464.6	-3536347.4	1741188.6	2026-05-21 07:51:30.879211
2	Chaîne 8	2026-05-23	2026-05-21	-903394.3	-3527079.3	1892687.1	2026-05-21 07:51:30.879211
3	Chaîne 8	2026-05-24	2026-05-21	73368.9	-2598942.4	2660740.4	2026-05-21 07:51:30.879211
4	Chaîne 8	2026-05-25	2026-05-21	12368799.8	9881578.2	15117360.2	2026-05-21 07:51:30.879211
5	Chaîne 8	2026-05-26	2026-05-21	264838.2	-2290565.2	3017462.6	2026-05-21 07:51:30.879211
6	Chaîne 8	2026-05-27	2026-05-21	-902853.6	-3518504.6	1706701.5	2026-05-21 07:51:30.879211
7	Chaîne 14	2026-05-22	2026-05-21	7018.1	6609.3	7408.9	2026-05-21 07:51:36.642006
8	Chaîne 14	2026-05-23	2026-05-21	7103.2	6695.7	7513.7	2026-05-21 07:51:36.642006
9	Chaîne 14	2026-05-24	2026-05-21	6233.1	5813.9	6662.8	2026-05-21 07:51:36.642006
10	Chaîne 14	2026-05-25	2026-05-21	7102.4	6710.9	7496.9	2026-05-21 07:51:36.642006
11	Chaîne 14	2026-05-26	2026-05-21	-4885.8	-5286.6	-4459.8	2026-05-21 07:51:36.642006
12	Chaîne 14	2026-05-27	2026-05-21	7128.3	6719.8	7542.7	2026-05-21 07:51:36.642006
13	Chaîne 15	2026-05-22	2026-05-21	6393.5	6003	6812.3	2026-05-21 07:51:38.201774
14	Chaîne 15	2026-05-23	2026-05-21	6311.7	5927	6691.8	2026-05-21 07:51:38.201774
15	Chaîne 15	2026-05-24	2026-05-21	5543.3	5138.1	5975.1	2026-05-21 07:51:38.201774
16	Chaîne 15	2026-05-25	2026-05-21	6640.5	6228.6	7049.8	2026-05-21 07:51:38.201774
17	Chaîne 15	2026-05-26	2026-05-21	6410.7	5992.4	6828.5	2026-05-21 07:51:38.201774
18	Chaîne 16	2026-05-22	2026-05-21	8331.9	-6978.9	23558.5	2026-05-21 07:51:39.843967
19	Chaîne 16	2026-05-23	2026-05-21	8338.4	-6906.4	23087.5	2026-05-21 07:51:39.843967
20	Chaîne 16	2026-05-24	2026-05-21	7165.1	-7889.3	23160	2026-05-21 07:51:39.843967
21	Chaîne 16	2026-05-25	2026-05-21	20347.3	4997.5	34613.2	2026-05-21 07:51:39.843967
22	Chaîne 16	2026-05-26	2026-05-21	8363.6	-6657.8	23099.3	2026-05-21 07:51:39.843967
23	Chaîne 16	2026-05-27	2026-05-21	8315.9	-7975.1	23212.7	2026-05-21 07:51:39.843967
157	Chaîne 8	2026-05-23	2026-05-22	7961.2	7457.7	8427	2026-05-22 14:22:14.099583
158	Chaîne 8	2026-05-24	2026-05-22	7061.5	6555.4	7577.1	2026-05-22 14:22:14.099583
159	Chaîne 8	2026-05-25	2026-05-22	3284.3	0	0	2026-05-22 14:22:14.099583
160	Chaîne 8	2026-05-26	2026-05-22	8006.3	7509.9	8528	2026-05-22 14:22:14.099583
161	Chaîne 8	2026-05-27	2026-05-22	7986.2	7490.6	8480.1	2026-05-22 14:22:14.099583
162	Chaîne 14	2026-05-23	2026-05-22	7023.4	6859.1	7188.1	2026-05-22 14:22:15.59015
163	Chaîne 14	2026-05-24	2026-05-22	5944.6	5795.3	6103	2026-05-22 14:22:15.59015
164	Chaîne 14	2026-05-25	2026-05-22	7022.5	6861.3	7190.3	2026-05-22 14:22:15.59015
165	Chaîne 14	2026-05-26	2026-05-22	2865.2	0	0	2026-05-22 14:22:15.59015
166	Chaîne 14	2026-05-27	2026-05-22	7048.3	6878.7	7204.1	2026-05-22 14:22:15.59015
167	Chaîne 15	2026-05-23	2026-05-22	6353.8	6164.1	6564.3	2026-05-22 14:22:17.134345
168	Chaîne 15	2026-05-24	2026-05-22	5585.7	5371.8	5780.9	2026-05-22 14:22:17.134345
169	Chaîne 15	2026-05-25	2026-05-22	6485.6	6273.6	6693.1	2026-05-22 14:22:17.134345
170	Chaîne 15	2026-05-26	2026-05-22	6452.9	6254.2	6659.8	2026-05-22 14:22:17.134345
171	Chaîne 16	2026-05-23	2026-05-22	7790.5	7621	7966.2	2026-05-22 14:22:18.444332
172	Chaîne 16	2026-05-24	2026-05-22	6616.9	6448.7	6789	2026-05-22 14:22:18.444332
173	Chaîne 16	2026-05-25	2026-05-22	7833.7	7661.3	8020.7	2026-05-22 14:22:18.444332
174	Chaîne 16	2026-05-26	2026-05-22	7818.3	7646.5	7982.3	2026-05-22 14:22:18.444332
175	Chaîne 16	2026-05-27	2026-05-22	7771.4	7594.8	7937.2	2026-05-22 14:22:18.444332
\.


--
-- Data for Name: qualite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qualite (id, date, heure, quart, atelier, sertissage_data, brix, co2_qualite, bo2, saisi_par, created_at, type_volet, produit) FROM stdin;
1	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-09 13:37:52.643052	AM	\N
2	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-09 13:37:52.643052	AM	\N
3	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-09 13:37:52.643052	AM	\N
4	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-09 14:21:38.481403	AM	\N
5	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-09 14:21:38.481403	AM	\N
6	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-09 14:21:38.481403	AM	\N
7	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-09 14:41:44.61836	AM	\N
8	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-09 14:41:44.61836	AM	\N
9	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-09 14:41:44.61836	AM	\N
10	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-09 15:01:47.892097	AM	\N
11	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-09 15:01:47.892097	AM	\N
12	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-09 15:01:47.892097	AM	\N
13	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-10 07:17:09.127719	AM	\N
14	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-10 07:17:09.127719	AM	\N
15	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-10 07:17:09.127719	AM	\N
16	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-10 10:02:03.260452	AM	\N
17	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-10 10:02:03.260452	AM	\N
18	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-10 10:02:03.260452	AM	\N
19	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-10 10:56:06.858011	AM	\N
20	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-10 10:56:06.858011	AM	\N
21	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-10 10:56:06.858011	AM	\N
22	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-11 00:53:45.391321	AM	\N
23	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-11 00:53:45.391321	AM	\N
24	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-11 00:53:45.391321	AM	\N
25	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-11 07:26:12.584834	AM	\N
26	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-11 07:26:12.584834	AM	\N
27	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-11 07:26:12.584834	AM	\N
28	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-11 11:22:53.818659	AM	\N
29	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-11 11:22:53.818659	AM	\N
30	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-11 11:22:53.818659	AM	\N
31	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-13 11:36:11.264033	AM	\N
32	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-13 11:36:11.264033	AM	\N
33	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-13 11:36:11.264033	AM	\N
34	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-16 13:03:24.045441	AM	\N
35	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-16 13:03:24.045441	AM	\N
36	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-16 13:03:24.045441	AM	\N
37	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-23 09:32:04.403036	AM	\N
38	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-23 09:32:04.403036	AM	\N
39	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-23 09:32:04.403036	AM	\N
40	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-23 09:32:09.001322	AM	\N
41	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-23 09:32:09.001322	AM	\N
42	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-23 09:32:09.001322	AM	\N
43	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-25 09:21:15.368803	AM	\N
44	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-25 09:21:15.368803	AM	\N
45	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-25 09:21:15.368803	AM	\N
46	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-25 09:21:47.050751	AM	\N
47	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-25 09:21:47.050751	AM	\N
48	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-25 09:21:47.050751	AM	\N
49	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-26 11:17:40.752843	AM	\N
50	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-26 11:17:40.752843	AM	\N
51	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-26 11:17:40.752843	AM	\N
52	2026-03-01	07:00	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.8	5.2	0.05	operateur1	2026-03-30 07:48:17.94224	AM	\N
53	2026-03-02	07:10	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.1, 1.15, 1.13, 1.12, 1.11]	10.9	5.3	0.06	operateur1	2026-03-30 07:48:17.94224	AM	\N
54	2026-03-03	07:05	6h-14h	Chaîne 8	[1.12, 1.15, 1.1, 1.13, 1.11, 1.14, 1.09, 1.18, 1.15, 1.11, 1.1, 1.19, 1.14, 1.12, 1.11, 1.1, 1.15, 1.2, 1.12, 1.11]	11.4	5.1	0.32	operateur1	2026-03-30 07:48:17.94224	AM	\N
55	2026-02-20	6h	6h-14h	Chaîne 8	[1.11, 1.13, 1.1, 1.11, 1.13, 1.13, 1.11, 1.13, 1.14, 1.1, 1.14, 1.13, 1.12, 1.11, 1.15, 1.12, 1.1, 1.1, 1.14, 1.13]	10.62	5.17	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
56	2026-02-20	14h	14h-22h	Chaîne 8	[1.14, 1.1, 1.11, 1.11, 1.1, 1.11, 1.11, 1.11, 1.13, 1.12, 1.12, 1.11, 1.11, 1.15, 1.13, 1.13, 1.11, 1.14, 1.11, 1.12]	10.85	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
57	2026-02-20	22h	22h-6h	Chaîne 8	[1.11, 1.15, 1.14, 1.12, 1.13, 1.12, 1.15, 1.12, 1.11, 1.11, 1.13, 1.11, 1.13, 1.14, 1.12, 1.11, 1.15, 1.13, 1.1, 1.1]	10.6	5.12	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
58	2026-02-20	6h	6h-14h	Chaîne 14	[1.1, 1.14, 1.13, 1.13, 1.11, 1.13, 1.11, 1.12, 1.12, 1.15, 1.14, 1.11, 1.13, 1.11, 1.15, 1.14]	11.01	5.5	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
59	2026-02-20	14h	14h-22h	Chaîne 14	[1.1, 1.15, 1.14, 1.14, 1.12, 1.1, 1.14, 1.15, 1.1, 1.12, 1.1, 1.14, 1.14, 1.11, 1.12, 1.13]	11.01	5.09	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
60	2026-02-20	22h	22h-6h	Chaîne 14	[1.12, 1.13, 1.11, 1.11, 1.12, 1.13, 1.11, 1.11, 1.1, 1.13, 1.11, 1.15, 1.14, 1.1, 1.11, 1.13]	10.92	5.51	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
61	2026-02-20	6h	6h-14h	Chaîne 15	[1.12, 1.12, 1.14, 1.13, 1.15, 1.1, 1.12, 1.12, 1.14, 1.11, 1.11, 1.12, 1.12, 1.11, 1.11, 1.15, 1.12, 1.14, 1.13, 1.1, 1.15, 1.14, 1.15, 1.15]	11.06	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
62	2026-02-20	14h	14h-22h	Chaîne 15	[1.12, 1.12, 1.15, 1.15, 1.13, 1.14, 1.11, 1.11, 1.15, 1.13, 1.13, 1.14, 1.1, 1.13, 1.13, 1.14, 1.11, 1.15, 1.1, 1.11, 1.13, 1.13, 1.11, 1.11]	11.42	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
63	2026-02-20	22h	22h-6h	Chaîne 15	[1.11, 1.12, 1.13, 1.11, 1.12, 1.14, 1.1, 1.12, 1.15, 1.15, 1.1, 1.11, 1.11, 1.15, 1.14, 1.14, 1.12, 1.11, 1.14, 1.14, 1.13, 1.15, 1.13, 1.1]	11.39	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
64	2026-02-20	6h	6h-14h	Chaîne 16	[1.14, 1.11, 1.13, 1.11, 1.12, 1.15, 1.14, 1.1, 1.12, 1.11, 1.1, 1.14, 1.13, 1.11, 1.14, 1.13, 1.12, 1.1, 1.1, 1.14, 1.15, 1.13, 1.14, 1.13]	11.02	5.11	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
65	2026-02-20	14h	14h-22h	Chaîne 16	[1.14, 1.14, 1.12, 1.13, 1.11, 1.15, 1.14, 1.15, 1.14, 1.14, 1.1, 1.14, 1.12, 1.15, 1.14, 1.14, 1.14, 1.11, 1.14, 1.11, 1.14, 1.14, 1.11, 1.14]	10.87	5.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
66	2026-02-20	22h	22h-6h	Chaîne 16	[1.13, 1.12, 1.15, 1.13, 1.15, 1.11, 1.15, 1.11, 1.15, 1.11, 1.11, 1.12, 1.14, 1.12, 1.13, 1.13, 1.12, 1.13, 1.11, 1.14, 1.1, 1.15, 1.13, 1.14]	11.16	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
67	2026-02-21	6h	6h-14h	Chaîne 8	[1.12, 1.12, 1.12, 1.11, 1.11, 1.12, 1.15, 1.13, 1.15, 1.13, 1.12, 1.13, 1.1, 1.11, 1.12, 1.13, 1.13, 1.12, 1.12, 1.11]	10.95	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
68	2026-02-21	14h	14h-22h	Chaîne 8	[1.13, 1.11, 1.11, 1.1, 1.11, 1.12, 1.14, 1.1, 1.12, 1.13, 1.11, 1.13, 1.12, 1.11, 1.13, 1.1, 1.14, 1.14, 1.11, 1.12]	10.73	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
69	2026-02-21	22h	22h-6h	Chaîne 8	[1.13, 1.15, 1.14, 1.13, 1.14, 1.13, 1.14, 1.13, 1.14, 1.14, 1.12, 1.11, 1.11, 1.13, 1.14, 1.13, 1.13, 1.11, 1.1, 1.11]	10.93	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
70	2026-02-21	6h	6h-14h	Chaîne 14	[1.12, 1.11, 1.12, 1.15, 1.13, 1.13, 1.14, 1.14, 1.12, 1.1, 1.12, 1.14, 1.14, 1.15, 1.12, 1.14]	10.81	5.26	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
71	2026-02-21	14h	14h-22h	Chaîne 14	[1.12, 1.11, 1.13, 1.1, 1.12, 1.13, 1.1, 1.13, 1.11, 1.12, 1.1, 1.12, 1.11, 1.12, 1.14, 1.12]	11.08	5.26	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
72	2026-02-21	22h	22h-6h	Chaîne 14	[1.13, 1.14, 1.15, 1.11, 1.1, 1.11, 1.11, 1.13, 1.13, 1.11, 1.13, 1.14, 1.11, 1.13, 1.14, 1.11]	10.93	5.36	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
73	2026-02-21	6h	6h-14h	Chaîne 15	[1.13, 1.13, 1.11, 1.14, 1.14, 1.13, 1.11, 1.15, 1.14, 1.12, 1.12, 1.12, 1.13, 1.12, 1.14, 1.14, 1.11, 1.15, 1.13, 1.14, 1.14, 1.12, 1.14, 1.15]	11.15	5.59	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
74	2026-02-21	14h	14h-22h	Chaîne 15	[1.14, 1.11, 1.12, 1.13, 1.12, 1.1, 1.14, 1.11, 1.11, 1.14, 1.12, 1.14, 1.14, 1.11, 1.1, 1.15, 1.1, 1.14, 1.12, 1.14, 1.13, 1.13, 1.12, 1.14]	11.36	5.65	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
75	2026-02-21	22h	22h-6h	Chaîne 15	[1.14, 1.11, 1.11, 1.11, 1.11, 1.11, 1.13, 1.14, 1.11, 1.11, 1.12, 1.14, 1.15, 1.13, 1.11, 1.11, 1.11, 1.11, 1.11, 1.1, 1.13, 1.11, 1.15, 1.13]	11.17	5.61	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
76	2026-02-21	6h	6h-14h	Chaîne 16	[1.15, 1.12, 1.14, 1.12, 1.1, 1.13, 1.1, 1.11, 1.13, 1.12, 1.15, 1.11, 1.14, 1.13, 1.14, 1.11, 1.13, 1.12, 1.12, 1.14, 1.15, 1.12, 1.13, 1.13]	10.97	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
77	2026-02-21	14h	14h-22h	Chaîne 16	[1.13, 1.11, 1.11, 1.14, 1.14, 1.12, 1.13, 1.15, 1.14, 1.13, 1.13, 1.15, 1.12, 1.13, 1.13, 1.15, 1.14, 1.1, 1.11, 1.12, 1.14, 1.13, 1.11, 1.11]	10.81	4.99	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
78	2026-02-21	22h	22h-6h	Chaîne 16	[1.1, 1.15, 1.14, 1.13, 1.15, 1.15, 1.13, 1.11, 1.1, 1.14, 1.12, 1.13, 1.15, 1.11, 1.13, 1.13, 1.12, 1.1, 1.12, 1.12, 1.13, 1.14, 1.12, 1.13]	10.97	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
79	2026-02-22	6h	6h-14h	Chaîne 8	[1.15, 1.13, 1.13, 1.12, 1.11, 1.12, 1.14, 1.13, 1.14, 1.11, 1.13, 1.15, 1.12, 1.13, 1.11, 1.15, 1.13, 1.11, 1.11, 1.13]	11	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
80	2026-02-22	14h	14h-22h	Chaîne 8	[1.11, 1.14, 1.15, 1.11, 1.13, 1.12, 1.15, 1.13, 1.14, 1.14, 1.11, 1.14, 1.12, 1.15, 1.13, 1.14, 1.11, 1.11, 1.13, 1.15]	10.8	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
81	2026-02-22	22h	22h-6h	Chaîne 8	[1.13, 1.11, 1.14, 1.1, 1.14, 1.14, 1.14, 1.12, 1.13, 1.14, 1.15, 1.12, 1.1, 1.13, 1.13, 1.14, 1.14, 1.12, 1.13, 1.12]	10.72	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
82	2026-02-22	6h	6h-14h	Chaîne 14	[1.14, 1.14, 1.12, 1.12, 1.14, 1.14, 1.14, 1.1, 1.1, 1.13, 1.15, 1.15, 1.14, 1.12, 1.1, 1.13]	11.08	5.36	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
83	2026-02-22	14h	14h-22h	Chaîne 14	[1.13, 1.14, 1.11, 1.1, 1.14, 1.13, 1.11, 1.15, 1.11, 1.12, 1.11, 1.11, 1.1, 1.14, 1.15, 1.13]	10.94	5.15	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
84	2026-02-22	22h	22h-6h	Chaîne 14	[1.12, 1.11, 1.13, 1.13, 1.15, 1.11, 1.15, 1.13, 1.11, 1.13, 1.13, 1.14, 1.1, 1.13, 1.12, 1.15]	11.15	5.17	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
85	2026-02-22	6h	6h-14h	Chaîne 15	[1.13, 1.15, 1.13, 1.12, 1.12, 1.13, 1.14, 1.1, 1.11, 1.14, 1.11, 1.11, 1.13, 1.15, 1.13, 1.15, 1.14, 1.11, 1.14, 1.12, 1.14, 1.14, 1.12, 1.11]	11.3	5.57	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
86	2026-02-22	14h	14h-22h	Chaîne 15	[1.1, 1.13, 1.12, 1.13, 1.13, 1.13, 1.14, 1.15, 1.11, 1.11, 1.1, 1.14, 1.13, 1.15, 1.11, 1.1, 1.14, 1.15, 1.12, 1.12, 1.11, 1.15, 1.12, 1.12]	11.34	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
87	2026-02-22	22h	22h-6h	Chaîne 15	[1.12, 1.1, 1.12, 1.12, 1.15, 1.1, 1.12, 1.12, 1.15, 1.14, 1.1, 1.13, 1.13, 1.15, 1.12, 1.12, 1.11, 1.11, 1.14, 1.12, 1.13, 1.13, 1.13, 1.1]	11.16	5.61	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
88	2026-02-22	6h	6h-14h	Chaîne 16	[1.11, 1.15, 1.1, 1.14, 1.11, 1.11, 1.11, 1.11, 1.13, 1.1, 1.1, 1.14, 1.11, 1.12, 1.11, 1.1, 1.14, 1.13, 1.14, 1.12, 1.14, 1.13, 1.11, 1.13]	10.88	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
89	2026-02-22	14h	14h-22h	Chaîne 16	[1.13, 1.12, 1.15, 1.1, 1.1, 1.13, 1.1, 1.11, 1.13, 1.13, 1.12, 1.15, 1.13, 1.12, 1.13, 1.1, 1.14, 1.14, 1.13, 1.14, 1.14, 1.11, 1.12, 1.11]	10.81	5.19	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
90	2026-02-22	22h	22h-6h	Chaîne 16	[1.14, 1.1, 1.1, 1.14, 1.14, 1.13, 1.13, 1.13, 1.12, 1.11, 1.12, 1.13, 1.14, 1.14, 1.14, 1.15, 1.13, 1.12, 1.13, 1.11, 1.13, 1.11, 1.11, 1.14]	10.85	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
91	2026-02-23	6h	6h-14h	Chaîne 14	[1.13, 1.12, 1.11, 1.13, 1.1, 1.14, 1.11, 1.12, 1.12, 1.12, 1.14, 1.14, 1.13, 1.1, 1.1, 1.11]	10.93	5.09	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
92	2026-02-23	14h	14h-22h	Chaîne 14	[1.11, 1.13, 1.12, 1.13, 1.1, 1.12, 1.13, 1.1, 1.12, 1.11, 1.11, 1.11, 1.12, 1.1, 1.14, 1.11]	11.11	5.14	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
93	2026-02-23	22h	22h-6h	Chaîne 14	[1.14, 1.13, 1.13, 1.14, 1.12, 1.11, 1.1, 1.12, 1.14, 1.13, 1.14, 1.15, 1.1, 1.14, 1.11, 1.13]	10.8	5.1	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
94	2026-02-23	6h	6h-14h	Chaîne 15	[1.12, 1.14, 1.14, 1.14, 1.11, 1.11, 1.11, 1.13, 1.14, 1.13, 1.11, 1.14, 1.12, 1.14, 1.14, 1.12, 1.15, 1.13, 1.13, 1.13, 1.14, 1.13, 1.11, 1.1]	11.03	5.5	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
95	2026-02-23	14h	14h-22h	Chaîne 15	[1.14, 1.14, 1.13, 1.13, 1.12, 1.13, 1.14, 1.14, 1.12, 1.14, 1.13, 1.12, 1.12, 1.11, 1.1, 1.11, 1.14, 1.12, 1.14, 1.13, 1.11, 1.11, 1.12, 1.12]	11	5.65	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
96	2026-02-23	22h	22h-6h	Chaîne 15	[1.1, 1.13, 1.11, 1.14, 1.13, 1.15, 1.14, 1.12, 1.13, 1.11, 1.12, 1.15, 1.13, 1.12, 1.13, 1.15, 1.12, 1.12, 1.14, 1.14, 1.13, 1.14, 1.14, 1.13]	11.33	5.56	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
97	2026-02-23	6h	6h-14h	Chaîne 16	[1.11, 1.1, 1.14, 1.11, 1.14, 1.14, 1.14, 1.1, 1.12, 1.14, 1.11, 1.12, 1.11, 1.14, 1.14, 1.14, 1.11, 1.12, 1.12, 1.13, 1.11, 1.12, 1.11, 1.14]	11.2	5.19	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
98	2026-02-23	14h	14h-22h	Chaîne 16	[1.11, 1.12, 1.13, 1.15, 1.14, 1.14, 1.11, 1.11, 1.13, 1.14, 1.13, 1.11, 1.14, 1.14, 1.11, 1.14, 1.11, 1.15, 1.11, 1.12, 1.15, 1.11, 1.12, 1.12]	11.2	5.4	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
99	2026-02-23	22h	22h-6h	Chaîne 16	[1.14, 1.11, 1.11, 1.14, 1.13, 1.11, 1.14, 1.12, 1.1, 1.1, 1.11, 1.14, 1.13, 1.14, 1.13, 1.11, 1.11, 1.12, 1.1, 1.12, 1.14, 1.12, 1.11, 1.15]	11.19	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
100	2026-02-24	6h	6h-14h	Chaîne 8	[1.1, 1.15, 1.1, 1.13, 1.13, 1.15, 1.13, 1.12, 1.12, 1.13, 1.15, 1.11, 1.1, 1.14, 1.12, 1.14, 1.13, 1.14, 1.14, 1.12]	10.69	5.17	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
101	2026-02-24	14h	14h-22h	Chaîne 8	[1.14, 1.12, 1.11, 1.1, 1.11, 1.1, 1.15, 1.13, 1.15, 1.13, 1.11, 1.14, 1.11, 1.12, 1.14, 1.14, 1.12, 1.11, 1.12, 1.14]	10.86	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
102	2026-02-24	22h	22h-6h	Chaîne 8	[1.1, 1.13, 1.14, 1.13, 1.12, 1.1, 1.13, 1.12, 1.13, 1.12, 1.13, 1.12, 1.1, 1.14, 1.12, 1.15, 1.11, 1.15, 1.15, 1.1]	10.81	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
103	2026-02-24	6h	6h-14h	Chaîne 15	[1.13, 1.13, 1.12, 1.13, 1.11, 1.11, 1.14, 1.12, 1.12, 1.13, 1.11, 1.11, 1.12, 1.15, 1.11, 1.15, 1.12, 1.11, 1.14, 1.12, 1.14, 1.12, 1.1, 1.13]	11.4	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
172	2026-03-03	6h	6h-14h	Chaîne 8	[1.12, 1.1, 1.15, 1.13, 1.13, 1.12, 1.13, 1.12, 1.14, 1.12, 1.11, 1.11, 1.1, 1.13, 1.12, 1.13, 1.1, 1.11, 1.11, 1.12]	10.89	5.06	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
104	2026-02-24	14h	14h-22h	Chaîne 15	[1.14, 1.13, 1.11, 1.11, 1.11, 1.14, 1.1, 1.13, 1.12, 1.14, 1.13, 1.13, 1.1, 1.12, 1.15, 1.14, 1.13, 1.14, 1.14, 1.1, 1.15, 1.13, 1.12, 1.13]	11.29	5.69	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
105	2026-02-24	22h	22h-6h	Chaîne 15	[1.11, 1.11, 1.12, 1.14, 1.12, 1.15, 1.14, 1.14, 1.11, 1.13, 1.13, 1.11, 1.12, 1.13, 1.13, 1.11, 1.15, 1.11, 1.13, 1.14, 1.13, 1.14, 1.13, 1.14]	11.38	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
106	2026-02-24	6h	6h-14h	Chaîne 16	[1.11, 1.15, 1.12, 1.14, 1.13, 1.11, 1.1, 1.1, 1.12, 1.12, 1.11, 1.13, 1.12, 1.14, 1.14, 1.14, 1.15, 1.11, 1.12, 1.13, 1.12, 1.12, 1.11, 1.11]	11.06	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
107	2026-02-24	14h	14h-22h	Chaîne 16	[1.14, 1.12, 1.13, 1.12, 1.12, 1.1, 1.15, 1.13, 1.15, 1.11, 1.12, 1.1, 1.12, 1.14, 1.13, 1.12, 1.13, 1.14, 1.12, 1.14, 1.14, 1.14, 1.12, 1.12]	10.92	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
108	2026-02-24	22h	22h-6h	Chaîne 16	[1.15, 1.12, 1.14, 1.12, 1.15, 1.14, 1.11, 1.13, 1.13, 1.1, 1.11, 1.12, 1.12, 1.12, 1.13, 1.13, 1.12, 1.13, 1.11, 1.15, 1.14, 1.11, 1.12, 1.14]	11.22	5.28	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
109	2026-02-25	6h	6h-14h	Chaîne 8	[1.13, 1.1, 1.12, 1.15, 1.14, 1.14, 1.13, 1.14, 1.13, 1.11, 1.13, 1.13, 1.14, 1.11, 1.13, 1.1, 1.15, 1.11, 1.1, 1.12]	10.84	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
110	2026-02-25	14h	14h-22h	Chaîne 8	[1.12, 1.13, 1.13, 1.12, 1.11, 1.15, 1.12, 1.12, 1.14, 1.14, 1.13, 1.13, 1.13, 1.11, 1.11, 1.13, 1.11, 1.15, 1.11, 1.11]	10.61	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
111	2026-02-25	22h	22h-6h	Chaîne 8	[1.15, 1.14, 1.15, 1.14, 1.11, 1.11, 1.14, 1.12, 1.12, 1.11, 1.12, 1.11, 1.13, 1.15, 1.13, 1.11, 1.13, 1.13, 1.11, 1.13]	10.64	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
112	2026-02-25	6h	6h-14h	Chaîne 14	[1.12, 1.15, 1.14, 1.12, 1.11, 1.15, 1.12, 1.13, 1.15, 1.1, 1.13, 1.13, 1.14, 1.15, 1.15, 1.11]	10.78	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
113	2026-02-25	14h	14h-22h	Chaîne 14	[1.1, 1.13, 1.11, 1.15, 1.11, 1.15, 1.13, 1.12, 1.15, 1.14, 1.12, 1.11, 1.11, 1.11, 1.12, 1.11]	11.2	5.48	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
114	2026-02-25	22h	22h-6h	Chaîne 14	[1.1, 1.13, 1.11, 1.11, 1.12, 1.11, 1.11, 1.11, 1.14, 1.15, 1.12, 1.14, 1.1, 1.13, 1.13, 1.1]	11.17	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
115	2026-02-25	6h	6h-14h	Chaîne 16	[1.13, 1.13, 1.11, 1.11, 1.14, 1.14, 1.1, 1.12, 1.14, 1.1, 1.13, 1.1, 1.13, 1.13, 1.13, 1.11, 1.12, 1.13, 1.11, 1.11, 1.13, 1.1, 1.13, 1.14]	10.96	5.22	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
116	2026-02-25	14h	14h-22h	Chaîne 16	[1.13, 1.1, 1.12, 1.1, 1.15, 1.15, 1.1, 1.15, 1.1, 1.12, 1.14, 1.14, 1.15, 1.13, 1.12, 1.15, 1.12, 1.14, 1.15, 1.12, 1.13, 1.13, 1.13, 1.13]	10.95	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
117	2026-02-25	22h	22h-6h	Chaîne 16	[1.13, 1.13, 1.14, 1.11, 1.12, 1.11, 1.15, 1.14, 1.11, 1.14, 1.12, 1.14, 1.14, 1.1, 1.11, 1.11, 1.1, 1.13, 1.14, 1.1, 1.14, 1.12, 1.11, 1.11]	10.79	5.12	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
118	2026-02-26	6h	6h-14h	Chaîne 8	[1.12, 1.11, 1.13, 1.11, 1.12, 1.1, 1.15, 1.14, 1.15, 1.13, 1.12, 1.12, 1.15, 1.15, 1.13, 1.14, 1.12, 1.12, 1.11, 1.12]	10.84	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
119	2026-02-26	14h	14h-22h	Chaîne 8	[1.11, 1.11, 1.11, 1.13, 1.15, 1.14, 1.1, 1.14, 1.11, 1.11, 1.13, 1.13, 1.14, 1.11, 1.14, 1.14, 1.13, 1.12, 1.14, 1.12]	10.83	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
120	2026-02-26	22h	22h-6h	Chaîne 8	[1.15, 1.13, 1.14, 1.12, 1.13, 1.12, 1.11, 1.13, 1.12, 1.1, 1.15, 1.12, 1.14, 1.15, 1.12, 1.12, 1.13, 1.11, 1.11, 1.11]	10.69	5.24	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
121	2026-02-26	6h	6h-14h	Chaîne 14	[1.11, 1.14, 1.15, 1.13, 1.12, 1.11, 1.14, 1.11, 1.14, 1.12, 1.15, 1.13, 1.13, 1.1, 1.1, 1.14]	11	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
122	2026-02-26	14h	14h-22h	Chaîne 14	[1.13, 1.13, 1.13, 1.12, 1.12, 1.1, 1.13, 1.1, 1.13, 1.11, 1.15, 1.1, 1.14, 1.13, 1.14, 1.15]	10.78	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
123	2026-02-26	22h	22h-6h	Chaîne 14	[1.13, 1.15, 1.11, 1.13, 1.14, 1.13, 1.14, 1.14, 1.1, 1.12, 1.13, 1.1, 1.1, 1.11, 1.12, 1.12]	10.95	5.25	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
124	2026-02-26	6h	6h-14h	Chaîne 15	[1.1, 1.1, 1.15, 1.14, 1.13, 1.1, 1.15, 1.12, 1.15, 1.13, 1.14, 1.14, 1.12, 1.1, 1.11, 1.11, 1.14, 1.12, 1.14, 1.12, 1.14, 1.11, 1.15, 1.14]	11.36	5.67	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
125	2026-02-26	14h	14h-22h	Chaîne 15	[1.1, 1.11, 1.15, 1.12, 1.12, 1.15, 1.12, 1.13, 1.13, 1.1, 1.13, 1.14, 1.14, 1.1, 1.11, 1.14, 1.13, 1.14, 1.12, 1.11, 1.1, 1.12, 1.12, 1.11]	11.4	5.45	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
126	2026-02-26	22h	22h-6h	Chaîne 15	[1.12, 1.11, 1.12, 1.1, 1.15, 1.15, 1.15, 1.13, 1.11, 1.12, 1.11, 1.12, 1.12, 1.1, 1.12, 1.12, 1.12, 1.1, 1.11, 1.11, 1.13, 1.13, 1.11, 1.11]	11.02	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
127	2026-02-27	6h	6h-14h	Chaîne 8	[1.12, 1.13, 1.11, 1.12, 1.14, 1.12, 1.11, 1.13, 1.13, 1.13, 1.13, 1.13, 1.15, 1.12, 1.14, 1.12, 1.11, 1.13, 1.14, 1.14]	11	5.11	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
128	2026-02-27	14h	14h-22h	Chaîne 8	[1.12, 1.13, 1.15, 1.13, 1.13, 1.14, 1.12, 1.14, 1.13, 1.13, 1.1, 1.14, 1.13, 1.12, 1.13, 1.1, 1.15, 1.13, 1.12, 1.14]	10.62	5.4	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
129	2026-02-27	22h	22h-6h	Chaîne 8	[1.14, 1.13, 1.13, 1.12, 1.1, 1.11, 1.12, 1.15, 1.11, 1.15, 1.11, 1.12, 1.12, 1.11, 1.12, 1.12, 1.12, 1.13, 1.12, 1.12]	10.83	5.18	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
130	2026-02-27	6h	6h-14h	Chaîne 14	[1.13, 1.15, 1.11, 1.12, 1.11, 1.13, 1.12, 1.1, 1.13, 1.11, 1.13, 1.12, 1.14, 1.11, 1.14, 1.14]	10.89	5.16	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
131	2026-02-27	14h	14h-22h	Chaîne 14	[1.13, 1.13, 1.13, 1.12, 1.14, 1.13, 1.14, 1.14, 1.11, 1.13, 1.1, 1.11, 1.11, 1.12, 1.11, 1.13]	11.16	5.31	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
132	2026-02-27	22h	22h-6h	Chaîne 14	[1.12, 1.11, 1.12, 1.12, 1.1, 1.12, 1.1, 1.11, 1.14, 1.15, 1.13, 1.12, 1.13, 1.12, 1.14, 1.12]	11.06	5.51	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
133	2026-02-27	6h	6h-14h	Chaîne 15	[1.13, 1.11, 1.11, 1.14, 1.14, 1.12, 1.14, 1.1, 1.14, 1.13, 1.15, 1.11, 1.14, 1.14, 1.11, 1.15, 1.12, 1.12, 1.14, 1.12, 1.15, 1.14, 1.11, 1.14]	11.18	5.61	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
134	2026-02-27	14h	14h-22h	Chaîne 15	[1.11, 1.13, 1.12, 1.14, 1.11, 1.11, 1.14, 1.15, 1.13, 1.1, 1.15, 1.14, 1.15, 1.15, 1.14, 1.11, 1.14, 1.11, 1.14, 1.14, 1.14, 1.13, 1.12, 1.13]	11.07	5.31	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
135	2026-02-27	22h	22h-6h	Chaîne 15	[1.15, 1.12, 1.1, 1.14, 1.14, 1.14, 1.12, 1.13, 1.12, 1.1, 1.13, 1.11, 1.12, 1.11, 1.11, 1.14, 1.12, 1.13, 1.13, 1.12, 1.12, 1.13, 1.1, 1.1]	11.1	5.69	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
136	2026-02-27	6h	6h-14h	Chaîne 16	[1.13, 1.11, 1.15, 1.11, 1.13, 1.11, 1.12, 1.15, 1.11, 1.12, 1.12, 1.13, 1.11, 1.13, 1.14, 1.1, 1.12, 1.11, 1.11, 1.13, 1.1, 1.13, 1.14, 1.15]	10.87	5.28	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
137	2026-02-27	14h	14h-22h	Chaîne 16	[1.14, 1.11, 1.15, 1.11, 1.13, 1.1, 1.13, 1.12, 1.14, 1.13, 1.11, 1.12, 1.13, 1.14, 1.1, 1.11, 1.14, 1.13, 1.12, 1.15, 1.12, 1.11, 1.11, 1.1]	11.17	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
138	2026-02-27	22h	22h-6h	Chaîne 16	[1.14, 1.11, 1.1, 1.14, 1.15, 1.12, 1.11, 1.12, 1.13, 1.13, 1.15, 1.15, 1.15, 1.11, 1.14, 1.13, 1.12, 1.13, 1.14, 1.15, 1.14, 1.1, 1.1, 1.11]	10.91	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
139	2026-02-28	6h	6h-14h	Chaîne 8	[1.13, 1.11, 1.12, 1.13, 1.11, 1.14, 1.13, 1.12, 1.13, 1.14, 1.13, 1.1, 1.13, 1.14, 1.14, 1.1, 1.1, 1.12, 1.12, 1.13]	10.89	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
140	2026-02-28	14h	14h-22h	Chaîne 8	[1.14, 1.11, 1.11, 1.14, 1.11, 1.14, 1.14, 1.1, 1.14, 1.11, 1.1, 1.14, 1.13, 1.1, 1.12, 1.12, 1.12, 1.13, 1.12, 1.11]	11	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
141	2026-02-28	22h	22h-6h	Chaîne 8	[1.11, 1.15, 1.14, 1.13, 1.15, 1.14, 1.12, 1.12, 1.12, 1.14, 1.11, 1.1, 1.12, 1.13, 1.15, 1.11, 1.14, 1.15, 1.15, 1.1]	10.69	5.19	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
142	2026-02-28	6h	6h-14h	Chaîne 14	[1.12, 1.13, 1.12, 1.14, 1.11, 1.15, 1.14, 1.11, 1.1, 1.12, 1.11, 1.12, 1.14, 1.14, 1.15, 1.1]	11.03	5.22	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
143	2026-02-28	14h	14h-22h	Chaîne 14	[1.1, 1.15, 1.14, 1.13, 1.14, 1.12, 1.15, 1.1, 1.1, 1.11, 1.14, 1.1, 1.13, 1.12, 1.15, 1.11]	10.81	5.51	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
144	2026-02-28	22h	22h-6h	Chaîne 14	[1.13, 1.11, 1.11, 1.12, 1.12, 1.13, 1.15, 1.11, 1.12, 1.11, 1.11, 1.11, 1.13, 1.14, 1.13, 1.1]	10.81	5.17	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
145	2026-02-28	6h	6h-14h	Chaîne 15	[1.12, 1.12, 1.14, 1.11, 1.12, 1.14, 1.11, 1.1, 1.14, 1.15, 1.11, 1.14, 1.12, 1.13, 1.13, 1.13, 1.11, 1.14, 1.1, 1.1, 1.15, 1.12, 1.11, 1.15]	11.09	5.72	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
146	2026-02-28	14h	14h-22h	Chaîne 15	[1.11, 1.11, 1.11, 1.11, 1.14, 1.1, 1.13, 1.11, 1.11, 1.12, 1.13, 1.1, 1.11, 1.11, 1.11, 1.14, 1.13, 1.13, 1.14, 1.14, 1.15, 1.14, 1.12, 1.13]	11.15	5.29	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
147	2026-02-28	22h	22h-6h	Chaîne 15	[1.15, 1.13, 1.14, 1.15, 1.15, 1.11, 1.13, 1.11, 1.14, 1.15, 1.1, 1.15, 1.11, 1.14, 1.14, 1.12, 1.14, 1.14, 1.11, 1.13, 1.14, 1.13, 1.15, 1.1]	11.38	5.62	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
148	2026-02-28	6h	6h-14h	Chaîne 16	[1.1, 1.11, 1.11, 1.13, 1.1, 1.15, 1.11, 1.11, 1.14, 1.15, 1.14, 1.12, 1.1, 1.13, 1.15, 1.14, 1.14, 1.14, 1.15, 1.12, 1.15, 1.12, 1.11, 1.12]	11	5.12	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
149	2026-02-28	14h	14h-22h	Chaîne 16	[1.14, 1.11, 1.13, 1.11, 1.12, 1.13, 1.11, 1.14, 1.15, 1.15, 1.12, 1.15, 1.15, 1.1, 1.13, 1.15, 1.15, 1.11, 1.13, 1.15, 1.11, 1.14, 1.11, 1.15]	11.21	5.28	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
150	2026-02-28	22h	22h-6h	Chaîne 16	[1.11, 1.11, 1.1, 1.12, 1.14, 1.15, 1.14, 1.12, 1.12, 1.13, 1.11, 1.12, 1.14, 1.13, 1.13, 1.11, 1.1, 1.14, 1.11, 1.12, 1.15, 1.1, 1.11, 1.12]	10.9	5.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
151	2026-03-01	6h	6h-14h	Chaîne 8	[1.14, 1.11, 1.11, 1.11, 1.11, 1.13, 1.14, 1.14, 1.11, 1.11, 1.11, 1.1, 1.13, 1.14, 1.11, 1.12, 1.12, 1.11, 1.13, 1.13]	10.6	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
152	2026-03-01	14h	14h-22h	Chaîne 8	[1.1, 1.13, 1.11, 1.14, 1.12, 1.12, 1.11, 1.12, 1.11, 1.11, 1.1, 1.14, 1.13, 1.1, 1.12, 1.13, 1.15, 1.13, 1.13, 1.14]	10.76	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
153	2026-03-01	22h	22h-6h	Chaîne 8	[1.13, 1.15, 1.14, 1.13, 1.13, 1.11, 1.14, 1.11, 1.15, 1.15, 1.14, 1.11, 1.12, 1.15, 1.12, 1.15, 1.13, 1.14, 1.11, 1.15]	10.62	5.37	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
154	2026-03-01	6h	6h-14h	Chaîne 14	[1.13, 1.12, 1.12, 1.11, 1.13, 1.14, 1.15, 1.15, 1.13, 1.11, 1.11, 1.13, 1.12, 1.12, 1.12, 1.12]	11.16	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
155	2026-03-01	14h	14h-22h	Chaîne 14	[1.14, 1.15, 1.14, 1.1, 1.14, 1.12, 1.11, 1.12, 1.13, 1.1, 1.14, 1.11, 1.15, 1.12, 1.14, 1.11]	11.17	5.23	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
156	2026-03-01	22h	22h-6h	Chaîne 14	[1.11, 1.12, 1.13, 1.11, 1.14, 1.14, 1.1, 1.11, 1.14, 1.14, 1.11, 1.12, 1.15, 1.14, 1.11, 1.14]	11.16	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
157	2026-03-01	6h	6h-14h	Chaîne 15	[1.11, 1.14, 1.14, 1.13, 1.11, 1.12, 1.11, 1.13, 1.15, 1.14, 1.13, 1.13, 1.11, 1.12, 1.1, 1.14, 1.14, 1.1, 1.15, 1.13, 1.13, 1.1, 1.11, 1.14]	11.37	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
158	2026-03-01	14h	14h-22h	Chaîne 15	[1.12, 1.11, 1.13, 1.13, 1.14, 1.12, 1.13, 1.13, 1.11, 1.11, 1.1, 1.15, 1.13, 1.14, 1.11, 1.14, 1.14, 1.11, 1.11, 1.14, 1.14, 1.14, 1.14, 1.13]	11.19	5.58	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
159	2026-03-01	22h	22h-6h	Chaîne 15	[1.13, 1.11, 1.14, 1.11, 1.13, 1.14, 1.15, 1.13, 1.13, 1.14, 1.14, 1.14, 1.11, 1.1, 1.11, 1.11, 1.14, 1.14, 1.11, 1.13, 1.12, 1.1, 1.12, 1.14]	11.15	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
160	2026-03-01	6h	6h-14h	Chaîne 16	[1.1, 1.14, 1.13, 1.14, 1.12, 1.11, 1.1, 1.14, 1.11, 1.11, 1.12, 1.13, 1.15, 1.12, 1.12, 1.14, 1.14, 1.12, 1.13, 1.11, 1.13, 1.1, 1.11, 1.14]	11.16	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
161	2026-03-01	14h	14h-22h	Chaîne 16	[1.1, 1.11, 1.12, 1.1, 1.12, 1.14, 1.11, 1.13, 1.13, 1.11, 1.13, 1.12, 1.11, 1.12, 1.13, 1.11, 1.14, 1.11, 1.11, 1.14, 1.13, 1.12, 1.14, 1.15]	10.96	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
162	2026-03-01	22h	22h-6h	Chaîne 16	[1.14, 1.13, 1.11, 1.12, 1.13, 1.1, 1.14, 1.11, 1.13, 1.1, 1.15, 1.13, 1.13, 1.1, 1.13, 1.12, 1.12, 1.13, 1.12, 1.11, 1.13, 1.13, 1.12, 1.13]	10.88	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
163	2026-03-02	6h	6h-14h	Chaîne 14	[1.11, 1.15, 1.12, 1.1, 1.13, 1.15, 1.14, 1.13, 1.11, 1.1, 1.13, 1.14, 1.11, 1.11, 1.11, 1.15]	10.91	5.1	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
164	2026-03-02	14h	14h-22h	Chaîne 14	[1.14, 1.1, 1.14, 1.13, 1.11, 1.12, 1.12, 1.13, 1.14, 1.1, 1.14, 1.11, 1.12, 1.15, 1.11, 1.12]	10.92	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
165	2026-03-02	22h	22h-6h	Chaîne 14	[1.13, 1.14, 1.13, 1.11, 1.12, 1.12, 1.1, 1.13, 1.14, 1.15, 1.11, 1.15, 1.11, 1.12, 1.1, 1.11]	11.19	5.16	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
166	2026-03-02	6h	6h-14h	Chaîne 15	[1.14, 1.1, 1.13, 1.11, 1.12, 1.13, 1.12, 1.14, 1.13, 1.15, 1.1, 1.13, 1.11, 1.14, 1.14, 1.14, 1.1, 1.12, 1.11, 1.15, 1.1, 1.11, 1.13, 1.12]	11.28	5.43	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
167	2026-03-02	14h	14h-22h	Chaîne 15	[1.12, 1.13, 1.1, 1.1, 1.13, 1.13, 1.12, 1.13, 1.11, 1.13, 1.15, 1.12, 1.1, 1.11, 1.12, 1.13, 1.13, 1.12, 1.13, 1.14, 1.11, 1.14, 1.11, 1.12]	11.2	5.57	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
168	2026-03-02	22h	22h-6h	Chaîne 15	[1.11, 1.13, 1.11, 1.15, 1.12, 1.12, 1.14, 1.14, 1.11, 1.12, 1.15, 1.14, 1.13, 1.14, 1.12, 1.13, 1.15, 1.11, 1.12, 1.13, 1.1, 1.15, 1.14, 1.12]	11.04	5.6	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
169	2026-03-02	6h	6h-14h	Chaîne 16	[1.12, 1.15, 1.15, 1.14, 1.11, 1.15, 1.15, 1.12, 1.11, 1.12, 1.14, 1.14, 1.11, 1.14, 1.14, 1.14, 1.15, 1.13, 1.11, 1.13, 1.11, 1.12, 1.13, 1.15]	11.04	5.36	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
170	2026-03-02	14h	14h-22h	Chaîne 16	[1.12, 1.14, 1.14, 1.11, 1.14, 1.14, 1.13, 1.1, 1.11, 1.13, 1.11, 1.14, 1.11, 1.11, 1.11, 1.14, 1.13, 1.11, 1.14, 1.1, 1.14, 1.11, 1.14, 1.14]	10.99	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
171	2026-03-02	22h	22h-6h	Chaîne 16	[1.15, 1.15, 1.12, 1.13, 1.1, 1.11, 1.13, 1.14, 1.14, 1.14, 1.15, 1.14, 1.13, 1.14, 1.13, 1.13, 1.14, 1.15, 1.11, 1.11, 1.13, 1.11, 1.11, 1.13]	11.07	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
173	2026-03-03	14h	14h-22h	Chaîne 8	[1.15, 1.13, 1.13, 1.15, 1.13, 1.12, 1.15, 1.15, 1.12, 1.13, 1.11, 1.15, 1.14, 1.12, 1.14, 1.12, 1.1, 1.14, 1.11, 1.13]	10.59	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
174	2026-03-03	22h	22h-6h	Chaîne 8	[1.11, 1.13, 1.14, 1.15, 1.14, 1.13, 1.15, 1.14, 1.11, 1.12, 1.12, 1.1, 1.1, 1.14, 1.13, 1.13, 1.11, 1.11, 1.12, 1.13]	10.92	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
175	2026-03-03	6h	6h-14h	Chaîne 15	[1.12, 1.13, 1.11, 1.12, 1.14, 1.13, 1.15, 1.11, 1.13, 1.15, 1.14, 1.14, 1.12, 1.15, 1.13, 1.13, 1.11, 1.1, 1.13, 1.13, 1.15, 1.12, 1.14, 1.15]	11.17	5.45	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
176	2026-03-03	14h	14h-22h	Chaîne 15	[1.14, 1.14, 1.15, 1.15, 1.12, 1.13, 1.11, 1.1, 1.1, 1.14, 1.12, 1.12, 1.11, 1.13, 1.11, 1.13, 1.15, 1.12, 1.12, 1.13, 1.12, 1.13, 1.13, 1.12]	11.06	5.36	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
177	2026-03-03	22h	22h-6h	Chaîne 15	[1.14, 1.12, 1.12, 1.12, 1.13, 1.11, 1.13, 1.14, 1.14, 1.11, 1.13, 1.11, 1.14, 1.1, 1.1, 1.1, 1.13, 1.1, 1.13, 1.12, 1.13, 1.15, 1.13, 1.13]	11.35	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
178	2026-03-03	6h	6h-14h	Chaîne 16	[1.12, 1.13, 1.13, 1.14, 1.14, 1.13, 1.11, 1.13, 1.12, 1.11, 1.15, 1.13, 1.15, 1.14, 1.12, 1.12, 1.11, 1.12, 1.1, 1.12, 1.1, 1.11, 1.15, 1.12]	10.91	5.19	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
179	2026-03-03	14h	14h-22h	Chaîne 16	[1.13, 1.11, 1.13, 1.12, 1.13, 1.14, 1.13, 1.12, 1.15, 1.13, 1.12, 1.14, 1.12, 1.12, 1.13, 1.13, 1.11, 1.11, 1.1, 1.13, 1.11, 1.11, 1.12, 1.14]	11.15	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
180	2026-03-03	22h	22h-6h	Chaîne 16	[1.1, 1.13, 1.11, 1.13, 1.1, 1.13, 1.1, 1.11, 1.11, 1.15, 1.13, 1.13, 1.1, 1.14, 1.13, 1.11, 1.1, 1.12, 1.15, 1.14, 1.11, 1.14, 1.13, 1.14]	10.85	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
181	2026-03-04	6h	6h-14h	Chaîne 8	[1.14, 1.13, 1.12, 1.11, 1.1, 1.12, 1.13, 1.1, 1.14, 1.13, 1.11, 1.12, 1.11, 1.06, 1.14, 1.14, 1.21, 1.13, 1.13, 1.12]	10.75	5.04	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
182	2026-03-04	14h	14h-22h	Chaîne 8	[1.13, 1.12, 1.11, 1.14, 1.08, 1.11, 1.12, 1.13, 1.11, 1.13, 1.13, 1.07, 1.19, 1.12, 1.11, 1.13, 1.13, 1.11, 1.08, 1.12]	10.91	4.99	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
183	2026-03-04	22h	22h-6h	Chaîne 8	[1.15, 1.13, 1.08, 1.14, 1.13, 1.21, 1.14, 1.13, 1.12, 1.11, 1.13, 1.14, 1.11, 1.1, 1.13, 1.13, 1.11, 1.11, 1.1, 1.11]	10.62	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
184	2026-03-04	6h	6h-14h	Chaîne 14	[1.13, 1.11, 1.15, 1.13, 1.11, 1.12, 1.11, 1.1, 1.11, 1.15, 1.14, 1.15, 1.14, 1.14, 1.13, 1.13]	10.93	5.5	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
185	2026-03-04	14h	14h-22h	Chaîne 14	[1.1, 1.13, 1.15, 1.13, 1.11, 1.12, 1.15, 1.13, 1.1, 1.14, 1.11, 1.1, 1.13, 1.14, 1.1, 1.15]	11.04	5.1	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
186	2026-03-04	22h	22h-6h	Chaîne 14	[1.14, 1.11, 1.11, 1.11, 1.13, 1.11, 1.11, 1.15, 1.13, 1.13, 1.13, 1.14, 1.13, 1.1, 1.12, 1.13]	11	5.17	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
187	2026-03-04	6h	6h-14h	Chaîne 16	[1.13, 1.12, 1.13, 1.1, 1.11, 1.13, 1.12, 1.13, 1.11, 1.13, 1.11, 1.12, 1.13, 1.12, 1.12, 1.11, 1.14, 1.12, 1.14, 1.11, 1.11, 1.11, 1.13, 1.11]	11.08	5.06	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
188	2026-03-04	14h	14h-22h	Chaîne 16	[1.12, 1.15, 1.14, 1.13, 1.14, 1.14, 1.12, 1.13, 1.13, 1.12, 1.13, 1.1, 1.14, 1.12, 1.13, 1.12, 1.12, 1.12, 1.13, 1.15, 1.11, 1.1, 1.11, 1.14]	10.85	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
189	2026-03-04	22h	22h-6h	Chaîne 16	[1.14, 1.12, 1.11, 1.13, 1.11, 1.11, 1.14, 1.12, 1.13, 1.13, 1.14, 1.1, 1.11, 1.11, 1.12, 1.11, 1.11, 1.13, 1.11, 1.12, 1.14, 1.12, 1.13, 1.15]	11.08	5.19	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
190	2026-03-05	6h	6h-14h	Chaîne 8	[1.1, 1.14, 1.13, 1.1, 1.12, 1.14, 1.1, 1.11, 1.11, 1.13, 1.14, 1.12, 1.11, 1.11, 1.13, 1.11, 1.14, 1.1, 1.13, 1.14]	10.62	5.06	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
191	2026-03-05	14h	14h-22h	Chaîne 8	[1.13, 1.13, 1.13, 1.13, 1.13, 1.12, 1.12, 1.13, 1.14, 1.12, 1.12, 1.11, 1.12, 1.1, 1.14, 1.14, 1.12, 1.12, 1.1, 1.15]	10.89	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
192	2026-03-05	22h	22h-6h	Chaîne 8	[1.12, 1.11, 1.14, 1.12, 1.12, 1.11, 1.12, 1.11, 1.14, 1.15, 1.14, 1.13, 1.11, 1.14, 1.14, 1.12, 1.14, 1.11, 1.11, 1.13]	10.75	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
193	2026-03-05	6h	6h-14h	Chaîne 14	[1.14, 1.14, 1.11, 1.11, 1.12, 1.12, 1.12, 1.14, 1.15, 1.12, 1.14, 1.12, 1.14, 1.15, 1.1, 1.14]	10.86	5.13	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
194	2026-03-05	14h	14h-22h	Chaîne 14	[1.12, 1.14, 1.1, 1.12, 1.14, 1.13, 1.15, 1.12, 1.13, 1.12, 1.12, 1.13, 1.1, 1.15, 1.13, 1.11]	11.12	5.19	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
195	2026-03-05	22h	22h-6h	Chaîne 14	[1.11, 1.14, 1.1, 1.1, 1.14, 1.12, 1.13, 1.12, 1.1, 1.11, 1.1, 1.13, 1.15, 1.15, 1.13, 1.1]	10.92	5.16	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
196	2026-03-05	6h	6h-14h	Chaîne 15	[1.11, 1.13, 1.12, 1.11, 1.14, 1.12, 1.12, 1.11, 1.13, 1.11, 1.11, 1.12, 1.14, 1.11, 1.14, 1.15, 1.13, 1.1, 1.11, 1.11, 1.11, 1.12, 1.1, 1.13]	11.32	5.63	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
197	2026-03-05	14h	14h-22h	Chaîne 15	[1.13, 1.12, 1.13, 1.13, 1.12, 1.13, 1.11, 1.13, 1.1, 1.14, 1.11, 1.14, 1.11, 1.12, 1.1, 1.13, 1.14, 1.13, 1.13, 1.14, 1.11, 1.12, 1.13, 1.1]	11.27	5.52	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
198	2026-03-05	22h	22h-6h	Chaîne 15	[1.12, 1.14, 1.14, 1.11, 1.1, 1.1, 1.12, 1.15, 1.15, 1.1, 1.14, 1.13, 1.11, 1.13, 1.11, 1.13, 1.11, 1.14, 1.12, 1.11, 1.13, 1.12, 1.12, 1.13]	11.23	5.69	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
199	2026-03-06	6h	6h-14h	Chaîne 8	[1.14, 1.15, 1.11, 1.15, 1.12, 1.12, 1.14, 1.15, 1.13, 1.13, 1.15, 1.12, 1.12, 1.11, 1.14, 1.1, 1.14, 1.13, 1.11, 1.13]	10.85	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
200	2026-03-06	14h	14h-22h	Chaîne 8	[1.1, 1.12, 1.15, 1.14, 1.14, 1.14, 1.11, 1.14, 1.13, 1.13, 1.15, 1.13, 1.12, 1.14, 1.13, 1.1, 1.1, 1.14, 1.12, 1.14]	10.84	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
201	2026-03-06	22h	22h-6h	Chaîne 8	[1.1, 1.13, 1.11, 1.13, 1.11, 1.1, 1.14, 1.12, 1.12, 1.13, 1.13, 1.11, 1.11, 1.12, 1.11, 1.1, 1.13, 1.1, 1.12, 1.1]	10.92	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
202	2026-03-06	6h	6h-14h	Chaîne 14	[1.11, 1.1, 1.14, 1.12, 1.15, 1.1, 1.13, 1.12, 1.12, 1.12, 1.13, 1.1, 1.12, 1.15, 1.13, 1.15]	10.87	5.35	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
203	2026-03-06	14h	14h-22h	Chaîne 14	[1.15, 1.15, 1.14, 1.14, 1.1, 1.13, 1.11, 1.12, 1.1, 1.11, 1.13, 1.11, 1.13, 1.11, 1.12, 1.14]	11.16	5.14	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
204	2026-03-06	22h	22h-6h	Chaîne 14	[1.1, 1.13, 1.1, 1.12, 1.11, 1.14, 1.13, 1.14, 1.1, 1.14, 1.13, 1.11, 1.12, 1.15, 1.1, 1.12]	10.9	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
205	2026-03-06	6h	6h-14h	Chaîne 15	[1.12, 1.11, 1.12, 1.12, 1.13, 1.11, 1.15, 1.13, 1.14, 1.13, 1.14, 1.14, 1.14, 1.1, 1.13, 1.11, 1.11, 1.14, 1.13, 1.1, 1.12, 1.15, 1.13, 1.13]	11.09	5.51	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
206	2026-03-06	14h	14h-22h	Chaîne 15	[1.14, 1.14, 1.12, 1.14, 1.13, 1.11, 1.15, 1.15, 1.11, 1.15, 1.15, 1.12, 1.13, 1.15, 1.11, 1.12, 1.14, 1.14, 1.14, 1.14, 1.12, 1.12, 1.12, 1.15]	11.07	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
207	2026-03-06	22h	22h-6h	Chaîne 15	[1.11, 1.11, 1.13, 1.12, 1.13, 1.12, 1.13, 1.13, 1.14, 1.12, 1.14, 1.12, 1.11, 1.11, 1.1, 1.14, 1.1, 1.11, 1.12, 1.14, 1.15, 1.14, 1.1, 1.15]	11.25	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
208	2026-03-06	6h	6h-14h	Chaîne 16	[1.12, 1.13, 1.14, 1.13, 1.13, 1.14, 1.14, 1.13, 1.12, 1.14, 1.1, 1.15, 1.13, 1.12, 1.14, 1.13, 1.13, 1.13, 1.1, 1.11, 1.12, 1.12, 1.14, 1.12]	10.8	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
209	2026-03-06	14h	14h-22h	Chaîne 16	[1.15, 1.13, 1.11, 1.12, 1.12, 1.11, 1.13, 1.14, 1.11, 1.12, 1.11, 1.13, 1.15, 1.14, 1.14, 1.11, 1.11, 1.12, 1.12, 1.13, 1.12, 1.14, 1.13, 1.15]	11.1	5.04	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
210	2026-03-06	22h	22h-6h	Chaîne 16	[1.12, 1.12, 1.14, 1.12, 1.13, 1.11, 1.11, 1.11, 1.13, 1.11, 1.12, 1.14, 1.13, 1.1, 1.14, 1.11, 1.13, 1.12, 1.12, 1.1, 1.13, 1.11, 1.13, 1.13]	11.16	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
211	2026-03-07	6h	6h-14h	Chaîne 8	[1.15, 1.1, 1.12, 1.11, 1.13, 1.13, 1.13, 1.13, 1.14, 1.11, 1.12, 1.13, 1.15, 1.1, 1.11, 1.12, 1.12, 1.1, 1.12, 1.13]	10.87	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
212	2026-03-07	14h	14h-22h	Chaîne 8	[1.13, 1.15, 1.12, 1.13, 1.15, 1.15, 1.11, 1.13, 1.12, 1.13, 1.15, 1.12, 1.11, 1.13, 1.13, 1.13, 1.12, 1.11, 1.13, 1.14]	10.85	5.04	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
213	2026-03-07	22h	22h-6h	Chaîne 8	[1.13, 1.13, 1.1, 1.11, 1.11, 1.14, 1.12, 1.13, 1.12, 1.1, 1.13, 1.12, 1.14, 1.13, 1.1, 1.11, 1.12, 1.12, 1.13, 1.15]	11.02	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
214	2026-03-07	6h	6h-14h	Chaîne 14	[1.14, 1.11, 1.14, 1.12, 1.13, 1.11, 1.13, 1.14, 1.14, 1.12, 1.15, 1.11, 1.1, 1.15, 1.13, 1.14]	11.12	5.26	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
215	2026-03-07	14h	14h-22h	Chaîne 14	[1.11, 1.12, 1.15, 1.11, 1.12, 1.11, 1.14, 1.14, 1.15, 1.12, 1.1, 1.12, 1.13, 1.11, 1.15, 1.14]	10.79	5.26	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
216	2026-03-07	22h	22h-6h	Chaîne 14	[1.14, 1.13, 1.1, 1.15, 1.13, 1.13, 1.1, 1.12, 1.1, 1.13, 1.13, 1.12, 1.13, 1.12, 1.14, 1.12]	10.84	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
217	2026-03-07	6h	6h-14h	Chaîne 15	[1.11, 1.12, 1.12, 1.11, 1.14, 1.11, 1.11, 1.1, 1.13, 1.12, 1.12, 1.11, 1.12, 1.13, 1.11, 1.1, 1.12, 1.11, 1.13, 1.13, 1.14, 1.13, 1.13, 1.12]	10.98	5.55	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
218	2026-03-07	14h	14h-22h	Chaîne 15	[1.12, 1.12, 1.13, 1.14, 1.12, 1.11, 1.11, 1.14, 1.13, 1.15, 1.12, 1.13, 1.13, 1.14, 1.14, 1.12, 1.1, 1.12, 1.12, 1.12, 1.11, 1.14, 1.13, 1.11]	11.04	5.64	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
219	2026-03-07	22h	22h-6h	Chaîne 15	[1.13, 1.15, 1.12, 1.12, 1.14, 1.13, 1.14, 1.12, 1.14, 1.13, 1.11, 1.13, 1.1, 1.15, 1.13, 1.12, 1.13, 1.12, 1.13, 1.14, 1.11, 1.15, 1.1, 1.11]	11.16	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
220	2026-03-07	6h	6h-14h	Chaîne 16	[1.1, 1.11, 1.11, 1.13, 1.12, 1.13, 1.11, 1.13, 1.12, 1.13, 1.15, 1.12, 1.15, 1.12, 1.15, 1.12, 1.1, 1.1, 1.15, 1.12, 1.11, 1.11, 1.12, 1.13]	11.17	5.37	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
221	2026-03-07	14h	14h-22h	Chaîne 16	[1.12, 1.12, 1.13, 1.13, 1.12, 1.11, 1.12, 1.15, 1.14, 1.11, 1.15, 1.13, 1.11, 1.1, 1.1, 1.14, 1.12, 1.12, 1.15, 1.1, 1.13, 1.12, 1.12, 1.14]	11.09	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
222	2026-03-07	22h	22h-6h	Chaîne 16	[1.14, 1.11, 1.13, 1.12, 1.13, 1.12, 1.15, 1.13, 1.14, 1.11, 1.12, 1.13, 1.11, 1.14, 1.15, 1.15, 1.14, 1.12, 1.1, 1.14, 1.1, 1.12, 1.14, 1.15]	10.86	5.24	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
223	2026-03-08	6h	6h-14h	Chaîne 8	[1.14, 1.12, 1.15, 1.14, 1.11, 1.1, 1.15, 1.14, 1.14, 1.13, 1.1, 1.12, 1.11, 1.1, 1.15, 1.14, 1.13, 1.11, 1.1, 1.13]	10.79	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
224	2026-03-08	14h	14h-22h	Chaîne 8	[1.12, 1.14, 1.11, 1.14, 1.12, 1.14, 1.14, 1.12, 1.1, 1.11, 1.15, 1.11, 1.12, 1.15, 1.14, 1.11, 1.12, 1.13, 1.11, 1.14]	10.66	5.24	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
225	2026-03-08	22h	22h-6h	Chaîne 8	[1.12, 1.14, 1.12, 1.11, 1.14, 1.1, 1.15, 1.12, 1.13, 1.15, 1.13, 1.1, 1.15, 1.13, 1.15, 1.12, 1.15, 1.14, 1.12, 1.11]	10.91	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
226	2026-03-08	6h	6h-14h	Chaîne 14	[1.11, 1.13, 1.13, 1.14, 1.1, 1.1, 1.11, 1.12, 1.11, 1.11, 1.11, 1.1, 1.1, 1.15, 1.13, 1.14]	10.87	5.23	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
227	2026-03-08	14h	14h-22h	Chaîne 14	[1.14, 1.13, 1.11, 1.12, 1.15, 1.13, 1.15, 1.11, 1.12, 1.15, 1.14, 1.12, 1.11, 1.1, 1.14, 1.12]	11.18	5.33	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
228	2026-03-08	22h	22h-6h	Chaîne 14	[1.11, 1.14, 1.11, 1.13, 1.15, 1.14, 1.11, 1.1, 1.13, 1.11, 1.12, 1.14, 1.11, 1.13, 1.15, 1.13]	11.05	5.16	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
229	2026-03-08	6h	6h-14h	Chaîne 15	[1.14, 1.13, 1.1, 1.15, 1.14, 1.12, 1.13, 1.15, 1.12, 1.13, 1.12, 1.13, 1.15, 1.1, 1.13, 1.15, 1.1, 1.12, 1.14, 1.13, 1.11, 1.1, 1.12, 1.11]	11.17	5.65	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
230	2026-03-08	14h	14h-22h	Chaîne 15	[1.13, 1.12, 1.1, 1.13, 1.12, 1.13, 1.14, 1.12, 1.15, 1.1, 1.1, 1.14, 1.1, 1.11, 1.14, 1.13, 1.12, 1.13, 1.14, 1.11, 1.13, 1.15, 1.1, 1.11]	11.04	5.36	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
231	2026-03-08	22h	22h-6h	Chaîne 15	[1.12, 1.11, 1.13, 1.14, 1.11, 1.12, 1.14, 1.11, 1.14, 1.12, 1.14, 1.15, 1.13, 1.12, 1.15, 1.13, 1.11, 1.14, 1.14, 1.14, 1.13, 1.12, 1.11, 1.11]	11	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
232	2026-03-08	6h	6h-14h	Chaîne 16	[1.1, 1.12, 1.1, 1.11, 1.1, 1.13, 1.14, 1.12, 1.14, 1.14, 1.13, 1.11, 1.13, 1.13, 1.12, 1.15, 1.13, 1.1, 1.11, 1.12, 1.15, 1.13, 1.14, 1.12]	11.15	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
233	2026-03-08	14h	14h-22h	Chaîne 16	[1.13, 1.11, 1.11, 1.14, 1.13, 1.15, 1.12, 1.11, 1.13, 1.1, 1.13, 1.11, 1.12, 1.12, 1.14, 1.14, 1.1, 1.14, 1.15, 1.11, 1.14, 1.12, 1.11, 1.14]	11.02	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
234	2026-03-08	22h	22h-6h	Chaîne 16	[1.14, 1.12, 1.11, 1.12, 1.12, 1.14, 1.11, 1.15, 1.12, 1.12, 1.11, 1.14, 1.13, 1.15, 1.11, 1.11, 1.13, 1.1, 1.11, 1.14, 1.12, 1.11, 1.12, 1.14]	10.92	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
235	2026-03-09	6h	6h-14h	Chaîne 14	[1.14, 1.13, 1.11, 1.13, 1.1, 1.15, 1.1, 1.12, 1.14, 1.1, 1.13, 1.12, 1.14, 1.14, 1.12, 1.11]	10.89	5.23	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
236	2026-03-09	14h	14h-22h	Chaîne 14	[1.14, 1.14, 1.14, 1.1, 1.12, 1.14, 1.14, 1.12, 1.14, 1.12, 1.12, 1.13, 1.14, 1.1, 1.14, 1.12]	10.82	5.29	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
237	2026-03-09	22h	22h-6h	Chaîne 14	[1.1, 1.15, 1.13, 1.14, 1.11, 1.12, 1.13, 1.12, 1.11, 1.13, 1.1, 1.14, 1.11, 1.15, 1.11, 1.11]	10.82	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
238	2026-03-09	6h	6h-14h	Chaîne 15	[1.11, 1.1, 1.12, 1.12, 1.13, 1.11, 1.14, 1.13, 1.13, 1.11, 1.13, 1.14, 1.15, 1.14, 1.15, 1.1, 1.14, 1.12, 1.1, 1.14, 1.11, 1.15, 1.11, 1.11]	11.13	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
239	2026-03-09	14h	14h-22h	Chaîne 15	[1.12, 1.13, 1.11, 1.1, 1.14, 1.11, 1.15, 1.13, 1.12, 1.12, 1.13, 1.12, 1.13, 1.13, 1.14, 1.12, 1.12, 1.11, 1.14, 1.11, 1.11, 1.12, 1.15, 1.14]	11.22	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
240	2026-03-09	22h	22h-6h	Chaîne 15	[1.13, 1.11, 1.11, 1.1, 1.12, 1.11, 1.11, 1.11, 1.13, 1.1, 1.12, 1.12, 1.12, 1.13, 1.11, 1.12, 1.15, 1.12, 1.12, 1.11, 1.12, 1.12, 1.1, 1.14]	11.41	5.65	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
241	2026-03-09	6h	6h-14h	Chaîne 16	[1.15, 1.12, 1.13, 1.14, 1.15, 1.11, 1.13, 1.12, 1.12, 1.14, 1.12, 1.1, 1.1, 1.13, 1.13, 1.11, 1.15, 1.11, 1.1, 1.13, 1.12, 1.13, 1.1, 1.13]	11.03	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
242	2026-03-09	14h	14h-22h	Chaîne 16	[1.11, 1.12, 1.15, 1.14, 1.1, 1.14, 1.12, 1.15, 1.14, 1.11, 1.14, 1.15, 1.12, 1.14, 1.11, 1.13, 1.1, 1.11, 1.12, 1.14, 1.15, 1.1, 1.15, 1.14]	11.16	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
243	2026-03-09	22h	22h-6h	Chaîne 16	[1.13, 1.1, 1.14, 1.14, 1.12, 1.13, 1.12, 1.1, 1.1, 1.11, 1.15, 1.14, 1.12, 1.13, 1.14, 1.12, 1.12, 1.13, 1.11, 1.11, 1.11, 1.15, 1.1, 1.14]	10.84	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
244	2026-03-10	6h	6h-14h	Chaîne 8	[1.11, 1.1, 1.12, 1.14, 1.11, 1.11, 1.11, 1.12, 1.15, 1.12, 1.11, 1.13, 1.15, 1.13, 1.14, 1.11, 1.1, 1.14, 1.13, 1.14]	10.81	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
245	2026-03-10	14h	14h-22h	Chaîne 8	[1.12, 1.12, 1.12, 1.15, 1.11, 1.11, 1.11, 1.11, 1.14, 1.13, 1.14, 1.13, 1.13, 1.13, 1.14, 1.11, 1.12, 1.1, 1.14, 1.15]	10.94	5	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
246	2026-03-10	22h	22h-6h	Chaîne 8	[1.14, 1.11, 1.14, 1.11, 1.11, 1.11, 1.11, 1.1, 1.13, 1.14, 1.1, 1.14, 1.14, 1.1, 1.11, 1.14, 1.13, 1.1, 1.11, 1.11]	10.73	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
247	2026-03-10	6h	6h-14h	Chaîne 15	[1.1, 1.13, 1.1, 1.11, 1.11, 1.11, 1.15, 1.13, 1.15, 1.1, 1.11, 1.13, 1.14, 1.12, 1.13, 1.12, 1.15, 1.11, 1.12, 1.12, 1.11, 1.11, 1.11, 1.15]	11.3	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
248	2026-03-10	14h	14h-22h	Chaîne 15	[1.13, 1.12, 1.15, 1.12, 1.13, 1.11, 1.14, 1.11, 1.1, 1.14, 1.12, 1.13, 1.11, 1.15, 1.12, 1.11, 1.12, 1.13, 1.1, 1.11, 1.12, 1.13, 1.11, 1.15]	11.12	5.33	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
249	2026-03-10	22h	22h-6h	Chaîne 15	[1.14, 1.13, 1.11, 1.14, 1.13, 1.12, 1.12, 1.13, 1.12, 1.12, 1.11, 1.14, 1.11, 1.11, 1.12, 1.13, 1.11, 1.1, 1.1, 1.1, 1.13, 1.15, 1.12, 1.13]	11.35	5.6	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
250	2026-03-10	6h	6h-14h	Chaîne 16	[1.11, 1.12, 1.14, 1.13, 1.15, 1.1, 1.12, 1.15, 1.12, 1.12, 1.12, 1.12, 1.1, 1.13, 1.14, 1.12, 1.14, 1.12, 1.11, 1.14, 1.12, 1.11, 1.13, 1.13]	10.87	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
251	2026-03-10	14h	14h-22h	Chaîne 16	[1.15, 1.12, 1.1, 1.1, 1.14, 1.12, 1.14, 1.1, 1.14, 1.12, 1.1, 1.12, 1.12, 1.12, 1.13, 1.11, 1.13, 1.13, 1.15, 1.1, 1.12, 1.12, 1.1, 1.12]	11.21	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
252	2026-03-10	22h	22h-6h	Chaîne 16	[1.13, 1.14, 1.11, 1.13, 1.12, 1.13, 1.14, 1.12, 1.13, 1.12, 1.12, 1.12, 1.14, 1.14, 1.14, 1.13, 1.11, 1.1, 1.15, 1.12, 1.11, 1.14, 1.1, 1.14]	11.21	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
253	2026-03-11	6h	6h-14h	Chaîne 8	[1.12, 1.13, 1.11, 1.12, 1.13, 1.12, 1.14, 1.11, 1.1, 1.14, 1.14, 1.13, 1.11, 1.15, 1.14, 1.12, 1.15, 1.13, 1.13, 1.14]	10.87	5.12	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
254	2026-03-11	14h	14h-22h	Chaîne 8	[1.12, 1.14, 1.1, 1.11, 1.12, 1.14, 1.13, 1.11, 1.13, 1.12, 1.11, 1.11, 1.11, 1.14, 1.12, 1.13, 1.12, 1.13, 1.1, 1.11]	10.88	5.12	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
255	2026-03-11	22h	22h-6h	Chaîne 8	[1.1, 1.13, 1.14, 1.15, 1.12, 1.12, 1.13, 1.1, 1.15, 1.14, 1.11, 1.11, 1.14, 1.15, 1.13, 1.14, 1.15, 1.15, 1.11, 1.14]	10.79	5	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
256	2026-03-11	6h	6h-14h	Chaîne 14	[1.11, 1.15, 1.12, 1.11, 1.13, 1.12, 1.12, 1.15, 1.12, 1.12, 1.13, 1.15, 1.14, 1.15, 1.12, 1.14]	10.88	5.27	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
257	2026-03-11	14h	14h-22h	Chaîne 14	[1.13, 1.12, 1.15, 1.12, 1.14, 1.11, 1.14, 1.14, 1.12, 1.15, 1.12, 1.15, 1.11, 1.1, 1.14, 1.11]	11.08	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
258	2026-03-11	22h	22h-6h	Chaîne 14	[1.15, 1.12, 1.12, 1.14, 1.14, 1.14, 1.14, 1.14, 1.13, 1.13, 1.12, 1.13, 1.14, 1.14, 1.12, 1.1]	10.79	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
259	2026-03-11	6h	6h-14h	Chaîne 16	[1.14, 1.11, 1.13, 1.14, 1.14, 1.11, 1.12, 1.11, 1.14, 1.15, 1.14, 1.11, 1.15, 1.15, 1.13, 1.13, 1.15, 1.15, 1.11, 1.14, 1.11, 1.12, 1.12, 1.11]	11.13	5.12	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
260	2026-03-11	14h	14h-22h	Chaîne 16	[1.14, 1.11, 1.14, 1.14, 1.11, 1.12, 1.11, 1.14, 1.13, 1.15, 1.11, 1.13, 1.12, 1.12, 1.11, 1.11, 1.11, 1.13, 1.15, 1.12, 1.13, 1.12, 1.1, 1.11]	10.98	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
261	2026-03-11	22h	22h-6h	Chaîne 16	[1.11, 1.15, 1.15, 1.15, 1.15, 1.13, 1.14, 1.1, 1.11, 1.13, 1.12, 1.12, 1.12, 1.15, 1.13, 1.13, 1.11, 1.13, 1.15, 1.14, 1.11, 1.12, 1.13, 1.11]	10.82	5.02	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
262	2026-03-12	6h	6h-14h	Chaîne 8	[1.14, 1.11, 1.12, 1.14, 1.12, 1.15, 1.14, 1.11, 1.14, 1.13, 1.14, 1.1, 1.11, 1.11, 1.1, 1.11, 1.14, 1.12, 1.15, 1.15]	10.71	5.36	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
263	2026-03-12	14h	14h-22h	Chaîne 8	[1.11, 1.11, 1.13, 1.11, 1.14, 1.13, 1.13, 1.15, 1.13, 1.13, 1.12, 1.1, 1.14, 1.13, 1.14, 1.1, 1.13, 1.13, 1.12, 1.13]	10.64	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
264	2026-03-12	22h	22h-6h	Chaîne 8	[1.15, 1.13, 1.15, 1.12, 1.14, 1.14, 1.15, 1.13, 1.11, 1.1, 1.13, 1.12, 1.1, 1.1, 1.15, 1.12, 1.12, 1.11, 1.15, 1.14]	11	5.24	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
265	2026-03-12	6h	6h-14h	Chaîne 14	[1.14, 1.12, 1.13, 1.11, 1.13, 1.14, 1.13, 1.12, 1.14, 1.12, 1.13, 1.12, 1.14, 1.14, 1.13, 1.12]	10.83	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
266	2026-03-12	14h	14h-22h	Chaîne 14	[1.11, 1.12, 1.15, 1.12, 1.11, 1.11, 1.15, 1.14, 1.13, 1.11, 1.1, 1.1, 1.1, 1.11, 1.12, 1.1]	11	5.35	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
267	2026-03-12	22h	22h-6h	Chaîne 14	[1.12, 1.1, 1.14, 1.11, 1.13, 1.12, 1.13, 1.13, 1.11, 1.15, 1.14, 1.11, 1.11, 1.14, 1.13, 1.14]	11.07	5.16	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
268	2026-03-12	6h	6h-14h	Chaîne 15	[1.12, 1.13, 1.15, 1.12, 1.13, 1.13, 1.12, 1.12, 1.11, 1.1, 1.11, 1.1, 1.15, 1.14, 1.11, 1.13, 1.13, 1.12, 1.13, 1.14, 1.11, 1.12, 1.12, 1.12]	11.37	5.7	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
269	2026-03-12	14h	14h-22h	Chaîne 15	[1.14, 1.1, 1.1, 1.13, 1.14, 1.15, 1.14, 1.14, 1.13, 1.13, 1.11, 1.12, 1.12, 1.13, 1.13, 1.13, 1.14, 1.12, 1.14, 1.13, 1.12, 1.12, 1.1, 1.14]	11.24	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
270	2026-03-12	22h	22h-6h	Chaîne 15	[1.11, 1.11, 1.15, 1.12, 1.13, 1.14, 1.13, 1.11, 1.11, 1.14, 1.15, 1.14, 1.13, 1.14, 1.14, 1.14, 1.14, 1.13, 1.11, 1.14, 1.13, 1.11, 1.11, 1.13]	11.11	5.36	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
271	2026-03-13	6h	6h-14h	Chaîne 8	[1.12, 1.12, 1.1, 1.14, 1.11, 1.11, 1.13, 1.13, 1.13, 1.14, 1.15, 1.12, 1.12, 1.14, 1.11, 1.11, 1.13, 1.14, 1.15, 1.14]	10.64	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
272	2026-03-13	14h	14h-22h	Chaîne 8	[1.1, 1.13, 1.12, 1.11, 1.14, 1.12, 1.12, 1.14, 1.11, 1.14, 1.12, 1.13, 1.1, 1.12, 1.14, 1.12, 1.13, 1.11, 1.14, 1.12]	10.77	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
273	2026-03-13	22h	22h-6h	Chaîne 8	[1.1, 1.14, 1.15, 1.1, 1.12, 1.15, 1.11, 1.1, 1.14, 1.13, 1.13, 1.15, 1.1, 1.13, 1.14, 1.13, 1.13, 1.11, 1.12, 1.13]	10.74	5	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
274	2026-03-13	6h	6h-14h	Chaîne 14	[1.11, 1.13, 1.14, 1.13, 1.13, 1.14, 1.14, 1.12, 1.11, 1.12, 1.1, 1.12, 1.14, 1.14, 1.11, 1.15]	11.18	5.38	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
275	2026-03-13	14h	14h-22h	Chaîne 14	[1.14, 1.14, 1.15, 1.11, 1.1, 1.12, 1.13, 1.12, 1.1, 1.13, 1.11, 1.11, 1.14, 1.12, 1.15, 1.14]	11.13	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
276	2026-03-13	22h	22h-6h	Chaîne 14	[1.13, 1.14, 1.13, 1.11, 1.12, 1.13, 1.14, 1.12, 1.1, 1.14, 1.14, 1.1, 1.1, 1.14, 1.12, 1.12]	10.91	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
277	2026-03-13	6h	6h-14h	Chaîne 15	[1.12, 1.15, 1.14, 1.11, 1.11, 1.14, 1.11, 1.14, 1.14, 1.11, 1.11, 1.12, 1.14, 1.15, 1.12, 1.15, 1.13, 1.12, 1.11, 1.13, 1.1, 1.11, 1.12, 1.15]	11.17	5.47	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
278	2026-03-13	14h	14h-22h	Chaîne 15	[1.12, 1.11, 1.12, 1.14, 1.12, 1.13, 1.13, 1.15, 1.14, 1.12, 1.14, 1.13, 1.14, 1.13, 1.12, 1.12, 1.12, 1.14, 1.12, 1.14, 1.13, 1.12, 1.11, 1.12]	11.37	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
279	2026-03-13	22h	22h-6h	Chaîne 15	[1.13, 1.11, 1.13, 1.11, 1.13, 1.13, 1.1, 1.13, 1.11, 1.12, 1.14, 1.11, 1.15, 1.11, 1.1, 1.14, 1.11, 1.14, 1.14, 1.12, 1.14, 1.13, 1.12, 1.1]	11.23	5.63	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
280	2026-03-13	6h	6h-14h	Chaîne 16	[1.11, 1.11, 1.1, 1.12, 1.12, 1.11, 1.13, 1.12, 1.1, 1.1, 1.12, 1.12, 1.12, 1.12, 1.12, 1.14, 1.11, 1.11, 1.14, 1.13, 1.12, 1.14, 1.12, 1.11]	10.83	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
281	2026-03-13	14h	14h-22h	Chaîne 16	[1.11, 1.13, 1.14, 1.12, 1.12, 1.1, 1.13, 1.11, 1.15, 1.12, 1.15, 1.14, 1.13, 1.12, 1.15, 1.12, 1.1, 1.12, 1.14, 1.11, 1.15, 1.1, 1.15, 1.12]	10.9	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
282	2026-03-13	22h	22h-6h	Chaîne 16	[1.12, 1.12, 1.11, 1.11, 1.13, 1.11, 1.12, 1.13, 1.15, 1.12, 1.13, 1.12, 1.11, 1.14, 1.12, 1.11, 1.15, 1.12, 1.12, 1.13, 1.1, 1.13, 1.13, 1.1]	10.8	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
283	2026-03-14	6h	6h-14h	Chaîne 8	[1.1, 1.1, 1.14, 1.13, 1.13, 1.12, 1.14, 1.14, 1.12, 1.11, 1.14, 1.13, 1.1, 1.12, 1.15, 1.12, 1.11, 1.1, 1.11, 1.15]	10.82	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
284	2026-03-14	14h	14h-22h	Chaîne 8	[1.14, 1.11, 1.11, 1.14, 1.12, 1.14, 1.13, 1.12, 1.13, 1.13, 1.13, 1.13, 1.13, 1.1, 1.11, 1.1, 1.11, 1.13, 1.11, 1.13]	10.74	5.11	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
285	2026-03-14	22h	22h-6h	Chaîne 8	[1.13, 1.15, 1.1, 1.15, 1.12, 1.15, 1.11, 1.13, 1.12, 1.12, 1.14, 1.14, 1.11, 1.11, 1.12, 1.12, 1.1, 1.11, 1.1, 1.13]	10.83	5.18	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
286	2026-03-14	6h	6h-14h	Chaîne 14	[1.12, 1.14, 1.13, 1.13, 1.12, 1.11, 1.11, 1.11, 1.12, 1.1, 1.12, 1.14, 1.15, 1.14, 1.13, 1.14]	10.92	5.35	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
287	2026-03-14	14h	14h-22h	Chaîne 14	[1.12, 1.12, 1.13, 1.1, 1.13, 1.13, 1.11, 1.12, 1.1, 1.14, 1.11, 1.13, 1.13, 1.1, 1.12, 1.14]	10.81	5.14	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
288	2026-03-14	22h	22h-6h	Chaîne 14	[1.1, 1.14, 1.11, 1.13, 1.13, 1.11, 1.12, 1.14, 1.12, 1.11, 1.14, 1.1, 1.12, 1.12, 1.15, 1.14]	10.86	5.13	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
289	2026-03-14	6h	6h-14h	Chaîne 15	[1.1, 1.13, 1.14, 1.14, 1.12, 1.11, 1.11, 1.15, 1.14, 1.12, 1.13, 1.13, 1.15, 1.13, 1.12, 1.13, 1.15, 1.13, 1.12, 1.11, 1.12, 1.14, 1.1, 1.11]	10.98	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
290	2026-03-14	14h	14h-22h	Chaîne 15	[1.11, 1.15, 1.12, 1.1, 1.1, 1.11, 1.11, 1.11, 1.13, 1.14, 1.1, 1.1, 1.11, 1.11, 1.14, 1.14, 1.12, 1.13, 1.11, 1.1, 1.14, 1.15, 1.1, 1.13]	11.12	5.61	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
291	2026-03-14	22h	22h-6h	Chaîne 15	[1.15, 1.14, 1.14, 1.1, 1.11, 1.15, 1.14, 1.11, 1.12, 1.12, 1.13, 1.15, 1.11, 1.1, 1.13, 1.11, 1.13, 1.14, 1.12, 1.1, 1.14, 1.14, 1.14, 1.15]	11.27	5.69	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
292	2026-03-14	6h	6h-14h	Chaîne 16	[1.12, 1.12, 1.12, 1.12, 1.13, 1.14, 1.12, 1.11, 1.12, 1.15, 1.13, 1.1, 1.11, 1.11, 1.14, 1.12, 1.12, 1.14, 1.13, 1.15, 1.12, 1.13, 1.11, 1.1]	11.11	5.26	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
293	2026-03-14	14h	14h-22h	Chaîne 16	[1.12, 1.11, 1.11, 1.13, 1.12, 1.1, 1.14, 1.13, 1.13, 1.14, 1.15, 1.1, 1.1, 1.1, 1.11, 1.11, 1.12, 1.12, 1.14, 1.13, 1.11, 1.14, 1.15, 1.15]	10.96	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
294	2026-03-14	22h	22h-6h	Chaîne 16	[1.13, 1.12, 1.13, 1.14, 1.11, 1.12, 1.11, 1.14, 1.12, 1.13, 1.14, 1.14, 1.14, 1.12, 1.14, 1.12, 1.11, 1.14, 1.13, 1.11, 1.12, 1.13, 1.12, 1.13]	10.96	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
295	2026-03-15	6h	6h-14h	Chaîne 8	[1.13, 1.12, 1.1, 1.14, 1.15, 1.11, 1.15, 1.12, 1.13, 1.13, 1.13, 1.14, 1.15, 1.11, 1.12, 1.13, 1.11, 1.11, 1.13, 1.12]	10.88	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
296	2026-03-15	14h	14h-22h	Chaîne 8	[1.11, 1.11, 1.13, 1.1, 1.1, 1.13, 1.11, 1.14, 1.12, 1.11, 1.11, 1.13, 1.12, 1.1, 1.15, 1.14, 1.11, 1.11, 1.12, 1.14]	10.66	5.02	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
297	2026-03-15	22h	22h-6h	Chaîne 8	[1.12, 1.14, 1.13, 1.15, 1.14, 1.12, 1.13, 1.14, 1.11, 1.14, 1.12, 1.14, 1.14, 1.11, 1.13, 1.14, 1.11, 1.11, 1.14, 1.14]	10.59	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
298	2026-03-15	6h	6h-14h	Chaîne 14	[1.11, 1.15, 1.13, 1.14, 1.11, 1.12, 1.15, 1.13, 1.15, 1.1, 1.11, 1.14, 1.12, 1.12, 1.11, 1.13]	11.16	5.2	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
299	2026-03-15	14h	14h-22h	Chaîne 14	[1.15, 1.12, 1.14, 1.12, 1.1, 1.13, 1.11, 1.15, 1.11, 1.14, 1.14, 1.11, 1.1, 1.11, 1.11, 1.13]	10.95	5.09	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
300	2026-03-15	22h	22h-6h	Chaîne 14	[1.13, 1.14, 1.14, 1.13, 1.14, 1.14, 1.12, 1.12, 1.1, 1.1, 1.14, 1.14, 1.15, 1.12, 1.11, 1.1]	10.8	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
301	2026-03-15	6h	6h-14h	Chaîne 15	[1.11, 1.12, 1.11, 1.12, 1.13, 1.11, 1.11, 1.13, 1.15, 1.11, 1.11, 1.12, 1.11, 1.12, 1.12, 1.12, 1.12, 1.1, 1.14, 1.13, 1.12, 1.1, 1.11, 1.12]	11.33	5.65	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
302	2026-03-15	14h	14h-22h	Chaîne 15	[1.13, 1.13, 1.15, 1.13, 1.12, 1.13, 1.14, 1.12, 1.14, 1.12, 1.12, 1.13, 1.13, 1.12, 1.13, 1.11, 1.13, 1.15, 1.11, 1.13, 1.14, 1.12, 1.14, 1.14]	11.41	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
303	2026-03-15	22h	22h-6h	Chaîne 15	[1.14, 1.12, 1.11, 1.13, 1.14, 1.13, 1.15, 1.13, 1.11, 1.1, 1.14, 1.12, 1.11, 1.13, 1.15, 1.13, 1.11, 1.13, 1.14, 1.13, 1.12, 1.12, 1.12, 1.1]	11.39	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
304	2026-03-15	6h	6h-14h	Chaîne 16	[1.11, 1.1, 1.14, 1.12, 1.14, 1.11, 1.11, 1.11, 1.11, 1.12, 1.13, 1.11, 1.14, 1.1, 1.15, 1.12, 1.11, 1.12, 1.13, 1.14, 1.14, 1.14, 1.14, 1.1]	11.04	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
305	2026-03-15	14h	14h-22h	Chaîne 16	[1.12, 1.13, 1.1, 1.11, 1.12, 1.11, 1.11, 1.1, 1.13, 1.14, 1.12, 1.15, 1.15, 1.15, 1.12, 1.12, 1.13, 1.13, 1.12, 1.1, 1.15, 1.12, 1.13, 1.11]	10.89	5.18	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
306	2026-03-15	22h	22h-6h	Chaîne 16	[1.14, 1.11, 1.1, 1.14, 1.13, 1.13, 1.13, 1.13, 1.11, 1.12, 1.13, 1.11, 1.13, 1.15, 1.14, 1.1, 1.14, 1.13, 1.15, 1.12, 1.13, 1.15, 1.13, 1.11]	11.09	5.26	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
307	2026-03-16	6h	6h-14h	Chaîne 14	[1.12, 1.15, 1.14, 1.1, 1.1, 1.13, 1.13, 1.13, 1.14, 1.11, 1.12, 1.14, 1.11, 1.11, 1.15, 1.12]	11.11	5.48	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
308	2026-03-16	14h	14h-22h	Chaîne 14	[1.14, 1.11, 1.11, 1.12, 1.11, 1.12, 1.13, 1.12, 1.13, 1.11, 1.1, 1.14, 1.1, 1.13, 1.15, 1.1]	10.96	5.35	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
309	2026-03-16	22h	22h-6h	Chaîne 14	[1.14, 1.15, 1.14, 1.15, 1.13, 1.12, 1.1, 1.12, 1.12, 1.11, 1.12, 1.13, 1.14, 1.14, 1.11, 1.13]	10.93	5.27	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
310	2026-03-16	6h	6h-14h	Chaîne 15	[1.15, 1.15, 1.14, 1.1, 1.12, 1.1, 1.14, 1.12, 1.12, 1.13, 1.12, 1.13, 1.1, 1.12, 1.15, 1.15, 1.15, 1.14, 1.15, 1.14, 1.11, 1.11, 1.11, 1.13]	11.19	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
311	2026-03-16	14h	14h-22h	Chaîne 15	[1.12, 1.11, 1.13, 1.11, 1.11, 1.14, 1.13, 1.1, 1.12, 1.14, 1.11, 1.15, 1.15, 1.14, 1.11, 1.11, 1.12, 1.14, 1.11, 1.11, 1.13, 1.14, 1.1, 1.13]	11.22	5.66	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
312	2026-03-16	22h	22h-6h	Chaîne 15	[1.13, 1.14, 1.14, 1.11, 1.11, 1.1, 1.1, 1.14, 1.15, 1.14, 1.11, 1.12, 1.14, 1.15, 1.13, 1.1, 1.1, 1.13, 1.14, 1.15, 1.12, 1.12, 1.13, 1.14]	11.31	5.45	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
313	2026-03-16	6h	6h-14h	Chaîne 16	[1.12, 1.13, 1.11, 1.13, 1.14, 1.14, 1.13, 1.12, 1.15, 1.11, 1.15, 1.14, 1.12, 1.14, 1.12, 1.14, 1.12, 1.15, 1.12, 1.14, 1.11, 1.14, 1.14, 1.14]	11.19	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
314	2026-03-16	14h	14h-22h	Chaîne 16	[1.12, 1.13, 1.15, 1.14, 1.12, 1.13, 1.11, 1.13, 1.11, 1.14, 1.12, 1.11, 1.14, 1.13, 1.14, 1.14, 1.14, 1.12, 1.11, 1.11, 1.13, 1.11, 1.11, 1.11]	11.15	5.4	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
315	2026-03-16	22h	22h-6h	Chaîne 16	[1.14, 1.15, 1.1, 1.15, 1.11, 1.1, 1.15, 1.13, 1.13, 1.15, 1.13, 1.12, 1.1, 1.11, 1.12, 1.13, 1.15, 1.13, 1.12, 1.13, 1.14, 1.13, 1.14, 1.14]	10.84	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
316	2026-03-17	6h	6h-14h	Chaîne 8	[1.13, 1.13, 1.11, 1.14, 1.14, 1.11, 1.12, 1.13, 1.12, 1.13, 1.1, 1.1, 1.15, 1.14, 1.11, 1.14, 1.1, 1.13, 1.13, 1.14]	10.87	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
317	2026-03-17	14h	14h-22h	Chaîne 8	[1.13, 1.11, 1.13, 1.14, 1.11, 1.11, 1.11, 1.11, 1.13, 1.14, 1.1, 1.15, 1.13, 1.12, 1.13, 1.12, 1.15, 1.1, 1.12, 1.15]	11	5.37	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
318	2026-03-17	22h	22h-6h	Chaîne 8	[1.11, 1.1, 1.14, 1.11, 1.11, 1.11, 1.14, 1.15, 1.13, 1.11, 1.12, 1.11, 1.13, 1.1, 1.11, 1.12, 1.15, 1.12, 1.1, 1.11]	11.01	5.14	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
319	2026-03-17	6h	6h-14h	Chaîne 15	[1.11, 1.11, 1.13, 1.1, 1.13, 1.12, 1.12, 1.11, 1.14, 1.11, 1.1, 1.12, 1.15, 1.12, 1.11, 1.15, 1.11, 1.14, 1.12, 1.14, 1.12, 1.13, 1.14, 1.14]	10.99	5.55	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
320	2026-03-17	14h	14h-22h	Chaîne 15	[1.13, 1.14, 1.12, 1.11, 1.1, 1.13, 1.11, 1.11, 1.12, 1.14, 1.1, 1.14, 1.15, 1.14, 1.11, 1.13, 1.14, 1.11, 1.15, 1.14, 1.13, 1.11, 1.12, 1.15]	11.31	5.71	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
321	2026-03-17	22h	22h-6h	Chaîne 15	[1.15, 1.11, 1.1, 1.14, 1.13, 1.12, 1.14, 1.15, 1.12, 1.13, 1.14, 1.12, 1.13, 1.15, 1.14, 1.13, 1.12, 1.13, 1.15, 1.14, 1.14, 1.14, 1.14, 1.11]	11.02	5.31	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
322	2026-03-17	6h	6h-14h	Chaîne 16	[1.07, 1.16, 1.13, 1.15, 1.12, 1.12, 1.12, 1.11, 1.15, 1.11, 1.13, 1.07, 1.11, 1.11, 1.11, 1.05, 1.14, 1.13, 1.11, 1.18, 1.15, 1.13, 1.14, 1.1]	12.43	6.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
323	2026-03-17	14h	14h-22h	Chaîne 16	[1.18, 1.12, 1.12, 1.08, 1.05, 1.11, 1.1, 1.12, 1.14, 1.15, 1.11, 1.05, 1.12, 1.13, 1.11, 1.12, 1.17, 1.14, 1.14, 1.12, 1.14, 1.14, 1.13, 1.15]	11.86	6.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
324	2026-03-17	22h	22h-6h	Chaîne 16	[1.22, 1.17, 1.11, 1.11, 1.1, 1.2, 1.15, 1.12, 1.13, 1.1, 1.1, 1.12, 1.12, 1.13, 1.11, 1.12, 1.12, 1.13, 1.13, 1.12, 1.11, 1.06, 1.12, 1.12]	12.26	6.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
325	2026-03-18	6h	6h-14h	Chaîne 8	[1.13, 1.1, 1.11, 1.13, 1.13, 1.1, 1.15, 1.14, 1.14, 1.11, 1.12, 1.1, 1.15, 1.13, 1.12, 1.12, 1.14, 1.13, 1.11, 1.11]	10.85	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
326	2026-03-18	14h	14h-22h	Chaîne 8	[1.12, 1.12, 1.13, 1.15, 1.14, 1.11, 1.11, 1.15, 1.11, 1.15, 1.1, 1.15, 1.11, 1.14, 1.12, 1.13, 1.13, 1.1, 1.12, 1.13]	10.74	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
327	2026-03-18	22h	22h-6h	Chaîne 8	[1.13, 1.14, 1.11, 1.14, 1.11, 1.11, 1.11, 1.11, 1.13, 1.11, 1.13, 1.15, 1.11, 1.11, 1.14, 1.1, 1.15, 1.15, 1.11, 1.11]	10.59	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
328	2026-03-18	6h	6h-14h	Chaîne 14	[1.15, 1.13, 1.1, 1.12, 1.14, 1.11, 1.11, 1.1, 1.13, 1.14, 1.15, 1.13, 1.14, 1.13, 1.15, 1.11]	10.84	5.47	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
329	2026-03-18	14h	14h-22h	Chaîne 14	[1.14, 1.12, 1.11, 1.12, 1.12, 1.12, 1.14, 1.11, 1.13, 1.15, 1.11, 1.11, 1.12, 1.14, 1.14, 1.13]	11.16	5.26	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
330	2026-03-18	22h	22h-6h	Chaîne 14	[1.1, 1.12, 1.11, 1.1, 1.14, 1.15, 1.11, 1.14, 1.11, 1.15, 1.13, 1.14, 1.1, 1.14, 1.13, 1.14]	10.84	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
331	2026-03-18	6h	6h-14h	Chaîne 16	[1.11, 1.11, 1.12, 1.12, 1.11, 1.15, 1.13, 1.13, 1.14, 1.15, 1.12, 1.15, 1.11, 1.15, 1.11, 1.1, 1.12, 1.12, 1.15, 1.1, 1.1, 1.11, 1.12, 1.12]	11.17	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
332	2026-03-18	14h	14h-22h	Chaîne 16	[1.11, 1.15, 1.14, 1.14, 1.14, 1.15, 1.14, 1.11, 1.11, 1.12, 1.14, 1.15, 1.14, 1.11, 1.12, 1.14, 1.11, 1.12, 1.11, 1.14, 1.12, 1.12, 1.12, 1.15]	10.9	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
333	2026-03-18	22h	22h-6h	Chaîne 16	[1.11, 1.1, 1.14, 1.13, 1.14, 1.14, 1.11, 1.1, 1.12, 1.11, 1.14, 1.12, 1.12, 1.11, 1.11, 1.15, 1.12, 1.14, 1.14, 1.11, 1.12, 1.14, 1.13, 1.15]	11.02	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
334	2026-03-19	6h	6h-14h	Chaîne 8	[1.1, 1.11, 1.13, 1.12, 1.13, 1.11, 1.11, 1.11, 1.11, 1.1, 1.14, 1.12, 1.14, 1.12, 1.11, 1.13, 1.15, 1.12, 1.14, 1.12]	10.9	5.28	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
335	2026-03-19	14h	14h-22h	Chaîne 8	[1.15, 1.12, 1.14, 1.11, 1.13, 1.12, 1.11, 1.15, 1.11, 1.1, 1.12, 1.15, 1.14, 1.12, 1.1, 1.12, 1.14, 1.15, 1.13, 1.1]	10.65	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
336	2026-03-19	22h	22h-6h	Chaîne 8	[1.12, 1.14, 1.12, 1.11, 1.11, 1.11, 1.11, 1.1, 1.15, 1.11, 1.11, 1.15, 1.11, 1.1, 1.13, 1.1, 1.15, 1.12, 1.1, 1.1]	10.77	5.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
337	2026-03-19	6h	6h-14h	Chaîne 14	[1.12, 1.14, 1.13, 1.13, 1.14, 1.1, 1.14, 1.12, 1.14, 1.1, 1.11, 1.13, 1.1, 1.13, 1.15, 1.11]	10.94	5.14	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
338	2026-03-19	14h	14h-22h	Chaîne 14	[1.12, 1.11, 1.11, 1.13, 1.15, 1.1, 1.14, 1.13, 1.11, 1.15, 1.13, 1.15, 1.13, 1.15, 1.1, 1.1]	11.05	5.31	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
339	2026-03-19	22h	22h-6h	Chaîne 14	[1.13, 1.12, 1.1, 1.14, 1.12, 1.15, 1.15, 1.14, 1.12, 1.15, 1.15, 1.15, 1.12, 1.12, 1.11, 1.12]	10.85	5.21	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
340	2026-03-19	6h	6h-14h	Chaîne 15	[1.15, 1.1, 1.15, 1.1, 1.14, 1.13, 1.13, 1.11, 1.11, 1.12, 1.13, 1.14, 1.11, 1.14, 1.13, 1.12, 1.12, 1.13, 1.14, 1.11, 1.11, 1.11, 1.15, 1.12]	11.16	5.48	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
341	2026-03-19	14h	14h-22h	Chaîne 15	[1.15, 1.11, 1.11, 1.13, 1.15, 1.14, 1.1, 1.14, 1.14, 1.15, 1.11, 1.11, 1.1, 1.14, 1.12, 1.11, 1.11, 1.11, 1.11, 1.1, 1.14, 1.12, 1.12, 1.11]	11.03	5.48	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
342	2026-03-19	22h	22h-6h	Chaîne 15	[1.13, 1.14, 1.15, 1.12, 1.15, 1.13, 1.14, 1.13, 1.14, 1.11, 1.14, 1.13, 1.11, 1.13, 1.14, 1.14, 1.14, 1.14, 1.1, 1.14, 1.15, 1.12, 1.12, 1.14]	11.06	5.69	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
343	2026-03-20	6h	6h-14h	Chaîne 8	[1.15, 1.12, 1.12, 1.12, 1.12, 1.14, 1.11, 1.12, 1.15, 1.12, 1.12, 1.14, 1.12, 1.15, 1.12, 1.15, 1.12, 1.12, 1.13, 1.11]	10.67	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
344	2026-03-20	14h	14h-22h	Chaîne 8	[1.14, 1.1, 1.1, 1.15, 1.11, 1.14, 1.13, 1.13, 1.13, 1.13, 1.14, 1.13, 1.14, 1.11, 1.14, 1.13, 1.11, 1.14, 1.15, 1.12]	10.98	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
345	2026-03-20	22h	22h-6h	Chaîne 8	[1.13, 1.12, 1.15, 1.15, 1.13, 1.1, 1.15, 1.1, 1.1, 1.14, 1.14, 1.13, 1.14, 1.12, 1.11, 1.13, 1.12, 1.13, 1.12, 1.13]	10.92	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
346	2026-03-20	6h	6h-14h	Chaîne 14	[1.11, 1.14, 1.11, 1.11, 1.13, 1.12, 1.14, 1.15, 1.14, 1.11, 1.12, 1.1, 1.1, 1.1, 1.14, 1.11]	10.96	5.22	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
347	2026-03-20	14h	14h-22h	Chaîne 14	[1.13, 1.11, 1.11, 1.14, 1.14, 1.14, 1.12, 1.11, 1.1, 1.1, 1.11, 1.1, 1.15, 1.14, 1.11, 1.15]	11.06	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
348	2026-03-20	22h	22h-6h	Chaîne 14	[1.12, 1.12, 1.13, 1.11, 1.12, 1.14, 1.13, 1.12, 1.11, 1.11, 1.15, 1.13, 1.13, 1.14, 1.11, 1.12]	10.87	5.13	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
349	2026-03-20	6h	6h-14h	Chaîne 15	[1.14, 1.11, 1.12, 1.14, 1.1, 1.11, 1.1, 1.13, 1.11, 1.11, 1.11, 1.1, 1.14, 1.13, 1.12, 1.14, 1.12, 1.15, 1.15, 1.11, 1.11, 1.14, 1.14, 1.15]	11.25	5.52	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
350	2026-03-20	14h	14h-22h	Chaîne 15	[1.12, 1.11, 1.12, 1.11, 1.12, 1.14, 1.14, 1.12, 1.14, 1.15, 1.11, 1.12, 1.13, 1.14, 1.15, 1.13, 1.12, 1.11, 1.14, 1.12, 1.11, 1.11, 1.11, 1.12]	11.18	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
351	2026-03-20	22h	22h-6h	Chaîne 15	[1.11, 1.11, 1.11, 1.13, 1.14, 1.15, 1.14, 1.13, 1.13, 1.13, 1.13, 1.12, 1.14, 1.11, 1.1, 1.12, 1.1, 1.11, 1.11, 1.12, 1.13, 1.13, 1.11, 1.1]	11.12	5.38	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
352	2026-03-20	6h	6h-14h	Chaîne 16	[1.12, 1.1, 1.12, 1.14, 1.12, 1.12, 1.12, 1.12, 1.1, 1.14, 1.12, 1.1, 1.11, 1.15, 1.12, 1.13, 1.15, 1.14, 1.15, 1.11, 1.11, 1.14, 1.11, 1.15]	10.8	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
353	2026-03-20	14h	14h-22h	Chaîne 16	[1.1, 1.14, 1.1, 1.1, 1.12, 1.11, 1.13, 1.14, 1.12, 1.13, 1.15, 1.13, 1.11, 1.12, 1.11, 1.13, 1.14, 1.14, 1.13, 1.13, 1.13, 1.11, 1.12, 1.12]	11.02	4.99	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
354	2026-03-20	22h	22h-6h	Chaîne 16	[1.14, 1.13, 1.1, 1.12, 1.11, 1.13, 1.12, 1.12, 1.12, 1.12, 1.14, 1.14, 1.13, 1.12, 1.15, 1.14, 1.13, 1.14, 1.11, 1.11, 1.15, 1.12, 1.12, 1.13]	11.15	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
355	2026-03-21	6h	6h-14h	Chaîne 8	[1.11, 1.1, 1.12, 1.11, 1.12, 1.13, 1.12, 1.11, 1.13, 1.12, 1.11, 1.12, 1.12, 1.12, 1.12, 1.12, 1.1, 1.12, 1.15, 1.11]	10.63	5.18	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
356	2026-03-21	14h	14h-22h	Chaîne 8	[1.14, 1.13, 1.11, 1.13, 1.11, 1.14, 1.13, 1.12, 1.12, 1.11, 1.14, 1.13, 1.12, 1.11, 1.11, 1.13, 1.14, 1.11, 1.1, 1.11]	10.69	5.04	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
357	2026-03-21	22h	22h-6h	Chaîne 8	[1.15, 1.13, 1.12, 1.1, 1.15, 1.14, 1.11, 1.14, 1.1, 1.12, 1.12, 1.1, 1.14, 1.12, 1.1, 1.1, 1.13, 1.11, 1.11, 1.13]	10.66	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
358	2026-03-21	6h	6h-14h	Chaîne 14	[1.12, 1.14, 1.12, 1.12, 1.13, 1.13, 1.14, 1.14, 1.12, 1.11, 1.13, 1.13, 1.11, 1.12, 1.11, 1.15]	11.02	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
359	2026-03-21	14h	14h-22h	Chaîne 14	[1.11, 1.13, 1.13, 1.15, 1.15, 1.14, 1.11, 1.15, 1.12, 1.12, 1.13, 1.15, 1.11, 1.11, 1.13, 1.14]	11.19	5.25	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
360	2026-03-21	22h	22h-6h	Chaîne 14	[1.13, 1.13, 1.11, 1.13, 1.11, 1.12, 1.1, 1.11, 1.12, 1.11, 1.14, 1.11, 1.12, 1.1, 1.12, 1.14]	10.78	5.48	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
361	2026-03-21	6h	6h-14h	Chaîne 15	[1.14, 1.12, 1.15, 1.11, 1.1, 1.15, 1.11, 1.13, 1.12, 1.12, 1.15, 1.14, 1.15, 1.13, 1.11, 1.12, 1.14, 1.14, 1.11, 1.14, 1.11, 1.12, 1.11, 1.12]	11.4	5.59	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
362	2026-03-21	14h	14h-22h	Chaîne 15	[1.13, 1.12, 1.12, 1.12, 1.15, 1.12, 1.15, 1.1, 1.14, 1.1, 1.11, 1.15, 1.14, 1.13, 1.12, 1.13, 1.14, 1.14, 1.1, 1.14, 1.11, 1.13, 1.12, 1.14]	11.21	5.59	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
363	2026-03-21	22h	22h-6h	Chaîne 15	[1.14, 1.11, 1.13, 1.13, 1.14, 1.14, 1.13, 1.13, 1.15, 1.11, 1.14, 1.13, 1.11, 1.13, 1.14, 1.15, 1.14, 1.13, 1.11, 1.1, 1.11, 1.14, 1.13, 1.11]	11.34	5.53	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
364	2026-03-21	6h	6h-14h	Chaîne 16	[1.11, 1.13, 1.12, 1.13, 1.11, 1.11, 1.1, 1.11, 1.14, 1.11, 1.13, 1.13, 1.11, 1.12, 1.11, 1.11, 1.13, 1.12, 1.11, 1.12, 1.14, 1.12, 1.14, 1.11]	10.86	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
365	2026-03-21	14h	14h-22h	Chaîne 16	[1.11, 1.14, 1.12, 1.1, 1.11, 1.13, 1.14, 1.11, 1.15, 1.13, 1.13, 1.11, 1.11, 1.13, 1.13, 1.12, 1.14, 1.11, 1.14, 1.13, 1.15, 1.1, 1.14, 1.12]	10.98	5.37	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
366	2026-03-21	22h	22h-6h	Chaîne 16	[1.13, 1.14, 1.1, 1.1, 1.14, 1.11, 1.13, 1.12, 1.13, 1.12, 1.11, 1.14, 1.15, 1.14, 1.11, 1.14, 1.14, 1.12, 1.15, 1.15, 1.1, 1.11, 1.1, 1.14]	11.09	5.24	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
367	2026-03-22	6h	6h-14h	Chaîne 8	[1.11, 1.12, 1.13, 1.11, 1.14, 1.12, 1.13, 1.14, 1.1, 1.1, 1.15, 1.1, 1.1, 1.11, 1.1, 1.14, 1.13, 1.14, 1.12, 1.13]	10.64	5.26	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
368	2026-03-22	14h	14h-22h	Chaîne 8	[1.14, 1.12, 1.13, 1.14, 1.13, 1.11, 1.13, 1.11, 1.12, 1.1, 1.13, 1.1, 1.14, 1.11, 1.14, 1.12, 1.12, 1.14, 1.11, 1.11]	10.74	5.37	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
369	2026-03-22	22h	22h-6h	Chaîne 8	[1.15, 1.13, 1.1, 1.12, 1.11, 1.14, 1.1, 1.11, 1.14, 1.12, 1.14, 1.15, 1.1, 1.12, 1.14, 1.13, 1.13, 1.14, 1.14, 1.12]	10.97	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
370	2026-03-22	6h	6h-14h	Chaîne 14	[1.11, 1.12, 1.12, 1.14, 1.14, 1.11, 1.15, 1.1, 1.14, 1.11, 1.13, 1.12, 1.13, 1.1, 1.12, 1.12]	11.1	5.13	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
371	2026-03-22	14h	14h-22h	Chaîne 14	[1.15, 1.11, 1.1, 1.1, 1.12, 1.14, 1.14, 1.13, 1.1, 1.14, 1.14, 1.11, 1.1, 1.1, 1.12, 1.11]	11.18	5.24	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
372	2026-03-22	22h	22h-6h	Chaîne 14	[1.11, 1.14, 1.14, 1.14, 1.14, 1.12, 1.12, 1.12, 1.13, 1.14, 1.11, 1.14, 1.12, 1.13, 1.11, 1.12]	11.07	5.12	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
373	2026-03-22	6h	6h-14h	Chaîne 15	[1.14, 1.14, 1.1, 1.11, 1.12, 1.14, 1.15, 1.1, 1.14, 1.11, 1.13, 1.12, 1.15, 1.1, 1.14, 1.12, 1.1, 1.12, 1.12, 1.11, 1.12, 1.13, 1.13, 1.13]	11.11	5.52	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
374	2026-03-22	14h	14h-22h	Chaîne 15	[1.1, 1.14, 1.13, 1.14, 1.14, 1.15, 1.14, 1.14, 1.13, 1.15, 1.15, 1.11, 1.15, 1.13, 1.12, 1.14, 1.14, 1.11, 1.15, 1.12, 1.15, 1.11, 1.15, 1.11]	11.09	5.61	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
375	2026-03-22	22h	22h-6h	Chaîne 15	[1.13, 1.14, 1.1, 1.12, 1.13, 1.14, 1.14, 1.12, 1.1, 1.1, 1.1, 1.12, 1.13, 1.13, 1.12, 1.13, 1.1, 1.14, 1.13, 1.15, 1.12, 1.11, 1.14, 1.11]	11.1	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
376	2026-03-22	6h	6h-14h	Chaîne 16	[1.12, 1.13, 1.11, 1.15, 1.15, 1.15, 1.1, 1.14, 1.14, 1.13, 1.1, 1.11, 1.11, 1.13, 1.11, 1.1, 1.11, 1.13, 1.14, 1.13, 1.1, 1.12, 1.11, 1.1]	10.86	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
377	2026-03-22	14h	14h-22h	Chaîne 16	[1.11, 1.13, 1.11, 1.11, 1.12, 1.14, 1.14, 1.14, 1.14, 1.15, 1.12, 1.13, 1.13, 1.11, 1.14, 1.13, 1.15, 1.15, 1.15, 1.13, 1.15, 1.13, 1.14, 1.13]	10.79	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
378	2026-03-22	22h	22h-6h	Chaîne 16	[1.12, 1.14, 1.15, 1.11, 1.12, 1.15, 1.13, 1.12, 1.15, 1.12, 1.1, 1.13, 1.1, 1.12, 1.12, 1.11, 1.14, 1.11, 1.14, 1.15, 1.15, 1.11, 1.15, 1.13]	10.87	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
379	2026-03-23	6h	6h-14h	Chaîne 14	[1.14, 1.14, 1.1, 1.11, 1.1, 1.13, 1.13, 1.12, 1.12, 1.11, 1.13, 1.11, 1.11, 1.12, 1.14, 1.12]	11.09	5.29	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
380	2026-03-23	14h	14h-22h	Chaîne 14	[1.14, 1.14, 1.14, 1.14, 1.13, 1.14, 1.13, 1.11, 1.1, 1.13, 1.13, 1.12, 1.12, 1.11, 1.14, 1.11]	11.06	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
381	2026-03-23	22h	22h-6h	Chaîne 14	[1.14, 1.15, 1.1, 1.15, 1.14, 1.14, 1.12, 1.11, 1.14, 1.12, 1.12, 1.11, 1.11, 1.12, 1.11, 1.11]	11.19	5.21	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
382	2026-03-23	6h	6h-14h	Chaîne 15	[1.11, 1.12, 1.14, 1.12, 1.11, 1.08, 1.12, 1.12, 1.11, 1.12, 1.07, 1.14, 1.15, 1.11, 1.14, 1.12, 1.1, 1.11, 1.11, 1.13, 1.15, 1.14, 1.14, 1.11]	11.54	5.67	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
383	2026-03-23	14h	14h-22h	Chaîne 15	[1.11, 1.11, 1.14, 1.14, 1.11, 1.11, 1.14, 1.15, 1.14, 1.2, 1.1, 1.1, 1.13, 1.11, 1.11, 1.21, 1.11, 1.12, 1.13, 1.13, 1.12, 1.07, 1.11, 1.12]	11.8	5.69	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
384	2026-03-23	22h	22h-6h	Chaîne 15	[1.07, 1.1, 1.11, 1.11, 1.16, 1.12, 1.13, 1.12, 1.13, 1.12, 1.14, 1.12, 1.11, 1.1, 1.12, 1.11, 1.13, 1.08, 1.12, 1.2, 1.14, 1.13, 1.14, 1.11]	12.07	5.66	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
385	2026-03-23	6h	6h-14h	Chaîne 16	[1.1, 1.14, 1.14, 1.13, 1.13, 1.14, 1.1, 1.11, 1.1, 1.13, 1.13, 1.1, 1.14, 1.14, 1.12, 1.12, 1.14, 1.14, 1.14, 1.1, 1.13, 1.14, 1.14, 1.1]	10.96	5.22	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
386	2026-03-23	14h	14h-22h	Chaîne 16	[1.14, 1.12, 1.12, 1.1, 1.15, 1.13, 1.12, 1.12, 1.11, 1.12, 1.11, 1.11, 1.14, 1.13, 1.12, 1.15, 1.14, 1.15, 1.14, 1.14, 1.12, 1.13, 1.1, 1.14]	11.16	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
387	2026-03-23	22h	22h-6h	Chaîne 16	[1.13, 1.1, 1.12, 1.14, 1.13, 1.14, 1.14, 1.1, 1.12, 1.12, 1.14, 1.14, 1.1, 1.13, 1.13, 1.14, 1.11, 1.11, 1.13, 1.12, 1.12, 1.15, 1.11, 1.12]	11.03	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
388	2026-03-24	6h	6h-14h	Chaîne 8	[1.11, 1.11, 1.14, 1.11, 1.14, 1.12, 1.13, 1.13, 1.11, 1.14, 1.12, 1.1, 1.11, 1.15, 1.14, 1.14, 1.11, 1.12, 1.14, 1.13]	10.64	5	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
389	2026-03-24	14h	14h-22h	Chaîne 8	[1.14, 1.15, 1.15, 1.11, 1.14, 1.12, 1.12, 1.11, 1.12, 1.15, 1.1, 1.14, 1.11, 1.1, 1.12, 1.1, 1.13, 1.13, 1.1, 1.13]	10.79	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
390	2026-03-24	22h	22h-6h	Chaîne 8	[1.15, 1.13, 1.13, 1.11, 1.13, 1.11, 1.11, 1.11, 1.13, 1.11, 1.13, 1.13, 1.12, 1.13, 1.14, 1.13, 1.15, 1.14, 1.13, 1.15]	10.9	5.14	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
391	2026-03-24	6h	6h-14h	Chaîne 15	[1.14, 1.14, 1.12, 1.14, 1.12, 1.1, 1.13, 1.11, 1.11, 1.13, 1.11, 1.11, 1.12, 1.12, 1.13, 1.11, 1.11, 1.14, 1.13, 1.11, 1.14, 1.14, 1.14, 1.12]	11.32	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
392	2026-03-24	14h	14h-22h	Chaîne 15	[1.11, 1.13, 1.12, 1.15, 1.15, 1.13, 1.1, 1.11, 1.13, 1.13, 1.12, 1.15, 1.14, 1.11, 1.1, 1.13, 1.1, 1.14, 1.12, 1.13, 1.12, 1.11, 1.14, 1.13]	11.42	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
393	2026-03-24	22h	22h-6h	Chaîne 15	[1.11, 1.12, 1.14, 1.12, 1.14, 1.11, 1.14, 1.13, 1.14, 1.12, 1.13, 1.14, 1.14, 1.11, 1.15, 1.14, 1.12, 1.1, 1.13, 1.12, 1.13, 1.1, 1.11, 1.14]	11.36	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
394	2026-03-24	6h	6h-14h	Chaîne 16	[1.12, 1.13, 1.11, 1.12, 1.14, 1.1, 1.15, 1.1, 1.15, 1.11, 1.1, 1.12, 1.13, 1.1, 1.11, 1.1, 1.13, 1.12, 1.14, 1.15, 1.12, 1.13, 1.15, 1.14]	11.06	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
395	2026-03-24	14h	14h-22h	Chaîne 16	[1.11, 1.15, 1.11, 1.12, 1.1, 1.12, 1.12, 1.14, 1.13, 1.14, 1.13, 1.11, 1.15, 1.13, 1.11, 1.13, 1.15, 1.12, 1.13, 1.13, 1.11, 1.12, 1.15, 1.13]	10.96	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
396	2026-03-24	22h	22h-6h	Chaîne 16	[1.12, 1.12, 1.13, 1.13, 1.15, 1.12, 1.11, 1.12, 1.15, 1.11, 1.12, 1.12, 1.15, 1.11, 1.12, 1.11, 1.13, 1.14, 1.12, 1.13, 1.13, 1.13, 1.14, 1.12]	11.01	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
397	2026-03-25	6h	6h-14h	Chaîne 8	[1.11, 1.12, 1.11, 1.13, 1.13, 1.11, 1.11, 1.12, 1.13, 1.13, 1.13, 1.15, 1.13, 1.11, 1.13, 1.14, 1.1, 1.1, 1.14, 1.11]	10.69	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
398	2026-03-25	14h	14h-22h	Chaîne 8	[1.14, 1.11, 1.13, 1.14, 1.1, 1.11, 1.1, 1.13, 1.12, 1.11, 1.12, 1.12, 1.12, 1.11, 1.15, 1.12, 1.12, 1.15, 1.12, 1.12]	10.66	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
399	2026-03-25	22h	22h-6h	Chaîne 8	[1.11, 1.11, 1.12, 1.13, 1.1, 1.13, 1.12, 1.1, 1.11, 1.12, 1.1, 1.12, 1.1, 1.12, 1.11, 1.11, 1.12, 1.13, 1.12, 1.11]	11	5	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
400	2026-03-25	6h	6h-14h	Chaîne 14	[1.14, 1.11, 1.11, 1.13, 1.13, 1.1, 1.13, 1.13, 1.12, 1.1, 1.12, 1.14, 1.11, 1.14, 1.15, 1.13]	11.1	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
401	2026-03-25	14h	14h-22h	Chaîne 14	[1.1, 1.15, 1.14, 1.11, 1.13, 1.13, 1.14, 1.12, 1.12, 1.1, 1.14, 1.12, 1.1, 1.13, 1.12, 1.12]	11.11	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
402	2026-03-25	22h	22h-6h	Chaîne 14	[1.14, 1.13, 1.12, 1.11, 1.13, 1.11, 1.11, 1.12, 1.14, 1.12, 1.12, 1.13, 1.15, 1.15, 1.15, 1.14]	10.91	5.1	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
403	2026-03-25	6h	6h-14h	Chaîne 16	[1.15, 1.15, 1.14, 1.13, 1.15, 1.13, 1.13, 1.14, 1.13, 1.1, 1.13, 1.11, 1.15, 1.11, 1.13, 1.11, 1.13, 1.1, 1.12, 1.11, 1.11, 1.1, 1.11, 1.14]	11.1	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
404	2026-03-25	14h	14h-22h	Chaîne 16	[1.14, 1.13, 1.12, 1.12, 1.13, 1.13, 1.12, 1.13, 1.12, 1.12, 1.14, 1.11, 1.14, 1.12, 1.13, 1.11, 1.12, 1.12, 1.13, 1.13, 1.1, 1.12, 1.15, 1.1]	11.09	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
405	2026-03-25	22h	22h-6h	Chaîne 16	[1.12, 1.14, 1.14, 1.11, 1.14, 1.15, 1.12, 1.13, 1.12, 1.15, 1.11, 1.12, 1.11, 1.11, 1.11, 1.14, 1.14, 1.15, 1.15, 1.13, 1.12, 1.11, 1.15, 1.11]	11.04	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
406	2026-03-26	6h	6h-14h	Chaîne 8	[1.14, 1.11, 1.15, 1.11, 1.14, 1.12, 1.1, 1.14, 1.14, 1.13, 1.13, 1.1, 1.13, 1.12, 1.12, 1.11, 1.1, 1.11, 1.13, 1.13]	10.81	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
407	2026-03-26	14h	14h-22h	Chaîne 8	[1.13, 1.14, 1.12, 1.13, 1.11, 1.15, 1.12, 1.14, 1.11, 1.12, 1.14, 1.11, 1.11, 1.1, 1.1, 1.13, 1.12, 1.13, 1.12, 1.11]	10.88	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
408	2026-03-26	22h	22h-6h	Chaîne 8	[1.14, 1.13, 1.12, 1.13, 1.12, 1.12, 1.14, 1.15, 1.14, 1.13, 1.14, 1.13, 1.15, 1.14, 1.12, 1.14, 1.1, 1.14, 1.14, 1.14]	10.69	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
409	2026-03-26	6h	6h-14h	Chaîne 14	[1.14, 1.14, 1.12, 1.13, 1.11, 1.11, 1.12, 1.11, 1.12, 1.13, 1.12, 1.14, 1.14, 1.14, 1.12, 1.13]	11.15	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
410	2026-03-26	14h	14h-22h	Chaîne 14	[1.14, 1.12, 1.14, 1.13, 1.12, 1.14, 1.13, 1.11, 1.14, 1.11, 1.13, 1.14, 1.11, 1.11, 1.14, 1.13]	10.79	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
411	2026-03-26	22h	22h-6h	Chaîne 14	[1.13, 1.13, 1.13, 1.12, 1.15, 1.13, 1.14, 1.12, 1.12, 1.12, 1.13, 1.1, 1.11, 1.11, 1.11, 1.13]	11.18	5.5	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
412	2026-03-26	6h	6h-14h	Chaîne 15	[1.14, 1.14, 1.12, 1.1, 1.13, 1.15, 1.13, 1.11, 1.15, 1.14, 1.13, 1.1, 1.14, 1.12, 1.13, 1.11, 1.14, 1.11, 1.15, 1.14, 1.11, 1.14, 1.11, 1.15]	11.31	5.64	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
413	2026-03-26	14h	14h-22h	Chaîne 15	[1.14, 1.12, 1.1, 1.14, 1.1, 1.14, 1.1, 1.12, 1.12, 1.12, 1.1, 1.13, 1.13, 1.11, 1.1, 1.12, 1.15, 1.14, 1.12, 1.13, 1.13, 1.13, 1.14, 1.15]	11.11	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
414	2026-03-26	22h	22h-6h	Chaîne 15	[1.12, 1.13, 1.13, 1.13, 1.11, 1.14, 1.11, 1.1, 1.14, 1.13, 1.12, 1.11, 1.14, 1.13, 1.1, 1.14, 1.12, 1.13, 1.14, 1.11, 1.11, 1.11, 1.12, 1.12]	11.27	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
415	2026-03-27	6h	6h-14h	Chaîne 8	[1.11, 1.15, 1.14, 1.12, 1.12, 1.14, 1.14, 1.12, 1.12, 1.13, 1.14, 1.1, 1.15, 1.1, 1.12, 1.13, 1.11, 1.12, 1.11, 1.14]	10.76	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
416	2026-03-27	14h	14h-22h	Chaîne 8	[1.13, 1.12, 1.11, 1.1, 1.11, 1.14, 1.15, 1.13, 1.15, 1.15, 1.14, 1.12, 1.15, 1.14, 1.11, 1.15, 1.13, 1.1, 1.1, 1.12]	10.83	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
417	2026-03-27	22h	22h-6h	Chaîne 8	[1.13, 1.13, 1.13, 1.12, 1.12, 1.13, 1.13, 1.13, 1.14, 1.13, 1.11, 1.14, 1.14, 1.13, 1.14, 1.15, 1.12, 1.14, 1.14, 1.11]	10.9	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
418	2026-03-27	6h	6h-14h	Chaîne 14	[1.12, 1.14, 1.14, 1.14, 1.1, 1.15, 1.12, 1.13, 1.15, 1.15, 1.14, 1.12, 1.13, 1.11, 1.12, 1.1]	11.19	5.15	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
419	2026-03-27	14h	14h-22h	Chaîne 14	[1.11, 1.1, 1.13, 1.14, 1.12, 1.14, 1.15, 1.11, 1.12, 1.11, 1.13, 1.12, 1.14, 1.14, 1.15, 1.14]	11.03	5.29	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
420	2026-03-27	22h	22h-6h	Chaîne 14	[1.13, 1.13, 1.11, 1.14, 1.15, 1.14, 1.14, 1.13, 1.11, 1.11, 1.12, 1.11, 1.13, 1.15, 1.1, 1.11]	11.16	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
421	2026-03-27	6h	6h-14h	Chaîne 15	[1.14, 1.1, 1.14, 1.15, 1.11, 1.15, 1.1, 1.14, 1.14, 1.11, 1.1, 1.12, 1.11, 1.14, 1.13, 1.11, 1.15, 1.13, 1.13, 1.13, 1.11, 1.11, 1.15, 1.14]	11.42	5.38	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
422	2026-03-27	14h	14h-22h	Chaîne 15	[1.12, 1.12, 1.15, 1.11, 1.12, 1.12, 1.1, 1.15, 1.13, 1.11, 1.14, 1.13, 1.14, 1.14, 1.1, 1.15, 1.14, 1.14, 1.1, 1.14, 1.11, 1.1, 1.13, 1.11]	11.2	5.7	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
423	2026-03-27	22h	22h-6h	Chaîne 15	[1.13, 1.11, 1.14, 1.13, 1.12, 1.15, 1.14, 1.1, 1.11, 1.12, 1.12, 1.14, 1.13, 1.1, 1.1, 1.1, 1.12, 1.14, 1.11, 1.12, 1.13, 1.14, 1.14, 1.11]	11.34	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
424	2026-03-27	6h	6h-14h	Chaîne 16	[1.14, 1.14, 1.1, 1.12, 1.14, 1.11, 1.12, 1.13, 1.15, 1.13, 1.1, 1.12, 1.14, 1.13, 1.11, 1.13, 1.14, 1.11, 1.13, 1.14, 1.14, 1.11, 1.13, 1.11]	10.96	5.37	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
425	2026-03-27	14h	14h-22h	Chaîne 16	[1.12, 1.12, 1.11, 1.14, 1.14, 1.14, 1.14, 1.13, 1.14, 1.15, 1.1, 1.13, 1.14, 1.11, 1.12, 1.1, 1.12, 1.14, 1.11, 1.14, 1.15, 1.12, 1.15, 1.12]	11.21	5.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
426	2026-03-27	22h	22h-6h	Chaîne 16	[1.14, 1.12, 1.1, 1.14, 1.14, 1.11, 1.14, 1.12, 1.1, 1.13, 1.1, 1.15, 1.14, 1.11, 1.14, 1.11, 1.12, 1.12, 1.13, 1.15, 1.15, 1.15, 1.11, 1.14]	10.86	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
427	2026-03-28	6h	6h-14h	Chaîne 8	[1.13, 1.1, 1.13, 1.13, 1.13, 1.15, 1.11, 1.11, 1.13, 1.13, 1.14, 1.11, 1.15, 1.14, 1.13, 1.15, 1.12, 1.11, 1.1, 1.15]	10.81	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
428	2026-03-28	14h	14h-22h	Chaîne 8	[1.13, 1.11, 1.14, 1.13, 1.1, 1.14, 1.11, 1.12, 1.11, 1.15, 1.15, 1.15, 1.12, 1.11, 1.12, 1.13, 1.11, 1.12, 1.11, 1.15]	10.71	5.02	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
429	2026-03-28	22h	22h-6h	Chaîne 8	[1.13, 1.13, 1.14, 1.13, 1.11, 1.12, 1.14, 1.13, 1.13, 1.11, 1.14, 1.14, 1.14, 1.14, 1.15, 1.1, 1.14, 1.11, 1.13, 1.12]	10.7	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
430	2026-03-28	6h	6h-14h	Chaîne 14	[1.11, 1.14, 1.12, 1.14, 1.12, 1.1, 1.11, 1.14, 1.14, 1.14, 1.15, 1.13, 1.12, 1.13, 1.11, 1.12]	11.1	5.49	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
431	2026-03-28	14h	14h-22h	Chaîne 14	[1.13, 1.13, 1.13, 1.14, 1.13, 1.1, 1.11, 1.14, 1.13, 1.1, 1.1, 1.15, 1.11, 1.13, 1.14, 1.13]	11.22	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
432	2026-03-28	22h	22h-6h	Chaîne 14	[1.14, 1.12, 1.15, 1.11, 1.11, 1.13, 1.12, 1.11, 1.12, 1.1, 1.12, 1.14, 1.12, 1.13, 1.12, 1.15]	10.8	5.26	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
433	2026-03-28	6h	6h-14h	Chaîne 15	[1.14, 1.14, 1.14, 1.11, 1.12, 1.1, 1.12, 1.13, 1.14, 1.15, 1.12, 1.12, 1.15, 1.1, 1.12, 1.13, 1.13, 1.14, 1.11, 1.14, 1.12, 1.12, 1.12, 1.12]	11.23	5.66	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
434	2026-03-28	14h	14h-22h	Chaîne 15	[1.13, 1.1, 1.1, 1.14, 1.15, 1.13, 1.14, 1.11, 1.12, 1.12, 1.11, 1.12, 1.14, 1.14, 1.14, 1.14, 1.13, 1.15, 1.12, 1.11, 1.14, 1.11, 1.11, 1.15]	11.11	5.53	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
435	2026-03-28	22h	22h-6h	Chaîne 15	[1.14, 1.12, 1.12, 1.13, 1.15, 1.11, 1.11, 1.13, 1.12, 1.13, 1.15, 1.12, 1.11, 1.14, 1.12, 1.14, 1.12, 1.12, 1.15, 1.11, 1.13, 1.1, 1.13, 1.12]	11.04	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
436	2026-03-28	6h	6h-14h	Chaîne 16	[1.14, 1.11, 1.12, 1.14, 1.15, 1.14, 1.11, 1.11, 1.14, 1.12, 1.12, 1.13, 1.1, 1.15, 1.1, 1.12, 1.13, 1.14, 1.12, 1.14, 1.1, 1.12, 1.15, 1.11]	11.09	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
437	2026-03-28	14h	14h-22h	Chaîne 16	[1.13, 1.12, 1.11, 1.14, 1.13, 1.12, 1.14, 1.15, 1.13, 1.14, 1.15, 1.1, 1.14, 1.13, 1.14, 1.1, 1.1, 1.12, 1.11, 1.11, 1.15, 1.14, 1.15, 1.14]	10.95	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
438	2026-03-28	22h	22h-6h	Chaîne 16	[1.12, 1.14, 1.11, 1.12, 1.11, 1.12, 1.11, 1.1, 1.11, 1.11, 1.12, 1.13, 1.1, 1.12, 1.1, 1.11, 1.14, 1.1, 1.13, 1.13, 1.1, 1.1, 1.15, 1.1]	11.08	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
439	2026-03-29	6h	6h-14h	Chaîne 8	[1.15, 1.1, 1.13, 1.11, 1.12, 1.11, 1.12, 1.14, 1.14, 1.13, 1.14, 1.12, 1.13, 1.15, 1.14, 1.14, 1.11, 1.15, 1.15, 1.11]	10.86	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
440	2026-03-29	14h	14h-22h	Chaîne 8	[1.14, 1.14, 1.15, 1.13, 1.1, 1.11, 1.11, 1.15, 1.12, 1.14, 1.1, 1.1, 1.15, 1.12, 1.14, 1.13, 1.14, 1.13, 1.14, 1.1]	10.73	5.18	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
441	2026-03-29	22h	22h-6h	Chaîne 8	[1.11, 1.13, 1.12, 1.12, 1.12, 1.12, 1.12, 1.12, 1.12, 1.12, 1.14, 1.11, 1.13, 1.1, 1.14, 1.11, 1.1, 1.14, 1.14, 1.13]	10.71	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
442	2026-03-29	6h	6h-14h	Chaîne 14	[1.12, 1.13, 1.14, 1.13, 1.13, 1.1, 1.11, 1.12, 1.11, 1.11, 1.12, 1.14, 1.12, 1.13, 1.13, 1.1]	11.02	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
443	2026-03-29	14h	14h-22h	Chaîne 14	[1.11, 1.15, 1.12, 1.11, 1.13, 1.13, 1.11, 1.15, 1.13, 1.14, 1.15, 1.12, 1.15, 1.13, 1.15, 1.12]	10.93	5.16	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
444	2026-03-29	22h	22h-6h	Chaîne 14	[1.14, 1.11, 1.13, 1.1, 1.11, 1.11, 1.14, 1.1, 1.13, 1.11, 1.14, 1.15, 1.14, 1.13, 1.11, 1.11]	10.78	5.38	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
445	2026-03-29	6h	6h-14h	Chaîne 15	[1.1, 1.12, 1.11, 1.1, 1.12, 1.1, 1.13, 1.1, 1.12, 1.12, 1.14, 1.12, 1.14, 1.13, 1.13, 1.15, 1.14, 1.14, 1.1, 1.1, 1.11, 1.14, 1.11, 1.11]	11.36	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
446	2026-03-29	14h	14h-22h	Chaîne 15	[1.1, 1.12, 1.14, 1.13, 1.11, 1.11, 1.13, 1.12, 1.11, 1.1, 1.13, 1.1, 1.14, 1.14, 1.12, 1.1, 1.15, 1.13, 1.1, 1.1, 1.1, 1.12, 1.13, 1.14]	11.26	5.43	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
447	2026-03-29	22h	22h-6h	Chaîne 15	[1.15, 1.11, 1.12, 1.11, 1.15, 1.13, 1.12, 1.14, 1.12, 1.14, 1.11, 1.11, 1.14, 1.15, 1.12, 1.11, 1.11, 1.14, 1.12, 1.11, 1.1, 1.12, 1.14, 1.14]	11.15	5.58	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
448	2026-03-29	6h	6h-14h	Chaîne 16	[1.12, 1.13, 1.11, 1.13, 1.11, 1.14, 1.13, 1.15, 1.14, 1.14, 1.12, 1.12, 1.14, 1.14, 1.12, 1.12, 1.12, 1.12, 1.13, 1.12, 1.15, 1.15, 1.14, 1.12]	10.98	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
449	2026-03-29	14h	14h-22h	Chaîne 16	[1.11, 1.15, 1.13, 1.14, 1.13, 1.13, 1.14, 1.11, 1.12, 1.11, 1.14, 1.14, 1.12, 1.13, 1.14, 1.13, 1.13, 1.1, 1.1, 1.1, 1.1, 1.15, 1.14, 1.12]	10.79	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
450	2026-03-29	22h	22h-6h	Chaîne 16	[1.12, 1.12, 1.11, 1.12, 1.14, 1.11, 1.14, 1.11, 1.11, 1.15, 1.12, 1.13, 1.13, 1.13, 1.11, 1.14, 1.11, 1.11, 1.15, 1.15, 1.1, 1.1, 1.14, 1.12]	11.05	5.12	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
451	2026-03-30	6h	6h-14h	Chaîne 14	[1.11, 1.15, 1.15, 1.11, 1.13, 1.11, 1.14, 1.14, 1.12, 1.15, 1.12, 1.13, 1.13, 1.15, 1.12, 1.11]	11.05	5.38	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
452	2026-03-30	14h	14h-22h	Chaîne 14	[1.12, 1.11, 1.15, 1.13, 1.13, 1.12, 1.1, 1.14, 1.15, 1.1, 1.13, 1.12, 1.11, 1.12, 1.12, 1.13]	11.09	5.2	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
453	2026-03-30	22h	22h-6h	Chaîne 14	[1.11, 1.11, 1.1, 1.12, 1.13, 1.14, 1.15, 1.14, 1.14, 1.1, 1.11, 1.14, 1.11, 1.11, 1.1, 1.13]	10.84	5.23	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
454	2026-03-30	6h	6h-14h	Chaîne 15	[1.15, 1.13, 1.12, 1.13, 1.13, 1.1, 1.11, 1.15, 1.15, 1.11, 1.14, 1.1, 1.12, 1.13, 1.11, 1.14, 1.12, 1.13, 1.11, 1.14, 1.14, 1.12, 1.14, 1.12]	11.01	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
455	2026-03-30	14h	14h-22h	Chaîne 15	[1.11, 1.11, 1.14, 1.11, 1.14, 1.14, 1.11, 1.12, 1.14, 1.11, 1.12, 1.13, 1.11, 1.11, 1.12, 1.11, 1.1, 1.14, 1.13, 1.11, 1.11, 1.1, 1.12, 1.15]	11.09	5.67	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
456	2026-03-30	22h	22h-6h	Chaîne 15	[1.15, 1.13, 1.13, 1.15, 1.13, 1.14, 1.12, 1.12, 1.14, 1.12, 1.12, 1.12, 1.13, 1.14, 1.11, 1.11, 1.13, 1.12, 1.14, 1.12, 1.14, 1.15, 1.12, 1.14]	11.28	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
457	2026-03-30	6h	6h-14h	Chaîne 16	[1.12, 1.12, 1.14, 1.15, 1.11, 1.15, 1.11, 1.1, 1.12, 1.11, 1.11, 1.12, 1.11, 1.14, 1.14, 1.11, 1.11, 1.13, 1.12, 1.12, 1.14, 1.12, 1.13, 1.12]	10.95	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
458	2026-03-30	14h	14h-22h	Chaîne 16	[1.13, 1.12, 1.12, 1.13, 1.13, 1.13, 1.13, 1.12, 1.12, 1.13, 1.11, 1.13, 1.12, 1.1, 1.12, 1.11, 1.15, 1.13, 1.15, 1.15, 1.13, 1.15, 1.12, 1.11]	10.88	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
459	2026-03-30	22h	22h-6h	Chaîne 16	[1.14, 1.11, 1.13, 1.14, 1.12, 1.14, 1.12, 1.11, 1.12, 1.13, 1.12, 1.15, 1.15, 1.14, 1.1, 1.12, 1.11, 1.14, 1.14, 1.12, 1.14, 1.12, 1.11, 1.1]	11.18	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
460	2026-03-31	6h	6h-14h	Chaîne 8	[1.11, 1.15, 1.13, 1.11, 1.1, 1.14, 1.13, 1.13, 1.11, 1.12, 1.14, 1.14, 1.11, 1.11, 1.11, 1.1, 1.13, 1.12, 1.12, 1.14]	10.97	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
461	2026-03-31	14h	14h-22h	Chaîne 8	[1.11, 1.13, 1.12, 1.1, 1.1, 1.12, 1.12, 1.11, 1.14, 1.12, 1.1, 1.12, 1.12, 1.11, 1.13, 1.14, 1.13, 1.12, 1.14, 1.1]	10.78	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
462	2026-03-31	22h	22h-6h	Chaîne 8	[1.12, 1.12, 1.1, 1.12, 1.1, 1.12, 1.1, 1.12, 1.14, 1.13, 1.13, 1.1, 1.11, 1.11, 1.14, 1.14, 1.11, 1.1, 1.13, 1.1]	10.65	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
463	2026-03-31	6h	6h-14h	Chaîne 15	[1.1, 1.11, 1.12, 1.12, 1.1, 1.14, 1.13, 1.14, 1.12, 1.11, 1.1, 1.13, 1.13, 1.11, 1.12, 1.12, 1.14, 1.14, 1.11, 1.11, 1.14, 1.12, 1.13, 1.12]	11.16	5.31	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
464	2026-03-31	14h	14h-22h	Chaîne 15	[1.14, 1.14, 1.11, 1.13, 1.11, 1.13, 1.12, 1.12, 1.13, 1.11, 1.14, 1.14, 1.11, 1.1, 1.1, 1.14, 1.14, 1.11, 1.15, 1.12, 1.12, 1.15, 1.13, 1.11]	11.02	5.69	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
465	2026-03-31	22h	22h-6h	Chaîne 15	[1.14, 1.15, 1.15, 1.12, 1.12, 1.13, 1.11, 1.1, 1.11, 1.11, 1.12, 1.14, 1.1, 1.12, 1.1, 1.14, 1.14, 1.12, 1.11, 1.15, 1.14, 1.14, 1.11, 1.15]	11.37	5.66	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
466	2026-03-31	6h	6h-14h	Chaîne 16	[1.13, 1.11, 1.14, 1.12, 1.14, 1.11, 1.1, 1.13, 1.1, 1.12, 1.14, 1.12, 1.15, 1.13, 1.1, 1.1, 1.14, 1.11, 1.11, 1.12, 1.14, 1.1, 1.11, 1.14]	10.88	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
467	2026-03-31	14h	14h-22h	Chaîne 16	[1.14, 1.1, 1.12, 1.13, 1.12, 1.12, 1.11, 1.13, 1.12, 1.13, 1.11, 1.14, 1.12, 1.11, 1.12, 1.12, 1.12, 1.11, 1.14, 1.14, 1.12, 1.13, 1.12, 1.12]	11.2	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
468	2026-03-31	22h	22h-6h	Chaîne 16	[1.14, 1.13, 1.13, 1.13, 1.14, 1.11, 1.14, 1.11, 1.14, 1.11, 1.13, 1.1, 1.12, 1.11, 1.13, 1.1, 1.11, 1.1, 1.15, 1.13, 1.11, 1.11, 1.14, 1.12]	10.85	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
469	2026-04-01	6h	6h-14h	Chaîne 8	[1.15, 1.11, 1.13, 1.11, 1.13, 1.14, 1.14, 1.14, 1.15, 1.14, 1.12, 1.15, 1.13, 1.12, 1.14, 1.12, 1.11, 1.13, 1.15, 1.11]	10.83	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
470	2026-04-01	14h	14h-22h	Chaîne 8	[1.1, 1.13, 1.12, 1.12, 1.12, 1.13, 1.15, 1.13, 1.13, 1.13, 1.15, 1.12, 1.12, 1.11, 1.12, 1.14, 1.14, 1.14, 1.12, 1.13]	10.64	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
471	2026-04-01	22h	22h-6h	Chaîne 8	[1.11, 1.14, 1.13, 1.1, 1.12, 1.12, 1.13, 1.12, 1.12, 1.13, 1.14, 1.12, 1.13, 1.1, 1.13, 1.13, 1.13, 1.1, 1.13, 1.1]	10.62	5.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
472	2026-04-01	6h	6h-14h	Chaîne 14	[1.12, 1.14, 1.1, 1.13, 1.12, 1.13, 1.15, 1.1, 1.12, 1.11, 1.12, 1.14, 1.13, 1.11, 1.12, 1.12]	10.83	5.31	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
473	2026-04-01	14h	14h-22h	Chaîne 14	[1.15, 1.13, 1.1, 1.12, 1.14, 1.12, 1.14, 1.14, 1.12, 1.13, 1.12, 1.1, 1.12, 1.14, 1.1, 1.1]	10.83	5.16	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
474	2026-04-01	22h	22h-6h	Chaîne 14	[1.11, 1.13, 1.13, 1.13, 1.12, 1.15, 1.13, 1.13, 1.11, 1.1, 1.11, 1.12, 1.14, 1.12, 1.12, 1.13]	10.79	5.12	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
475	2026-04-01	6h	6h-14h	Chaîne 16	[1.14, 1.11, 1.14, 1.12, 1.15, 1.1, 1.11, 1.13, 1.12, 1.13, 1.15, 1.14, 1.12, 1.14, 1.1, 1.12, 1.12, 1.11, 1.14, 1.12, 1.12, 1.14, 1.11, 1.15]	11.16	5.02	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
476	2026-04-01	14h	14h-22h	Chaîne 16	[1.13, 1.12, 1.13, 1.14, 1.14, 1.14, 1.1, 1.11, 1.11, 1.13, 1.15, 1.12, 1.14, 1.13, 1.15, 1.14, 1.12, 1.12, 1.14, 1.14, 1.13, 1.13, 1.13, 1.13]	11.01	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
477	2026-04-01	22h	22h-6h	Chaîne 16	[1.14, 1.13, 1.11, 1.15, 1.12, 1.11, 1.11, 1.15, 1.11, 1.12, 1.13, 1.11, 1.13, 1.13, 1.11, 1.13, 1.14, 1.14, 1.13, 1.11, 1.13, 1.14, 1.13, 1.11]	10.81	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
478	2026-04-02	6h	6h-14h	Chaîne 8	[1.14, 1.12, 1.12, 1.14, 1.15, 1.12, 1.12, 1.11, 1.1, 1.11, 1.12, 1.13, 1.12, 1.1, 1.14, 1.11, 1.12, 1.15, 1.13, 1.14]	10.86	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
479	2026-04-02	14h	14h-22h	Chaîne 8	[1.11, 1.14, 1.15, 1.1, 1.1, 1.11, 1.13, 1.11, 1.1, 1.14, 1.12, 1.1, 1.13, 1.1, 1.11, 1.15, 1.14, 1.11, 1.11, 1.11]	10.77	5.12	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
480	2026-04-02	22h	22h-6h	Chaîne 8	[1.12, 1.13, 1.1, 1.11, 1.13, 1.13, 1.15, 1.14, 1.11, 1.11, 1.12, 1.11, 1.13, 1.14, 1.15, 1.11, 1.1, 1.13, 1.12, 1.14]	10.91	5.06	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
481	2026-04-02	6h	6h-14h	Chaîne 14	[1.1, 1.14, 1.11, 1.13, 1.12, 1.14, 1.12, 1.1, 1.13, 1.12, 1.12, 1.11, 1.11, 1.1, 1.14, 1.13]	11.17	5.45	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
482	2026-04-02	14h	14h-22h	Chaîne 14	[1.13, 1.13, 1.13, 1.1, 1.14, 1.1, 1.13, 1.12, 1.1, 1.12, 1.12, 1.12, 1.12, 1.12, 1.11, 1.15]	10.95	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
483	2026-04-02	22h	22h-6h	Chaîne 14	[1.11, 1.14, 1.11, 1.13, 1.13, 1.11, 1.13, 1.11, 1.11, 1.11, 1.12, 1.14, 1.11, 1.12, 1.11, 1.1]	10.8	5.25	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
484	2026-04-02	6h	6h-14h	Chaîne 15	[1.11, 1.1, 1.15, 1.13, 1.1, 1.14, 1.11, 1.14, 1.13, 1.14, 1.13, 1.12, 1.11, 1.13, 1.11, 1.14, 1.12, 1.11, 1.11, 1.14, 1.13, 1.14, 1.12, 1.11]	11.11	5.49	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
485	2026-04-02	14h	14h-22h	Chaîne 15	[1.11, 1.13, 1.1, 1.15, 1.11, 1.11, 1.13, 1.12, 1.14, 1.13, 1.14, 1.14, 1.12, 1.13, 1.13, 1.14, 1.13, 1.14, 1.12, 1.11, 1.15, 1.11, 1.14, 1.11]	11.18	5.59	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
486	2026-04-02	22h	22h-6h	Chaîne 15	[1.14, 1.11, 1.14, 1.14, 1.12, 1.13, 1.14, 1.11, 1.14, 1.12, 1.11, 1.15, 1.15, 1.11, 1.12, 1.14, 1.12, 1.11, 1.11, 1.15, 1.11, 1.11, 1.13, 1.11]	11.11	5.29	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
487	2026-04-03	6h	6h-14h	Chaîne 8	[1.13, 1.1, 1.13, 1.13, 1.12, 1.12, 1.12, 1.13, 1.12, 1.12, 1.12, 1.14, 1.13, 1.14, 1.14, 1.12, 1.13, 1.13, 1.13, 1.14]	10.59	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
488	2026-04-03	14h	14h-22h	Chaîne 8	[1.11, 1.13, 1.11, 1.11, 1.1, 1.1, 1.11, 1.12, 1.11, 1.14, 1.14, 1.12, 1.13, 1.15, 1.11, 1.15, 1.11, 1.1, 1.14, 1.14]	10.86	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
489	2026-04-03	22h	22h-6h	Chaîne 8	[1.12, 1.15, 1.13, 1.13, 1.15, 1.14, 1.13, 1.12, 1.11, 1.13, 1.14, 1.13, 1.11, 1.13, 1.14, 1.11, 1.1, 1.12, 1.12, 1.13]	10.73	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
490	2026-04-03	6h	6h-14h	Chaîne 14	[1.14, 1.11, 1.15, 1.15, 1.13, 1.13, 1.12, 1.12, 1.13, 1.11, 1.11, 1.13, 1.15, 1.13, 1.14, 1.15]	10.85	5.18	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
491	2026-04-03	14h	14h-22h	Chaîne 14	[1.15, 1.12, 1.11, 1.12, 1.11, 1.11, 1.14, 1.12, 1.13, 1.13, 1.14, 1.11, 1.1, 1.14, 1.11, 1.12]	10.92	5.29	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
492	2026-04-03	22h	22h-6h	Chaîne 14	[1.13, 1.15, 1.13, 1.13, 1.1, 1.11, 1.12, 1.1, 1.15, 1.1, 1.1, 1.1, 1.15, 1.14, 1.14, 1.14]	10.79	5.21	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
493	2026-04-03	6h	6h-14h	Chaîne 15	[1.14, 1.13, 1.12, 1.11, 1.11, 1.12, 1.12, 1.11, 1.12, 1.12, 1.15, 1.12, 1.13, 1.14, 1.12, 1.15, 1.14, 1.14, 1.13, 1.11, 1.12, 1.14, 1.1, 1.1]	11.18	5.66	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
494	2026-04-03	14h	14h-22h	Chaîne 15	[1.12, 1.15, 1.13, 1.13, 1.14, 1.12, 1.14, 1.14, 1.13, 1.12, 1.12, 1.12, 1.1, 1.14, 1.14, 1.12, 1.14, 1.12, 1.15, 1.14, 1.14, 1.12, 1.14, 1.14]	11.12	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
495	2026-04-03	22h	22h-6h	Chaîne 15	[1.14, 1.12, 1.1, 1.11, 1.13, 1.12, 1.11, 1.11, 1.11, 1.1, 1.1, 1.12, 1.12, 1.13, 1.12, 1.11, 1.14, 1.15, 1.11, 1.11, 1.13, 1.14, 1.14, 1.11]	11.05	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
496	2026-04-03	6h	6h-14h	Chaîne 16	[1.11, 1.15, 1.12, 1.11, 1.1, 1.13, 1.15, 1.1, 1.14, 1.12, 1.12, 1.14, 1.13, 1.15, 1.14, 1.11, 1.11, 1.14, 1.14, 1.14, 1.13, 1.13, 1.12, 1.1]	10.8	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
497	2026-04-03	14h	14h-22h	Chaîne 16	[1.15, 1.1, 1.14, 1.14, 1.14, 1.14, 1.14, 1.13, 1.12, 1.13, 1.13, 1.13, 1.14, 1.14, 1.15, 1.12, 1.14, 1.11, 1.13, 1.1, 1.12, 1.12, 1.11, 1.12]	11.13	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
498	2026-04-03	22h	22h-6h	Chaîne 16	[1.14, 1.11, 1.15, 1.13, 1.13, 1.1, 1.11, 1.11, 1.15, 1.15, 1.1, 1.14, 1.14, 1.11, 1.11, 1.14, 1.12, 1.13, 1.14, 1.13, 1.13, 1.12, 1.13, 1.14]	10.97	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
499	2026-04-04	6h	6h-14h	Chaîne 8	[1.1, 1.1, 1.11, 1.11, 1.14, 1.13, 1.12, 1.15, 1.13, 1.1, 1.14, 1.14, 1.12, 1.14, 1.14, 1.12, 1.11, 1.13, 1.12, 1.13]	10.98	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
500	2026-04-04	14h	14h-22h	Chaîne 8	[1.14, 1.1, 1.11, 1.13, 1.1, 1.13, 1.12, 1.12, 1.14, 1.1, 1.12, 1.12, 1.11, 1.1, 1.13, 1.14, 1.13, 1.12, 1.13, 1.13]	10.78	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
501	2026-04-04	22h	22h-6h	Chaîne 8	[1.15, 1.13, 1.15, 1.13, 1.14, 1.15, 1.11, 1.14, 1.15, 1.15, 1.12, 1.12, 1.14, 1.12, 1.1, 1.11, 1.11, 1.1, 1.11, 1.13]	10.77	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
502	2026-04-04	6h	6h-14h	Chaîne 14	[1.1, 1.12, 1.14, 1.14, 1.15, 1.1, 1.14, 1.15, 1.14, 1.13, 1.15, 1.13, 1.11, 1.12, 1.15, 1.12]	11.03	5.33	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
503	2026-04-04	14h	14h-22h	Chaîne 14	[1.14, 1.12, 1.11, 1.11, 1.15, 1.14, 1.11, 1.12, 1.11, 1.15, 1.14, 1.11, 1.14, 1.12, 1.14, 1.11]	10.78	5.47	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
504	2026-04-04	22h	22h-6h	Chaîne 14	[1.12, 1.11, 1.12, 1.13, 1.12, 1.14, 1.11, 1.11, 1.15, 1.12, 1.13, 1.11, 1.13, 1.14, 1.14, 1.11]	11.03	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
505	2026-04-04	6h	6h-14h	Chaîne 15	[1.11, 1.14, 1.11, 1.11, 1.1, 1.1, 1.12, 1.15, 1.11, 1.11, 1.1, 1.11, 1.11, 1.13, 1.12, 1.12, 1.12, 1.11, 1.13, 1.11, 1.12, 1.15, 1.12, 1.13]	11.34	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
506	2026-04-04	14h	14h-22h	Chaîne 15	[1.11, 1.1, 1.1, 1.12, 1.1, 1.14, 1.1, 1.12, 1.11, 1.12, 1.14, 1.11, 1.11, 1.12, 1.1, 1.14, 1.13, 1.13, 1.12, 1.13, 1.12, 1.13, 1.11, 1.12]	11.4	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
507	2026-04-04	22h	22h-6h	Chaîne 15	[1.15, 1.11, 1.14, 1.13, 1.13, 1.11, 1.13, 1.14, 1.14, 1.1, 1.13, 1.14, 1.11, 1.11, 1.14, 1.14, 1.13, 1.13, 1.13, 1.14, 1.13, 1.11, 1.12, 1.13]	11.07	5.7	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
508	2026-04-04	6h	6h-14h	Chaîne 16	[1.12, 1.13, 1.11, 1.11, 1.12, 1.14, 1.13, 1.13, 1.1, 1.12, 1.11, 1.11, 1.1, 1.12, 1.12, 1.11, 1.12, 1.11, 1.15, 1.1, 1.1, 1.13, 1.11, 1.12]	10.86	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
509	2026-04-04	14h	14h-22h	Chaîne 16	[1.12, 1.1, 1.1, 1.13, 1.11, 1.11, 1.13, 1.12, 1.11, 1.12, 1.11, 1.11, 1.14, 1.14, 1.13, 1.13, 1.14, 1.1, 1.13, 1.13, 1.13, 1.13, 1.1, 1.14]	11.1	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
510	2026-04-04	22h	22h-6h	Chaîne 16	[1.12, 1.12, 1.13, 1.1, 1.1, 1.13, 1.1, 1.11, 1.11, 1.11, 1.14, 1.14, 1.11, 1.11, 1.11, 1.12, 1.13, 1.11, 1.11, 1.11, 1.15, 1.11, 1.13, 1.14]	10.9	5.17	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
511	2026-04-05	6h	6h-14h	Chaîne 8	[1.14, 1.11, 1.14, 1.11, 1.11, 1.11, 1.11, 1.14, 1.11, 1.13, 1.13, 1.13, 1.15, 1.15, 1.14, 1.15, 1.15, 1.14, 1.11, 1.15]	10.75	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
512	2026-04-05	14h	14h-22h	Chaîne 8	[1.14, 1.1, 1.12, 1.12, 1.13, 1.15, 1.14, 1.11, 1.13, 1.15, 1.11, 1.14, 1.15, 1.11, 1.12, 1.15, 1.13, 1.14, 1.11, 1.13]	10.7	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
513	2026-04-05	22h	22h-6h	Chaîne 8	[1.13, 1.11, 1.12, 1.11, 1.11, 1.12, 1.14, 1.11, 1.14, 1.11, 1.13, 1.13, 1.13, 1.1, 1.14, 1.13, 1.14, 1.12, 1.11, 1.11]	10.69	5.22	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
514	2026-04-05	6h	6h-14h	Chaîne 14	[1.14, 1.13, 1.1, 1.13, 1.12, 1.14, 1.12, 1.14, 1.13, 1.1, 1.13, 1.15, 1.1, 1.11, 1.12, 1.12]	11.1	5.12	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
515	2026-04-05	14h	14h-22h	Chaîne 14	[1.12, 1.15, 1.1, 1.11, 1.14, 1.13, 1.14, 1.12, 1.12, 1.13, 1.12, 1.1, 1.1, 1.13, 1.14, 1.12]	11.04	5.33	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
516	2026-04-05	22h	22h-6h	Chaîne 14	[1.15, 1.12, 1.1, 1.12, 1.11, 1.13, 1.14, 1.13, 1.1, 1.12, 1.12, 1.11, 1.13, 1.13, 1.12, 1.12]	10.96	5.43	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
517	2026-04-05	6h	6h-14h	Chaîne 15	[1.14, 1.11, 1.13, 1.14, 1.15, 1.14, 1.11, 1.14, 1.15, 1.13, 1.13, 1.12, 1.14, 1.11, 1.11, 1.14, 1.11, 1.13, 1.12, 1.11, 1.13, 1.11, 1.12, 1.13]	11	5.63	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
518	2026-04-05	14h	14h-22h	Chaîne 15	[1.14, 1.14, 1.12, 1.11, 1.15, 1.11, 1.12, 1.1, 1.12, 1.15, 1.13, 1.11, 1.15, 1.12, 1.11, 1.14, 1.11, 1.14, 1.14, 1.12, 1.13, 1.11, 1.11, 1.14]	11.37	5.61	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
519	2026-04-05	22h	22h-6h	Chaîne 15	[1.1, 1.11, 1.11, 1.11, 1.13, 1.13, 1.14, 1.11, 1.14, 1.11, 1.13, 1.13, 1.13, 1.12, 1.11, 1.13, 1.15, 1.11, 1.11, 1.11, 1.15, 1.14, 1.11, 1.13]	11.41	5.51	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
520	2026-04-05	6h	6h-14h	Chaîne 16	[1.14, 1.11, 1.1, 1.15, 1.11, 1.1, 1.13, 1.12, 1.11, 1.13, 1.15, 1.1, 1.12, 1.1, 1.1, 1.1, 1.14, 1.14, 1.12, 1.15, 1.15, 1.1, 1.15, 1.14]	11.09	5.18	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
521	2026-04-05	14h	14h-22h	Chaîne 16	[1.12, 1.13, 1.14, 1.13, 1.1, 1.13, 1.12, 1.13, 1.12, 1.14, 1.14, 1.13, 1.15, 1.15, 1.15, 1.14, 1.13, 1.12, 1.13, 1.12, 1.14, 1.1, 1.13, 1.14]	11.14	5.24	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
522	2026-04-05	22h	22h-6h	Chaîne 16	[1.15, 1.11, 1.14, 1.11, 1.11, 1.13, 1.11, 1.11, 1.11, 1.12, 1.1, 1.11, 1.1, 1.14, 1.14, 1.11, 1.13, 1.15, 1.1, 1.12, 1.1, 1.14, 1.11, 1.15]	10.93	5	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
523	2026-04-06	6h	6h-14h	Chaîne 14	[1.15, 1.11, 1.15, 1.14, 1.16, 1.12, 1.1, 1.12, 1.17, 1.12, 1.11, 1.08, 1.12, 1.14, 1.13, 1.11]	10.95	5.38	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
524	2026-04-06	14h	14h-22h	Chaîne 14	[1.13, 1.13, 1.1, 1.12, 1.06, 1.14, 1.14, 1.11, 1.11, 1.1, 1.08, 1.15, 1.2, 1.05, 1.14, 1.18]	10.8	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
525	2026-04-06	22h	22h-6h	Chaîne 14	[1.14, 1.12, 1.13, 1.15, 1.1, 1.09, 1.1, 1.08, 1.11, 1.13, 1.08, 1.12, 1.14, 1.13, 1.11, 1.11]	11.14	5.18	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
526	2026-04-06	6h	6h-14h	Chaîne 15	[1.11, 1.13, 1.12, 1.13, 1.12, 1.11, 1.14, 1.12, 1.12, 1.12, 1.1, 1.14, 1.1, 1.12, 1.12, 1.13, 1.13, 1.11, 1.11, 1.13, 1.13, 1.15, 1.14, 1.11]	11.13	5.52	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
527	2026-04-06	14h	14h-22h	Chaîne 15	[1.15, 1.12, 1.11, 1.1, 1.14, 1.12, 1.12, 1.14, 1.1, 1.1, 1.14, 1.14, 1.13, 1.1, 1.13, 1.14, 1.12, 1.15, 1.14, 1.1, 1.1, 1.13, 1.13, 1.11]	11.26	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
528	2026-04-06	22h	22h-6h	Chaîne 15	[1.13, 1.13, 1.1, 1.12, 1.13, 1.11, 1.14, 1.12, 1.13, 1.12, 1.1, 1.15, 1.14, 1.14, 1.14, 1.12, 1.11, 1.11, 1.1, 1.14, 1.14, 1.12, 1.13, 1.12]	11.21	5.66	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
529	2026-04-06	6h	6h-14h	Chaîne 16	[1.1, 1.11, 1.11, 1.11, 1.15, 1.15, 1.12, 1.14, 1.11, 1.12, 1.15, 1.11, 1.13, 1.1, 1.1, 1.14, 1.14, 1.11, 1.11, 1.13, 1.1, 1.11, 1.14, 1.11]	10.95	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
530	2026-04-06	14h	14h-22h	Chaîne 16	[1.11, 1.11, 1.1, 1.15, 1.14, 1.12, 1.11, 1.12, 1.13, 1.15, 1.1, 1.11, 1.15, 1.11, 1.11, 1.11, 1.11, 1.12, 1.11, 1.11, 1.12, 1.14, 1.13, 1.11]	10.88	5.02	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
531	2026-04-06	22h	22h-6h	Chaîne 16	[1.15, 1.12, 1.13, 1.12, 1.14, 1.14, 1.13, 1.12, 1.14, 1.14, 1.11, 1.14, 1.11, 1.11, 1.13, 1.13, 1.15, 1.12, 1.12, 1.13, 1.12, 1.14, 1.12, 1.14]	10.86	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
532	2026-04-07	6h	6h-14h	Chaîne 8	[1.13, 1.14, 1.14, 1.1, 1.14, 1.12, 1.11, 1.13, 1.11, 1.11, 1.12, 1.13, 1.1, 1.12, 1.14, 1.12, 1.14, 1.13, 1.12, 1.11]	10.96	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
533	2026-04-07	14h	14h-22h	Chaîne 8	[1.14, 1.15, 1.13, 1.13, 1.13, 1.11, 1.13, 1.13, 1.14, 1.14, 1.15, 1.11, 1.15, 1.14, 1.14, 1.15, 1.13, 1.11, 1.14, 1.12]	10.64	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
534	2026-04-07	22h	22h-6h	Chaîne 8	[1.1, 1.1, 1.12, 1.13, 1.13, 1.15, 1.14, 1.1, 1.13, 1.1, 1.15, 1.11, 1.13, 1.12, 1.12, 1.13, 1.15, 1.11, 1.15, 1.12]	10.95	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
535	2026-04-07	6h	6h-14h	Chaîne 15	[1.1, 1.13, 1.12, 1.13, 1.12, 1.11, 1.13, 1.11, 1.1, 1.11, 1.1, 1.14, 1.12, 1.15, 1.12, 1.13, 1.13, 1.13, 1.1, 1.11, 1.11, 1.13, 1.14, 1.12]	11.21	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
536	2026-04-07	14h	14h-22h	Chaîne 15	[1.13, 1.11, 1.13, 1.13, 1.11, 1.12, 1.14, 1.14, 1.11, 1.15, 1.15, 1.15, 1.12, 1.11, 1.1, 1.13, 1.12, 1.13, 1.12, 1.15, 1.12, 1.15, 1.12, 1.11]	11.34	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
537	2026-04-07	22h	22h-6h	Chaîne 15	[1.13, 1.13, 1.12, 1.12, 1.15, 1.12, 1.11, 1.12, 1.14, 1.12, 1.13, 1.14, 1.14, 1.11, 1.11, 1.1, 1.12, 1.13, 1.14, 1.14, 1.14, 1.1, 1.14, 1.15]	11.14	5.38	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
538	2026-04-07	6h	6h-14h	Chaîne 16	[1.1, 1.11, 1.11, 1.14, 1.11, 1.11, 1.11, 1.13, 1.11, 1.12, 1.14, 1.15, 1.1, 1.14, 1.12, 1.12, 1.1, 1.13, 1.15, 1.11, 1.14, 1.14, 1.11, 1.14]	10.82	5.14	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
539	2026-04-07	14h	14h-22h	Chaîne 16	[1.14, 1.14, 1.1, 1.12, 1.11, 1.13, 1.13, 1.14, 1.12, 1.14, 1.15, 1.13, 1.15, 1.14, 1.12, 1.15, 1.14, 1.13, 1.12, 1.14, 1.13, 1.11, 1.14, 1.11]	11.01	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
540	2026-04-07	22h	22h-6h	Chaîne 16	[1.14, 1.14, 1.11, 1.13, 1.12, 1.13, 1.11, 1.1, 1.13, 1.15, 1.1, 1.15, 1.1, 1.1, 1.11, 1.12, 1.13, 1.13, 1.14, 1.1, 1.11, 1.13, 1.14, 1.15]	10.97	5.14	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
541	2026-04-08	6h	6h-14h	Chaîne 8	[1.13, 1.11, 1.11, 1.13, 1.13, 1.12, 1.13, 1.14, 1.11, 1.15, 1.13, 1.15, 1.12, 1.14, 1.14, 1.14, 1.11, 1.12, 1.14, 1.11]	10.86	5.17	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
542	2026-04-08	14h	14h-22h	Chaîne 8	[1.14, 1.11, 1.11, 1.14, 1.11, 1.13, 1.14, 1.13, 1.13, 1.13, 1.1, 1.14, 1.14, 1.13, 1.12, 1.12, 1.11, 1.13, 1.12, 1.13]	10.68	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
543	2026-04-08	22h	22h-6h	Chaîne 8	[1.13, 1.11, 1.11, 1.11, 1.13, 1.1, 1.11, 1.1, 1.14, 1.14, 1.14, 1.12, 1.13, 1.11, 1.11, 1.1, 1.14, 1.14, 1.15, 1.13]	10.78	5.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
544	2026-04-08	6h	6h-14h	Chaîne 14	[1.1, 1.11, 1.11, 1.15, 1.15, 1.11, 1.12, 1.11, 1.11, 1.12, 1.12, 1.14, 1.1, 1.12, 1.13, 1.11]	11.04	5.17	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
545	2026-04-08	14h	14h-22h	Chaîne 14	[1.11, 1.14, 1.12, 1.14, 1.12, 1.11, 1.12, 1.11, 1.1, 1.12, 1.14, 1.13, 1.15, 1.12, 1.14, 1.11]	10.92	5.49	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
546	2026-04-08	22h	22h-6h	Chaîne 14	[1.13, 1.14, 1.15, 1.14, 1.11, 1.14, 1.14, 1.11, 1.15, 1.15, 1.13, 1.11, 1.1, 1.13, 1.15, 1.11]	10.85	5.23	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
547	2026-04-08	6h	6h-14h	Chaîne 16	[1.13, 1.12, 1.11, 1.13, 1.15, 1.14, 1.15, 1.14, 1.14, 1.1, 1.1, 1.15, 1.11, 1.12, 1.1, 1.13, 1.14, 1.12, 1.12, 1.12, 1.14, 1.15, 1.14, 1.13]	11.09	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
548	2026-04-08	14h	14h-22h	Chaîne 16	[1.11, 1.11, 1.14, 1.13, 1.1, 1.14, 1.15, 1.13, 1.15, 1.1, 1.13, 1.12, 1.13, 1.11, 1.12, 1.13, 1.14, 1.11, 1.11, 1.14, 1.15, 1.15, 1.12, 1.14]	11.11	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
549	2026-04-08	22h	22h-6h	Chaîne 16	[1.1, 1.11, 1.12, 1.14, 1.13, 1.12, 1.11, 1.15, 1.14, 1.11, 1.11, 1.11, 1.12, 1.11, 1.1, 1.11, 1.13, 1.13, 1.12, 1.13, 1.11, 1.14, 1.11, 1.1]	11.18	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
550	2026-04-09	6h	6h-14h	Chaîne 8	[1.12, 1.1, 1.14, 1.11, 1.14, 1.15, 1.12, 1.12, 1.14, 1.14, 1.14, 1.1, 1.15, 1.14, 1.13, 1.12, 1.14, 1.13, 1.14, 1.14]	10.73	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
551	2026-04-09	14h	14h-22h	Chaîne 8	[1.14, 1.11, 1.1, 1.14, 1.11, 1.11, 1.12, 1.1, 1.11, 1.13, 1.12, 1.13, 1.11, 1.11, 1.13, 1.12, 1.14, 1.1, 1.12, 1.13]	10.75	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
552	2026-04-09	22h	22h-6h	Chaîne 8	[1.13, 1.1, 1.14, 1.14, 1.1, 1.1, 1.1, 1.12, 1.15, 1.15, 1.13, 1.14, 1.12, 1.12, 1.14, 1.13, 1.12, 1.13, 1.14, 1.12]	11	5.06	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
553	2026-04-09	6h	6h-14h	Chaîne 14	[1.1, 1.11, 1.14, 1.11, 1.11, 1.14, 1.14, 1.12, 1.11, 1.12, 1.11, 1.15, 1.12, 1.12, 1.1, 1.1]	10.98	5.09	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
554	2026-04-09	14h	14h-22h	Chaîne 14	[1.13, 1.12, 1.11, 1.1, 1.14, 1.12, 1.15, 1.14, 1.11, 1.15, 1.15, 1.12, 1.11, 1.12, 1.11, 1.11]	10.93	5.11	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
555	2026-04-09	22h	22h-6h	Chaîne 14	[1.13, 1.12, 1.15, 1.14, 1.14, 1.13, 1.11, 1.14, 1.15, 1.15, 1.14, 1.14, 1.12, 1.11, 1.12, 1.1]	11.04	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
556	2026-04-09	6h	6h-14h	Chaîne 15	[1.1, 1.1, 1.11, 1.12, 1.12, 1.12, 1.15, 1.1, 1.14, 1.11, 1.11, 1.14, 1.13, 1.14, 1.13, 1.13, 1.14, 1.13, 1.13, 1.12, 1.13, 1.14, 1.12, 1.11]	11.02	5.7	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
557	2026-04-09	14h	14h-22h	Chaîne 15	[1.12, 1.11, 1.1, 1.12, 1.12, 1.11, 1.12, 1.13, 1.14, 1.11, 1.15, 1.15, 1.11, 1.12, 1.15, 1.12, 1.13, 1.11, 1.14, 1.14, 1.12, 1.11, 1.13, 1.13]	11.38	5.62	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
558	2026-04-09	22h	22h-6h	Chaîne 15	[1.14, 1.15, 1.11, 1.11, 1.1, 1.12, 1.15, 1.14, 1.11, 1.12, 1.14, 1.13, 1.13, 1.13, 1.13, 1.11, 1.14, 1.15, 1.13, 1.15, 1.1, 1.12, 1.14, 1.13]	11.34	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
559	2026-04-10	6h	6h-14h	Chaîne 8	[1.11, 1.13, 1.11, 1.11, 1.15, 1.14, 1.13, 1.14, 1.11, 1.15, 1.15, 1.12, 1.15, 1.13, 1.1, 1.1, 1.13, 1.12, 1.12, 1.13]	10.61	5.22	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
560	2026-04-10	14h	14h-22h	Chaîne 8	[1.12, 1.14, 1.11, 1.11, 1.13, 1.13, 1.13, 1.12, 1.14, 1.13, 1.15, 1.15, 1.12, 1.13, 1.11, 1.13, 1.11, 1.11, 1.15, 1.1]	10.87	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
561	2026-04-10	22h	22h-6h	Chaîne 8	[1.11, 1.14, 1.12, 1.14, 1.12, 1.14, 1.14, 1.13, 1.12, 1.11, 1.1, 1.13, 1.12, 1.13, 1.14, 1.12, 1.13, 1.14, 1.15, 1.12]	10.88	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
562	2026-04-10	6h	6h-14h	Chaîne 14	[1.11, 1.13, 1.11, 1.13, 1.1, 1.15, 1.15, 1.14, 1.11, 1.12, 1.13, 1.11, 1.1, 1.12, 1.15, 1.12]	10.85	5.48	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
563	2026-04-10	14h	14h-22h	Chaîne 14	[1.11, 1.14, 1.15, 1.11, 1.13, 1.15, 1.13, 1.11, 1.14, 1.11, 1.12, 1.11, 1.12, 1.12, 1.1, 1.11]	10.82	5.12	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
564	2026-04-10	22h	22h-6h	Chaîne 14	[1.14, 1.12, 1.11, 1.13, 1.12, 1.13, 1.14, 1.13, 1.11, 1.14, 1.12, 1.14, 1.12, 1.14, 1.14, 1.15]	11.18	5.24	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
565	2026-04-10	6h	6h-14h	Chaîne 15	[1.12, 1.14, 1.11, 1.11, 1.12, 1.12, 1.14, 1.11, 1.11, 1.12, 1.11, 1.12, 1.12, 1.11, 1.12, 1.13, 1.13, 1.15, 1.13, 1.13, 1.13, 1.13, 1.12, 1.13]	11.22	5.68	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
566	2026-04-10	14h	14h-22h	Chaîne 15	[1.13, 1.11, 1.14, 1.14, 1.15, 1.11, 1.15, 1.14, 1.1, 1.11, 1.12, 1.12, 1.14, 1.11, 1.13, 1.14, 1.13, 1.12, 1.12, 1.11, 1.15, 1.13, 1.11, 1.13]	11	5.33	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
567	2026-04-10	22h	22h-6h	Chaîne 15	[1.11, 1.1, 1.15, 1.15, 1.13, 1.11, 1.15, 1.14, 1.13, 1.12, 1.12, 1.12, 1.12, 1.11, 1.14, 1.15, 1.12, 1.14, 1.12, 1.12, 1.13, 1.1, 1.12, 1.15]	11.34	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
568	2026-04-10	6h	6h-14h	Chaîne 16	[1.12, 1.11, 1.13, 1.14, 1.12, 1.11, 1.11, 1.13, 1.13, 1.12, 1.15, 1.1, 1.15, 1.12, 1.14, 1.11, 1.11, 1.11, 1.14, 1.12, 1.15, 1.12, 1.13, 1.12]	11.12	5.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
569	2026-04-10	14h	14h-22h	Chaîne 16	[1.14, 1.11, 1.14, 1.13, 1.15, 1.1, 1.15, 1.13, 1.11, 1.13, 1.15, 1.12, 1.12, 1.13, 1.11, 1.1, 1.13, 1.14, 1.12, 1.15, 1.14, 1.15, 1.11, 1.11]	10.82	5.37	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
570	2026-04-10	22h	22h-6h	Chaîne 16	[1.14, 1.14, 1.12, 1.12, 1.13, 1.14, 1.14, 1.13, 1.12, 1.12, 1.14, 1.11, 1.15, 1.15, 1.11, 1.11, 1.13, 1.13, 1.11, 1.12, 1.11, 1.14, 1.15, 1.11]	10.85	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
571	2026-04-11	6h	6h-14h	Chaîne 8	[1.11, 1.11, 1.15, 1.15, 1.11, 1.13, 1.14, 1.14, 1.12, 1.15, 1.14, 1.15, 1.12, 1.15, 1.12, 1.11, 1.13, 1.13, 1.13, 1.11]	10.96	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
572	2026-04-11	14h	14h-22h	Chaîne 8	[1.14, 1.1, 1.14, 1.15, 1.14, 1.11, 1.14, 1.11, 1.12, 1.15, 1.15, 1.12, 1.13, 1.14, 1.11, 1.14, 1.12, 1.11, 1.12, 1.1]	10.74	5	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
573	2026-04-11	22h	22h-6h	Chaîne 8	[1.12, 1.15, 1.11, 1.11, 1.13, 1.12, 1.11, 1.1, 1.13, 1.14, 1.14, 1.13, 1.12, 1.13, 1.12, 1.14, 1.11, 1.13, 1.13, 1.15]	10.8	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
574	2026-04-11	6h	6h-14h	Chaîne 14	[1.13, 1.13, 1.15, 1.13, 1.14, 1.14, 1.14, 1.13, 1.12, 1.15, 1.12, 1.14, 1.14, 1.11, 1.14, 1.13]	10.89	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
575	2026-04-11	14h	14h-22h	Chaîne 14	[1.11, 1.13, 1.11, 1.12, 1.13, 1.11, 1.14, 1.11, 1.11, 1.13, 1.13, 1.1, 1.15, 1.11, 1.14, 1.11]	11.09	5.16	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
576	2026-04-11	22h	22h-6h	Chaîne 14	[1.11, 1.1, 1.1, 1.13, 1.12, 1.12, 1.1, 1.1, 1.14, 1.13, 1.14, 1.15, 1.13, 1.14, 1.11, 1.13]	10.8	5.14	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
577	2026-04-11	6h	6h-14h	Chaîne 15	[1.15, 1.13, 1.14, 1.14, 1.11, 1.14, 1.14, 1.13, 1.11, 1.12, 1.12, 1.15, 1.12, 1.13, 1.1, 1.1, 1.14, 1.15, 1.12, 1.14, 1.15, 1.1, 1.14, 1.11]	11.11	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
578	2026-04-11	14h	14h-22h	Chaîne 15	[1.11, 1.1, 1.15, 1.12, 1.12, 1.14, 1.14, 1.14, 1.14, 1.15, 1.15, 1.1, 1.12, 1.12, 1.12, 1.14, 1.15, 1.11, 1.13, 1.1, 1.13, 1.12, 1.13, 1.11]	11.17	5.67	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
579	2026-04-11	22h	22h-6h	Chaîne 15	[1.11, 1.12, 1.13, 1.14, 1.13, 1.12, 1.15, 1.13, 1.12, 1.13, 1.12, 1.12, 1.13, 1.11, 1.12, 1.1, 1.12, 1.12, 1.13, 1.11, 1.1, 1.1, 1.12, 1.14]	11.15	5.48	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
580	2026-04-11	6h	6h-14h	Chaîne 16	[1.14, 1.15, 1.13, 1.15, 1.15, 1.14, 1.12, 1.13, 1.15, 1.11, 1.12, 1.11, 1.1, 1.14, 1.12, 1.12, 1.11, 1.1, 1.13, 1.14, 1.13, 1.11, 1.1, 1.14]	10.91	5.02	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
581	2026-04-11	14h	14h-22h	Chaîne 16	[1.15, 1.14, 1.14, 1.12, 1.15, 1.11, 1.13, 1.13, 1.12, 1.14, 1.1, 1.12, 1.13, 1.1, 1.13, 1.11, 1.14, 1.12, 1.1, 1.13, 1.15, 1.1, 1.13, 1.11]	10.81	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
582	2026-04-11	22h	22h-6h	Chaîne 16	[1.15, 1.13, 1.14, 1.14, 1.11, 1.1, 1.12, 1.13, 1.15, 1.13, 1.11, 1.11, 1.12, 1.1, 1.15, 1.1, 1.15, 1.13, 1.15, 1.14, 1.1, 1.1, 1.14, 1.15]	11.16	5.4	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
583	2026-04-12	6h	6h-14h	Chaîne 8	[1.13, 1.12, 1.12, 1.14, 1.1, 1.12, 1.15, 1.14, 1.12, 1.14, 1.11, 1.1, 1.12, 1.14, 1.13, 1.13, 1.1, 1.12, 1.15, 1.14]	10.78	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
584	2026-04-12	14h	14h-22h	Chaîne 8	[1.12, 1.13, 1.11, 1.14, 1.12, 1.13, 1.11, 1.12, 1.11, 1.14, 1.1, 1.13, 1.14, 1.15, 1.15, 1.11, 1.12, 1.13, 1.11, 1.14]	10.86	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
585	2026-04-12	22h	22h-6h	Chaîne 8	[1.11, 1.14, 1.14, 1.12, 1.11, 1.14, 1.14, 1.12, 1.15, 1.12, 1.1, 1.14, 1.15, 1.12, 1.14, 1.12, 1.13, 1.11, 1.14, 1.11]	10.88	5.02	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
586	2026-04-12	6h	6h-14h	Chaîne 14	[1.11, 1.15, 1.13, 1.12, 1.1, 1.14, 1.15, 1.14, 1.12, 1.12, 1.12, 1.1, 1.15, 1.11, 1.13, 1.14]	11.21	5.47	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
587	2026-04-12	14h	14h-22h	Chaîne 14	[1.11, 1.11, 1.15, 1.15, 1.12, 1.13, 1.12, 1.13, 1.13, 1.11, 1.14, 1.14, 1.12, 1.12, 1.13, 1.11]	10.92	5.1	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
588	2026-04-12	22h	22h-6h	Chaîne 14	[1.14, 1.13, 1.11, 1.15, 1.14, 1.15, 1.12, 1.15, 1.1, 1.14, 1.14, 1.13, 1.1, 1.12, 1.12, 1.14]	11.19	5.38	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
589	2026-04-12	6h	6h-14h	Chaîne 15	[1.1, 1.14, 1.1, 1.12, 1.11, 1.11, 1.13, 1.1, 1.12, 1.14, 1.13, 1.13, 1.15, 1.13, 1.14, 1.1, 1.15, 1.11, 1.13, 1.11, 1.12, 1.14, 1.11, 1.14]	11.37	5.43	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
590	2026-04-12	14h	14h-22h	Chaîne 15	[1.11, 1.13, 1.1, 1.11, 1.13, 1.14, 1.13, 1.11, 1.13, 1.12, 1.14, 1.15, 1.13, 1.12, 1.1, 1.12, 1.1, 1.12, 1.12, 1.15, 1.1, 1.1, 1.13, 1.15]	11.41	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
591	2026-04-12	22h	22h-6h	Chaîne 15	[1.13, 1.11, 1.14, 1.11, 1.11, 1.14, 1.12, 1.13, 1.15, 1.14, 1.1, 1.12, 1.12, 1.14, 1.14, 1.12, 1.1, 1.11, 1.12, 1.1, 1.12, 1.15, 1.12, 1.11]	11.38	5.72	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
592	2026-04-12	6h	6h-14h	Chaîne 16	[1.11, 1.12, 1.1, 1.1, 1.14, 1.13, 1.13, 1.14, 1.14, 1.1, 1.11, 1.13, 1.15, 1.13, 1.12, 1.11, 1.1, 1.14, 1.11, 1.12, 1.12, 1.14, 1.13, 1.1]	11.03	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
593	2026-04-12	14h	14h-22h	Chaîne 16	[1.13, 1.11, 1.11, 1.14, 1.14, 1.12, 1.12, 1.11, 1.14, 1.12, 1.14, 1.11, 1.1, 1.13, 1.12, 1.12, 1.11, 1.11, 1.15, 1.14, 1.13, 1.11, 1.15, 1.11]	11.13	5.22	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
594	2026-04-12	22h	22h-6h	Chaîne 16	[1.13, 1.1, 1.15, 1.13, 1.11, 1.13, 1.12, 1.1, 1.12, 1.1, 1.11, 1.11, 1.12, 1.13, 1.12, 1.13, 1.14, 1.14, 1.13, 1.12, 1.15, 1.11, 1.13, 1.12]	10.85	5.26	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
595	2026-04-13	6h	6h-14h	Chaîne 14	[1.14, 1.13, 1.15, 1.11, 1.14, 1.12, 1.1, 1.11, 1.11, 1.11, 1.11, 1.15, 1.15, 1.11, 1.15, 1.1]	11	5.23	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
596	2026-04-13	14h	14h-22h	Chaîne 14	[1.15, 1.13, 1.14, 1.14, 1.13, 1.14, 1.14, 1.11, 1.13, 1.15, 1.11, 1.14, 1.11, 1.14, 1.11, 1.12]	11.11	5.12	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
597	2026-04-13	22h	22h-6h	Chaîne 14	[1.14, 1.12, 1.12, 1.1, 1.15, 1.1, 1.14, 1.13, 1.15, 1.12, 1.12, 1.12, 1.13, 1.13, 1.11, 1.14]	11.11	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
598	2026-04-13	6h	6h-14h	Chaîne 15	[1.1, 1.15, 1.13, 1.15, 1.11, 1.15, 1.1, 1.11, 1.15, 1.13, 1.11, 1.13, 1.12, 1.11, 1.1, 1.14, 1.15, 1.12, 1.1, 1.1, 1.12, 1.14, 1.15, 1.12]	11.01	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
599	2026-04-13	14h	14h-22h	Chaîne 15	[1.12, 1.1, 1.13, 1.14, 1.14, 1.12, 1.1, 1.15, 1.12, 1.11, 1.12, 1.14, 1.14, 1.13, 1.12, 1.12, 1.13, 1.11, 1.11, 1.14, 1.12, 1.12, 1.14, 1.1]	11.04	5.53	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
600	2026-04-13	22h	22h-6h	Chaîne 15	[1.11, 1.13, 1.13, 1.14, 1.1, 1.14, 1.15, 1.13, 1.13, 1.1, 1.13, 1.12, 1.13, 1.14, 1.15, 1.14, 1.13, 1.13, 1.12, 1.11, 1.13, 1.14, 1.14, 1.14]	11.22	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
601	2026-04-13	6h	6h-14h	Chaîne 16	[1.1, 1.14, 1.12, 1.13, 1.12, 1.1, 1.15, 1.11, 1.14, 1.14, 1.12, 1.2, 1.13, 1.21, 1.14, 1.12, 1.14, 1.14, 1.09, 1.14, 1.15, 1.15, 1.12, 1.11]	11.2	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
602	2026-04-13	14h	14h-22h	Chaîne 16	[1.11, 1.12, 1.11, 1.14, 1.12, 1.09, 1.12, 1.18, 1.11, 1.15, 1.1, 1.14, 1.11, 1.18, 1.14, 1.13, 1.11, 1.11, 1.11, 1.14, 1.1, 1.13, 1.11, 1.13]	11.19	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
603	2026-04-13	22h	22h-6h	Chaîne 16	[1.13, 1.1, 1.15, 1.11, 1.07, 1.12, 1.15, 1.16, 1.14, 1.12, 1.15, 1.14, 1.11, 1.14, 1.09, 1.13, 1.1, 1.12, 1.13, 1.11, 1.13, 1.14, 1.1, 1.17]	10.84	5.04	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
604	2026-04-14	6h	6h-14h	Chaîne 8	[1.15, 1.1, 1.15, 1.12, 1.13, 1.14, 1.1, 1.11, 1.12, 1.14, 1.11, 1.12, 1.13, 1.11, 1.13, 1.14, 1.14, 1.11, 1.12, 1.14]	10.99	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
605	2026-04-14	14h	14h-22h	Chaîne 8	[1.15, 1.1, 1.13, 1.13, 1.13, 1.12, 1.11, 1.11, 1.12, 1.13, 1.14, 1.14, 1.13, 1.15, 1.11, 1.11, 1.13, 1.14, 1.11, 1.13]	10.89	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
606	2026-04-14	22h	22h-6h	Chaîne 8	[1.11, 1.12, 1.1, 1.12, 1.1, 1.12, 1.15, 1.13, 1.12, 1.13, 1.12, 1.12, 1.15, 1.14, 1.14, 1.14, 1.11, 1.1, 1.1, 1.11]	10.92	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
607	2026-04-14	6h	6h-14h	Chaîne 15	[1.11, 1.12, 1.11, 1.11, 1.15, 1.15, 1.15, 1.15, 1.11, 1.11, 1.14, 1.1, 1.11, 1.13, 1.11, 1.11, 1.13, 1.13, 1.14, 1.11, 1.14, 1.15, 1.13, 1.11]	11.22	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
608	2026-04-14	14h	14h-22h	Chaîne 15	[1.14, 1.13, 1.14, 1.14, 1.11, 1.14, 1.11, 1.1, 1.12, 1.14, 1.11, 1.14, 1.1, 1.13, 1.11, 1.13, 1.12, 1.11, 1.13, 1.11, 1.14, 1.1, 1.14, 1.11]	11.14	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
609	2026-04-14	22h	22h-6h	Chaîne 15	[1.12, 1.12, 1.11, 1.1, 1.11, 1.13, 1.1, 1.1, 1.15, 1.11, 1.1, 1.14, 1.13, 1.12, 1.11, 1.13, 1.13, 1.13, 1.12, 1.15, 1.13, 1.12, 1.12, 1.14]	11.15	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
610	2026-04-14	6h	6h-14h	Chaîne 16	[1.11, 1.13, 1.11, 1.1, 1.11, 1.11, 1.14, 1.15, 1.13, 1.12, 1.13, 1.12, 1.1, 1.15, 1.12, 1.1, 1.12, 1.14, 1.11, 1.14, 1.15, 1.11, 1.12, 1.12]	10.81	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
611	2026-04-14	14h	14h-22h	Chaîne 16	[1.11, 1.13, 1.13, 1.15, 1.13, 1.11, 1.13, 1.13, 1.12, 1.12, 1.1, 1.13, 1.14, 1.13, 1.12, 1.11, 1.11, 1.11, 1.13, 1.12, 1.1, 1.12, 1.14, 1.11]	10.96	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
612	2026-04-14	22h	22h-6h	Chaîne 16	[1.13, 1.14, 1.12, 1.11, 1.12, 1.12, 1.12, 1.15, 1.12, 1.11, 1.14, 1.12, 1.15, 1.11, 1.12, 1.1, 1.11, 1.12, 1.11, 1.11, 1.13, 1.12, 1.11, 1.12]	11.21	5.19	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
613	2026-04-15	6h	6h-14h	Chaîne 8	[1.12, 1.12, 1.1, 1.12, 1.11, 1.13, 1.12, 1.13, 1.12, 1.11, 1.1, 1.12, 1.11, 1.13, 1.14, 1.14, 1.14, 1.13, 1.12, 1.11]	10.75	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
614	2026-04-15	14h	14h-22h	Chaîne 8	[1.14, 1.12, 1.11, 1.13, 1.13, 1.11, 1.13, 1.14, 1.15, 1.11, 1.13, 1.11, 1.13, 1.11, 1.12, 1.1, 1.14, 1.14, 1.13, 1.11]	10.68	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
615	2026-04-15	22h	22h-6h	Chaîne 8	[1.14, 1.13, 1.15, 1.1, 1.11, 1.15, 1.15, 1.14, 1.12, 1.1, 1.11, 1.14, 1.14, 1.12, 1.12, 1.14, 1.12, 1.11, 1.14, 1.12]	10.83	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
616	2026-04-15	6h	6h-14h	Chaîne 14	[1.1, 1.14, 1.11, 1.1, 1.1, 1.14, 1.14, 1.11, 1.14, 1.11, 1.14, 1.12, 1.12, 1.12, 1.14, 1.12]	11.03	5.45	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
617	2026-04-15	14h	14h-22h	Chaîne 14	[1.1, 1.14, 1.13, 1.11, 1.13, 1.12, 1.11, 1.1, 1.15, 1.13, 1.1, 1.11, 1.14, 1.11, 1.12, 1.15]	10.81	5.33	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
618	2026-04-15	22h	22h-6h	Chaîne 14	[1.14, 1.12, 1.14, 1.13, 1.13, 1.14, 1.13, 1.1, 1.13, 1.15, 1.15, 1.12, 1.14, 1.11, 1.14, 1.12]	10.83	5.22	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
619	2026-04-15	6h	6h-14h	Chaîne 16	[1.13, 1.15, 1.12, 1.12, 1.12, 1.12, 1.14, 1.15, 1.11, 1.11, 1.13, 1.11, 1.14, 1.1, 1.1, 1.12, 1.13, 1.11, 1.11, 1.1, 1.1, 1.11, 1.12, 1.12]	10.94	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
620	2026-04-15	14h	14h-22h	Chaîne 16	[1.12, 1.14, 1.11, 1.14, 1.11, 1.13, 1.11, 1.1, 1.15, 1.15, 1.14, 1.13, 1.11, 1.12, 1.11, 1.11, 1.14, 1.15, 1.11, 1.11, 1.11, 1.1, 1.15, 1.13]	10.97	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
621	2026-04-15	22h	22h-6h	Chaîne 16	[1.12, 1.14, 1.12, 1.14, 1.13, 1.13, 1.14, 1.15, 1.14, 1.12, 1.13, 1.12, 1.14, 1.12, 1.13, 1.14, 1.15, 1.11, 1.11, 1.12, 1.13, 1.11, 1.14, 1.12]	10.84	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
622	2026-04-16	6h	6h-14h	Chaîne 8	[1.12, 1.12, 1.13, 1.14, 1.15, 1.14, 1.11, 1.11, 1.11, 1.11, 1.13, 1.15, 1.14, 1.1, 1.1, 1.15, 1.11, 1.12, 1.13, 1.11]	10.6	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
623	2026-04-16	14h	14h-22h	Chaîne 8	[1.14, 1.11, 1.1, 1.13, 1.11, 1.11, 1.11, 1.15, 1.13, 1.13, 1.11, 1.12, 1.14, 1.14, 1.12, 1.11, 1.11, 1.12, 1.12, 1.11]	10.97	5.18	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
624	2026-04-16	22h	22h-6h	Chaîne 8	[1.13, 1.13, 1.14, 1.11, 1.11, 1.14, 1.13, 1.14, 1.11, 1.11, 1.12, 1.14, 1.14, 1.12, 1.14, 1.12, 1.13, 1.15, 1.1, 1.12]	10.75	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
625	2026-04-16	6h	6h-14h	Chaîne 14	[1.12, 1.11, 1.14, 1.11, 1.12, 1.13, 1.11, 1.14, 1.14, 1.12, 1.11, 1.12, 1.12, 1.12, 1.11, 1.15]	11.12	5.22	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
626	2026-04-16	14h	14h-22h	Chaîne 14	[1.11, 1.13, 1.11, 1.12, 1.14, 1.15, 1.12, 1.1, 1.13, 1.12, 1.13, 1.13, 1.11, 1.11, 1.13, 1.14]	10.79	5.24	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
627	2026-04-16	22h	22h-6h	Chaîne 14	[1.1, 1.13, 1.12, 1.11, 1.14, 1.11, 1.13, 1.14, 1.1, 1.13, 1.14, 1.11, 1.14, 1.1, 1.13, 1.11]	10.81	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
628	2026-04-16	6h	6h-14h	Chaîne 15	[1.12, 1.12, 1.12, 1.12, 1.14, 1.11, 1.13, 1.13, 1.11, 1.13, 1.12, 1.15, 1.14, 1.14, 1.13, 1.1, 1.12, 1.13, 1.13, 1.15, 1.12, 1.13, 1.11, 1.12]	11.03	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
629	2026-04-16	14h	14h-22h	Chaîne 15	[1.11, 1.13, 1.11, 1.11, 1.15, 1.14, 1.11, 1.11, 1.1, 1.13, 1.1, 1.11, 1.11, 1.11, 1.15, 1.11, 1.12, 1.13, 1.14, 1.14, 1.14, 1.11, 1.12, 1.13]	11.31	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
630	2026-04-16	22h	22h-6h	Chaîne 15	[1.14, 1.1, 1.11, 1.12, 1.12, 1.14, 1.14, 1.14, 1.1, 1.12, 1.11, 1.11, 1.12, 1.13, 1.11, 1.1, 1.12, 1.1, 1.14, 1.11, 1.14, 1.14, 1.13, 1.1]	11.27	5.51	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
631	2026-04-17	6h	6h-14h	Chaîne 8	[1.14, 1.13, 1.12, 1.14, 1.15, 1.11, 1.12, 1.15, 1.1, 1.12, 1.11, 1.13, 1.13, 1.14, 1.14, 1.12, 1.12, 1.11, 1.12, 1.12]	10.95	5.41	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
632	2026-04-17	14h	14h-22h	Chaîne 8	[1.14, 1.14, 1.11, 1.14, 1.12, 1.13, 1.14, 1.13, 1.12, 1.15, 1.14, 1.14, 1.12, 1.14, 1.12, 1.1, 1.1, 1.14, 1.14, 1.14]	10.89	5.06	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
633	2026-04-17	22h	22h-6h	Chaîne 8	[1.15, 1.11, 1.15, 1.13, 1.12, 1.13, 1.13, 1.13, 1.11, 1.13, 1.12, 1.12, 1.14, 1.1, 1.14, 1.14, 1.14, 1.12, 1.13, 1.14]	10.62	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
634	2026-04-17	6h	6h-14h	Chaîne 14	[1.15, 1.12, 1.11, 1.11, 1.12, 1.13, 1.14, 1.14, 1.14, 1.13, 1.13, 1.12, 1.13, 1.11, 1.13, 1.12]	10.92	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
635	2026-04-17	14h	14h-22h	Chaîne 14	[1.12, 1.13, 1.13, 1.14, 1.11, 1.11, 1.15, 1.11, 1.13, 1.13, 1.12, 1.12, 1.11, 1.14, 1.13, 1.13]	11.12	5.28	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
636	2026-04-17	22h	22h-6h	Chaîne 14	[1.13, 1.13, 1.13, 1.12, 1.1, 1.15, 1.11, 1.14, 1.1, 1.12, 1.15, 1.1, 1.12, 1.13, 1.15, 1.1]	10.79	5.21	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
637	2026-04-17	6h	6h-14h	Chaîne 15	[1.14, 1.12, 1.12, 1.14, 1.13, 1.13, 1.14, 1.11, 1.14, 1.15, 1.13, 1.12, 1.14, 1.1, 1.15, 1.12, 1.12, 1.1, 1.1, 1.1, 1.12, 1.12, 1.13, 1.11]	11.22	5.52	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
638	2026-04-17	14h	14h-22h	Chaîne 15	[1.14, 1.15, 1.13, 1.14, 1.11, 1.12, 1.1, 1.14, 1.15, 1.15, 1.13, 1.13, 1.11, 1.14, 1.14, 1.1, 1.13, 1.11, 1.12, 1.13, 1.1, 1.11, 1.11, 1.15]	11.02	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
639	2026-04-17	22h	22h-6h	Chaîne 15	[1.11, 1.15, 1.12, 1.14, 1.11, 1.12, 1.12, 1.13, 1.14, 1.11, 1.15, 1.14, 1.11, 1.14, 1.11, 1.1, 1.11, 1.15, 1.13, 1.11, 1.14, 1.11, 1.12, 1.15]	11.38	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
640	2026-04-17	6h	6h-14h	Chaîne 16	[1.12, 1.12, 1.1, 1.11, 1.12, 1.12, 1.11, 1.14, 1.14, 1.13, 1.1, 1.11, 1.11, 1.11, 1.1, 1.14, 1.15, 1.14, 1.11, 1.14, 1.11, 1.15, 1.12, 1.12]	11.15	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
641	2026-04-17	14h	14h-22h	Chaîne 16	[1.11, 1.14, 1.11, 1.14, 1.11, 1.11, 1.13, 1.12, 1.13, 1.12, 1.1, 1.15, 1.13, 1.13, 1.12, 1.13, 1.11, 1.12, 1.11, 1.11, 1.12, 1.11, 1.14, 1.11]	10.92	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
642	2026-04-17	22h	22h-6h	Chaîne 16	[1.12, 1.11, 1.14, 1.13, 1.1, 1.11, 1.13, 1.1, 1.11, 1.13, 1.12, 1.14, 1.1, 1.11, 1.14, 1.13, 1.13, 1.11, 1.15, 1.13, 1.13, 1.14, 1.14, 1.13]	11.04	5.28	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
643	2026-04-18	6h	6h-14h	Chaîne 8	[1.13, 1.12, 1.14, 1.11, 1.12, 1.11, 1.14, 1.14, 1.1, 1.13, 1.14, 1.12, 1.13, 1.11, 1.11, 1.12, 1.1, 1.12, 1.14, 1.15]	10.88	5.12	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
644	2026-04-18	14h	14h-22h	Chaîne 8	[1.14, 1.11, 1.15, 1.1, 1.13, 1.13, 1.1, 1.1, 1.1, 1.13, 1.12, 1.11, 1.1, 1.15, 1.14, 1.13, 1.12, 1.1, 1.1, 1.13]	10.85	5.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
645	2026-04-18	22h	22h-6h	Chaîne 8	[1.14, 1.13, 1.12, 1.12, 1.11, 1.15, 1.12, 1.14, 1.12, 1.13, 1.13, 1.14, 1.11, 1.13, 1.11, 1.13, 1.11, 1.1, 1.14, 1.12]	10.81	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
646	2026-04-18	6h	6h-14h	Chaîne 14	[1.14, 1.12, 1.15, 1.14, 1.13, 1.15, 1.11, 1.12, 1.1, 1.11, 1.15, 1.12, 1.14, 1.11, 1.15, 1.15]	10.86	5.35	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
647	2026-04-18	14h	14h-22h	Chaîne 14	[1.13, 1.15, 1.14, 1.1, 1.15, 1.12, 1.1, 1.14, 1.14, 1.13, 1.15, 1.15, 1.14, 1.13, 1.11, 1.11]	11.02	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
648	2026-04-18	22h	22h-6h	Chaîne 14	[1.13, 1.14, 1.13, 1.1, 1.14, 1.15, 1.1, 1.14, 1.12, 1.11, 1.12, 1.14, 1.11, 1.13, 1.14, 1.1]	11.14	5.25	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
649	2026-04-18	6h	6h-14h	Chaîne 15	[1.13, 1.13, 1.12, 1.13, 1.11, 1.13, 1.11, 1.11, 1.1, 1.11, 1.11, 1.12, 1.12, 1.15, 1.15, 1.14, 1.13, 1.11, 1.14, 1.11, 1.12, 1.11, 1.12, 1.14]	11.13	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
650	2026-04-18	14h	14h-22h	Chaîne 15	[1.15, 1.1, 1.13, 1.11, 1.13, 1.1, 1.12, 1.12, 1.12, 1.13, 1.13, 1.12, 1.14, 1.11, 1.12, 1.11, 1.15, 1.13, 1.13, 1.14, 1.15, 1.12, 1.11, 1.1]	11.12	5.66	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
651	2026-04-18	22h	22h-6h	Chaîne 15	[1.11, 1.14, 1.13, 1.1, 1.14, 1.13, 1.13, 1.15, 1.12, 1.14, 1.12, 1.14, 1.13, 1.11, 1.14, 1.1, 1.12, 1.11, 1.11, 1.13, 1.1, 1.12, 1.11, 1.11]	11.06	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
652	2026-04-18	6h	6h-14h	Chaîne 16	[1.11, 1.12, 1.11, 1.1, 1.12, 1.14, 1.12, 1.12, 1.13, 1.14, 1.13, 1.13, 1.15, 1.15, 1.13, 1.11, 1.13, 1.14, 1.15, 1.13, 1.14, 1.14, 1.14, 1.12]	10.9	5.04	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
653	2026-04-18	14h	14h-22h	Chaîne 16	[1.13, 1.12, 1.13, 1.13, 1.11, 1.11, 1.12, 1.14, 1.11, 1.14, 1.14, 1.11, 1.15, 1.13, 1.14, 1.15, 1.13, 1.11, 1.12, 1.13, 1.12, 1.13, 1.14, 1.11]	10.83	5.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
654	2026-04-18	22h	22h-6h	Chaîne 16	[1.13, 1.13, 1.12, 1.1, 1.13, 1.12, 1.12, 1.14, 1.15, 1.15, 1.1, 1.14, 1.14, 1.11, 1.1, 1.1, 1.13, 1.12, 1.11, 1.11, 1.11, 1.1, 1.14, 1.12]	11.18	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
655	2026-04-19	6h	6h-14h	Chaîne 8	[1.14, 1.12, 1.15, 1.15, 1.11, 1.11, 1.15, 1.1, 1.14, 1.13, 1.11, 1.12, 1.11, 1.15, 1.12, 1.11, 1.12, 1.15, 1.14, 1.14]	10.82	5.02	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
656	2026-04-19	14h	14h-22h	Chaîne 8	[1.12, 1.13, 1.1, 1.12, 1.1, 1.1, 1.13, 1.12, 1.13, 1.1, 1.15, 1.14, 1.1, 1.12, 1.14, 1.12, 1.14, 1.14, 1.1, 1.12]	10.81	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
657	2026-04-19	22h	22h-6h	Chaîne 8	[1.13, 1.1, 1.14, 1.11, 1.12, 1.11, 1.14, 1.13, 1.11, 1.1, 1.11, 1.14, 1.13, 1.14, 1.12, 1.1, 1.12, 1.11, 1.11, 1.14]	10.8	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
658	2026-04-19	6h	6h-14h	Chaîne 14	[1.1, 1.14, 1.12, 1.12, 1.12, 1.15, 1.11, 1.11, 1.12, 1.14, 1.15, 1.11, 1.12, 1.1, 1.12, 1.11]	11.03	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
659	2026-04-19	14h	14h-22h	Chaîne 14	[1.12, 1.14, 1.14, 1.12, 1.1, 1.13, 1.12, 1.13, 1.12, 1.11, 1.11, 1.12, 1.13, 1.13, 1.12, 1.13]	10.79	5.2	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
660	2026-04-19	22h	22h-6h	Chaîne 14	[1.13, 1.12, 1.15, 1.13, 1.14, 1.11, 1.12, 1.14, 1.15, 1.14, 1.14, 1.14, 1.14, 1.11, 1.13, 1.14]	10.95	5.14	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
661	2026-04-19	6h	6h-14h	Chaîne 15	[1.14, 1.13, 1.1, 1.13, 1.13, 1.12, 1.13, 1.13, 1.06, 1.12, 1.1, 1.13, 1.14, 1.19, 1.08, 1.14, 1.09, 1.12, 1.15, 1.13, 1.14, 1.14, 1.15, 1.11]	11.09	5.5	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
662	2026-04-19	14h	14h-22h	Chaîne 15	[1.13, 1.12, 1.14, 1.14, 1.15, 1.12, 1.13, 1.13, 1.1, 1.13, 1.14, 1.13, 1.1, 1.11, 1.22, 1.1, 1.13, 1.14, 1.21, 1.13, 1.14, 1.11, 1.11, 1.2]	11.32	5.28	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
663	2026-04-19	22h	22h-6h	Chaîne 15	[1.15, 1.13, 1.21, 1.11, 1.11, 1.1, 1.14, 1.15, 1.1, 1.1, 1.14, 1.16, 1.13, 1.13, 1.12, 1.11, 1.13, 1.14, 1.15, 1.12, 1.15, 1.11, 1.11, 1.14]	11	5.69	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
664	2026-04-19	6h	6h-14h	Chaîne 16	[1.13, 1.11, 1.13, 1.1, 1.11, 1.14, 1.15, 1.13, 1.11, 1.11, 1.11, 1.12, 1.15, 1.11, 1.1, 1.15, 1.12, 1.1, 1.12, 1.14, 1.12, 1.13, 1.15, 1.12]	10.97	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
665	2026-04-19	14h	14h-22h	Chaîne 16	[1.13, 1.15, 1.13, 1.11, 1.14, 1.11, 1.11, 1.12, 1.1, 1.11, 1.13, 1.12, 1.13, 1.11, 1.14, 1.12, 1.14, 1.1, 1.13, 1.11, 1.11, 1.12, 1.1, 1.11]	10.98	5	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
666	2026-04-19	22h	22h-6h	Chaîne 16	[1.13, 1.1, 1.1, 1.1, 1.15, 1.15, 1.14, 1.1, 1.14, 1.12, 1.12, 1.15, 1.14, 1.14, 1.15, 1.11, 1.12, 1.1, 1.14, 1.13, 1.14, 1.15, 1.12, 1.11]	11.18	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
667	2026-04-20	6h	6h-14h	Chaîne 14	[1.11, 1.12, 1.11, 1.13, 1.14, 1.13, 1.11, 1.12, 1.1, 1.12, 1.12, 1.14, 1.15, 1.15, 1.14, 1.15]	10.82	5.51	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
668	2026-04-20	14h	14h-22h	Chaîne 14	[1.14, 1.11, 1.12, 1.1, 1.11, 1.1, 1.11, 1.1, 1.12, 1.15, 1.14, 1.12, 1.13, 1.15, 1.15, 1.11]	11.02	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
669	2026-04-20	22h	22h-6h	Chaîne 14	[1.12, 1.13, 1.14, 1.13, 1.14, 1.11, 1.11, 1.14, 1.1, 1.12, 1.13, 1.14, 1.13, 1.1, 1.11, 1.13]	11.02	5.49	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
670	2026-04-20	6h	6h-14h	Chaîne 15	[1.13, 1.11, 1.14, 1.13, 1.11, 1.1, 1.13, 1.13, 1.12, 1.1, 1.12, 1.11, 1.14, 1.12, 1.1, 1.11, 1.1, 1.1, 1.14, 1.12, 1.11, 1.14, 1.1, 1.14]	11.17	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
671	2026-04-20	14h	14h-22h	Chaîne 15	[1.14, 1.13, 1.13, 1.1, 1.1, 1.11, 1.15, 1.11, 1.13, 1.13, 1.13, 1.13, 1.15, 1.1, 1.14, 1.1, 1.1, 1.11, 1.15, 1.14, 1.11, 1.14, 1.12, 1.1]	11.35	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
672	2026-04-20	22h	22h-6h	Chaîne 15	[1.12, 1.14, 1.15, 1.15, 1.14, 1.11, 1.13, 1.11, 1.15, 1.12, 1.13, 1.14, 1.15, 1.13, 1.1, 1.15, 1.12, 1.12, 1.11, 1.11, 1.12, 1.11, 1.13, 1.14]	11.37	5.35	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
673	2026-04-20	6h	6h-14h	Chaîne 16	[1.13, 1.13, 1.14, 1.12, 1.14, 1.11, 1.11, 1.13, 1.14, 1.13, 1.12, 1.12, 1.14, 1.13, 1.12, 1.14, 1.1, 1.14, 1.13, 1.11, 1.15, 1.11, 1.11, 1.1]	10.83	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
674	2026-04-20	14h	14h-22h	Chaîne 16	[1.14, 1.11, 1.12, 1.11, 1.15, 1.11, 1.13, 1.14, 1.12, 1.13, 1.12, 1.12, 1.12, 1.12, 1.12, 1.12, 1.12, 1.13, 1.1, 1.13, 1.11, 1.13, 1.15, 1.15]	10.89	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
675	2026-04-20	22h	22h-6h	Chaîne 16	[1.12, 1.1, 1.11, 1.1, 1.15, 1.14, 1.13, 1.11, 1.14, 1.11, 1.11, 1.14, 1.11, 1.13, 1.11, 1.11, 1.13, 1.11, 1.1, 1.1, 1.12, 1.11, 1.12, 1.14]	10.91	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
676	2026-04-21	6h	6h-14h	Chaîne 8	[1.15, 1.13, 1.12, 1.14, 1.11, 1.14, 1.13, 1.12, 1.12, 1.1, 1.1, 1.1, 1.11, 1.14, 1.15, 1.12, 1.14, 1.11, 1.13, 1.14]	10.89	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
677	2026-04-21	14h	14h-22h	Chaîne 8	[1.15, 1.15, 1.12, 1.1, 1.11, 1.12, 1.13, 1.13, 1.12, 1.11, 1.12, 1.15, 1.1, 1.13, 1.13, 1.11, 1.14, 1.1, 1.11, 1.11]	10.96	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
678	2026-04-21	22h	22h-6h	Chaîne 8	[1.1, 1.13, 1.11, 1.12, 1.11, 1.13, 1.13, 1.13, 1.11, 1.13, 1.1, 1.1, 1.12, 1.15, 1.13, 1.14, 1.14, 1.11, 1.1, 1.12]	10.61	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
679	2026-04-21	6h	6h-14h	Chaîne 15	[1.14, 1.13, 1.11, 1.15, 1.14, 1.14, 1.15, 1.11, 1.13, 1.15, 1.12, 1.13, 1.12, 1.11, 1.14, 1.12, 1.13, 1.12, 1.1, 1.14, 1.13, 1.14, 1.13, 1.15]	11.17	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
680	2026-04-21	14h	14h-22h	Chaîne 15	[1.15, 1.13, 1.11, 1.11, 1.12, 1.1, 1.15, 1.13, 1.12, 1.15, 1.14, 1.12, 1.13, 1.14, 1.12, 1.1, 1.12, 1.13, 1.12, 1.14, 1.12, 1.11, 1.14, 1.13]	10.98	5.63	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
681	2026-04-21	22h	22h-6h	Chaîne 15	[1.11, 1.14, 1.11, 1.13, 1.12, 1.11, 1.1, 1.12, 1.12, 1.14, 1.12, 1.11, 1.12, 1.12, 1.1, 1.11, 1.13, 1.13, 1.11, 1.11, 1.13, 1.13, 1.11, 1.12]	11.31	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
682	2026-04-21	6h	6h-14h	Chaîne 16	[1.15, 1.14, 1.1, 1.15, 1.14, 1.11, 1.12, 1.12, 1.1, 1.12, 1.1, 1.1, 1.12, 1.14, 1.1, 1.11, 1.15, 1.12, 1.11, 1.14, 1.1, 1.12, 1.1, 1.1]	11.18	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
683	2026-04-21	14h	14h-22h	Chaîne 16	[1.13, 1.14, 1.12, 1.11, 1.13, 1.13, 1.15, 1.1, 1.12, 1.15, 1.11, 1.11, 1.12, 1.14, 1.14, 1.13, 1.11, 1.13, 1.14, 1.11, 1.12, 1.11, 1.14, 1.11]	11.16	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
684	2026-04-21	22h	22h-6h	Chaîne 16	[1.14, 1.14, 1.12, 1.13, 1.14, 1.12, 1.11, 1.13, 1.12, 1.11, 1.12, 1.13, 1.13, 1.12, 1.12, 1.1, 1.14, 1.12, 1.14, 1.12, 1.12, 1.12, 1.12, 1.14]	11.12	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
685	2026-04-22	6h	6h-14h	Chaîne 8	[1.12, 1.14, 1.11, 1.14, 1.13, 1.11, 1.13, 1.15, 1.13, 1.11, 1.11, 1.15, 1.11, 1.11, 1.15, 1.11, 1.1, 1.11, 1.12, 1.13]	10.6	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
686	2026-04-22	14h	14h-22h	Chaîne 8	[1.14, 1.13, 1.14, 1.14, 1.11, 1.14, 1.13, 1.14, 1.11, 1.14, 1.11, 1.11, 1.15, 1.13, 1.11, 1.14, 1.1, 1.13, 1.14, 1.15]	10.93	5.28	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
687	2026-04-22	22h	22h-6h	Chaîne 8	[1.12, 1.14, 1.13, 1.11, 1.1, 1.11, 1.15, 1.12, 1.1, 1.12, 1.13, 1.11, 1.1, 1.1, 1.11, 1.14, 1.11, 1.1, 1.11, 1.12]	10.78	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
688	2026-04-22	6h	6h-14h	Chaîne 14	[1.12, 1.15, 1.12, 1.11, 1.14, 1.13, 1.12, 1.12, 1.14, 1.11, 1.1, 1.13, 1.11, 1.14, 1.11, 1.1]	10.94	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
689	2026-04-22	14h	14h-22h	Chaîne 14	[1.11, 1.12, 1.1, 1.1, 1.11, 1.14, 1.11, 1.13, 1.11, 1.13, 1.1, 1.14, 1.12, 1.13, 1.13, 1.11]	10.85	5.13	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
690	2026-04-22	22h	22h-6h	Chaîne 14	[1.13, 1.14, 1.13, 1.11, 1.11, 1.15, 1.1, 1.14, 1.12, 1.1, 1.12, 1.12, 1.13, 1.15, 1.14, 1.14]	10.88	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
691	2026-04-22	6h	6h-14h	Chaîne 16	[1.11, 1.14, 1.13, 1.14, 1.12, 1.12, 1.11, 1.14, 1.11, 1.12, 1.13, 1.14, 1.12, 1.15, 1.14, 1.13, 1.12, 1.12, 1.14, 1.12, 1.13, 1.11, 1.14, 1.1]	11.01	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
692	2026-04-22	14h	14h-22h	Chaîne 16	[1.13, 1.11, 1.11, 1.1, 1.14, 1.11, 1.11, 1.15, 1.1, 1.13, 1.11, 1.1, 1.1, 1.14, 1.12, 1.11, 1.13, 1.1, 1.12, 1.1, 1.15, 1.14, 1.14, 1.1]	10.91	5.06	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
693	2026-04-22	22h	22h-6h	Chaîne 16	[1.13, 1.11, 1.14, 1.13, 1.11, 1.11, 1.14, 1.1, 1.15, 1.11, 1.14, 1.13, 1.12, 1.1, 1.13, 1.12, 1.13, 1.12, 1.11, 1.11, 1.13, 1.12, 1.14, 1.12]	11.05	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
694	2026-04-23	6h	6h-14h	Chaîne 8	[1.12, 1.12, 1.12, 1.11, 1.11, 1.11, 1.15, 1.14, 1.14, 1.11, 1.13, 1.14, 1.11, 1.14, 1.15, 1.11, 1.15, 1.14, 1.12, 1.11]	10.72	5.18	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
695	2026-04-23	14h	14h-22h	Chaîne 8	[1.14, 1.12, 1.13, 1.14, 1.13, 1.11, 1.15, 1.14, 1.14, 1.14, 1.12, 1.14, 1.11, 1.13, 1.1, 1.1, 1.14, 1.13, 1.13, 1.11]	10.74	5.39	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
696	2026-04-23	22h	22h-6h	Chaîne 8	[1.12, 1.12, 1.11, 1.14, 1.13, 1.12, 1.14, 1.1, 1.12, 1.11, 1.13, 1.14, 1.12, 1.14, 1.12, 1.13, 1.11, 1.12, 1.11, 1.12]	10.92	5.06	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
697	2026-04-23	6h	6h-14h	Chaîne 14	[1.11, 1.1, 1.14, 1.11, 1.14, 1.13, 1.14, 1.1, 1.14, 1.12, 1.1, 1.13, 1.1, 1.12, 1.13, 1.12]	11.06	5.22	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
698	2026-04-23	14h	14h-22h	Chaîne 14	[1.14, 1.15, 1.12, 1.12, 1.14, 1.14, 1.11, 1.14, 1.14, 1.12, 1.15, 1.15, 1.14, 1.12, 1.11, 1.13]	11.1	5.12	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
699	2026-04-23	22h	22h-6h	Chaîne 14	[1.14, 1.12, 1.1, 1.12, 1.14, 1.13, 1.1, 1.15, 1.12, 1.14, 1.12, 1.12, 1.1, 1.14, 1.12, 1.15]	11.09	5.33	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
700	2026-04-23	6h	6h-14h	Chaîne 15	[1.13, 1.11, 1.14, 1.12, 1.14, 1.12, 1.13, 1.11, 1.1, 1.1, 1.13, 1.13, 1.13, 1.12, 1.13, 1.12, 1.13, 1.14, 1.12, 1.14, 1.13, 1.11, 1.13, 1.11]	11.19	5.63	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
701	2026-04-23	14h	14h-22h	Chaîne 15	[1.14, 1.13, 1.13, 1.11, 1.11, 1.12, 1.11, 1.14, 1.12, 1.14, 1.1, 1.14, 1.13, 1.12, 1.12, 1.11, 1.14, 1.14, 1.12, 1.11, 1.15, 1.13, 1.14, 1.12]	11.33	5.56	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
702	2026-04-23	22h	22h-6h	Chaîne 15	[1.13, 1.12, 1.12, 1.14, 1.11, 1.14, 1.12, 1.12, 1.15, 1.1, 1.12, 1.14, 1.13, 1.11, 1.13, 1.11, 1.11, 1.13, 1.13, 1.15, 1.11, 1.14, 1.13, 1.11]	11.34	5.69	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
703	2026-04-24	6h	6h-14h	Chaîne 8	[1.11, 1.13, 1.13, 1.14, 1.13, 1.11, 1.1, 1.11, 1.14, 1.13, 1.14, 1.12, 1.13, 1.12, 1.13, 1.15, 1.12, 1.12, 1.13, 1.13]	11.01	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
704	2026-04-24	14h	14h-22h	Chaîne 8	[1.13, 1.14, 1.11, 1.14, 1.13, 1.12, 1.11, 1.12, 1.1, 1.12, 1.15, 1.15, 1.12, 1.11, 1.12, 1.1, 1.1, 1.13, 1.1, 1.13]	10.75	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
705	2026-04-24	22h	22h-6h	Chaîne 8	[1.11, 1.13, 1.14, 1.1, 1.14, 1.12, 1.13, 1.13, 1.15, 1.15, 1.11, 1.13, 1.13, 1.1, 1.12, 1.1, 1.15, 1.13, 1.14, 1.14]	10.66	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
706	2026-04-24	6h	6h-14h	Chaîne 14	[1.1, 1.14, 1.11, 1.15, 1.11, 1.15, 1.11, 1.11, 1.12, 1.13, 1.13, 1.11, 1.11, 1.15, 1.13, 1.14]	11.15	5.19	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
707	2026-04-24	14h	14h-22h	Chaîne 14	[1.13, 1.13, 1.15, 1.11, 1.11, 1.12, 1.1, 1.13, 1.11, 1.12, 1.14, 1.15, 1.1, 1.13, 1.13, 1.12]	10.85	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
708	2026-04-24	22h	22h-6h	Chaîne 14	[1.11, 1.14, 1.13, 1.14, 1.14, 1.14, 1.11, 1.1, 1.11, 1.12, 1.14, 1.14, 1.14, 1.13, 1.11, 1.14]	10.93	5.18	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
709	2026-04-24	6h	6h-14h	Chaîne 15	[1.12, 1.14, 1.13, 1.13, 1.13, 1.11, 1.1, 1.12, 1.12, 1.14, 1.15, 1.14, 1.13, 1.11, 1.14, 1.15, 1.11, 1.13, 1.11, 1.15, 1.13, 1.11, 1.12, 1.12]	11.06	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
710	2026-04-24	14h	14h-22h	Chaîne 15	[1.14, 1.13, 1.14, 1.14, 1.14, 1.11, 1.12, 1.13, 1.12, 1.15, 1.13, 1.12, 1.12, 1.13, 1.12, 1.14, 1.1, 1.11, 1.11, 1.11, 1.13, 1.14, 1.11, 1.13]	11.24	5.67	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
711	2026-04-24	22h	22h-6h	Chaîne 15	[1.1, 1.11, 1.13, 1.13, 1.12, 1.12, 1.14, 1.14, 1.15, 1.15, 1.12, 1.13, 1.11, 1.1, 1.11, 1.15, 1.1, 1.12, 1.1, 1.13, 1.13, 1.12, 1.15, 1.14]	11.03	5.28	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
712	2026-04-24	6h	6h-14h	Chaîne 16	[1.11, 1.1, 1.13, 1.14, 1.11, 1.13, 1.11, 1.14, 1.1, 1.15, 1.15, 1.12, 1.15, 1.11, 1.15, 1.13, 1.13, 1.11, 1.15, 1.15, 1.14, 1.13, 1.15, 1.14]	11.11	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
713	2026-04-24	14h	14h-22h	Chaîne 16	[1.12, 1.15, 1.12, 1.12, 1.12, 1.14, 1.13, 1.14, 1.15, 1.11, 1.14, 1.12, 1.14, 1.12, 1.11, 1.14, 1.12, 1.15, 1.13, 1.12, 1.13, 1.14, 1.1, 1.1]	11.06	4.99	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
714	2026-04-24	22h	22h-6h	Chaîne 16	[1.1, 1.13, 1.14, 1.14, 1.13, 1.14, 1.13, 1.13, 1.11, 1.12, 1.11, 1.14, 1.14, 1.14, 1.12, 1.14, 1.11, 1.13, 1.14, 1.12, 1.1, 1.14, 1.13, 1.14]	11.11	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
715	2026-04-25	6h	6h-14h	Chaîne 8	[1.12, 1.1, 1.15, 1.13, 1.14, 1.12, 1.12, 1.11, 1.13, 1.14, 1.13, 1.1, 1.12, 1.11, 1.11, 1.13, 1.1, 1.14, 1.13, 1.12]	10.62	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
716	2026-04-25	14h	14h-22h	Chaîne 8	[1.13, 1.11, 1.12, 1.13, 1.14, 1.1, 1.11, 1.13, 1.14, 1.14, 1.14, 1.12, 1.12, 1.13, 1.15, 1.15, 1.11, 1.15, 1.14, 1.11]	10.93	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
717	2026-04-25	22h	22h-6h	Chaîne 8	[1.14, 1.13, 1.13, 1.11, 1.15, 1.14, 1.13, 1.13, 1.1, 1.12, 1.11, 1.13, 1.1, 1.15, 1.11, 1.12, 1.13, 1.14, 1.14, 1.12]	10.9	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
718	2026-04-25	6h	6h-14h	Chaîne 14	[1.14, 1.12, 1.13, 1.15, 1.13, 1.15, 1.1, 1.11, 1.15, 1.14, 1.13, 1.13, 1.13, 1.14, 1.13, 1.14]	11.18	5.47	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
719	2026-04-25	14h	14h-22h	Chaîne 14	[1.13, 1.12, 1.14, 1.11, 1.13, 1.11, 1.13, 1.1, 1.15, 1.14, 1.13, 1.11, 1.1, 1.11, 1.15, 1.13]	10.82	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
720	2026-04-25	22h	22h-6h	Chaîne 14	[1.11, 1.13, 1.11, 1.12, 1.1, 1.12, 1.1, 1.13, 1.12, 1.11, 1.11, 1.14, 1.12, 1.12, 1.12, 1.14]	11.16	5.38	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
721	2026-04-25	6h	6h-14h	Chaîne 15	[1.1, 1.12, 1.14, 1.15, 1.1, 1.15, 1.13, 1.1, 1.15, 1.1, 1.11, 1.12, 1.11, 1.14, 1.12, 1.11, 1.13, 1.13, 1.13, 1.12, 1.14, 1.13, 1.13, 1.1]	11.31	5.31	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
722	2026-04-25	14h	14h-22h	Chaîne 15	[1.11, 1.11, 1.15, 1.14, 1.13, 1.13, 1.12, 1.14, 1.13, 1.14, 1.15, 1.1, 1.13, 1.13, 1.1, 1.14, 1.12, 1.15, 1.15, 1.15, 1.13, 1.11, 1.11, 1.13]	11.14	5.29	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
723	2026-04-25	22h	22h-6h	Chaîne 15	[1.13, 1.11, 1.13, 1.12, 1.13, 1.13, 1.11, 1.14, 1.11, 1.12, 1.15, 1.11, 1.11, 1.14, 1.12, 1.11, 1.13, 1.1, 1.13, 1.12, 1.11, 1.14, 1.11, 1.12]	11.08	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
724	2026-04-25	6h	6h-14h	Chaîne 16	[1.12, 1.15, 1.12, 1.12, 1.1, 1.15, 1.13, 1.1, 1.11, 1.14, 1.15, 1.12, 1.14, 1.12, 1.1, 1.13, 1.13, 1.12, 1.11, 1.12, 1.11, 1.13, 1.12, 1.13]	11.18	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
725	2026-04-25	14h	14h-22h	Chaîne 16	[1.12, 1.12, 1.13, 1.14, 1.14, 1.15, 1.13, 1.13, 1.12, 1.14, 1.12, 1.14, 1.13, 1.12, 1.12, 1.11, 1.11, 1.14, 1.14, 1.12, 1.13, 1.13, 1.12, 1.15]	11.19	5.37	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
726	2026-04-25	22h	22h-6h	Chaîne 16	[1.14, 1.14, 1.11, 1.11, 1.1, 1.12, 1.12, 1.11, 1.14, 1.11, 1.14, 1.13, 1.11, 1.13, 1.11, 1.15, 1.12, 1.11, 1.11, 1.13, 1.11, 1.11, 1.11, 1.12]	11.13	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
727	2026-04-26	6h	6h-14h	Chaîne 8	[1.11, 1.13, 1.18, 1.1, 1.13, 1.1, 1.12, 1.11, 1.06, 1.11, 1.06, 1.11, 1.15, 1.12, 1.1, 1.13, 1.11, 1.13, 1.2, 1.12]	11.75	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
728	2026-04-26	14h	14h-22h	Chaîne 8	[1.14, 1.07, 1.1, 1.12, 1.19, 1.14, 1.1, 1.14, 1.08, 1.2, 1.1, 1.12, 1.1, 1.13, 1.11, 1.16, 1.12, 1.13, 1.1, 1.14]	11.25	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
729	2026-04-26	22h	22h-6h	Chaîne 8	[1.21, 1.13, 1.11, 1.13, 1.05, 1.13, 1.18, 1.13, 1.14, 1.06, 1.14, 1.14, 1.13, 1.1, 1.13, 1.14, 1.12, 1.13, 1.13, 1.12]	11.43	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
730	2026-04-26	6h	6h-14h	Chaîne 14	[1.14, 1.15, 1.14, 1.11, 1.11, 1.13, 1.13, 1.15, 1.15, 1.12, 1.14, 1.15, 1.11, 1.12, 1.12, 1.13]	11.09	5.17	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
731	2026-04-26	14h	14h-22h	Chaîne 14	[1.13, 1.15, 1.11, 1.12, 1.1, 1.13, 1.15, 1.11, 1.14, 1.13, 1.12, 1.12, 1.14, 1.13, 1.13, 1.14]	11.06	5.36	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
732	2026-04-26	22h	22h-6h	Chaîne 14	[1.11, 1.1, 1.13, 1.15, 1.11, 1.12, 1.11, 1.14, 1.1, 1.14, 1.12, 1.12, 1.11, 1.1, 1.12, 1.15]	11.13	5.17	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
733	2026-04-26	6h	6h-14h	Chaîne 15	[1.12, 1.1, 1.15, 1.11, 1.12, 1.1, 1.1, 1.13, 1.12, 1.14, 1.12, 1.13, 1.11, 1.13, 1.12, 1.12, 1.12, 1.12, 1.11, 1.14, 1.14, 1.11, 1.14, 1.13]	11.12	5.61	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
734	2026-04-26	14h	14h-22h	Chaîne 15	[1.14, 1.14, 1.14, 1.14, 1.12, 1.15, 1.12, 1.1, 1.13, 1.14, 1.11, 1.15, 1.13, 1.12, 1.11, 1.14, 1.12, 1.1, 1.13, 1.13, 1.1, 1.13, 1.14, 1.14]	11.42	5.29	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
735	2026-04-26	22h	22h-6h	Chaîne 15	[1.13, 1.12, 1.14, 1.12, 1.11, 1.11, 1.11, 1.12, 1.11, 1.1, 1.12, 1.1, 1.11, 1.14, 1.12, 1.13, 1.11, 1.13, 1.15, 1.13, 1.12, 1.13, 1.11, 1.11]	11.19	5.65	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
736	2026-04-26	6h	6h-14h	Chaîne 16	[1.13, 1.14, 1.1, 1.11, 1.1, 1.15, 1.13, 1.14, 1.12, 1.11, 1.14, 1.1, 1.11, 1.12, 1.1, 1.1, 1.14, 1.13, 1.12, 1.13, 1.12, 1.13, 1.15, 1.11]	10.85	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
737	2026-04-26	14h	14h-22h	Chaîne 16	[1.14, 1.12, 1.13, 1.14, 1.13, 1.14, 1.11, 1.13, 1.11, 1.13, 1.11, 1.15, 1.12, 1.14, 1.12, 1.13, 1.14, 1.14, 1.11, 1.12, 1.12, 1.15, 1.11, 1.14]	10.78	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
738	2026-04-26	22h	22h-6h	Chaîne 16	[1.13, 1.14, 1.14, 1.12, 1.13, 1.11, 1.11, 1.12, 1.12, 1.12, 1.12, 1.13, 1.13, 1.1, 1.12, 1.11, 1.11, 1.14, 1.11, 1.12, 1.12, 1.13, 1.13, 1.15]	11.08	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
739	2026-04-27	6h	6h-14h	Chaîne 14	[1.1, 1.14, 1.12, 1.12, 1.11, 1.13, 1.15, 1.14, 1.13, 1.13, 1.1, 1.12, 1.11, 1.13, 1.12, 1.1]	11.21	5.33	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
740	2026-04-27	14h	14h-22h	Chaîne 14	[1.11, 1.13, 1.12, 1.13, 1.14, 1.15, 1.13, 1.12, 1.11, 1.13, 1.13, 1.11, 1.15, 1.14, 1.13, 1.13]	10.85	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
741	2026-04-27	22h	22h-6h	Chaîne 14	[1.14, 1.13, 1.11, 1.14, 1.13, 1.12, 1.15, 1.12, 1.14, 1.15, 1.1, 1.11, 1.12, 1.11, 1.12, 1.11]	11.01	5.25	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
742	2026-04-27	6h	6h-14h	Chaîne 15	[1.12, 1.1, 1.14, 1.1, 1.12, 1.12, 1.13, 1.14, 1.14, 1.14, 1.15, 1.11, 1.12, 1.12, 1.14, 1.12, 1.14, 1.14, 1.14, 1.13, 1.14, 1.11, 1.12, 1.13]	11.36	5.57	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
743	2026-04-27	14h	14h-22h	Chaîne 15	[1.13, 1.14, 1.11, 1.1, 1.12, 1.13, 1.11, 1.15, 1.12, 1.12, 1.12, 1.1, 1.15, 1.11, 1.11, 1.11, 1.13, 1.12, 1.1, 1.12, 1.15, 1.11, 1.13, 1.12]	11.25	5.58	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
744	2026-04-27	22h	22h-6h	Chaîne 15	[1.11, 1.15, 1.14, 1.13, 1.12, 1.13, 1.11, 1.15, 1.13, 1.11, 1.15, 1.15, 1.14, 1.12, 1.14, 1.15, 1.14, 1.1, 1.11, 1.11, 1.12, 1.11, 1.12, 1.13]	11.18	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
745	2026-04-27	6h	6h-14h	Chaîne 16	[1.13, 1.15, 1.14, 1.11, 1.1, 1.13, 1.1, 1.13, 1.15, 1.13, 1.13, 1.15, 1.11, 1.11, 1.1, 1.14, 1.14, 1.1, 1.12, 1.14, 1.13, 1.13, 1.14, 1.1]	11.07	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
746	2026-04-27	14h	14h-22h	Chaîne 16	[1.13, 1.13, 1.15, 1.12, 1.14, 1.15, 1.13, 1.12, 1.12, 1.12, 1.15, 1.14, 1.1, 1.13, 1.12, 1.13, 1.13, 1.15, 1.14, 1.1, 1.14, 1.11, 1.11, 1.12]	10.83	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
747	2026-04-27	22h	22h-6h	Chaîne 16	[1.14, 1.11, 1.12, 1.13, 1.15, 1.15, 1.14, 1.1, 1.11, 1.15, 1.13, 1.15, 1.14, 1.13, 1.13, 1.12, 1.14, 1.11, 1.14, 1.12, 1.12, 1.11, 1.14, 1.15]	10.79	5.41	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
748	2026-04-28	6h	6h-14h	Chaîne 8	[1.14, 1.11, 1.13, 1.15, 1.11, 1.13, 1.1, 1.14, 1.11, 1.12, 1.12, 1.11, 1.12, 1.12, 1.14, 1.1, 1.14, 1.13, 1.12, 1.13]	10.93	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
749	2026-04-28	14h	14h-22h	Chaîne 8	[1.12, 1.14, 1.11, 1.14, 1.14, 1.11, 1.12, 1.12, 1.11, 1.11, 1.13, 1.14, 1.12, 1.15, 1.12, 1.13, 1.12, 1.13, 1.11, 1.11]	10.61	5.12	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
750	2026-04-28	22h	22h-6h	Chaîne 8	[1.12, 1.15, 1.14, 1.12, 1.1, 1.14, 1.11, 1.15, 1.15, 1.14, 1.15, 1.11, 1.13, 1.12, 1.11, 1.15, 1.11, 1.1, 1.12, 1.11]	10.95	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
751	2026-04-28	6h	6h-14h	Chaîne 15	[1.1, 1.1, 1.12, 1.11, 1.12, 1.12, 1.1, 1.11, 1.13, 1.14, 1.13, 1.1, 1.14, 1.13, 1.15, 1.1, 1.11, 1.1, 1.1, 1.1, 1.11, 1.12, 1.12, 1.13]	11.12	5.31	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
752	2026-04-28	14h	14h-22h	Chaîne 15	[1.12, 1.12, 1.1, 1.13, 1.13, 1.1, 1.14, 1.14, 1.13, 1.11, 1.14, 1.1, 1.15, 1.11, 1.14, 1.1, 1.1, 1.11, 1.1, 1.15, 1.12, 1.12, 1.13, 1.15]	11.26	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
753	2026-04-28	22h	22h-6h	Chaîne 15	[1.1, 1.12, 1.11, 1.14, 1.13, 1.1, 1.15, 1.12, 1.14, 1.11, 1.14, 1.11, 1.11, 1.11, 1.1, 1.15, 1.11, 1.15, 1.11, 1.13, 1.1, 1.12, 1.13, 1.1]	11.33	5.29	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
754	2026-04-28	6h	6h-14h	Chaîne 16	[1.11, 1.11, 1.12, 1.15, 1.14, 1.11, 1.14, 1.11, 1.14, 1.12, 1.11, 1.11, 1.12, 1.13, 1.11, 1.14, 1.13, 1.12, 1.1, 1.11, 1.13, 1.12, 1.11, 1.14]	10.88	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
755	2026-04-28	14h	14h-22h	Chaîne 16	[1.13, 1.13, 1.11, 1.12, 1.11, 1.12, 1.14, 1.12, 1.11, 1.12, 1.15, 1.12, 1.12, 1.14, 1.11, 1.14, 1.12, 1.11, 1.14, 1.14, 1.13, 1.13, 1.12, 1.12]	11.16	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
756	2026-04-28	22h	22h-6h	Chaîne 16	[1.15, 1.12, 1.14, 1.13, 1.12, 1.13, 1.13, 1.13, 1.12, 1.14, 1.14, 1.13, 1.14, 1.14, 1.11, 1.11, 1.15, 1.14, 1.12, 1.15, 1.11, 1.11, 1.12, 1.11]	11.17	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
757	2026-04-29	6h	6h-14h	Chaîne 8	[1.13, 1.13, 1.12, 1.13, 1.1, 1.14, 1.12, 1.13, 1.11, 1.12, 1.13, 1.13, 1.14, 1.14, 1.14, 1.1, 1.1, 1.14, 1.13, 1.13]	10.7	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
758	2026-04-29	14h	14h-22h	Chaîne 8	[1.12, 1.11, 1.14, 1.1, 1.1, 1.13, 1.12, 1.12, 1.13, 1.14, 1.13, 1.11, 1.14, 1.13, 1.11, 1.15, 1.15, 1.12, 1.11, 1.14]	10.93	5.19	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
759	2026-04-29	22h	22h-6h	Chaîne 8	[1.12, 1.12, 1.15, 1.11, 1.11, 1.11, 1.15, 1.14, 1.13, 1.14, 1.1, 1.12, 1.13, 1.13, 1.13, 1.15, 1.11, 1.13, 1.14, 1.12]	10.86	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
760	2026-04-29	6h	6h-14h	Chaîne 14	[1.1, 1.15, 1.11, 1.12, 1.14, 1.1, 1.12, 1.14, 1.13, 1.11, 1.13, 1.14, 1.1, 1.11, 1.11, 1.11]	10.88	5.23	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
761	2026-04-29	14h	14h-22h	Chaîne 14	[1.14, 1.11, 1.14, 1.15, 1.14, 1.12, 1.11, 1.1, 1.11, 1.13, 1.11, 1.1, 1.11, 1.13, 1.13, 1.13]	10.82	5.11	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
762	2026-04-29	22h	22h-6h	Chaîne 14	[1.15, 1.12, 1.13, 1.1, 1.15, 1.14, 1.13, 1.11, 1.11, 1.15, 1.14, 1.11, 1.14, 1.15, 1.12, 1.11]	11.03	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
763	2026-04-29	6h	6h-14h	Chaîne 16	[1.11, 1.11, 1.14, 1.13, 1.12, 1.14, 1.1, 1.11, 1.15, 1.13, 1.1, 1.15, 1.13, 1.14, 1.1, 1.1, 1.11, 1.13, 1.14, 1.11, 1.11, 1.12, 1.13, 1.14]	11.09	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
764	2026-04-29	14h	14h-22h	Chaîne 16	[1.1, 1.15, 1.12, 1.13, 1.11, 1.15, 1.11, 1.13, 1.11, 1.11, 1.11, 1.12, 1.14, 1.1, 1.11, 1.15, 1.11, 1.1, 1.13, 1.12, 1.13, 1.12, 1.12, 1.11]	11.05	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
765	2026-04-29	22h	22h-6h	Chaîne 16	[1.14, 1.15, 1.12, 1.13, 1.14, 1.11, 1.13, 1.15, 1.12, 1.13, 1.13, 1.15, 1.13, 1.15, 1.1, 1.11, 1.15, 1.14, 1.12, 1.12, 1.15, 1.15, 1.11, 1.12]	10.84	5.14	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
766	2026-04-30	6h	6h-14h	Chaîne 8	[1.12, 1.11, 1.14, 1.12, 1.13, 1.1, 1.14, 1.13, 1.11, 1.14, 1.1, 1.14, 1.13, 1.15, 1.12, 1.11, 1.1, 1.14, 1.12, 1.14]	10.76	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
767	2026-04-30	14h	14h-22h	Chaîne 8	[1.11, 1.11, 1.12, 1.11, 1.13, 1.11, 1.12, 1.14, 1.11, 1.11, 1.13, 1.11, 1.13, 1.11, 1.13, 1.12, 1.14, 1.13, 1.12, 1.13]	11.01	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
768	2026-04-30	22h	22h-6h	Chaîne 8	[1.14, 1.15, 1.12, 1.1, 1.14, 1.14, 1.11, 1.15, 1.15, 1.15, 1.11, 1.13, 1.13, 1.15, 1.1, 1.15, 1.11, 1.13, 1.15, 1.12]	10.63	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
769	2026-04-30	6h	6h-14h	Chaîne 14	[1.13, 1.15, 1.14, 1.12, 1.12, 1.13, 1.14, 1.11, 1.14, 1.14, 1.1, 1.13, 1.11, 1.13, 1.14, 1.11]	11.15	5.1	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
770	2026-04-30	14h	14h-22h	Chaîne 14	[1.15, 1.13, 1.14, 1.1, 1.15, 1.12, 1.13, 1.11, 1.11, 1.11, 1.13, 1.14, 1.14, 1.11, 1.15, 1.11]	10.79	5.18	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
771	2026-04-30	22h	22h-6h	Chaîne 14	[1.14, 1.13, 1.11, 1.13, 1.14, 1.14, 1.13, 1.12, 1.13, 1.13, 1.12, 1.11, 1.13, 1.13, 1.1, 1.1]	11.13	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
772	2026-04-30	6h	6h-14h	Chaîne 15	[1.1, 1.11, 1.13, 1.1, 1.13, 1.13, 1.11, 1.11, 1.1, 1.11, 1.12, 1.12, 1.13, 1.13, 1.14, 1.11, 1.12, 1.14, 1.12, 1.15, 1.12, 1.14, 1.1, 1.11]	11.01	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
773	2026-04-30	14h	14h-22h	Chaîne 15	[1.14, 1.12, 1.15, 1.12, 1.11, 1.13, 1.12, 1.11, 1.15, 1.15, 1.12, 1.14, 1.13, 1.12, 1.11, 1.11, 1.12, 1.11, 1.14, 1.11, 1.11, 1.14, 1.13, 1.11]	11.01	5.59	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
774	2026-04-30	22h	22h-6h	Chaîne 15	[1.13, 1.12, 1.15, 1.13, 1.13, 1.12, 1.1, 1.11, 1.11, 1.11, 1.11, 1.12, 1.12, 1.13, 1.14, 1.15, 1.12, 1.11, 1.11, 1.12, 1.13, 1.12, 1.15, 1.1]	11	5.29	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
775	2026-05-01	6h	6h-14h	Chaîne 8	[1.13, 1.12, 1.12, 1.13, 1.1, 1.13, 1.11, 1.13, 1.12, 1.1, 1.11, 1.14, 1.12, 1.14, 1.11, 1.12, 1.13, 1.12, 1.15, 1.12]	10.83	5.26	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
776	2026-05-01	14h	14h-22h	Chaîne 8	[1.11, 1.15, 1.13, 1.12, 1.15, 1.13, 1.1, 1.12, 1.11, 1.14, 1.14, 1.12, 1.14, 1.11, 1.11, 1.14, 1.11, 1.13, 1.15, 1.15]	10.9	5.4	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
777	2026-05-01	22h	22h-6h	Chaîne 8	[1.11, 1.14, 1.11, 1.1, 1.14, 1.12, 1.13, 1.12, 1.1, 1.14, 1.1, 1.11, 1.1, 1.11, 1.12, 1.13, 1.15, 1.1, 1.13, 1.12]	10.79	5.36	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
778	2026-05-01	6h	6h-14h	Chaîne 14	[1.13, 1.11, 1.13, 1.12, 1.15, 1.1, 1.11, 1.11, 1.12, 1.1, 1.1, 1.14, 1.12, 1.12, 1.15, 1.13]	10.81	5.15	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
779	2026-05-01	14h	14h-22h	Chaîne 14	[1.12, 1.13, 1.11, 1.12, 1.15, 1.14, 1.11, 1.13, 1.11, 1.13, 1.12, 1.13, 1.14, 1.12, 1.11, 1.13]	10.93	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
780	2026-05-01	22h	22h-6h	Chaîne 14	[1.14, 1.14, 1.14, 1.12, 1.14, 1.12, 1.15, 1.12, 1.12, 1.15, 1.15, 1.12, 1.14, 1.13, 1.12, 1.14]	10.97	5.21	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
781	2026-05-01	6h	6h-14h	Chaîne 15	[1.14, 1.1, 1.12, 1.11, 1.1, 1.12, 1.11, 1.13, 1.12, 1.13, 1.12, 1.11, 1.14, 1.1, 1.12, 1.11, 1.12, 1.12, 1.12, 1.13, 1.11, 1.12, 1.1, 1.12]	11.34	5.53	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
782	2026-05-01	14h	14h-22h	Chaîne 15	[1.11, 1.14, 1.11, 1.12, 1.13, 1.14, 1.15, 1.13, 1.14, 1.1, 1.15, 1.15, 1.14, 1.12, 1.14, 1.12, 1.14, 1.11, 1.13, 1.12, 1.11, 1.13, 1.13, 1.1]	11.37	5.57	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
851	2026-05-08	14h	14h-22h	Chaîne 14	[1.15, 1.14, 1.12, 1.13, 1.12, 1.11, 1.15, 1.1, 1.13, 1.15, 1.12, 1.14, 1.15, 1.12, 1.12, 1.11]	11.13	5.23	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
783	2026-05-01	22h	22h-6h	Chaîne 15	[1.13, 1.14, 1.12, 1.14, 1.12, 1.12, 1.14, 1.1, 1.11, 1.13, 1.13, 1.14, 1.14, 1.14, 1.12, 1.1, 1.1, 1.11, 1.14, 1.11, 1.14, 1.14, 1.14, 1.14]	11.3	5.35	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
784	2026-05-01	6h	6h-14h	Chaîne 16	[1.12, 1.13, 1.1, 1.14, 1.11, 1.15, 1.13, 1.12, 1.14, 1.13, 1.13, 1.12, 1.14, 1.13, 1.11, 1.15, 1.14, 1.14, 1.13, 1.1, 1.15, 1.15, 1.11, 1.14]	10.87	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
785	2026-05-01	14h	14h-22h	Chaîne 16	[1.14, 1.1, 1.11, 1.12, 1.12, 1.12, 1.14, 1.13, 1.13, 1.14, 1.1, 1.14, 1.11, 1.13, 1.13, 1.13, 1.14, 1.1, 1.11, 1.1, 1.11, 1.11, 1.1, 1.12]	10.87	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
786	2026-05-01	22h	22h-6h	Chaîne 16	[1.12, 1.13, 1.11, 1.13, 1.1, 1.15, 1.13, 1.12, 1.11, 1.11, 1.14, 1.12, 1.11, 1.1, 1.15, 1.1, 1.14, 1.14, 1.13, 1.12, 1.13, 1.13, 1.13, 1.11]	11.01	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
787	2026-05-02	6h	6h-14h	Chaîne 8	[1.14, 1.12, 1.12, 1.14, 1.13, 1.13, 1.11, 1.1, 1.14, 1.14, 1.14, 1.12, 1.15, 1.11, 1.11, 1.12, 1.13, 1.13, 1.12, 1.12]	10.77	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
788	2026-05-02	14h	14h-22h	Chaîne 8	[1.13, 1.1, 1.15, 1.14, 1.12, 1.1, 1.13, 1.13, 1.11, 1.12, 1.13, 1.13, 1.11, 1.14, 1.14, 1.1, 1.14, 1.12, 1.11, 1.14]	10.8	5.11	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
789	2026-05-02	22h	22h-6h	Chaîne 8	[1.12, 1.14, 1.12, 1.11, 1.11, 1.11, 1.14, 1.12, 1.11, 1.15, 1.13, 1.13, 1.12, 1.14, 1.14, 1.13, 1.14, 1.11, 1.14, 1.14]	10.74	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
790	2026-05-02	6h	6h-14h	Chaîne 14	[1.14, 1.13, 1.15, 1.11, 1.14, 1.1, 1.12, 1.1, 1.1, 1.14, 1.14, 1.11, 1.11, 1.13, 1.12, 1.14]	11	5.15	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
791	2026-05-02	14h	14h-22h	Chaîne 14	[1.15, 1.15, 1.13, 1.13, 1.12, 1.12, 1.14, 1.12, 1.14, 1.12, 1.12, 1.11, 1.13, 1.14, 1.12, 1.14]	11.11	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
792	2026-05-02	22h	22h-6h	Chaîne 14	[1.13, 1.12, 1.14, 1.13, 1.15, 1.11, 1.14, 1.13, 1.14, 1.11, 1.13, 1.1, 1.1, 1.13, 1.12, 1.11]	10.9	5.15	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
793	2026-05-02	6h	6h-14h	Chaîne 15	[1.14, 1.15, 1.12, 1.1, 1.1, 1.12, 1.13, 1.14, 1.13, 1.14, 1.15, 1.13, 1.14, 1.15, 1.11, 1.12, 1.13, 1.14, 1.12, 1.14, 1.13, 1.11, 1.13, 1.12]	11.31	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
794	2026-05-02	14h	14h-22h	Chaîne 15	[1.11, 1.14, 1.1, 1.15, 1.12, 1.11, 1.13, 1.12, 1.11, 1.13, 1.12, 1.13, 1.11, 1.14, 1.15, 1.15, 1.12, 1.11, 1.1, 1.14, 1.13, 1.14, 1.13, 1.1]	11.36	5.58	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
795	2026-05-02	22h	22h-6h	Chaîne 15	[1.11, 1.14, 1.12, 1.13, 1.14, 1.14, 1.13, 1.11, 1.11, 1.14, 1.14, 1.15, 1.12, 1.14, 1.14, 1.11, 1.1, 1.15, 1.1, 1.1, 1.1, 1.14, 1.13, 1.1]	11.23	5.43	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
796	2026-05-02	6h	6h-14h	Chaîne 16	[1.13, 1.11, 1.12, 1.14, 1.13, 1.11, 1.13, 1.13, 1.11, 1.15, 1.14, 1.13, 1.12, 1.1, 1.14, 1.12, 1.13, 1.13, 1.13, 1.14, 1.11, 1.11, 1.13, 1.13]	11.01	5.4	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
797	2026-05-02	14h	14h-22h	Chaîne 16	[1.14, 1.1, 1.14, 1.15, 1.1, 1.12, 1.13, 1.11, 1.14, 1.11, 1.14, 1.12, 1.15, 1.13, 1.13, 1.11, 1.11, 1.13, 1.15, 1.14, 1.11, 1.12, 1.11, 1.15]	10.98	4.99	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
798	2026-05-02	22h	22h-6h	Chaîne 16	[1.14, 1.11, 1.13, 1.14, 1.11, 1.15, 1.12, 1.13, 1.13, 1.12, 1.1, 1.13, 1.14, 1.14, 1.11, 1.15, 1.11, 1.11, 1.12, 1.12, 1.13, 1.13, 1.1, 1.13]	11.16	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
799	2026-05-03	6h	6h-14h	Chaîne 8	[1.15, 1.1, 1.11, 1.13, 1.14, 1.13, 1.11, 1.12, 1.13, 1.12, 1.11, 1.12, 1.13, 1.12, 1.11, 1.13, 1.11, 1.13, 1.15, 1.13]	10.86	5.27	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
800	2026-05-03	14h	14h-22h	Chaîne 8	[1.13, 1.13, 1.15, 1.11, 1.15, 1.14, 1.14, 1.12, 1.1, 1.13, 1.1, 1.11, 1.15, 1.13, 1.1, 1.14, 1.12, 1.1, 1.14, 1.11]	10.99	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
801	2026-05-03	22h	22h-6h	Chaîne 8	[1.1, 1.11, 1.11, 1.11, 1.14, 1.11, 1.13, 1.1, 1.13, 1.14, 1.1, 1.11, 1.13, 1.15, 1.12, 1.13, 1.12, 1.15, 1.11, 1.14]	10.78	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
802	2026-05-03	6h	6h-14h	Chaîne 14	[1.11, 1.12, 1.14, 1.11, 1.14, 1.13, 1.2, 1.12, 1.14, 1.18, 1.18, 1.13, 1.12, 1.14, 1.13, 1.18]	10.79	5.15	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
803	2026-05-03	14h	14h-22h	Chaîne 14	[1.22, 1.11, 1.14, 1.11, 1.15, 1.21, 1.13, 1.2, 1.08, 1.12, 1.12, 1.12, 1.12, 1.11, 1.12, 1.21]	10.87	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
804	2026-05-03	22h	22h-6h	Chaîne 14	[1.12, 1.11, 1.14, 1.1, 1.11, 1.11, 1.15, 1.13, 1.11, 1.1, 1.17, 1.05, 1.14, 1.2, 1.05, 1.13]	11.1	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
805	2026-05-03	6h	6h-14h	Chaîne 15	[1.13, 1.13, 1.11, 1.11, 1.12, 1.14, 1.14, 1.11, 1.14, 1.14, 1.11, 1.11, 1.13, 1.13, 1.11, 1.14, 1.12, 1.11, 1.12, 1.11, 1.13, 1.14, 1.12, 1.11]	11.04	5.48	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
806	2026-05-03	14h	14h-22h	Chaîne 15	[1.11, 1.14, 1.15, 1.14, 1.14, 1.13, 1.13, 1.12, 1.1, 1.13, 1.15, 1.12, 1.12, 1.14, 1.11, 1.12, 1.1, 1.14, 1.11, 1.11, 1.14, 1.12, 1.11, 1.12]	11.13	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
807	2026-05-03	22h	22h-6h	Chaîne 15	[1.14, 1.11, 1.11, 1.14, 1.1, 1.11, 1.11, 1.15, 1.13, 1.12, 1.1, 1.13, 1.1, 1.13, 1.1, 1.14, 1.11, 1.14, 1.11, 1.13, 1.12, 1.1, 1.14, 1.15]	11.3	5.62	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
808	2026-05-03	6h	6h-14h	Chaîne 16	[1.11, 1.14, 1.15, 1.15, 1.11, 1.14, 1.14, 1.13, 1.13, 1.15, 1.12, 1.12, 1.15, 1.13, 1.13, 1.1, 1.12, 1.14, 1.12, 1.12, 1.14, 1.11, 1.11, 1.14]	11.18	5.28	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
809	2026-05-03	14h	14h-22h	Chaîne 16	[1.1, 1.11, 1.11, 1.14, 1.13, 1.14, 1.13, 1.11, 1.14, 1.12, 1.15, 1.1, 1.1, 1.13, 1.11, 1.15, 1.12, 1.11, 1.13, 1.12, 1.12, 1.13, 1.11, 1.13]	10.81	5.29	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
810	2026-05-03	22h	22h-6h	Chaîne 16	[1.13, 1.1, 1.1, 1.13, 1.11, 1.13, 1.11, 1.13, 1.11, 1.13, 1.1, 1.12, 1.11, 1.12, 1.14, 1.11, 1.1, 1.11, 1.13, 1.12, 1.1, 1.13, 1.12, 1.13]	10.85	5.04	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
811	2026-05-04	6h	6h-14h	Chaîne 14	[1.1, 1.13, 1.13, 1.12, 1.12, 1.11, 1.14, 1.11, 1.13, 1.14, 1.11, 1.12, 1.13, 1.13, 1.11, 1.1]	11.11	5.22	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
812	2026-05-04	14h	14h-22h	Chaîne 14	[1.1, 1.14, 1.11, 1.11, 1.12, 1.11, 1.12, 1.11, 1.1, 1.13, 1.13, 1.12, 1.11, 1.1, 1.13, 1.11]	11.02	5.14	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
813	2026-05-04	22h	22h-6h	Chaîne 14	[1.13, 1.1, 1.15, 1.12, 1.11, 1.12, 1.1, 1.14, 1.13, 1.12, 1.12, 1.12, 1.1, 1.1, 1.11, 1.11]	11.15	5.19	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
814	2026-05-04	6h	6h-14h	Chaîne 15	[1.13, 1.14, 1.12, 1.11, 1.12, 1.13, 1.1, 1.11, 1.14, 1.14, 1.13, 1.14, 1.12, 1.11, 1.12, 1.13, 1.11, 1.12, 1.12, 1.14, 1.13, 1.12, 1.12, 1.11]	11.14	5.63	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
815	2026-05-04	14h	14h-22h	Chaîne 15	[1.11, 1.12, 1.14, 1.15, 1.12, 1.11, 1.1, 1.12, 1.11, 1.1, 1.13, 1.14, 1.12, 1.11, 1.15, 1.11, 1.11, 1.13, 1.15, 1.14, 1.11, 1.12, 1.1, 1.11]	11.17	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
816	2026-05-04	22h	22h-6h	Chaîne 15	[1.13, 1.11, 1.13, 1.12, 1.11, 1.11, 1.13, 1.15, 1.14, 1.11, 1.15, 1.11, 1.1, 1.11, 1.12, 1.13, 1.13, 1.13, 1.15, 1.15, 1.11, 1.13, 1.14, 1.11]	11.01	5.48	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
817	2026-05-04	6h	6h-14h	Chaîne 16	[1.11, 1.15, 1.14, 1.14, 1.15, 1.11, 1.13, 1.12, 1.1, 1.12, 1.11, 1.1, 1.15, 1.1, 1.14, 1.13, 1.13, 1.1, 1.12, 1.11, 1.11, 1.12, 1.13, 1.1]	11.15	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
818	2026-05-04	14h	14h-22h	Chaîne 16	[1.14, 1.14, 1.13, 1.14, 1.12, 1.11, 1.13, 1.13, 1.1, 1.11, 1.14, 1.11, 1.11, 1.11, 1.14, 1.14, 1.15, 1.12, 1.14, 1.13, 1.13, 1.11, 1.15, 1.15]	10.93	5.18	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
819	2026-05-04	22h	22h-6h	Chaîne 16	[1.1, 1.13, 1.15, 1.12, 1.12, 1.14, 1.14, 1.14, 1.11, 1.13, 1.13, 1.11, 1.15, 1.13, 1.1, 1.14, 1.11, 1.14, 1.14, 1.13, 1.14, 1.1, 1.13, 1.15]	10.89	5.41	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
820	2026-05-05	6h	6h-14h	Chaîne 8	[1.12, 1.14, 1.13, 1.12, 1.11, 1.14, 1.1, 1.13, 1.13, 1.11, 1.1, 1.14, 1.12, 1.13, 1.1, 1.12, 1.11, 1.12, 1.11, 1.13]	10.67	5.28	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
821	2026-05-05	14h	14h-22h	Chaîne 8	[1.12, 1.11, 1.14, 1.13, 1.11, 1.15, 1.14, 1.14, 1.11, 1.14, 1.1, 1.13, 1.14, 1.12, 1.14, 1.1, 1.14, 1.15, 1.15, 1.11]	10.84	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
822	2026-05-05	22h	22h-6h	Chaîne 8	[1.12, 1.13, 1.11, 1.11, 1.14, 1.14, 1.13, 1.12, 1.1, 1.12, 1.14, 1.13, 1.1, 1.14, 1.12, 1.12, 1.13, 1.12, 1.15, 1.1]	10.76	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
823	2026-05-05	6h	6h-14h	Chaîne 15	[1.12, 1.13, 1.1, 1.11, 1.15, 1.12, 1.15, 1.12, 1.12, 1.11, 1.12, 1.11, 1.11, 1.1, 1.15, 1.12, 1.13, 1.13, 1.14, 1.15, 1.1, 1.13, 1.14, 1.14]	11.12	5.7	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
824	2026-05-05	14h	14h-22h	Chaîne 15	[1.13, 1.12, 1.11, 1.11, 1.15, 1.14, 1.11, 1.13, 1.13, 1.11, 1.11, 1.14, 1.14, 1.1, 1.13, 1.12, 1.12, 1.14, 1.1, 1.13, 1.13, 1.13, 1.15, 1.12]	11.38	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
825	2026-05-05	22h	22h-6h	Chaîne 15	[1.12, 1.14, 1.11, 1.14, 1.15, 1.13, 1.13, 1.13, 1.14, 1.12, 1.1, 1.15, 1.14, 1.1, 1.11, 1.12, 1.13, 1.11, 1.13, 1.15, 1.1, 1.15, 1.11, 1.12]	11.29	5.67	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
826	2026-05-05	6h	6h-14h	Chaîne 16	[1.1, 1.1, 1.14, 1.14, 1.11, 1.13, 1.14, 1.14, 1.14, 1.12, 1.11, 1.13, 1.11, 1.1, 1.12, 1.11, 1.14, 1.11, 1.11, 1.14, 1.13, 1.13, 1.11, 1.11]	10.88	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
827	2026-05-05	14h	14h-22h	Chaîne 16	[1.14, 1.11, 1.11, 1.13, 1.12, 1.13, 1.11, 1.12, 1.1, 1.11, 1.12, 1.14, 1.13, 1.12, 1.15, 1.14, 1.13, 1.15, 1.14, 1.15, 1.13, 1.14, 1.15, 1.14]	10.8	5.17	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
828	2026-05-05	22h	22h-6h	Chaîne 16	[1.12, 1.1, 1.12, 1.14, 1.13, 1.1, 1.14, 1.14, 1.12, 1.11, 1.13, 1.12, 1.15, 1.15, 1.14, 1.13, 1.12, 1.12, 1.15, 1.12, 1.13, 1.13, 1.11, 1.1]	10.92	5.03	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
829	2026-05-06	6h	6h-14h	Chaîne 8	[1.15, 1.1, 1.15, 1.11, 1.13, 1.14, 1.15, 1.15, 1.12, 1.12, 1.12, 1.12, 1.12, 1.12, 1.13, 1.1, 1.14, 1.12, 1.1, 1.1]	10.61	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
830	2026-05-06	14h	14h-22h	Chaîne 8	[1.12, 1.13, 1.1, 1.15, 1.15, 1.12, 1.15, 1.13, 1.14, 1.12, 1.14, 1.14, 1.11, 1.12, 1.1, 1.14, 1.14, 1.11, 1.11, 1.13]	11	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
831	2026-05-06	22h	22h-6h	Chaîne 8	[1.14, 1.14, 1.13, 1.14, 1.15, 1.12, 1.11, 1.12, 1.14, 1.13, 1.14, 1.13, 1.14, 1.11, 1.13, 1.13, 1.14, 1.12, 1.13, 1.1]	10.6	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
832	2026-05-06	6h	6h-14h	Chaîne 14	[1.13, 1.1, 1.14, 1.13, 1.1, 1.11, 1.15, 1.14, 1.11, 1.14, 1.14, 1.12, 1.13, 1.14, 1.1, 1.11]	11.12	5.27	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
833	2026-05-06	14h	14h-22h	Chaîne 14	[1.13, 1.14, 1.14, 1.11, 1.13, 1.13, 1.11, 1.11, 1.12, 1.12, 1.12, 1.14, 1.15, 1.12, 1.11, 1.11]	11.06	5.2	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
834	2026-05-06	22h	22h-6h	Chaîne 14	[1.12, 1.1, 1.13, 1.15, 1.15, 1.13, 1.14, 1.11, 1.12, 1.14, 1.12, 1.11, 1.11, 1.11, 1.11, 1.13]	10.95	5.49	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
835	2026-05-06	6h	6h-14h	Chaîne 16	[1.12, 1.12, 1.11, 1.1, 1.12, 1.12, 1.11, 1.14, 1.1, 1.13, 1.14, 1.13, 1.1, 1.14, 1.14, 1.14, 1.12, 1.12, 1.13, 1.11, 1.11, 1.11, 1.11, 1.15]	11.16	5.17	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
836	2026-05-06	14h	14h-22h	Chaîne 16	[1.13, 1.15, 1.13, 1.1, 1.15, 1.11, 1.1, 1.15, 1.14, 1.1, 1.14, 1.14, 1.13, 1.14, 1.12, 1.12, 1.1, 1.13, 1.13, 1.13, 1.14, 1.14, 1.15, 1.1]	10.84	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
837	2026-05-06	22h	22h-6h	Chaîne 16	[1.12, 1.1, 1.13, 1.13, 1.13, 1.13, 1.11, 1.12, 1.13, 1.12, 1.13, 1.14, 1.12, 1.14, 1.14, 1.1, 1.12, 1.11, 1.12, 1.15, 1.13, 1.1, 1.13, 1.1]	10.81	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
838	2026-05-07	6h	6h-14h	Chaîne 8	[1.14, 1.13, 1.13, 1.12, 1.15, 1.1, 1.1, 1.1, 1.14, 1.13, 1.12, 1.12, 1.12, 1.14, 1.11, 1.13, 1.1, 1.12, 1.14, 1.12]	10.98	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
839	2026-05-07	14h	14h-22h	Chaîne 8	[1.11, 1.14, 1.14, 1.12, 1.11, 1.12, 1.1, 1.15, 1.13, 1.14, 1.12, 1.12, 1.14, 1.12, 1.12, 1.11, 1.15, 1.15, 1.1, 1.13]	10.59	5.37	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
840	2026-05-07	22h	22h-6h	Chaîne 8	[1.15, 1.14, 1.12, 1.11, 1.11, 1.13, 1.12, 1.14, 1.14, 1.1, 1.13, 1.12, 1.14, 1.14, 1.1, 1.11, 1.15, 1.15, 1.12, 1.14]	10.94	5.14	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
841	2026-05-07	6h	6h-14h	Chaîne 14	[1.13, 1.15, 1.1, 1.14, 1.14, 1.14, 1.15, 1.15, 1.1, 1.11, 1.12, 1.11, 1.14, 1.15, 1.11, 1.15]	11.19	5.13	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
842	2026-05-07	14h	14h-22h	Chaîne 14	[1.1, 1.12, 1.12, 1.11, 1.1, 1.1, 1.14, 1.1, 1.11, 1.12, 1.13, 1.12, 1.14, 1.15, 1.12, 1.1]	11.15	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
843	2026-05-07	22h	22h-6h	Chaîne 14	[1.13, 1.12, 1.14, 1.12, 1.12, 1.14, 1.12, 1.14, 1.12, 1.15, 1.12, 1.14, 1.14, 1.11, 1.13, 1.11]	11.05	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
844	2026-05-07	6h	6h-14h	Chaîne 15	[1.12, 1.11, 1.13, 1.12, 1.13, 1.13, 1.1, 1.1, 1.14, 1.14, 1.14, 1.13, 1.11, 1.13, 1.11, 1.14, 1.12, 1.11, 1.14, 1.15, 1.11, 1.1, 1.14, 1.12]	11.25	5.6	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
845	2026-05-07	14h	14h-22h	Chaîne 15	[1.14, 1.14, 1.14, 1.1, 1.13, 1.11, 1.14, 1.13, 1.15, 1.13, 1.12, 1.14, 1.13, 1.12, 1.14, 1.11, 1.1, 1.15, 1.13, 1.15, 1.11, 1.12, 1.12, 1.11]	11.21	5.56	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
846	2026-05-07	22h	22h-6h	Chaîne 15	[1.13, 1.15, 1.13, 1.14, 1.11, 1.13, 1.13, 1.1, 1.12, 1.11, 1.1, 1.14, 1.14, 1.11, 1.12, 1.12, 1.12, 1.12, 1.12, 1.14, 1.13, 1.13, 1.12, 1.14]	11.3	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
847	2026-05-08	6h	6h-14h	Chaîne 8	[1.14, 1.12, 1.13, 1.15, 1.13, 1.14, 1.1, 1.12, 1.15, 1.12, 1.11, 1.15, 1.14, 1.1, 1.1, 1.1, 1.14, 1.11, 1.12, 1.15]	10.81	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
848	2026-05-08	14h	14h-22h	Chaîne 8	[1.14, 1.14, 1.14, 1.13, 1.14, 1.14, 1.14, 1.13, 1.15, 1.13, 1.12, 1.13, 1.14, 1.11, 1.14, 1.14, 1.15, 1.11, 1.12, 1.13]	10.68	5	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
849	2026-05-08	22h	22h-6h	Chaîne 8	[1.12, 1.14, 1.11, 1.13, 1.13, 1.14, 1.13, 1.14, 1.14, 1.12, 1.13, 1.11, 1.14, 1.12, 1.13, 1.13, 1.13, 1.14, 1.11, 1.15]	10.9	5.04	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
850	2026-05-08	6h	6h-14h	Chaîne 14	[1.13, 1.11, 1.15, 1.12, 1.15, 1.13, 1.13, 1.13, 1.12, 1.12, 1.13, 1.12, 1.11, 1.11, 1.12, 1.13]	10.97	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
852	2026-05-08	22h	22h-6h	Chaîne 14	[1.14, 1.12, 1.14, 1.13, 1.12, 1.13, 1.11, 1.14, 1.15, 1.1, 1.15, 1.12, 1.13, 1.11, 1.14, 1.12]	10.94	5.22	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
853	2026-05-08	6h	6h-14h	Chaîne 15	[1.13, 1.14, 1.12, 1.13, 1.11, 1.12, 1.13, 1.13, 1.13, 1.11, 1.13, 1.1, 1.1, 1.13, 1.13, 1.1, 1.1, 1.11, 1.15, 1.13, 1.1, 1.14, 1.14, 1.12]	11.1	5.34	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
854	2026-05-08	14h	14h-22h	Chaîne 15	[1.11, 1.11, 1.12, 1.13, 1.12, 1.14, 1.15, 1.14, 1.12, 1.14, 1.12, 1.1, 1.12, 1.11, 1.15, 1.14, 1.11, 1.13, 1.11, 1.13, 1.14, 1.14, 1.12, 1.12]	11.09	5.46	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
855	2026-05-08	22h	22h-6h	Chaîne 15	[1.14, 1.13, 1.13, 1.13, 1.14, 1.13, 1.12, 1.14, 1.13, 1.1, 1.11, 1.11, 1.11, 1.15, 1.12, 1.12, 1.13, 1.11, 1.12, 1.12, 1.13, 1.14, 1.14, 1.14]	11.4	5.71	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
856	2026-05-08	6h	6h-14h	Chaîne 16	[1.13, 1.11, 1.14, 1.13, 1.11, 1.11, 1.11, 1.15, 1.13, 1.11, 1.14, 1.14, 1.13, 1.13, 1.13, 1.12, 1.12, 1.12, 1.12, 1.12, 1.14, 1.12, 1.12, 1.12]	10.94	5.02	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
857	2026-05-08	14h	14h-22h	Chaîne 16	[1.12, 1.13, 1.15, 1.14, 1.14, 1.11, 1.13, 1.14, 1.12, 1.15, 1.13, 1.11, 1.11, 1.11, 1.13, 1.12, 1.15, 1.13, 1.11, 1.15, 1.13, 1.12, 1.14, 1.14]	10.99	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
858	2026-05-08	22h	22h-6h	Chaîne 16	[1.13, 1.12, 1.11, 1.12, 1.13, 1.14, 1.12, 1.1, 1.13, 1.14, 1.12, 1.11, 1.13, 1.11, 1.14, 1.13, 1.15, 1.12, 1.1, 1.14, 1.14, 1.14, 1.14, 1.12]	10.86	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
859	2026-05-09	6h	6h-14h	Chaîne 8	[1.13, 1.11, 1.11, 1.11, 1.11, 1.14, 1.14, 1.13, 1.12, 1.12, 1.12, 1.11, 1.14, 1.15, 1.12, 1.14, 1.11, 1.15, 1.13, 1.12]	10.97	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
860	2026-05-09	14h	14h-22h	Chaîne 8	[1.15, 1.12, 1.14, 1.1, 1.12, 1.11, 1.14, 1.11, 1.1, 1.12, 1.13, 1.13, 1.1, 1.11, 1.14, 1.15, 1.12, 1.14, 1.11, 1.1]	11.01	5.21	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
861	2026-05-09	22h	22h-6h	Chaîne 8	[1.14, 1.11, 1.13, 1.14, 1.13, 1.12, 1.13, 1.12, 1.11, 1.12, 1.15, 1.12, 1.13, 1.12, 1.13, 1.12, 1.12, 1.12, 1.11, 1.13]	10.65	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
862	2026-05-09	6h	6h-14h	Chaîne 14	[1.15, 1.12, 1.12, 1.12, 1.13, 1.12, 1.14, 1.15, 1.12, 1.14, 1.14, 1.12, 1.14, 1.14, 1.15, 1.11]	10.81	5.17	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
863	2026-05-09	14h	14h-22h	Chaîne 14	[1.13, 1.14, 1.13, 1.11, 1.14, 1.13, 1.15, 1.12, 1.15, 1.13, 1.11, 1.14, 1.14, 1.15, 1.14, 1.14]	11.08	5.18	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
864	2026-05-09	22h	22h-6h	Chaîne 14	[1.11, 1.11, 1.13, 1.12, 1.11, 1.12, 1.15, 1.13, 1.14, 1.13, 1.14, 1.11, 1.12, 1.13, 1.12, 1.15]	11.08	5.49	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
865	2026-05-09	6h	6h-14h	Chaîne 15	[1.15, 1.11, 1.1, 1.14, 1.13, 1.14, 1.15, 1.12, 1.11, 1.15, 1.11, 1.15, 1.13, 1.11, 1.11, 1.14, 1.13, 1.11, 1.13, 1.12, 1.15, 1.12, 1.12, 1.1]	11.14	5.64	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
866	2026-05-09	14h	14h-22h	Chaîne 15	[1.11, 1.11, 1.1, 1.1, 1.11, 1.11, 1.11, 1.12, 1.11, 1.13, 1.14, 1.12, 1.11, 1.15, 1.1, 1.13, 1.15, 1.13, 1.12, 1.11, 1.13, 1.14, 1.12, 1.14]	11.01	5.57	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
867	2026-05-09	22h	22h-6h	Chaîne 15	[1.14, 1.12, 1.1, 1.11, 1.13, 1.14, 1.11, 1.11, 1.14, 1.11, 1.14, 1.13, 1.14, 1.11, 1.12, 1.11, 1.13, 1.1, 1.1, 1.14, 1.13, 1.11, 1.13, 1.12]	11.2	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
868	2026-05-09	6h	6h-14h	Chaîne 16	[1.15, 1.14, 1.13, 1.13, 1.11, 1.1, 1.14, 1.13, 1.1, 1.12, 1.13, 1.13, 1.12, 1.1, 1.11, 1.11, 1.12, 1.11, 1.13, 1.13, 1.12, 1.11, 1.14, 1.15]	10.88	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
869	2026-05-09	14h	14h-22h	Chaîne 16	[1.1, 1.14, 1.15, 1.11, 1.14, 1.12, 1.11, 1.13, 1.11, 1.13, 1.13, 1.1, 1.12, 1.12, 1.14, 1.12, 1.1, 1.12, 1.15, 1.12, 1.11, 1.13, 1.12, 1.1]	11	5.14	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
870	2026-05-09	22h	22h-6h	Chaîne 16	[1.13, 1.14, 1.13, 1.1, 1.11, 1.14, 1.14, 1.12, 1.12, 1.12, 1.14, 1.13, 1.11, 1.12, 1.13, 1.15, 1.14, 1.12, 1.11, 1.15, 1.13, 1.1, 1.1, 1.12]	10.82	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
871	2026-05-10	6h	6h-14h	Chaîne 8	[1.14, 1.12, 1.14, 1.12, 1.1, 1.12, 1.11, 1.12, 1.15, 1.14, 1.15, 1.14, 1.12, 1.13, 1.14, 1.14, 1.13, 1.12, 1.11, 1.11]	10.7	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
872	2026-05-10	14h	14h-22h	Chaîne 8	[1.12, 1.14, 1.12, 1.11, 1.13, 1.1, 1.12, 1.14, 1.12, 1.14, 1.14, 1.13, 1.15, 1.12, 1.14, 1.14, 1.11, 1.1, 1.13, 1.14]	10.8	5.4	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
873	2026-05-10	22h	22h-6h	Chaîne 8	[1.12, 1.12, 1.12, 1.11, 1.14, 1.12, 1.12, 1.13, 1.14, 1.11, 1.12, 1.13, 1.11, 1.12, 1.15, 1.13, 1.14, 1.13, 1.13, 1.11]	10.63	5.19	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
874	2026-05-10	6h	6h-14h	Chaîne 14	[1.14, 1.12, 1.11, 1.11, 1.12, 1.13, 1.1, 1.14, 1.12, 1.12, 1.12, 1.13, 1.12, 1.14, 1.11, 1.13]	11.04	5.48	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
875	2026-05-10	14h	14h-22h	Chaîne 14	[1.15, 1.14, 1.15, 1.11, 1.13, 1.12, 1.11, 1.14, 1.12, 1.15, 1.13, 1.11, 1.11, 1.11, 1.13, 1.14]	10.98	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
876	2026-05-10	22h	22h-6h	Chaîne 14	[1.15, 1.12, 1.15, 1.11, 1.11, 1.15, 1.12, 1.12, 1.11, 1.12, 1.13, 1.12, 1.14, 1.13, 1.1, 1.13]	11.14	5.47	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
877	2026-05-10	6h	6h-14h	Chaîne 15	[1.14, 1.12, 1.11, 1.15, 1.13, 1.14, 1.13, 1.1, 1.11, 1.12, 1.12, 1.11, 1.14, 1.12, 1.15, 1.12, 1.15, 1.15, 1.12, 1.14, 1.12, 1.14, 1.15, 1.13]	11.35	5.43	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
878	2026-05-10	14h	14h-22h	Chaîne 15	[1.12, 1.15, 1.1, 1.15, 1.15, 1.13, 1.15, 1.15, 1.15, 1.14, 1.13, 1.13, 1.12, 1.13, 1.12, 1.15, 1.13, 1.11, 1.14, 1.1, 1.14, 1.14, 1.13, 1.14]	11.05	5.39	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
879	2026-05-10	22h	22h-6h	Chaîne 15	[1.13, 1.12, 1.1, 1.1, 1.1, 1.13, 1.12, 1.13, 1.11, 1.1, 1.13, 1.14, 1.13, 1.1, 1.14, 1.12, 1.11, 1.15, 1.1, 1.11, 1.12, 1.11, 1.14, 1.1]	11.08	5.61	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
880	2026-05-10	6h	6h-14h	Chaîne 16	[1.14, 1.11, 1.14, 1.1, 1.17, 1.14, 1.11, 1.18, 1.15, 1.11, 1.1, 1.15, 1.05, 1.12, 1.15, 1.13, 1.11, 1.13, 1.13, 1.12, 1.14, 1.14, 1.12, 1.15]	12.41	5.91	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
881	2026-05-10	14h	14h-22h	Chaîne 16	[1.08, 1.11, 1.11, 1.11, 1.13, 1.14, 1.14, 1.13, 1.14, 1.14, 1.06, 1.13, 1.13, 1.11, 1.09, 1.15, 1.15, 1.15, 1.14, 1.1, 1.14, 1.14, 1.13, 1.1]	11.95	6.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
882	2026-05-10	22h	22h-6h	Chaîne 16	[1.14, 1.11, 1.15, 1.12, 1.14, 1.09, 1.14, 1.11, 1.11, 1.12, 1.13, 1.12, 1.12, 1.14, 1.13, 1.11, 1.15, 1.12, 1.12, 1.06, 1.12, 1.14, 1.12, 1.14]	12.37	6.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
883	2026-05-11	6h	6h-14h	Chaîne 14	[1.11, 1.11, 1.11, 1.1, 1.12, 1.13, 1.1, 1.14, 1.14, 1.11, 1.14, 1.15, 1.15, 1.13, 1.11, 1.11]	11.09	5.5	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
884	2026-05-11	14h	14h-22h	Chaîne 14	[1.14, 1.14, 1.13, 1.13, 1.11, 1.13, 1.11, 1.15, 1.13, 1.15, 1.11, 1.14, 1.11, 1.13, 1.13, 1.14]	11.2	5.23	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
885	2026-05-11	22h	22h-6h	Chaîne 14	[1.14, 1.1, 1.11, 1.12, 1.15, 1.14, 1.12, 1.14, 1.12, 1.1, 1.14, 1.11, 1.13, 1.13, 1.14, 1.13]	11.13	5.12	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
886	2026-05-11	6h	6h-14h	Chaîne 15	[1.12, 1.13, 1.1, 1.15, 1.11, 1.11, 1.12, 1.12, 1.11, 1.14, 1.1, 1.12, 1.15, 1.14, 1.11, 1.13, 1.13, 1.12, 1.11, 1.13, 1.13, 1.11, 1.14, 1.14]	11.2	5.65	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
887	2026-05-11	14h	14h-22h	Chaîne 15	[1.14, 1.1, 1.11, 1.1, 1.12, 1.11, 1.11, 1.14, 1.13, 1.1, 1.15, 1.12, 1.11, 1.11, 1.11, 1.12, 1.11, 1.13, 1.13, 1.11, 1.14, 1.11, 1.11, 1.12]	11.13	5.37	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
888	2026-05-11	22h	22h-6h	Chaîne 15	[1.13, 1.12, 1.14, 1.15, 1.11, 1.15, 1.1, 1.11, 1.14, 1.14, 1.13, 1.15, 1.12, 1.1, 1.13, 1.11, 1.14, 1.14, 1.11, 1.11, 1.14, 1.1, 1.12, 1.13]	11.29	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
889	2026-05-11	6h	6h-14h	Chaîne 16	[1.15, 1.15, 1.15, 1.13, 1.14, 1.11, 1.13, 1.14, 1.12, 1.12, 1.11, 1.15, 1.12, 1.11, 1.15, 1.13, 1.11, 1.11, 1.11, 1.14, 1.12, 1.14, 1.11, 1.14]	11.11	5.3	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
890	2026-05-11	14h	14h-22h	Chaîne 16	[1.1, 1.1, 1.11, 1.12, 1.13, 1.12, 1.14, 1.13, 1.12, 1.12, 1.14, 1.12, 1.13, 1.13, 1.12, 1.15, 1.13, 1.14, 1.13, 1.11, 1.1, 1.11, 1.14, 1.14]	11.16	4.99	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
891	2026-05-11	22h	22h-6h	Chaîne 16	[1.14, 1.13, 1.12, 1.11, 1.13, 1.12, 1.13, 1.14, 1.14, 1.1, 1.14, 1.12, 1.12, 1.13, 1.15, 1.13, 1.13, 1.12, 1.15, 1.14, 1.13, 1.11, 1.12, 1.13]	11.04	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
892	2026-05-12	6h	6h-14h	Chaîne 8	[1.11, 1.11, 1.11, 1.12, 1.1, 1.13, 1.14, 1.14, 1.1, 1.13, 1.1, 1.12, 1.12, 1.14, 1.14, 1.13, 1.15, 1.12, 1.13, 1.12]	10.87	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
893	2026-05-12	14h	14h-22h	Chaîne 8	[1.12, 1.12, 1.14, 1.12, 1.12, 1.11, 1.12, 1.12, 1.1, 1.13, 1.14, 1.14, 1.11, 1.12, 1.15, 1.1, 1.1, 1.13, 1.12, 1.13]	10.99	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
894	2026-05-12	22h	22h-6h	Chaîne 8	[1.12, 1.11, 1.13, 1.1, 1.12, 1.13, 1.11, 1.14, 1.14, 1.11, 1.11, 1.12, 1.11, 1.14, 1.11, 1.13, 1.11, 1.12, 1.14, 1.12]	10.68	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
895	2026-05-12	6h	6h-14h	Chaîne 15	[1.11, 1.14, 1.11, 1.13, 1.14, 1.1, 1.1, 1.1, 1.11, 1.11, 1.12, 1.15, 1.15, 1.12, 1.15, 1.11, 1.12, 1.13, 1.15, 1.12, 1.15, 1.12, 1.12, 1.13]	11.11	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
896	2026-05-12	14h	14h-22h	Chaîne 15	[1.11, 1.11, 1.11, 1.14, 1.11, 1.12, 1.14, 1.12, 1.14, 1.15, 1.11, 1.1, 1.12, 1.13, 1.1, 1.11, 1.15, 1.14, 1.11, 1.14, 1.14, 1.1, 1.1, 1.12]	11.32	5.56	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
897	2026-05-12	22h	22h-6h	Chaîne 15	[1.13, 1.12, 1.11, 1.1, 1.11, 1.12, 1.12, 1.13, 1.14, 1.14, 1.12, 1.11, 1.11, 1.14, 1.11, 1.13, 1.11, 1.13, 1.12, 1.14, 1.11, 1.12, 1.12, 1.12]	11.32	5.49	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
898	2026-05-12	6h	6h-14h	Chaîne 16	[1.15, 1.14, 1.13, 1.11, 1.13, 1.1, 1.1, 1.11, 1.15, 1.14, 1.14, 1.13, 1.14, 1.14, 1.14, 1.14, 1.13, 1.14, 1.14, 1.12, 1.13, 1.13, 1.14, 1.14]	11.08	5.25	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
899	2026-05-12	14h	14h-22h	Chaîne 16	[1.11, 1.14, 1.14, 1.13, 1.12, 1.15, 1.12, 1.1, 1.14, 1.11, 1.13, 1.12, 1.13, 1.1, 1.12, 1.1, 1.12, 1.1, 1.14, 1.14, 1.14, 1.15, 1.12, 1.11]	10.82	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
900	2026-05-12	22h	22h-6h	Chaîne 16	[1.15, 1.11, 1.12, 1.15, 1.13, 1.14, 1.12, 1.11, 1.11, 1.14, 1.15, 1.11, 1.13, 1.13, 1.15, 1.13, 1.1, 1.15, 1.11, 1.11, 1.11, 1.14, 1.15, 1.11]	11.18	5.11	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
901	2026-05-13	6h	6h-14h	Chaîne 8	[1.1, 1.13, 1.1, 1.12, 1.15, 1.11, 1.13, 1.1, 1.1, 1.13, 1.12, 1.12, 1.12, 1.1, 1.12, 1.12, 1.12, 1.11, 1.1, 1.12]	10.91	5.18	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
902	2026-05-13	14h	14h-22h	Chaîne 8	[1.1, 1.1, 1.13, 1.12, 1.11, 1.15, 1.15, 1.12, 1.12, 1.14, 1.12, 1.15, 1.14, 1.11, 1.12, 1.13, 1.12, 1.11, 1.11, 1.15]	10.81	5.1	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
903	2026-05-13	22h	22h-6h	Chaîne 8	[1.1, 1.15, 1.11, 1.11, 1.15, 1.14, 1.12, 1.13, 1.12, 1.11, 1.11, 1.13, 1.12, 1.13, 1.12, 1.14, 1.12, 1.15, 1.11, 1.15]	10.94	5.4	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
904	2026-05-13	6h	6h-14h	Chaîne 14	[1.13, 1.11, 1.13, 1.15, 1.11, 1.12, 1.11, 1.14, 1.12, 1.14, 1.11, 1.15, 1.11, 1.13, 1.12, 1.12]	11.11	5.22	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
905	2026-05-13	14h	14h-22h	Chaîne 14	[1.14, 1.15, 1.11, 1.13, 1.14, 1.13, 1.12, 1.12, 1.1, 1.14, 1.15, 1.15, 1.11, 1.11, 1.11, 1.14]	11.03	5.24	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
906	2026-05-13	22h	22h-6h	Chaîne 14	[1.11, 1.14, 1.11, 1.11, 1.1, 1.13, 1.13, 1.13, 1.15, 1.12, 1.11, 1.12, 1.11, 1.13, 1.13, 1.12]	11.16	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
907	2026-05-13	6h	6h-14h	Chaîne 16	[1.13, 1.14, 1.1, 1.1, 1.15, 1.12, 1.1, 1.1, 1.1, 1.15, 1.14, 1.13, 1.14, 1.1, 1.12, 1.1, 1.1, 1.13, 1.11, 1.11, 1.11, 1.14, 1.13, 1.13]	11.04	5.05	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
908	2026-05-13	14h	14h-22h	Chaîne 16	[1.12, 1.13, 1.1, 1.13, 1.15, 1.15, 1.14, 1.14, 1.12, 1.11, 1.15, 1.1, 1.11, 1.11, 1.11, 1.13, 1.15, 1.12, 1.13, 1.13, 1.12, 1.15, 1.12, 1.12]	10.87	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
909	2026-05-13	22h	22h-6h	Chaîne 16	[1.14, 1.12, 1.11, 1.12, 1.1, 1.13, 1.15, 1.11, 1.1, 1.11, 1.11, 1.11, 1.13, 1.13, 1.12, 1.11, 1.15, 1.13, 1.1, 1.14, 1.12, 1.1, 1.11, 1.11]	10.79	5.08	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
910	2026-05-14	6h	6h-14h	Chaîne 8	[1.12, 1.12, 1.11, 1.12, 1.13, 1.12, 1.11, 1.14, 1.13, 1.14, 1.11, 1.11, 1.11, 1.13, 1.14, 1.11, 1.13, 1.11, 1.15, 1.14]	10.81	5.36	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
911	2026-05-14	14h	14h-22h	Chaîne 8	[1.1, 1.11, 1.13, 1.13, 1.12, 1.12, 1.1, 1.12, 1.14, 1.13, 1.13, 1.13, 1.14, 1.15, 1.13, 1.11, 1.12, 1.12, 1.13, 1.11]	10.62	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
912	2026-05-14	22h	22h-6h	Chaîne 8	[1.15, 1.12, 1.1, 1.11, 1.12, 1.11, 1.13, 1.1, 1.13, 1.12, 1.13, 1.13, 1.12, 1.14, 1.14, 1.15, 1.14, 1.11, 1.14, 1.15]	10.66	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
913	2026-05-14	6h	6h-14h	Chaîne 14	[1.13, 1.15, 1.15, 1.12, 1.11, 1.13, 1.11, 1.12, 1.15, 1.12, 1.12, 1.11, 1.12, 1.13, 1.14, 1.11]	10.9	5.12	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
914	2026-05-14	14h	14h-22h	Chaîne 14	[1.11, 1.13, 1.11, 1.12, 1.15, 1.14, 1.11, 1.11, 1.14, 1.13, 1.13, 1.11, 1.11, 1.12, 1.14, 1.15]	11.09	5.33	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
915	2026-05-14	22h	22h-6h	Chaîne 14	[1.12, 1.14, 1.1, 1.13, 1.11, 1.13, 1.12, 1.14, 1.13, 1.12, 1.11, 1.14, 1.12, 1.12, 1.13, 1.1]	11.15	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
916	2026-05-14	6h	6h-14h	Chaîne 15	[1.13, 1.1, 1.12, 1.15, 1.11, 1.11, 1.1, 1.14, 1.13, 1.1, 1.15, 1.13, 1.13, 1.14, 1.13, 1.11, 1.12, 1.14, 1.13, 1.15, 1.14, 1.11, 1.15, 1.1]	11.03	5.47	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
917	2026-05-14	14h	14h-22h	Chaîne 15	[1.12, 1.11, 1.14, 1.11, 1.11, 1.11, 1.15, 1.12, 1.12, 1.11, 1.12, 1.1, 1.13, 1.11, 1.14, 1.13, 1.1, 1.14, 1.1, 1.12, 1.11, 1.15, 1.14, 1.11]	11.15	5.53	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
918	2026-05-14	22h	22h-6h	Chaîne 15	[1.12, 1.14, 1.14, 1.11, 1.14, 1.14, 1.12, 1.13, 1.13, 1.11, 1.14, 1.13, 1.1, 1.13, 1.13, 1.15, 1.13, 1.13, 1.11, 1.15, 1.14, 1.15, 1.14, 1.12]	11.34	5.55	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
919	2026-05-15	6h	6h-14h	Chaîne 8	[1.1, 1.12, 1.13, 1.1, 1.11, 1.11, 1.15, 1.14, 1.13, 1.14, 1.1, 1.14, 1.12, 1.14, 1.12, 1.14, 1.14, 1.12, 1.15, 1.11]	10.82	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
920	2026-05-15	14h	14h-22h	Chaîne 8	[1.14, 1.13, 1.12, 1.12, 1.13, 1.15, 1.1, 1.13, 1.14, 1.15, 1.14, 1.11, 1.14, 1.14, 1.12, 1.15, 1.12, 1.11, 1.14, 1.13]	10.84	5.07	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
921	2026-05-15	22h	22h-6h	Chaîne 8	[1.14, 1.13, 1.15, 1.11, 1.14, 1.11, 1.14, 1.13, 1.12, 1.1, 1.13, 1.11, 1.12, 1.14, 1.11, 1.13, 1.13, 1.13, 1.13, 1.11]	10.98	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
922	2026-05-15	6h	6h-14h	Chaîne 14	[1.14, 1.14, 1.11, 1.11, 1.15, 1.12, 1.12, 1.1, 1.14, 1.14, 1.11, 1.13, 1.14, 1.14, 1.13, 1.14]	11.03	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
923	2026-05-15	14h	14h-22h	Chaîne 14	[1.11, 1.13, 1.12, 1.11, 1.14, 1.14, 1.1, 1.1, 1.11, 1.13, 1.13, 1.15, 1.14, 1.15, 1.13, 1.11]	10.83	5.42	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
924	2026-05-15	22h	22h-6h	Chaîne 14	[1.14, 1.14, 1.11, 1.13, 1.15, 1.11, 1.11, 1.14, 1.14, 1.15, 1.11, 1.12, 1.15, 1.14, 1.11, 1.13]	11.2	5.28	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
925	2026-05-15	6h	6h-14h	Chaîne 15	[1.13, 1.12, 1.13, 1.12, 1.13, 1.11, 1.13, 1.12, 1.13, 1.14, 1.1, 1.12, 1.12, 1.14, 1.15, 1.13, 1.12, 1.15, 1.11, 1.15, 1.13, 1.1, 1.13, 1.12]	11	5.64	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
926	2026-05-15	14h	14h-22h	Chaîne 15	[1.13, 1.11, 1.11, 1.14, 1.12, 1.1, 1.15, 1.12, 1.13, 1.12, 1.15, 1.12, 1.14, 1.14, 1.11, 1.14, 1.15, 1.15, 1.13, 1.12, 1.11, 1.12, 1.12, 1.13]	10.98	5.5	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
927	2026-05-15	22h	22h-6h	Chaîne 15	[1.11, 1.14, 1.12, 1.1, 1.11, 1.12, 1.12, 1.13, 1.15, 1.1, 1.15, 1.1, 1.12, 1.12, 1.1, 1.12, 1.12, 1.15, 1.14, 1.13, 1.14, 1.14, 1.11, 1.11]	11.03	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
928	2026-05-15	6h	6h-14h	Chaîne 16	[1.12, 1.12, 1.15, 1.11, 1.11, 1.15, 1.13, 1.13, 1.13, 1.12, 1.11, 1.12, 1.13, 1.11, 1.1, 1.11, 1.12, 1.14, 1.12, 1.12, 1.11, 1.12, 1.14, 1.12]	11.13	5.34	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
929	2026-05-15	14h	14h-22h	Chaîne 16	[1.13, 1.13, 1.11, 1.14, 1.1, 1.13, 1.13, 1.14, 1.12, 1.12, 1.13, 1.14, 1.11, 1.15, 1.14, 1.13, 1.11, 1.13, 1.11, 1.13, 1.12, 1.12, 1.1, 1.11]	10.84	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
930	2026-05-15	22h	22h-6h	Chaîne 16	[1.13, 1.11, 1.12, 1.1, 1.12, 1.12, 1.11, 1.11, 1.11, 1.1, 1.13, 1.13, 1.14, 1.14, 1.13, 1.13, 1.14, 1.14, 1.11, 1.15, 1.14, 1.13, 1.11, 1.14]	11.08	5.06	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
931	2026-05-16	6h	6h-14h	Chaîne 8	[1.12, 1.11, 1.12, 1.1, 1.11, 1.13, 1.12, 1.13, 1.14, 1.14, 1.14, 1.15, 1.1, 1.11, 1.11, 1.13, 1.14, 1.14, 1.1, 1.1]	10.97	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
932	2026-05-16	14h	14h-22h	Chaîne 8	[1.11, 1.12, 1.14, 1.12, 1.13, 1.1, 1.12, 1.14, 1.11, 1.11, 1.13, 1.15, 1.15, 1.11, 1.12, 1.12, 1.12, 1.11, 1.12, 1.15]	10.8	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
933	2026-05-16	22h	22h-6h	Chaîne 8	[1.11, 1.13, 1.13, 1.12, 1.15, 1.13, 1.11, 1.13, 1.14, 1.11, 1.14, 1.11, 1.12, 1.14, 1.14, 1.14, 1.11, 1.12, 1.1, 1.11]	10.92	5.01	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
934	2026-05-16	6h	6h-14h	Chaîne 14	[1.15, 1.12, 1.12, 1.12, 1.14, 1.14, 1.13, 1.11, 1.13, 1.11, 1.11, 1.11, 1.14, 1.11, 1.13, 1.12]	10.78	5.17	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
935	2026-05-16	14h	14h-22h	Chaîne 14	[1.1, 1.12, 1.15, 1.11, 1.1, 1.13, 1.14, 1.12, 1.14, 1.11, 1.11, 1.12, 1.13, 1.14, 1.1, 1.14]	11.21	5.32	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
936	2026-05-16	22h	22h-6h	Chaîne 14	[1.1, 1.1, 1.15, 1.1, 1.15, 1.13, 1.1, 1.13, 1.1, 1.11, 1.13, 1.12, 1.14, 1.1, 1.1, 1.12]	11.09	5.36	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
937	2026-05-16	6h	6h-14h	Chaîne 15	[1.15, 1.14, 1.12, 1.05, 1.13, 1.13, 1.21, 1.12, 1.11, 1.16, 1.12, 1.06, 1.15, 1.14, 1.11, 1.14, 1.12, 1.12, 1.13, 1.13, 1.14, 1.13, 1.11, 1.21]	11.05	5.68	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
938	2026-05-16	14h	14h-22h	Chaîne 15	[1.14, 1.13, 1.07, 1.19, 1.13, 1.11, 1.13, 1.1, 1.1, 1.15, 1.14, 1.13, 1.11, 1.14, 1.13, 1.12, 1.11, 1.1, 1.21, 1.13, 1.11, 1.11, 1.21, 1.21]	11.33	5.41	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
939	2026-05-16	22h	22h-6h	Chaîne 15	[1.19, 1.12, 1.11, 1.13, 1.15, 1.13, 1.11, 1.12, 1.12, 1.19, 1.11, 1.13, 1.08, 1.15, 1.2, 1.13, 1.11, 1.13, 1.15, 1.14, 1.14, 1.12, 1.13, 1.13]	11.37	5.3	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
940	2026-05-16	6h	6h-14h	Chaîne 16	[1.13, 1.13, 1.13, 1.12, 1.15, 1.13, 1.15, 1.12, 1.11, 1.13, 1.14, 1.14, 1.15, 1.11, 1.1, 1.15, 1.15, 1.11, 1.15, 1.15, 1.15, 1.12, 1.14, 1.1]	10.97	5.35	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
941	2026-05-16	14h	14h-22h	Chaîne 16	[1.13, 1.11, 1.14, 1.14, 1.13, 1.14, 1.12, 1.11, 1.14, 1.13, 1.12, 1.15, 1.1, 1.12, 1.13, 1.12, 1.14, 1.14, 1.11, 1.14, 1.15, 1.14, 1.1, 1.12]	10.87	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
942	2026-05-16	22h	22h-6h	Chaîne 16	[1.1, 1.14, 1.15, 1.11, 1.14, 1.13, 1.14, 1.12, 1.13, 1.13, 1.11, 1.11, 1.14, 1.12, 1.11, 1.1, 1.14, 1.11, 1.1, 1.13, 1.1, 1.13, 1.11, 1.15]	10.98	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
943	2026-05-17	6h	6h-14h	Chaîne 8	[1.11, 1.12, 1.14, 1.11, 1.13, 1.1, 1.13, 1.13, 1.13, 1.12, 1.1, 1.11, 1.13, 1.14, 1.12, 1.13, 1.15, 1.12, 1.15, 1.11]	10.96	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
944	2026-05-17	14h	14h-22h	Chaîne 8	[1.1, 1.11, 1.11, 1.13, 1.14, 1.11, 1.13, 1.13, 1.15, 1.1, 1.14, 1.14, 1.11, 1.11, 1.1, 1.14, 1.15, 1.13, 1.15, 1.11]	10.95	5.4	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
945	2026-05-17	22h	22h-6h	Chaîne 8	[1.14, 1.15, 1.14, 1.11, 1.13, 1.15, 1.12, 1.11, 1.11, 1.15, 1.15, 1.1, 1.11, 1.13, 1.14, 1.11, 1.13, 1.14, 1.14, 1.15]	10.73	5.19	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
946	2026-05-17	6h	6h-14h	Chaîne 14	[1.14, 1.1, 1.11, 1.11, 1.13, 1.14, 1.12, 1.1, 1.11, 1.12, 1.14, 1.13, 1.11, 1.13, 1.14, 1.14]	11.13	5.44	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
947	2026-05-17	14h	14h-22h	Chaîne 14	[1.13, 1.14, 1.13, 1.15, 1.14, 1.14, 1.15, 1.13, 1.11, 1.11, 1.12, 1.13, 1.14, 1.1, 1.14, 1.12]	10.93	5.21	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
948	2026-05-17	22h	22h-6h	Chaîne 14	[1.15, 1.13, 1.15, 1.11, 1.13, 1.12, 1.11, 1.11, 1.11, 1.14, 1.15, 1.11, 1.13, 1.12, 1.13, 1.15]	10.93	5.35	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
949	2026-05-17	6h	6h-14h	Chaîne 15	[1.15, 1.12, 1.1, 1.12, 1.13, 1.13, 1.11, 1.1, 1.15, 1.1, 1.14, 1.11, 1.13, 1.13, 1.11, 1.15, 1.12, 1.14, 1.12, 1.13, 1.11, 1.12, 1.13, 1.12]	11.24	5.54	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
950	2026-05-17	14h	14h-22h	Chaîne 15	[1.12, 1.12, 1.11, 1.13, 1.12, 1.13, 1.12, 1.15, 1.15, 1.12, 1.12, 1.13, 1.12, 1.15, 1.13, 1.11, 1.15, 1.12, 1.12, 1.13, 1.15, 1.1, 1.12, 1.14]	11.07	5.4	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
951	2026-05-17	22h	22h-6h	Chaîne 15	[1.1, 1.11, 1.12, 1.11, 1.12, 1.14, 1.13, 1.12, 1.14, 1.1, 1.12, 1.13, 1.13, 1.15, 1.11, 1.14, 1.12, 1.12, 1.14, 1.13, 1.14, 1.1, 1.14, 1.12]	11.37	5.7	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
952	2026-05-17	6h	6h-14h	Chaîne 16	[1.12, 1.1, 1.14, 1.13, 1.12, 1.1, 1.14, 1.12, 1.14, 1.11, 1.15, 1.14, 1.14, 1.11, 1.15, 1.1, 1.14, 1.13, 1.15, 1.12, 1.11, 1.14, 1.14, 1.13]	11.06	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
953	2026-05-17	14h	14h-22h	Chaîne 16	[1.1, 1.1, 1.15, 1.12, 1.15, 1.1, 1.14, 1.13, 1.15, 1.12, 1.12, 1.1, 1.15, 1.1, 1.15, 1.11, 1.14, 1.14, 1.14, 1.11, 1.14, 1.14, 1.12, 1.11]	10.94	5.23	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
954	2026-05-17	22h	22h-6h	Chaîne 16	[1.14, 1.11, 1.14, 1.13, 1.14, 1.14, 1.13, 1.15, 1.1, 1.11, 1.14, 1.13, 1.11, 1.13, 1.13, 1.13, 1.13, 1.14, 1.13, 1.13, 1.12, 1.12, 1.11, 1.14]	11	5.11	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
955	2026-05-18	6h	6h-14h	Chaîne 14	[1.14, 1.15, 1.15, 1.1, 1.14, 1.11, 1.13, 1.13, 1.13, 1.14, 1.14, 1.12, 1.1, 1.14, 1.1, 1.11]	10.8	5.22	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
956	2026-05-18	14h	14h-22h	Chaîne 14	[1.14, 1.12, 1.12, 1.1, 1.14, 1.12, 1.14, 1.11, 1.14, 1.13, 1.11, 1.1, 1.12, 1.14, 1.11, 1.1]	10.97	5.49	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
957	2026-05-18	22h	22h-6h	Chaîne 14	[1.13, 1.12, 1.14, 1.1, 1.11, 1.14, 1.13, 1.14, 1.11, 1.12, 1.14, 1.1, 1.12, 1.13, 1.12, 1.13]	11.21	5.11	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
958	2026-05-18	6h	6h-14h	Chaîne 15	[1.14, 1.12, 1.14, 1.14, 1.13, 1.14, 1.1, 1.13, 1.13, 1.11, 1.11, 1.11, 1.14, 1.14, 1.12, 1.14, 1.14, 1.11, 1.14, 1.13, 1.13, 1.11, 1.14, 1.11]	11.29	5.31	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
959	2026-05-18	14h	14h-22h	Chaîne 15	[1.12, 1.15, 1.14, 1.12, 1.15, 1.11, 1.13, 1.11, 1.13, 1.12, 1.1, 1.11, 1.12, 1.14, 1.14, 1.11, 1.12, 1.13, 1.11, 1.14, 1.11, 1.14, 1.14, 1.11]	11.39	5.65	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
960	2026-05-18	22h	22h-6h	Chaîne 15	[1.12, 1.12, 1.14, 1.1, 1.11, 1.14, 1.11, 1.12, 1.11, 1.12, 1.14, 1.13, 1.12, 1.1, 1.11, 1.13, 1.1, 1.11, 1.14, 1.11, 1.14, 1.12, 1.11, 1.11]	11.16	5.68	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
961	2026-05-18	6h	6h-14h	Chaîne 16	[1.12, 1.1, 1.13, 1.12, 1.14, 1.14, 1.12, 1.14, 1.11, 1.15, 1.15, 1.11, 1.12, 1.15, 1.12, 1.14, 1.15, 1.15, 1.15, 1.15, 1.12, 1.1, 1.11, 1.1]	10.95	5	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
962	2026-05-18	14h	14h-22h	Chaîne 16	[1.11, 1.1, 1.1, 1.13, 1.12, 1.15, 1.11, 1.14, 1.15, 1.15, 1.12, 1.13, 1.15, 1.13, 1.13, 1.13, 1.14, 1.14, 1.14, 1.14, 1.12, 1.13, 1.13, 1.13]	11.08	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
963	2026-05-18	22h	22h-6h	Chaîne 16	[1.1, 1.13, 1.15, 1.1, 1.11, 1.11, 1.14, 1.14, 1.14, 1.14, 1.15, 1.11, 1.14, 1.13, 1.13, 1.11, 1.14, 1.12, 1.12, 1.1, 1.12, 1.14, 1.15, 1.12]	10.89	5.32	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
964	2026-05-19	6h	6h-14h	Chaîne 8	[1.11, 1.14, 1.15, 1.14, 1.12, 1.13, 1.15, 1.14, 1.11, 1.12, 1.13, 1.15, 1.11, 1.15, 1.14, 1.15, 1.15, 1.14, 1.13, 1.12]	10.85	5.15	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
965	2026-05-19	14h	14h-22h	Chaîne 8	[1.13, 1.14, 1.12, 1.15, 1.13, 1.12, 1.1, 1.15, 1.14, 1.1, 1.12, 1.12, 1.15, 1.11, 1.13, 1.13, 1.13, 1.12, 1.12, 1.1]	10.88	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
966	2026-05-19	22h	22h-6h	Chaîne 8	[1.13, 1.14, 1.14, 1.14, 1.12, 1.12, 1.11, 1.15, 1.14, 1.13, 1.13, 1.12, 1.13, 1.14, 1.14, 1.14, 1.13, 1.13, 1.13, 1.13]	10.62	5.38	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
967	2026-05-19	6h	6h-14h	Chaîne 15	[1.11, 1.15, 1.15, 1.12, 1.13, 1.11, 1.12, 1.1, 1.15, 1.11, 1.12, 1.13, 1.15, 1.15, 1.14, 1.11, 1.14, 1.12, 1.14, 1.11, 1.14, 1.14, 1.12, 1.15]	10.99	5.67	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
968	2026-05-19	14h	14h-22h	Chaîne 15	[1.11, 1.13, 1.15, 1.12, 1.1, 1.12, 1.13, 1.11, 1.11, 1.11, 1.12, 1.1, 1.1, 1.13, 1.14, 1.14, 1.13, 1.11, 1.11, 1.12, 1.15, 1.1, 1.12, 1.12]	11.2	5.6	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
969	2026-05-19	22h	22h-6h	Chaîne 15	[1.12, 1.12, 1.14, 1.13, 1.15, 1.14, 1.1, 1.1, 1.13, 1.14, 1.1, 1.14, 1.13, 1.15, 1.12, 1.14, 1.12, 1.14, 1.13, 1.13, 1.14, 1.15, 1.14, 1.12]	11.23	5.72	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
970	2026-05-19	6h	6h-14h	Chaîne 16	[1.13, 1.13, 1.13, 1.13, 1.12, 1.12, 1.12, 1.12, 1.13, 1.13, 1.12, 1.14, 1.14, 1.13, 1.11, 1.12, 1.12, 1.11, 1.12, 1.12, 1.11, 1.14, 1.13, 1.13]	11.2	5.36	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
971	2026-05-19	14h	14h-22h	Chaîne 16	[1.1, 1.12, 1.11, 1.13, 1.15, 1.1, 1.11, 1.14, 1.13, 1.15, 1.12, 1.15, 1.12, 1.12, 1.11, 1.13, 1.14, 1.1, 1.15, 1.14, 1.14, 1.14, 1.1, 1.12]	10.92	5.31	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
972	2026-05-19	22h	22h-6h	Chaîne 16	[1.12, 1.13, 1.13, 1.1, 1.14, 1.12, 1.14, 1.11, 1.14, 1.14, 1.13, 1.11, 1.11, 1.12, 1.11, 1.11, 1.11, 1.15, 1.13, 1.11, 1.15, 1.13, 1.12, 1.14]	10.83	5.13	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
973	2026-05-20	6h	6h-14h	Chaîne 8	[1.14, 1.13, 1.14, 1.1, 1.13, 1.12, 1.13, 1.11, 1.14, 1.11, 1.12, 1.11, 1.11, 1.14, 1.11, 1.11, 1.13, 1.14, 1.13, 1.13]	10.68	5.09	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
974	2026-05-20	14h	14h-22h	Chaîne 8	[1.13, 1.14, 1.13, 1.12, 1.15, 1.13, 1.12, 1.12, 1.13, 1.13, 1.14, 1.13, 1.12, 1.12, 1.14, 1.12, 1.14, 1.13, 1.1, 1.12]	10.59	5.19	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
975	2026-05-20	22h	22h-6h	Chaîne 8	[1.15, 1.15, 1.12, 1.13, 1.13, 1.11, 1.15, 1.13, 1.13, 1.13, 1.13, 1.11, 1.12, 1.15, 1.12, 1.15, 1.13, 1.14, 1.13, 1.1]	10.65	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
976	2026-05-20	6h	6h-14h	Chaîne 14	[1.13, 1.1, 1.12, 1.12, 1.12, 1.15, 1.13, 1.12, 1.13, 1.1, 1.13, 1.11, 1.11, 1.12, 1.1, 1.11]	10.93	5.24	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
977	2026-05-20	14h	14h-22h	Chaîne 14	[1.12, 1.14, 1.12, 1.11, 1.12, 1.13, 1.12, 1.15, 1.12, 1.11, 1.13, 1.12, 1.13, 1.11, 1.12, 1.13]	11.1	5.19	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
978	2026-05-20	22h	22h-6h	Chaîne 14	[1.13, 1.11, 1.1, 1.14, 1.1, 1.13, 1.14, 1.15, 1.15, 1.12, 1.12, 1.13, 1.15, 1.12, 1.12, 1.14]	11.07	5.17	0.05	simulation	2026-05-21 00:11:47.614469	AM	\N
979	2026-05-20	6h	6h-14h	Chaîne 16	[1.1, 1.12, 1.15, 1.14, 1.12, 1.12, 1.14, 1.14, 1.13, 1.13, 1.13, 1.13, 1.13, 1.13, 1.13, 1.11, 1.12, 1.12, 1.1, 1.14, 1.13, 1.13, 1.12, 1.15]	11.01	5.16	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
980	2026-05-20	14h	14h-22h	Chaîne 16	[1.11, 1.12, 1.13, 1.12, 1.15, 1.14, 1.13, 1.15, 1.13, 1.14, 1.14, 1.14, 1.14, 1.15, 1.12, 1.13, 1.13, 1.13, 1.12, 1.12, 1.15, 1.13, 1.12, 1.14]	10.93	5.2	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
981	2026-05-20	22h	22h-6h	Chaîne 16	[1.13, 1.12, 1.12, 1.11, 1.1, 1.11, 1.12, 1.11, 1.1, 1.14, 1.13, 1.14, 1.12, 1.12, 1.13, 1.13, 1.11, 1.11, 1.14, 1.11, 1.11, 1.12, 1.12, 1.15]	10.9	5.33	0.06	simulation	2026-05-21 00:11:47.614469	AM	\N
\.


--
-- Data for Name: qualite_a; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qualite_a (id, date, heure, quart, atelier, produit, densite_valeur, densite_ecart, saturation_valeur, saturation_ecart, saturation_pression, saturation_temperature, saturation_air_total, o2_dissous, gaz_etranger, bilan_o2_total, bilan_o2_col, bilan_o2_reprise, bilan_o2_bln, bilan_o2_es, pression_pissette, contre_pression, cadence_soutireuse, debit_co2_balayage, sertissage_data, saisi_par, created_at) FROM stdin;
\.


--
-- Data for Name: qualite_archive; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qualite_archive (id, date, heure, ligne, sertissage_data, brix, co2, bo2) FROM stdin;
\.


--
-- Data for Name: resultats_anomalies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultats_anomalies (id, date, atelier, quart, score_anomalie, est_anomalie, index_elec, index_eau_rincage, index_eau_bain, index_eau_pasteur, index_eau_aero, index_co2, production_hl, brix, co2_qualite, bo2, ecart_elec_pct, ecart_eau_rincage_pct, ecart_eau_bain_pct, ecart_eau_pasteur_pct, ecart_eau_aero_pct, ecart_production_pct, message_xai, created_at, pct_hors_sertissage) FROM stdin;
3629	2026-03-06	Chaîne 8	\N	-0.45285946460309895	f	7891.88	3262.3199999999997	629.5	27621.010000000002	1451.79	534.46	3545.93	10.87	\N	\N	-0.4	5.2	-0.4	-3.7	1	-1.6	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3630	2026-03-07	Chaîne 8	\N	-0.47542404676465755	f	8038.33	3038.16	616.8	28073.55	1426.45	540	3777.69	10.913333333333332	\N	\N	1.4	-2	-2.4	-2.1	-0.7	4.8	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3631	2026-03-08	Chaîne 8	\N	-0.5615114788615468	f	6714.6	2639.09	542.39	27721.010000000002	1413.77	446.78	3019.5299999999997	10.786666666666667	\N	\N	-15.3	-14.9	-14.2	-3.4	-1.6	-16.2	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3632	2026-03-10	Chaîne 8	\N	-0.39282385305640805	f	8088.9400000000005	3114.13	634.97	29327.36	1467.66	539.05	3605.87	10.826666666666668	\N	\N	2.1	0.5	0.4	2.2	2.1	0	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3633	2026-03-11	Chaîne 8	\N	-0.41209171034371467	f	7698.55	3063.38	634.14	29163.78	1409.5	534.8199999999999	3679.45	10.846666666666666	\N	\N	-2.8	-1.2	0.3	1.7	-1.9	2.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3634	2026-03-12	Chaîne 8	\N	-0.4644277960630909	f	7802.43	3062.85	622.29	28576.559999999998	1473.77	559.31	3767.63	10.783333333333333	\N	\N	-1.5	-1.2	-1.6	-0.4	2.6	4.5	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3635	2026-03-13	Chaîne 8	\N	-0.43860555001938123	f	7608.05	3123.87	645.71	28412.37	1433.41	539.81	3645.81	10.716666666666667	\N	\N	-4	0.8	2.1	-0.9	-0.2	1.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3636	2026-03-14	Chaîne 8	\N	-0.39765256026489987	f	7978.74	3062.98	646.02	28812.79	1483.22	541.28	3621.95	10.796666666666667	\N	\N	0.7	-1.2	2.2	0.4	3.2	0.5	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3637	2026-03-15	Chaîne 8	\N	-0.5459937557376652	f	6772.74	2647.4700000000003	528.59	29133.839999999997	1428.43	465.17	3025.0299999999997	10.71	\N	\N	-14.5	-14.6	-16.4	1.6	-0.6	-16.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3638	2026-03-17	Chaîne 8	\N	-0.4358428490064142	f	8003.95	3107.7799999999997	644.3100000000001	28654.72	1435.92	528.42	3671.51	10.959999999999999	\N	\N	1	0.3	1.9	-0.1	-0.1	1.9	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3639	2026-03-18	Chaîne 8	\N	-0.41739270618779845	f	8002.05	3152.3199999999997	638.14	28443.370000000003	1448.42	550.6800000000001	3616.7	10.726666666666667	\N	\N	1	1.7	0.9	-0.8	0.8	0.3	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3640	2026-03-19	Chaîne 8	\N	-0.4248341323827863	f	8035.8099999999995	2997.49	620.6	28277.370000000003	1416.27	540.55	3455.77	10.773333333333333	\N	\N	1.4	-3.3	-1.8	-1.4	-1.4	-4.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3641	2026-03-20	Chaîne 8	\N	-0.4181029390689854	f	7869.96	3100	640.5699999999999	29214.519999999997	1476.15	547.53	3731.04	10.856666666666667	\N	\N	-0.7	0	1.3	1.8	2.7	3.5	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3642	2026-03-21	Chaîne 8	\N	-0.43307126939731294	f	7869.27	3059.52	623.19	29034.71	1458.8600000000001	536.52	3566.93	10.66	\N	\N	-0.7	-1.3	-1.4	1.2	1.5	-1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3643	2026-03-22	Chaîne 8	\N	-0.5718563391950022	t	6890.4	2624.84	543.01	27819.83	1389.96	462.62	3072.29	10.783333333333333	\N	\N	-13	-15.3	-14.1	-3	-3.3	-14.8	⚠ Anomalie Chaîne 8 — 22/03/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:40.476522	0
3644	2026-03-24	Chaîne 8	\N	-0.37628231384708216	f	7942.700000000001	3063.36	633.71	28913.090000000004	1476.48	545.99	3544.13	10.776666666666666	\N	\N	0.2	-1.2	0.2	0.8	2.8	-1.7	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3645	2026-03-25	Chaîne 8	\N	-0.4376519953269937	f	7757.26	3135.6400000000003	644.77	28887.95	1414.8600000000001	521.81	3687.12	10.783333333333333	\N	\N	-2.1	1.1	2	0.7	-1.5	2.3	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3646	2026-03-26	Chaîne 8	\N	-0.387565331266431	f	7800.62	3123.6000000000004	639.42	28594.71	1469.34	544.87	3714.34	10.793333333333335	\N	\N	-1.6	0.8	1.1	-0.3	2.3	3	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3647	2026-03-27	Chaîne 8	\N	-0.39042672838794734	f	7757.42	3073.81	626.7	28776.440000000002	1429.92	531.91	3692.51	10.83	\N	\N	-2.1	-0.8	-0.9	0.3	-0.5	2.4	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3648	2026-03-28	Chaîne 8	\N	-0.3964458012111891	f	7938.76	3077.5299999999997	631.33	28824.730000000003	1460.74	526.04	3647.56	10.74	\N	\N	0.2	-0.7	-0.1	0.5	1.7	1.2	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3649	2026-03-29	Chaîne 8	\N	-0.5446465471482287	f	6807.23	2665.33	539.3	28437.89	1412.23	450.58	3061.73	10.766666666666666	\N	\N	-14.1	-14	-14.7	-0.9	-1.7	-15.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3650	2026-03-31	Chaîne 8	\N	-0.40500160517286343	f	8085.11	3134.88	637.86	28534.35	1483.21	530.74	3603.61	10.799999999999999	\N	\N	2	1.1	0.9	-0.5	3.2	0	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3651	2026-04-01	Chaîne 8	\N	-0.42773485479947004	f	7773.54	3153.83	638.38	29595.879999999997	1434.75	544.73	3630.5	10.696666666666667	\N	\N	-1.9	1.7	1	3.2	-0.2	0.7	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3652	2026-04-02	Chaîne 8	\N	-0.3977116836741216	f	7976.63	3121.92	628.66	29287.510000000002	1417.77	527.5	3566.3199999999997	10.846666666666666	\N	\N	0.7	0.7	-0.6	2.1	-1.3	-1.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3653	2026-04-03	Chaîne 8	\N	-0.4938673575555466	f	7730.4400000000005	3276.1200000000003	625.74	28684.260000000002	1395.71	546.92	3720.71	10.726666666666667	\N	\N	-2.4	5.7	-1	0	-2.9	3.2	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3654	2026-04-04	Chaîne 8	\N	-0.41371151637542414	f	8053.55	3072.2699999999995	640.25	29678.8	1472.66	538.9	3542.12	10.843333333333334	\N	\N	1.6	-0.9	1.3	3.5	2.5	-1.7	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3655	2026-04-05	Chaîne 8	\N	-0.5504700731550499	f	6726.87	2638.96	534.55	28459.129999999997	1467.16	468.47	3010.37	10.713333333333333	\N	\N	-15.1	-14.9	-15.4	-0.8	2.1	-16.5	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3656	2026-04-07	Chaîne 8	\N	-0.4083565601410621	f	7949.63	3152.76	632.1800000000001	29647.03	1438.54	530.37	3652.3100000000004	10.85	\N	\N	0.3	1.7	0	3.4	0.1	1.3	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3657	2026-04-08	Chaîne 8	\N	-0.4350615617217056	f	8030.91	3134.63	640.1800000000001	28952.06	1396.16	546.62	3502.6800000000003	10.773333333333333	\N	\N	1.4	1.1	1.3	0.9	-2.8	-2.8	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3658	2026-04-09	Chaîne 8	\N	-0.4651854808182071	f	7683.39	3061.84	630.7	28310.34	1511.44	543.82	3607.55	10.826666666666668	\N	\N	-3	-1.2	-0.2	-1.3	5.2	0.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3659	2026-04-10	Chaîne 8	\N	-0.4324391721706309	f	8199.67	3016.1000000000004	626.4300000000001	28439.489999999998	1436.96	525.1800000000001	3731.4300000000003	10.786666666666667	\N	\N	3.5	-2.7	-0.9	-0.9	0	3.5	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3660	2026-04-11	Chaîne 8	\N	-0.4400150838958199	f	7811.76	3138.82	640.34	28410.21	1411.71	556.8199999999999	3736.01	10.833333333333334	\N	\N	-1.4	1.3	1.3	-1	-1.8	3.6	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3661	2026-04-12	Chaîne 8	\N	-0.5731727049319969	t	6912.22	2662.91	528.02	27570.47	1456.69	458.81	2957.45	10.839999999999998	\N	\N	-12.8	-14.1	-16.5	-3.9	1.4	-18	⚠ Anomalie Chaîne 8 — 12/04/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:40.476522	0
3662	2026-04-14	Chaîne 8	\N	-0.4930140531349755	f	8270.59	3129.0699999999997	613.91	27428.300000000003	1429.73	544.23	3549.23	10.933333333333332	\N	\N	4.4	0.9	-2.9	-4.4	-0.5	-1.5	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3663	2026-04-15	Chaîne 8	\N	-0.4092880514567949	f	7831.280000000001	3073.99	636.47	28959.37	1474.92	554.45	3536.08	10.753333333333332	\N	\N	-1.2	-0.8	0.7	1	2.6	-1.9	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3664	2026-04-16	Chaîne 8	\N	-0.39784464996889146	f	7912.02	3118.3799999999997	615.16	28967.5	1457.21	532.73	3642	10.773333333333333	\N	\N	-0.1	0.6	-2.7	1	1.4	1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3665	2026-04-17	Chaîne 8	\N	-0.36802991454883643	f	7923.629999999999	3074.7200000000003	624.84	28180.370000000003	1452.6299999999999	535.01	3604.3900000000003	10.82	\N	\N	0	-0.8	-1.2	-1.8	1.1	0	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3666	2026-04-18	Chaîne 8	\N	-0.4574013306415726	f	7987.49	3023.76	641.98	29002.589999999997	1401.69	555.89	3480.7200000000003	10.846666666666666	\N	\N	0.8	-2.5	1.6	1.1	-2.5	-3.4	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3667	2026-04-19	Chaîne 8	\N	-0.5691749708613586	f	6670.43	2607.09	528.6800000000001	28339.260000000002	1432.27	460.56999999999994	2893.74	10.81	\N	\N	-15.8	-15.9	-16.4	-1.2	-0.3	-19.7	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3668	2026-04-21	Chaîne 8	\N	-0.3818021351705476	f	7994.860000000001	3127.05	630.09	27816.870000000003	1431.27	546.5799999999999	3567.76	10.82	\N	\N	0.9	0.9	-0.3	-3	-0.4	-1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3669	2026-04-22	Chaîne 8	\N	-0.41911923898439746	f	7713.51	3113.6499999999996	637.8199999999999	28997.4	1441.63	555.02	3520.96	10.770000000000001	\N	\N	-2.7	0.4	0.9	1.1	0.3	-2.3	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3670	2026-04-23	Chaîne 8	\N	-0.42551162951643795	f	8102.219999999999	2952.49	627.59	28875.510000000002	1443.99	538.63	3458.52	10.793333333333335	\N	\N	2.3	-4.8	-0.7	0.7	0.5	-4.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3671	2026-04-24	Chaîne 8	\N	-0.43457991099766513	f	8278.79	3133.4700000000003	626.16	28417.63	1455.71	547.48	3480.61	10.806666666666667	\N	\N	4.5	1.1	-1	-0.9	1.3	-3.4	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3672	2026-04-25	Chaîne 8	\N	-0.36732802660242564	f	7936.889999999999	3026.46	634.12	28776.08	1425.5099999999998	542.04	3627.5200000000004	10.816666666666668	\N	\N	0.2	-2.4	0.3	0.3	-0.8	0.6	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3673	2026-04-26	Chaîne 8	\N	-0.8104452357519247	t	9773.23	2635.99	547.08	45469.24	1493.17	460.91999999999996	1883.22	11.476666666666667	\N	\N	23.3	-15	-13.5	58.5	3.9	-47.8	⚠ Anomalie Chaîne 8 — 26/04/2026 : Eau pasteurisateur +59% → Suspecter fuite circuit pasteurisateur | Production -48% (1883 hl vs objectif) → Arrêt non planifié probable | Sertissage hors tolerance : 21.7% des mesures non conformes -> Usure des rouleaux probable — verifier la sertisseuse	2026-06-04 22:40:40.476522	21.666666666666668
3674	2026-04-28	Chaîne 8	\N	-0.372582346069456	f	7902.37	3132.16	624.85	28969.879999999997	1420.1000000000001	536.53	3599.87	10.829999999999998	\N	\N	-0.3	1	-1.2	1	-1.2	-0.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3675	2026-04-29	Chaîne 8	\N	-0.39243268566144024	f	7883.25	3167.2200000000003	638.12	28933.99	1467.08	537.24	3547.62	10.829999999999998	\N	\N	-0.5	2.2	0.9	0.9	2.1	-1.6	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3676	2026-04-30	Chaîne 8	\N	-0.40013307949667526	f	8115.71	3031.61	641.48	28119.72	1452.97	531.46	3604.85	10.799999999999999	\N	\N	2.4	-2.2	1.5	-2	1.1	0	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3677	2026-05-01	Chaîne 8	\N	-0.4427730655382362	f	8171.95	3206.08	623.49	28596.35	1411.67	532.49	3532.29	10.839999999999998	\N	\N	3.1	3.4	-1.4	-0.3	-1.8	-2	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3678	2026-05-02	Chaîne 8	\N	-0.40317737932353437	f	7803.69	3104.7200000000003	619.12	28389.32	1423.1399999999999	551.89	3601.62	10.770000000000001	\N	\N	-1.5	0.2	-2.1	-1	-1	-0.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3679	2026-05-03	Chaîne 8	\N	-0.5867349895996286	t	6568.59	2719.99	533.39	29501.65	1446.04	467.15	2989.03	10.876666666666665	\N	\N	-17.1	-12.3	-15.6	2.8	0.6	-17.1	⚠ Anomalie Chaîne 8 — 03/05/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:40.476522	0
3680	2026-05-05	Chaîne 8	\N	-0.44325679835469434	f	7957.02	3007.48	624.53	29941.71	1473.0500000000002	544.29	3671.5299999999997	10.756666666666666	\N	\N	0.4	-3	-1.2	4.4	2.5	1.9	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3681	2026-05-06	Chaîne 8	\N	-0.41039550883828335	f	7892.23	3105.71	645.84	28686.260000000002	1430.19	544.28	3506.32	10.736666666666666	\N	\N	-0.4	0.2	2.2	0	-0.5	-2.7	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3682	2026-05-07	Chaîne 8	\N	-0.42639942033143974	f	7798.9400000000005	3084.2	630.83	27344.120000000003	1423.55	547.91	3537.3199999999997	10.836666666666666	\N	\N	-1.6	-0.5	-0.2	-4.7	-0.9	-1.9	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3683	2026-05-08	Chaîne 8	\N	-0.43349707923476777	f	7845.22	3142.7200000000003	652.97	28284.190000000002	1461.78	533.87	3662.9700000000003	10.796666666666667	\N	\N	-1	1.4	3.3	-1.4	1.7	1.6	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3684	2026-05-09	Chaîne 8	\N	-0.4348927343783288	f	8106.379999999999	3209.4900000000002	616.31	28399.93	1438.85	537.67	3635.48	10.876666666666667	\N	\N	2.3	3.5	-2.5	-1	0.1	0.9	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3685	2026-05-10	Chaîne 8	\N	-0.5798517214840432	t	6772.06	2603.86	541.87	29491.57	1456.06	451.57000000000005	3044.08	10.71	\N	\N	-14.5	-16	-14.3	2.8	1.3	-15.6	⚠ Anomalie Chaîne 8 — 10/05/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:40.476522	0
3686	2026-05-12	Chaîne 8	\N	-0.4357092212781446	f	7622.87	3189.6899999999996	628.62	28712	1418.31	543.71	3685.0299999999997	10.846666666666666	\N	\N	-3.8	2.9	-0.6	0.1	-1.3	2.2	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3687	2026-05-13	Chaîne 8	\N	-0.37835426176098247	f	7879.719999999999	3108.03	639.37	28979.53	1445.77	536.8399999999999	3615.13	10.886666666666665	\N	\N	-0.6	0.3	1.1	1	0.6	0.3	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3688	2026-05-14	Chaîne 8	\N	-0.4431713139681268	f	8024.389999999999	2993.13	633.28	28579.39	1405.67	545.9200000000001	3706.6099999999997	10.696666666666667	\N	\N	1.3	-3.4	0.2	-0.4	-2.2	2.8	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3689	2026-05-15	Chaîne 8	\N	-0.44522913104357803	f	8095.780000000001	3091.9	643.3	29146.08	1486.63	546.0799999999999	3716.4	10.88	\N	\N	2.2	-0.3	1.8	1.6	3.5	3.1	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3690	2026-05-16	Chaîne 8	\N	-0.45056874402418323	f	7972.53	3082.42	635.29	28788.269999999997	1385.08	527.4	3604.6	10.896666666666667	\N	\N	0.6	-0.6	0.5	0.4	-3.6	0	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3691	2026-05-17	Chaîne 8	\N	-0.5909522486308109	t	6784.709999999999	2728.54	548.09	28172.120000000003	1424.33	476.82	3161.77	10.88	\N	\N	-14.4	-12	-13.3	-1.8	-0.9	-12.3	⚠ Anomalie Chaîne 8 — 17/05/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:40.476522	0
3692	2026-05-19	Chaîne 8	\N	-0.4025735328955362	f	7994.07	3024.77	638.51	28672.36	1457.27	555.73	3522.93	10.783333333333333	\N	\N	0.9	-2.4	1	0	1.4	-2.3	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3693	2026-05-20	Chaîne 8	\N	-0.4884222100106223	f	8070.29	3192.1899999999996	646.02	27979.52	1432.28	544.4	3515.04	10.64	\N	\N	1.9	3	2.2	-2.5	-0.3	-2.5	Fonctionnement normal.	2026-06-04 22:40:40.476522	0
3694	2026-03-06	Chaîne 14	\N	-0.3972247264155255	f	6887.200000000001	1878.0700000000002	660.25	25791.84	1269.47	454.87	3201.33	10.976666666666667	\N	\N	-0.8	0.9	-4.8	-0.1	-0.3	1.3	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3695	2026-03-07	Chaîne 14	\N	-0.46279791353459887	f	7108.299999999999	1892.87	689.6	26638.58	1323.55	477.72	3146.23	10.916666666666666	\N	\N	2.4	1.7	-0.6	3.1	3.9	-0.5	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3696	2026-03-08	Chaîne 14	\N	-0.537289927726193	f	5926.28	1583.96	604.68	25404.3	1303.3	393.09000000000003	2797.22	11.033333333333333	\N	\N	-14.6	-14.9	-12.8	-1.6	2.3	-11.5	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3697	2026-03-09	Chaîne 14	\N	-0.4897024209173301	f	6889.99	1865.5	700	27021.93	1245.58	470.84000000000003	3292.7	10.843333333333334	\N	\N	-0.7	0.3	0.9	4.6	-2.2	4.2	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3698	2026-03-11	Chaîne 14	\N	-0.43112946723041057	f	6942.14	1831.8600000000001	729.73	25815.7	1315.12	471.13	3287.75	10.916666666666666	\N	\N	0	-1.5	5.2	-0.1	3.3	4	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3699	2026-03-12	Chaîne 14	\N	-0.42150510622041554	f	6898.92	1866.68	675.97	25768.489999999998	1228.51	473.96	3084.6299999999997	10.966666666666667	\N	\N	-0.6	0.3	-2.6	-0.2	-3.5	-2.4	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3700	2026-03-13	Chaîne 14	\N	-0.4122392944704412	f	7073.99	1828.85	715.16	26329.47	1264.08	456.20000000000005	3076.98	11.073333333333332	\N	\N	1.9	-1.7	3.1	1.9	-0.7	-2.7	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3701	2026-03-14	Chaîne 14	\N	-0.425286356137649	f	6996.34	1903.96	693.77	25630.58	1241.3	456.23	3157.91	10.863333333333335	\N	\N	0.8	2.3	0	-0.8	-2.5	-0.1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3702	2026-03-15	Chaîne 14	\N	-0.5224052535390699	f	5903.25	1563.7	595.12	26265.059999999998	1245.89	404.85	2681.67	10.969999999999999	\N	\N	-14.9	-16	-14.2	1.7	-2.2	-15.2	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3703	2026-03-16	Chaîne 14	\N	-0.40623267539066327	f	7202.63	1829.69	674.63	26031.510000000002	1315.04	465.18	3186.65	11	\N	\N	3.8	-1.7	-2.8	0.8	3.3	0.8	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3704	2026-03-18	Chaîne 14	\N	-0.37340190586157196	f	6995.58	1864.97	699.39	25464.11	1295.25	465.21	3198	10.946666666666667	\N	\N	0.8	0.2	0.8	-1.4	1.7	1.2	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3705	2026-03-19	Chaîne 14	\N	-0.42881759368046923	f	6926.389999999999	1909.0900000000001	702.66	26757.35	1319.55	461.92999999999995	3242.7599999999998	10.946666666666667	\N	\N	-0.2	2.6	1.3	3.6	3.6	2.6	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3706	2026-03-20	Chaîne 14	\N	-0.44283647376086016	f	6903.54	1815.7800000000002	716.51	25444.8	1251.71	473.89	3371.17	10.963333333333333	\N	\N	-0.5	-2.4	3.3	-1.5	-1.7	6.6	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3707	2026-03-21	Chaîne 14	\N	-0.4121635639934357	f	7113.12	1829.13	695.16	26346.04	1276.3200000000002	456.84000000000003	3019.82	10.996666666666664	\N	\N	2.5	-1.7	0.2	2	0.2	-4.5	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3708	2026-03-22	Chaîne 14	\N	-0.5708311564291089	t	5771.219999999999	1566.1200000000001	611.46	26741.510000000002	1256.31	387.39	2687.5	11.116666666666667	\N	\N	-16.8	-15.8	-11.9	3.5	-1.4	-15	⚠ Anomalie Chaîne 14 — 22/03/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:44.117874	0
3709	2026-03-23	Chaîne 14	\N	-0.4813902199876489	f	7207.89	1798.81	693.86	24809.82	1280.23	473.20000000000005	3301.25	11.113333333333335	\N	\N	3.9	-3.3	0	-3.9	0.5	4.4	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3710	2026-03-25	Chaîne 14	\N	-0.43866271291772907	f	7254.58	1882.2	691.45	26049.01	1223.5	463.49	3131.84	11.04	\N	\N	4.5	1.2	-0.3	0.9	-3.9	-0.9	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3711	2026-03-26	Chaîne 14	\N	-0.39982214177602254	f	6724.27	1825.91	698.03	25657.190000000002	1264.59	464.09	3112.1800000000003	11.04	\N	\N	-3.1	-1.9	0.6	-0.7	-0.7	-1.6	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3712	2026-03-27	Chaîne 14	\N	-0.47363567726598227	f	6794.29	1804.1	697.5699999999999	24916.7	1257.08	458.09000000000003	3206.65	11.126666666666665	\N	\N	-2.1	-3	0.5	-3.5	-1.3	1.4	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3713	2026-03-28	Chaîne 14	\N	-0.4001415553496204	f	6839.03	1919.31	694.5799999999999	25975.160000000003	1245.96	463.89	3124.1099999999997	11.040000000000001	\N	\N	-1.5	3.2	0.1	0.6	-2.2	-1.2	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3714	2026-03-29	Chaîne 14	\N	-0.575903944506541	t	5730.450000000001	1624.54	568.91	25368.89	1305.01	400.53	2712.09	10.909999999999998	\N	\N	-17.4	-12.7	-18	-1.8	2.5	-14.2	⚠ Anomalie Chaîne 14 — 29/03/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:44.117874	0
3715	2026-03-30	Chaîne 14	\N	-0.39857122442628	f	6938.73	1913.8400000000001	700.57	25088.69	1267.1	455.11	3183.8599999999997	10.993333333333334	\N	\N	0	2.9	1	-2.9	-0.5	0.7	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3716	2026-04-01	Chaîne 14	\N	-0.4433586805631836	f	6921.17	1894.49	700.19	26068.98	1275.18	483.12	3161.4	10.816666666666668	\N	\N	-0.3	1.8	0.9	0.9	0.1	0	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3717	2026-04-02	Chaîne 14	\N	-0.3757239152390712	f	6935.85	1835.95	673.42	26043.809999999998	1258.55	469.15	3143.8500000000004	10.973333333333334	\N	\N	-0.1	-1.3	-2.9	0.8	-1.2	-0.6	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3718	2026-04-03	Chaîne 14	\N	-0.42947370908052623	f	6967.26	1911.17	699.47	26327.760000000002	1272.56	461.33	3084.58	10.853333333333333	\N	\N	0.4	2.7	0.8	1.9	-0.1	-2.4	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3719	2026-04-04	Chaîne 14	\N	-0.4029327727873208	f	7198.1900000000005	1831.12	685.4300000000001	26253.66	1264.65	457.13	3253.88	10.946666666666665	\N	\N	3.7	-1.6	-1.2	1.6	-0.7	2.9	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3720	2026-04-05	Chaîne 14	\N	-0.5153234479594214	f	5964.22	1563.74	607.03	26097.59	1259.1399999999999	389.96999999999997	2754.17	11.033333333333333	\N	\N	-14.1	-16	-12.5	1	-1.1	-12.9	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3721	2026-04-06	Chaîne 14	\N	-0.689770903339955	t	6902.49	2402.08	1153.5700000000002	25603.1	1284.72	462.26	3319.05	10.963333333333333	\N	\N	-0.5	29.1	66.3	-0.9	0.9	5	⚠ Anomalie Chaîne 14 — 06/04/2026 : Eau bain laveuse +66% → Suspecter fuite bain chloré | Eau rinçage +29% → Vérifier circuit rinçage | Sertissage hors tolerance : 22.9% des mesures non conformes -> Usure des rouleaux probable — verifier la sertisseuse	2026-06-04 22:40:44.117874	22.916666666666668
3722	2026-04-08	Chaîne 14	\N	-0.37931907481617394	f	7122.98	1861.48	693.5	26269.8	1276.98	468.30999999999995	3189.34	10.936666666666667	\N	\N	2.6	0	0	1.7	0.3	0.9	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3723	2026-04-09	Chaîne 14	\N	-0.4178226216935301	f	6691.27	1910.9299999999998	701.34	25423.59	1305.51	464.9	3195.44	10.983333333333334	\N	\N	-3.6	2.7	1.1	-1.6	2.5	1.1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3724	2026-04-10	Chaîne 14	\N	-0.4638724691374734	f	6761.4	1939.78	682.87	25814.47	1228.79	457.76	3251.79	10.950000000000001	\N	\N	-2.6	4.3	-1.6	-0.1	-3.5	2.9	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3725	2026-04-11	Chaîne 14	\N	-0.38933789073604813	f	6903.33	1862.04	720.72	25951.79	1304.77	470.02	3210.27	10.926666666666668	\N	\N	-0.5	0.1	3.9	0.5	2.5	1.5	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3726	2026-04-12	Chaîne 14	\N	-0.5341763660549621	f	5804.33	1556.56	598.31	26386.27	1239.46	398.92999999999995	2674.88	11.106666666666667	\N	\N	-16.4	-16.3	-13.8	2.2	-2.7	-15.4	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3727	2026-04-13	Chaîne 14	\N	-0.4560225893283138	f	6714.8	1920.27	719.02	25170.519999999997	1301.67	468.16	3250.8	11.073333333333332	\N	\N	-3.2	3.2	3.6	-2.5	2.2	2.8	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3728	2026-04-15	Chaîne 14	\N	-0.4493484943148883	f	6961.92	1849.03	684.85	25828.78	1214.1	460.78	3184.92	10.89	\N	\N	0.3	-0.6	-1.3	0	-4.7	0.7	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3729	2026-04-16	Chaîne 14	\N	-0.42728816193259506	f	7140.780000000001	1773.22	683.85	25639.69	1303.18	456.38	3114.3399999999997	10.906666666666666	\N	\N	2.9	-4.7	-1.4	-0.7	2.3	-1.5	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3730	2026-04-17	Chaîne 14	\N	-0.42552344812338233	f	7074.91	1892.21	708.43	25711.980000000003	1309.97	445.59	3095.5299999999997	10.943333333333333	\N	\N	1.9	1.7	2.1	-0.5	2.9	-2.1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3731	2026-04-18	Chaîne 14	\N	-0.3934864770434485	f	6882.17	1827.04	688.1	25447.11	1250.21	454.13	3127.82	11.006666666666666	\N	\N	-0.8	-1.8	-0.8	-1.5	-1.8	-1.1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3732	2026-04-19	Chaîne 14	\N	-0.5749681360819852	t	5910.29	1652.68	586.32	24924.91	1302.8899999999999	397.53	2707.93	10.923333333333332	\N	\N	-14.8	-11.2	-15.5	-3.5	2.3	-14.3	⚠ Anomalie Chaîne 14 — 19/04/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:44.117874	0
3733	2026-04-20	Chaîne 14	\N	-0.4169892121839001	f	7191.33	1873.2	671.19	26136.25	1292.8899999999999	476.65999999999997	3283.4	10.953333333333333	\N	\N	3.6	0.7	-3.3	1.2	1.5	3.9	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3734	2026-04-22	Chaîne 14	\N	-0.4408199699350653	f	7086.05	1880.6999999999998	715.11	25606.81	1244.08	470.24	3032.7000000000003	10.89	\N	\N	2.1	1.1	3.1	-0.9	-2.3	-4.1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3735	2026-04-23	Chaîne 14	\N	-0.42601189864924416	f	6939.91	1838.1100000000001	689.27	26736.36	1287.9	448.57000000000005	3160.65	11.083333333333334	\N	\N	0	-1.2	-0.6	3.5	1.1	0	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3736	2026-04-24	Chaîne 14	\N	-0.404902476016018	f	6987.01	1826.25	684.01	25741.370000000003	1288.38	481.74	3091.45	10.976666666666667	\N	\N	0.7	-1.8	-1.4	-0.3	1.2	-2.2	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3737	2026-04-25	Chaîne 14	\N	-0.37234763841521895	f	6902.18	1857.96	693.28	25840.75	1293.51	470.49	3121.12	11.053333333333333	\N	\N	-0.5	-0.1	-0.1	0	1.6	-1.3	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3738	2026-04-26	Chaîne 14	\N	-0.5887744189939252	t	5933.51	1612.48	598.78	25574.82	1327.47	386.83	2633.63	11.093333333333334	\N	\N	-14.5	-13.3	-13.7	-1	4.2	-16.7	⚠ Anomalie Chaîne 14 — 26/04/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:44.117874	0
3739	2026-04-27	Chaîne 14	\N	-0.39975121592778456	f	7058.07	1824.23	712.36	25605.32	1292.4	472.75	3302	11.023333333333333	\N	\N	1.7	-2	2.7	-0.9	1.5	4.4	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3740	2026-04-29	Chaîne 14	\N	-0.40155215390363275	f	7000.26	1850.01	704.88	26258.92	1251.42	474.51	3198.88	10.910000000000002	\N	\N	0.9	-0.6	1.6	1.7	-1.7	1.2	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3741	2026-04-30	Chaîne 14	\N	-0.3980349350822964	f	7164.01	1885.3600000000001	673.15	25578.94	1264	467.34000000000003	3272.1	11.023333333333333	\N	\N	3.2	1.3	-3	-1	-0.7	3.5	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3742	2026-05-01	Chaîne 14	\N	-0.4176682128821389	f	6868.5199999999995	1863.13	670.08	25524.52	1299.28	465.63	3099.38	10.903333333333334	\N	\N	-1	0.1	-3.4	-1.2	2	-2	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3743	2026-05-02	Chaîne 14	\N	-0.4510267699656772	f	7183.469999999999	1901.14	687.8199999999999	26678.04	1301.44	451.3	3291.1099999999997	11.003333333333332	\N	\N	3.5	2.2	-0.9	3.3	2.2	4.1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3744	2026-05-03	Chaîne 14	\N	-0.7125835437372549	t	8646.49	1562.21	580.04	26415.58	1256.88	404.85	2308.9300000000003	10.92	\N	\N	24.6	-16	-16.4	2.3	-1.3	-27	⚠ Anomalie Chaîne 14 — 03/05/2026 : Production -27% (2309 hl vs objectif) → Arrêt non planifié probable | Sertissage hors tolerance : 27.1% des mesures non conformes -> Usure des rouleaux probable — verifier la sertisseuse	2026-06-04 22:40:44.117874	27.083333333333332
3745	2026-05-04	Chaîne 14	\N	-0.4144891075682567	f	7197.35	1860.56	718.19	25552.29	1263.54	461.57	3157.73	11.093333333333334	\N	\N	3.7	0	3.5	-1.1	-0.8	-0.1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3746	2026-05-06	Chaîne 14	\N	-0.38596051261844166	f	6898.83	1814.71	701.72	25476.399999999998	1273.51	455.52	3129.5	11.043333333333331	\N	\N	-0.6	-2.5	1.1	-1.4	0	-1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3747	2026-05-07	Chaîne 14	\N	-0.4523122213723492	f	6861.66	1902.5700000000002	669.03	25615.62	1285.94	472.4	3310.85	11.13	\N	\N	-1.1	2.3	-3.6	-0.8	1	4.7	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3748	2026-05-08	Chaîne 14	\N	-0.40182735458691926	f	7073.39	1842.1799999999998	702.77	25019.11	1271.23	452.37	3120	11.013333333333334	\N	\N	1.9	-1	1.3	-3.1	-0.2	-1.3	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3749	2026-05-09	Chaîne 14	\N	-0.4362466433897866	f	6975.51	1816.23	703.13	26467.670000000002	1321.02	466.67	3322.6499999999996	10.99	\N	\N	0.5	-2.4	1.3	2.5	3.7	5.1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3750	2026-05-10	Chaîne 14	\N	-0.5364667720885037	f	5975.42	1547.5700000000002	584.09	26050.71	1263.5	396.02	2794.29	11.053333333333333	\N	\N	-13.9	-16.8	-15.8	0.9	-0.8	-11.6	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3751	2026-05-11	Chaîne 14	\N	-0.44428899300495717	f	7123.73	1866.25	690.33	25991.22	1245.51	484.07000000000005	3165.71	11.14	\N	\N	2.6	0.3	-0.5	0.6	-2.2	0.1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3752	2026-05-13	Chaîne 14	\N	-0.4119601643689008	f	7220.87	1859.5300000000002	716.76	26161.45	1283.35	468.18	3227.2	11.1	\N	\N	4	-0.1	3.3	1.3	0.8	2.1	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3753	2026-05-14	Chaîne 14	\N	-0.43837876377941554	f	7078.29	1866.21	689.56	25364.92	1304.6100000000001	441.03	3317.0600000000004	11.046666666666667	\N	\N	2	0.3	-0.6	-1.8	2.4	4.9	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3754	2026-05-15	Chaîne 14	\N	-0.43273148038950515	f	6887.030000000001	1890.1999999999998	704.91	26804.28	1323.77	467.11	3161.44	11.020000000000001	\N	\N	-0.8	1.6	1.6	3.8	3.9	0	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3755	2026-05-16	Chaîne 14	\N	-0.3643593894783059	f	7023.31	1877.04	700.36	25672.96	1277.86	460.39	3187.5200000000004	11.026666666666666	\N	\N	1.2	0.9	0.9	-0.6	0.3	0.8	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3756	2026-05-17	Chaîne 14	\N	-0.5689089365136989	f	6148.93	1537.4299999999998	599.24	26432.519999999997	1234.57	411.73	2660.52	10.996666666666668	\N	\N	-11.4	-17.4	-13.6	2.3	-3.1	-15.8	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3757	2026-05-18	Chaîne 14	\N	-0.452400799391451	f	6886.71	1813.3200000000002	720.99	26215.97	1239.17	486.32000000000005	3206.34	10.993333333333334	\N	\N	-0.8	-2.5	3.9	1.5	-2.7	1.4	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3758	2026-05-20	Chaîne 14	\N	-0.38484577723909463	f	6852.96	1869.4099999999999	679.04	25662.06	1281.85	473.64	3136.49	11.033333333333333	\N	\N	-1.3	0.5	-2.1	-0.6	0.7	-0.8	Fonctionnement normal.	2026-06-04 22:40:44.117874	0
3759	2026-03-06	Chaîne 15	\N	-0.3802969163552241	f	6480.49	1709.9699999999998	63.55	4661.67	1168.6799999999998	415.56	2863.12	11.136666666666665	\N	\N	2.6	0.6	-3.3	3	0.4	0	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3760	2026-03-07	Chaîne 15	\N	-0.3868193123294286	f	6278.28	1718.5300000000002	66.65	4491.05	1179.59	419.29999999999995	2857.3199999999997	11.06	\N	\N	-0.6	1.1	1.4	-0.8	1.3	-0.2	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3761	2026-03-08	Chaîne 15	\N	-0.5275797998301607	f	5435.45	1477.8600000000001	58.120000000000005	4434.98	1157.71	357.27	2451.23	11.07	\N	\N	-13.9	-13	-11.5	-2	-0.5	-14.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3762	2026-03-09	Chaîne 15	\N	-0.35287732914019526	f	6306.7300000000005	1719.22	67.08	4556.71	1179.32	419.98	2896.6000000000004	11.253333333333336	\N	\N	-0.1	1.2	2.1	0.7	1.3	1.2	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3763	2026-03-10	Chaîne 15	\N	-0.38121099370069805	f	6271.540000000001	1666.97	67.24000000000001	4629.67	1175.09	419.04999999999995	2764.92	11.256666666666666	\N	\N	-0.7	-1.9	2.3	2.3	1	-3.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3764	2026-03-12	Chaîne 15	\N	-0.3870806763945304	f	6115.85	1675.53	63.629999999999995	4567.99	1168.31	418.37	2914.01	11.24	\N	\N	-3.1	-1.4	-3.2	0.9	0.4	1.8	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3765	2026-03-13	Chaîne 15	\N	-0.38294958063878987	f	6288.889999999999	1728.6100000000001	67.93	4502	1173.99	409.9	2987.52	11.256666666666666	\N	\N	-0.4	1.7	3.4	-0.5	0.9	4.3	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3766	2026-03-14	Chaîne 15	\N	-0.42431070865095194	f	6154.97	1723.83	64.93	4558.38	1137.85	413.69	2991.2799999999997	11.123333333333333	\N	\N	-2.5	1.4	-1.2	0.7	-2.2	4.5	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3767	2026-03-15	Chaîne 15	\N	-0.5330290678070415	f	5440.54	1477.75	54.449999999999996	4440.72	1184.62	351.15	2408.87	11.376666666666667	\N	\N	-13.8	-13	-17.1	-1.9	1.8	-15.9	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3768	2026-03-16	Chaîne 15	\N	-0.39582918742607764	f	6568.6	1736.23	67.11	4530.68	1182.7	412.83	2977.97	11.24	\N	\N	4	2.2	2.1	0.1	1.6	4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3769	2026-03-17	Chaîne 15	\N	-0.39604590454376565	f	6510.58	1748.3600000000001	66.84	4509.98	1193.1399999999999	421.16	2831.27	11.106666666666667	\N	\N	3.1	2.9	1.7	-0.4	2.5	-1.1	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3770	2026-03-19	Chaîne 15	\N	-0.39101811629231	f	6471.7	1683.8600000000001	63.43	4565.65	1176.02	415.15	2838.76	11.083333333333334	\N	\N	2.5	-0.9	-3.5	0.9	1	-0.9	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3771	2026-03-20	Chaîne 15	\N	-0.39115057578066786	f	6135.71	1741.6799999999998	65.23	4403.66	1164.55	411.57	2833.19	11.183333333333332	\N	\N	-2.8	2.5	-0.7	-2.7	0	-1	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3772	2026-03-21	Chaîne 15	\N	-0.41921355392972354	f	6199.25	1725.53	65.79	4479.09	1203.47	423.81	2850.82	11.316666666666668	\N	\N	-1.8	1.5	0.1	-1	3.4	-0.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3773	2026-03-22	Chaîne 15	\N	-0.5228925351293561	f	5320.84	1473.83	58.09	4571.25	1191.09	357.17	2451.91	11.1	\N	\N	-15.7	-13.3	-11.6	1	2.3	-14.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3774	2026-03-23	Chaîne 15	\N	-0.759155268204551	t	8958.78	1723.8600000000001	66.3	6570.46	1170.63	396.22	1869.67	11.803333333333333	\N	\N	41.9	1.4	0.9	45.2	0.6	-34.7	⚠ Anomalie Chaîne 15 — 23/03/2026 : Électricité +42% vs baseline (8959 kWh vs 6313 kWh) → Vérifier moteurs et tableau électrique | Eau pasteurisateur +45% → Suspecter fuite circuit pasteurisateur | Production -35% (1870 hl vs objectif) → Arrêt non planifié probable | Brix 11.80°Bx (trop élevé, norme 10.5–11.5) → Vérifier dosage et capteur Brix	2026-06-04 22:40:46.05393	12.5
3775	2026-03-24	Chaîne 15	\N	-0.40246255742004683	f	6247.11	1713.99	65.7	4680.3	1159.11	416.69	2887.27	11.366666666666667	\N	\N	-1	0.9	0	3.4	-0.4	0.8	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3776	2026-03-26	Chaîne 15	\N	-0.4118372620371726	f	6303.56	1650.58	65.24	4591.44	1184.1599999999999	425.47	2726.35	11.229999999999999	\N	\N	-0.2	-2.9	-0.7	1.4	1.7	-4.8	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3777	2026-03-27	Chaîne 15	\N	-0.37227432729114474	f	6281.58	1674.58	66.9	4500.2	1166.49	408.1	2854.15	11.32	\N	\N	-0.5	-1.5	1.8	-0.6	0.2	-0.3	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3778	2026-03-28	Chaîne 15	\N	-0.3931834867543085	f	6104.72	1677.02	64.58	4455.68	1182.01	419.95	2908.2799999999997	11.126666666666665	\N	\N	-3.3	-1.3	-1.7	-1.6	1.5	1.6	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3779	2026-03-29	Chaîne 15	\N	-0.5802243603762642	t	5533.18	1428.8	55.66	4401.34	1222.5	349.28	2375.13	11.256666666666666	\N	\N	-12.4	-15.9	-15.3	-2.8	5	-17	⚠ Anomalie Chaîne 15 — 29/03/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:46.05393	0
3780	2026-03-30	Chaîne 15	\N	-0.4360377845862821	f	6256.610000000001	1692.9299999999998	65.65	4585.43	1197.43	405.29	3103.4700000000003	11.126666666666665	\N	\N	-0.9	-0.4	-0.1	1.3	2.9	8.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3781	2026-03-31	Chaîne 15	\N	-0.40407353166163057	f	6320.3	1744.92	65.59	4661.29	1159.67	397.46000000000004	2925.67	11.183333333333332	\N	\N	0.1	2.7	-0.2	3	-0.4	2.2	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3782	2026-04-02	Chaîne 15	\N	-0.4027097379656927	f	6344.51	1704.2800000000002	66.59	4656.47	1162.44	433.64	2908.6	11.133333333333333	\N	\N	0.5	0.3	1.4	2.9	-0.1	1.6	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3783	2026-04-03	Chaîne 15	\N	-0.3736222937685758	f	6513.4800000000005	1667.6100000000001	67.89	4560.18	1174.92	409.43	2862.55	11.116666666666667	\N	\N	3.2	-1.9	3.3	0.7	0.9	0	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3784	2026-04-04	Chaîne 15	\N	-0.36406883052824485	f	6306.87	1654.07	65.22	4544.82	1153.22	409.87	2930.79	11.270000000000001	\N	\N	-0.1	-2.7	-0.7	0.4	-0.9	2.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3785	2026-04-05	Chaîne 15	\N	-0.5395150420266013	f	5618.5	1470.21	56.949999999999996	4607.28	1188.7	355.88	2344.88	11.26	\N	\N	-11	-13.5	-13.3	1.8	2.1	-18.1	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3786	2026-04-06	Chaîne 15	\N	-0.392192842565437	f	6337.040000000001	1720.56	67.94	4375.74	1163.5	420.39	2964.34	11.200000000000001	\N	\N	0.4	1.3	3.4	-3.3	0	3.5	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3787	2026-04-07	Chaîne 15	\N	-0.35027539903982685	f	6442.4	1679.9	67.19	4567.83	1176.8899999999999	417.02	2851.92	11.229999999999999	\N	\N	2	-1.1	2.3	0.9	1.1	-0.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3788	2026-04-09	Chaîne 15	\N	-0.37815921562094806	f	6254.52	1667.87	65.72	4387.63	1159.17	418.72	2817.95	11.246666666666668	\N	\N	-0.9	-1.8	0	-3.1	-0.4	-1.6	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3789	2026-04-10	Chaîne 15	\N	-0.38914678076313663	f	6231	1719.4	67.18	4426.12	1154.96	427.85	2881.7799999999997	11.186666666666667	\N	\N	-1.3	1.2	2.3	-2.2	-0.8	0.7	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3790	2026-04-11	Chaîne 15	\N	-0.3793959323413769	f	6383.37	1675.3200000000002	65.4	4492.34	1149.17	428.11	2868.47	11.143333333333333	\N	\N	1.1	-1.4	-0.5	-0.8	-1.3	0.2	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3791	2026-04-12	Chaîne 15	\N	-0.5286113209165484	f	5500.45	1456.76	53.91	4472.84	1160.53	345.14	2501	11.386666666666665	\N	\N	-12.9	-14.3	-17.9	-1.2	-0.3	-12.6	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3792	2026-04-13	Chaîne 15	\N	-0.4631983235800655	f	6650.620000000001	1685.8600000000001	69.2	4548.99	1173.1599999999999	420.51	3014.46	11.089999999999998	\N	\N	5.3	-0.8	5.3	0.5	0.8	5.3	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3793	2026-04-14	Chaîne 15	\N	-0.42779501498027545	f	6520.43	1720.73	64.13	4502.68	1196.35	435.46	2930.74	11.170000000000002	\N	\N	3.3	1.3	-2.4	-0.5	2.8	2.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3794	2026-04-16	Chaîne 15	\N	-0.42548042079521003	f	6147.67	1763.02	64.96000000000001	4445.02	1206.6299999999999	415.8	2931.24	11.203333333333333	\N	\N	-2.6	3.8	-1.1	-1.8	3.7	2.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3795	2026-04-17	Chaîne 15	\N	-0.35814932488260826	f	6423.65	1708.99	67.47	4425.38	1159.35	417.03	2873.02	11.206666666666669	\N	\N	1.7	0.6	2.7	-2.2	-0.4	0.3	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3796	2026-04-18	Chaîne 15	\N	-0.41388995513676774	f	6193.72	1711.19	65.74000000000001	4620.6900000000005	1141.69	398.92	2888.19	11.103333333333333	\N	\N	-1.9	0.7	0.1	2.1	-1.9	0.9	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3797	2026-04-19	Chaîne 15	\N	-0.6704985035166736	t	6396.3	1462.26	57.11	7343.88	1137.2	348.42	2456.14	11.136666666666665	\N	\N	1.3	-13.9	-13.1	62.2	-2.3	-14.2	⚠ Anomalie Chaîne 15 — 19/04/2026 : Eau pasteurisateur +62% → Suspecter fuite circuit pasteurisateur	2026-06-04 22:40:46.05393	12.5
3798	2026-04-20	Chaîne 15	\N	-0.4318554545393055	f	6403.15	1700.77	66.76	4286.02	1167.81	425.84000000000003	2974.16	11.296666666666667	\N	\N	1.4	0.1	1.6	-5.3	0.3	3.9	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3799	2026-04-21	Chaîne 15	\N	-0.3989936745325379	f	6559.37	1664.2	65.73	4411.26	1191.3	421.99	2894.01	11.153333333333334	\N	\N	3.9	-2.1	0	-2.5	2.3	1.1	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3800	2026-04-23	Chaîne 15	\N	-0.4617885693992259	f	6498.540000000001	1694.5	64.86	4628.01	1203.98	396.47	3070.42	11.286666666666667	\N	\N	2.9	-0.3	-1.3	2.2	3.4	7.2	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3801	2026-04-24	Chaîne 15	\N	-0.3990712660131384	f	6450.0599999999995	1753.7600000000002	65.7	4526.2	1195.03	413.32	2807.84	11.11	\N	\N	2.2	3.2	0	0	2.7	-1.9	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3802	2026-04-25	Chaîne 15	\N	-0.3813954268470263	f	6313.389999999999	1625.09	65	4449.31	1164.02	410.03999999999996	2801.44	11.176666666666668	\N	\N	0	-4.4	-1.1	-1.7	0	-2.2	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3803	2026-04-26	Chaîne 15	\N	-0.5074598254658457	f	5398.26	1451.4	53.95	4596.09	1159.8	364.61	2573.46	11.243333333333332	\N	\N	-14.5	-14.6	-17.9	1.5	-0.4	-10.1	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3804	2026-04-27	Chaîne 15	\N	-0.3832178183786494	f	6531.52	1711.97	64.99000000000001	4472.85	1156.73	428.07	2916.2	11.263333333333334	\N	\N	3.5	0.7	-1.1	-1.2	-0.6	1.9	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3805	2026-04-28	Chaîne 15	\N	-0.38694791905534337	f	6491.789999999999	1605.3	65.7	4554.5	1149.41	412.21000000000004	2877.9700000000003	11.236666666666666	\N	\N	2.8	-5.5	0	0.6	-1.3	0.5	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3806	2026-04-30	Chaîne 15	\N	-0.4684309267379378	f	6088.97	1686.53	65.92	4439.07	1189.38	399.75	2862.89	11.006666666666666	\N	\N	-3.6	-0.7	0.3	-1.9	2.2	0	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3807	2026-05-01	Chaîne 15	\N	-0.4595489404270184	f	6459.030000000001	1725.81	67.45	4666.41	1121.96	412.34000000000003	2800.79	11.336666666666666	\N	\N	2.3	1.6	2.7	3.1	-3.6	-2.2	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3808	2026-05-02	Chaîne 15	\N	-0.4129331816923691	f	6113.860000000001	1625.58	64.69	4667.84	1162.94	418.81	2901.44	11.299999999999999	\N	\N	-3.2	-4.3	-1.5	3.1	-0.1	1.3	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3809	2026-05-03	Chaîne 15	\N	-0.5446109980817637	t	5534.83	1419.34	53.5	4440.53	1137.78	346.61	2597.08	11.156666666666666	\N	\N	-12.3	-16.5	-18.6	-1.9	-2.3	-9.3	⚠ Anomalie Chaîne 15 — 03/05/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:46.05393	0
3810	2026-05-04	Chaîne 15	\N	-0.3717406852876671	f	6382.01	1723.43	66.06	4598.93	1153.75	410.47999999999996	2824.7200000000003	11.106666666666667	\N	\N	1.1	1.4	0.5	1.6	-0.9	-1.3	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3811	2026-05-05	Chaîne 15	\N	-0.3700164896191047	f	6365.41	1735.3899999999999	66.83	4572.26	1150.84	409.1	2930.23	11.263333333333334	\N	\N	0.8	2.1	1.7	1	-1.1	2.3	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3812	2026-05-07	Chaîne 15	\N	-0.4316080155429391	f	6588.68	1703.46	68.05	4498.45	1143.74	407.71	2725.56	11.253333333333336	\N	\N	4.4	0.2	3.6	-0.6	-1.7	-4.8	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3813	2026-05-08	Chaîne 15	\N	-0.361866881957899	f	6246.63	1699.24	67.42	4451.67	1158.78	419.02	2871.5	11.196666666666667	\N	\N	-1.1	0	2.6	-1.7	-0.5	0.3	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3814	2026-05-09	Chaîne 15	\N	-0.3940969570209337	f	6478.07	1678.48	65.67	4502.639999999999	1137.47	406.33	2837.52	11.116666666666667	\N	\N	2.6	-1.2	0	-0.5	-2.3	-0.9	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3815	2026-05-10	Chaîne 15	\N	-0.5043237804820538	f	5320.52	1470.4099999999999	54.72	4640.01	1158.42	351.13	2517.5099999999998	11.160000000000002	\N	\N	-15.7	-13.5	-16.7	2.5	-0.5	-12.1	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3816	2026-05-11	Chaîne 15	\N	-0.37218174798991416	f	6353.3099999999995	1720.83	65.38	4584.99	1143.05	406.08000000000004	2850.34	11.206666666666665	\N	\N	0.6	1.3	-0.5	1.3	-1.8	-0.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3817	2026-05-12	Chaîne 15	\N	-0.3588441583014616	f	6270.46	1659.4899999999998	64.76	4472.3	1163.79	410.13	2841.69	11.25	\N	\N	-0.7	-2.3	-1.4	-1.2	0	-0.7	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3818	2026-05-14	Chaîne 15	\N	-0.3993029379248828	f	6395.72	1727.8400000000001	64.28999999999999	4377.91	1147.04	416.49	2859.1400000000003	11.173333333333332	\N	\N	1.3	1.7	-2.1	-3.3	-1.5	-0.1	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3819	2026-05-15	Chaîne 15	\N	-0.44025193306350313	f	6557.85	1625.3400000000001	67.7	4460.82	1163.51	415.69	2875.9700000000003	11.003333333333332	\N	\N	3.9	-4.3	3	-1.5	0	0.4	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3820	2026-05-16	Chaîne 15	\N	-0.6680338072403257	t	6355.95	2060.56	102.43	4570.86	1134.1399999999999	415.82	2907.91	11.25	\N	\N	0.7	21.3	55.9	1	-2.6	1.6	⚠ Anomalie Chaîne 15 — 16/05/2026 : Eau bain laveuse +56% → Suspecter fuite bain chloré | Sertissage hors tolerance : 19.4% des mesures non conformes -> Usure des rouleaux probable — verifier la sertisseuse	2026-06-04 22:40:46.05393	19.444444444444446
3821	2026-05-17	Chaîne 15	\N	-0.5618342609441426	t	5434	1438.68	55.04	4641.01	1113.95	344.65999999999997	2564.2200000000003	11.226666666666667	\N	\N	-13.9	-15.3	-16.2	2.5	-4.3	-10.4	⚠ Anomalie Chaîne 15 — 17/05/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:46.05393	0
3822	2026-05-18	Chaîne 15	\N	-0.3891805054578965	f	6551.55	1700.57	63.87	4526.5	1159.33	423.95000000000005	2920.43	11.280000000000001	\N	\N	3.8	0.1	-2.8	0	-0.4	2	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3823	2026-05-19	Chaîne 15	\N	-0.4203658154547551	f	6519.799999999999	1714.69	67.52	4582.77	1197.4099999999999	433.53	2796.63	11.14	\N	\N	3.3	0.9	2.8	1.2	2.9	-2.3	Fonctionnement normal.	2026-06-04 22:40:46.05393	0
3824	2026-03-06	Chaîne 16	\N	-0.3431376999004566	f	7919.8099999999995	2150.1	295.31	13908.880000000001	1410.58	1855.79	3468.79	11.020000000000001	\N	\N	1.9	1.8	0	0.5	-1.5	-1.8	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3825	2026-03-07	Chaîne 16	\N	-0.350758227225139	f	7805.66	2153.4	296.90999999999997	13703.619999999999	1464.34	1832.95	3539.3199999999997	11.04	\N	\N	0.4	2	0.5	-1	2.3	0.2	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3826	2026-03-08	Chaîne 16	\N	-0.46777905566192757	f	6541.91	1801.33	248.08	13608.21	1441.09	1513.9	3044.95	11.030000000000001	\N	\N	-15.8	-14.7	-16	-1.7	0.6	-13.8	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3827	2026-03-09	Chaîne 16	\N	-0.34970312532163744	f	7756.93	2080.29	306.41999999999996	13976.76	1445.79	1873.9899999999998	3622.2	11.01	\N	\N	-0.2	-1.5	3.8	1	1	2.6	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3828	2026-03-10	Chaîne 16	\N	-0.35420714326682723	f	7767.95	2164.08	293.6	13956.91	1433.16	1862.31	3627.88	11.096666666666666	\N	\N	-0.1	2.5	-0.6	0.8	0.1	2.8	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3829	2026-03-11	Chaîne 16	\N	-0.40122642937293046	f	7529.49	2123.37	311.3	13860.169999999998	1470.33	1874.37	3636.6400000000003	10.976666666666667	\N	\N	-3.1	0.6	5.4	0.1	2.7	3	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3830	2026-03-13	Chaîne 16	\N	-0.36422114620798374	f	7821.48	2101.13	294.7	13648.19	1453.35	1808.92	3591.4700000000003	10.843333333333334	\N	\N	0.6	-0.5	-0.2	-1.4	1.5	1.7	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3831	2026-03-14	Chaîne 16	\N	-0.3482774461146991	f	8002.41	2099.23	298.65	13489.83	1436.61	1821.26	3601.59	11.01	\N	\N	3	-0.6	1.1	-2.6	0.3	2	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3832	2026-03-15	Chaîne 16	\N	-0.4712964394046754	f	6702.91	1778.67	256.84000000000003	14214.66	1416.06	1519.48	3024.32	11.006666666666666	\N	\N	-13.8	-15.8	-13	2.7	-1.1	-14.3	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3833	2026-03-16	Chaîne 16	\N	-0.37454018995658134	f	7753.37	2177.84	285.1	13834.37	1430.6599999999999	1885.18	3606.4	11.06	\N	\N	-0.3	3.2	-3.5	-0.1	-0.1	2.1	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3834	2026-03-17	Chaîne 16	\N	-0.6198548566287766	t	7978.23	2121.43	299.41	13645.39	1429.3	1917.8400000000001	3546.04	12.183333333333332	\N	\N	2.6	0.5	1.4	-1.4	-0.2	0.4	⚠ Anomalie Chaîne 16 — 17/03/2026 : Sertissage hors tolerance : 19.4% des mesures non conformes -> Usure des rouleaux probable — verifier la sertisseuse | Brix 12.18°Bx (trop élevé, norme 10.5–11.5) → Vérifier dosage et capteur Brix	2026-06-04 22:40:47.827767	19.444444444444446
3835	2026-03-18	Chaîne 16	\N	-0.33108507146152294	f	7762.35	2102.44	299.32	13852.52	1434.47	1816.5	3566.34	11.030000000000001	\N	\N	-0.1	-0.4	1.4	0.1	0.2	1	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3836	2026-03-20	Chaîne 16	\N	-0.40952858398534164	f	7732.9	2184.07	295.27	13056.27	1456.24	1849.27	3686.19	10.99	\N	\N	-0.5	3.4	0	-5.7	1.7	4.4	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3837	2026-03-21	Chaîne 16	\N	-0.3318627235542498	f	7760.45	2052.24	293.06	13875.9	1428.27	1845.51	3544.7599999999998	10.976666666666667	\N	\N	-0.2	-2.8	-0.8	0.2	-0.3	0.4	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3838	2026-03-22	Chaîne 16	\N	-0.4770241695272785	f	6589.9400000000005	1795.77	257.86	14273.619999999999	1441.01	1576.1599999999999	2986.46	10.839999999999998	\N	\N	-15.2	-14.9	-12.7	3.1	0.6	-15.4	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3839	2026-03-23	Chaîne 16	\N	-0.3620325626670056	f	8047.01	2149.0299999999997	297.53999999999996	13574.49	1404.5	1812.7599999999998	3528.7999999999997	11.049999999999999	\N	\N	3.5	1.8	0.8	-2	-1.9	-0.1	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3840	2026-03-24	Chaîne 16	\N	-0.361505256829634	f	7867.83	2100.41	291.82	13307.18	1409.18	1818.37	3626.45	11.01	\N	\N	1.2	-0.5	-1.2	-3.9	-1.6	2.7	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3841	2026-03-25	Chaîne 16	\N	-0.3652077644636532	f	8021.9400000000005	2086.7	296.93	13968.17	1430.35	1780.29	3489.16	11.076666666666666	\N	\N	3.2	-1.2	0.6	0.9	-0.1	-1.2	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3842	2026-03-27	Chaîne 16	\N	-0.3638897079421591	f	7548.34	2120.46	294.92	13938.89	1404.04	1868.99	3640.17	11.01	\N	\N	-2.9	0.4	-0.1	0.7	-2	3.1	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3843	2026-03-28	Chaîne 16	\N	-0.39626629532917745	f	7712.52	2204.75	298.2	13794.86	1381.19	1883.3400000000001	3610.74	11.04	\N	\N	-0.8	4.4	1	-0.4	-3.5	2.3	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3844	2026-03-29	Chaîne 16	\N	-0.45492526906652175	f	6598.37	1790.19	257.33	13837.05	1476.01	1570.88	3030.42	10.94	\N	\N	-15.1	-15.2	-12.9	-0.1	3.1	-14.2	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3845	2026-03-30	Chaîne 16	\N	-0.3710461790720696	f	7637.32	2151.5299999999997	305.63	13989.43	1460.83	1886	3624.21	11.003333333333332	\N	\N	-1.7	1.9	3.5	1	2	2.7	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3846	2026-03-31	Chaîne 16	\N	-0.37336467840389037	f	7844.049999999999	2160.0299999999997	284.23	14036.25	1449.74	1845.2600000000002	3527.52	10.976666666666667	\N	\N	0.9	2.3	-3.7	1.4	1.2	-0.1	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3847	2026-04-01	Chaîne 16	\N	-0.34220038822254084	f	7810.7300000000005	2142.65	295.99	13668.49	1459.48	1854.7	3549.3	10.993333333333334	\N	\N	0.5	1.5	0.2	-1.3	1.9	0.5	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3848	2026-04-03	Chaîne 16	\N	-0.4042207474007861	f	7586.48	2130.67	305.67	13699.720000000001	1372.31	1805.87	3456.88	10.966666666666669	\N	\N	-2.4	0.9	3.5	-1	-4.2	-2.1	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3849	2026-04-04	Chaîne 16	\N	-0.3847196000281066	f	7652.65	2051.09	300.64	13981.8	1380.23	1870.33	3637.37	10.953333333333333	\N	\N	-1.5	-2.9	1.8	1	-3.6	3	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3850	2026-04-05	Chaîne 16	\N	-0.5039376832848824	t	6846.07	1854.41	250.4	13425.41	1461.78	1546.62	2879.3	11.053333333333333	\N	\N	-11.9	-12.2	-15.2	-3	2.1	-18.4	⚠ Anomalie Chaîne 16 — 05/04/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:47.827767	0
3851	2026-04-06	Chaîne 16	\N	-0.80518749172806	t	66850.04	45562.1	30449.49	215946.1	42486.57	528705.14	18603.524999999998	10.896666666666667	\N	\N	760	2058	10211.7	1459.8	2867	426.9	⚠ Anomalie Chaîne 16 — 06/04/2026 : Électricité +760% vs baseline (66850 kWh vs 7773 kWh) → Vérifier moteurs et tableau électrique | Eau pasteurisateur +1460% → Suspecter fuite circuit pasteurisateur | Eau bain laveuse +10212% → Suspecter fuite bain chloré | Eau rinçage +2058% → Vérifier circuit rinçage	2026-06-04 22:40:47.827767	0
3852	2026-04-07	Chaîne 16	\N	-0.3598015443147328	f	7778.030000000001	2114.33	295.78	14107.16	1410.87	1866.42	3694.2	10.933333333333332	\N	\N	0.1	0.1	0.2	1.9	-1.5	4.6	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3853	2026-04-08	Chaîne 16	\N	-0.3705706958105318	f	7966.45	2067.5699999999997	304.1	13956.49	1411.38	1859.1299999999999	3614.4	11.126666666666665	\N	\N	2.5	-2.1	3	0.8	-1.4	2.4	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3854	2026-04-10	Chaîne 16	\N	-0.3534216903110117	f	7850.9400000000005	2165.41	292.86	13588.2	1408.02	1791.3	3539.32	10.93	\N	\N	1	2.6	-0.8	-1.9	-1.7	0.2	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3855	2026-04-11	Chaîne 16	\N	-0.36118594711516505	f	8007.04	2069.7	298.08000000000004	13368.69	1422.54	1885.75	3498.63	10.96	\N	\N	3	-2	0.9	-3.4	-0.7	-0.9	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3856	2026-04-12	Chaîne 16	\N	-0.47403016330837566	f	6809.98	1795.62	255.28	14011.93	1398.95	1577.8200000000002	3090.6099999999997	11.003333333333332	\N	\N	-12.4	-15	-13.5	1.2	-2.3	-12.5	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3857	2026-04-13	Chaîne 16	\N	-0.8759096764002575	t	104647.55	7284501.35	796279.54	667401.03	373818.23	1154305.37	496400.46	11.076666666666666	\N	\N	1246.3	344926.9	269560.2	4720.6	26004.9	13960	⚠ Anomalie Chaîne 16 — 13/04/2026 : Électricité +1246% vs baseline (104648 kWh vs 7773 kWh) → Vérifier moteurs et tableau électrique | Eau pasteurisateur +4721% → Suspecter fuite circuit pasteurisateur | Eau bain laveuse +269560% → Suspecter fuite bain chloré | Eau rinçage +344927% → Vérifier circuit rinçage	2026-06-04 22:40:47.827767	13.888888888888888
3858	2026-04-14	Chaîne 16	\N	-0.37256567539044416	f	7714.4	2151.98	303.07	13443.59	1386.5900000000001	1852.72	3557.56	10.993333333333334	\N	\N	-0.8	1.9	2.6	-2.9	-3.2	0.8	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3859	2026-04-15	Chaîne 16	\N	-0.36169977958350813	f	7875.77	2085.13	302.52	13629.35	1414.46	1896.23	3628.76	10.916666666666666	\N	\N	1.3	-1.2	2.4	-1.6	-1.2	2.8	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3860	2026-04-17	Chaîne 16	\N	-0.3626728791574816	f	7794.17	2130.98	308.27	13671.55	1435.97	1873.04	3391.85	11.036666666666667	\N	\N	0.3	0.9	4.4	-1.3	0.3	-3.9	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3861	2026-04-18	Chaîne 16	\N	-0.35538304314294267	f	7880.469999999999	2067.88	292.24	13754.89	1452.7	1783.6100000000001	3497.4	10.969999999999999	\N	\N	1.4	-2.1	-1	-0.6	1.4	-0.9	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3862	2026-04-19	Chaîne 16	\N	-0.46773223727157165	f	6639.360000000001	1771	255.3	13396.490000000002	1453.79	1600.01	2937.23	11.043333333333335	\N	\N	-14.6	-16.1	-13.5	-3.2	1.5	-16.8	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3863	2026-04-20	Chaîne 16	\N	-0.4182977054057221	f	7940.17	2178.71	306.18	13705.26	1440.33	1741.99	3421.49	10.876666666666667	\N	\N	2.2	3.2	3.7	-1	0.6	-3.1	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3864	2026-04-21	Chaîne 16	\N	-0.39000796420537415	f	8097.389999999999	2094.17	303.16999999999996	13650.97	1406.01	1853.44	3478.37	11.153333333333334	\N	\N	4.2	-0.8	2.7	-1.4	-1.8	-1.5	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3865	2026-04-22	Chaîne 16	\N	-0.3487164247051513	f	7650.700000000001	2078.94	291.97	13875.21	1435.12	1801.9499999999998	3646.24	10.99	\N	\N	-1.6	-1.5	-1.1	0.2	0.2	3.3	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3866	2026-04-24	Chaîne 16	\N	-0.3560454813085521	f	7864.62	2084.96	294.38	13533.310000000001	1416.74	1819.1599999999999	3476.91	11.093333333333334	\N	\N	1.2	-1.2	-0.3	-2.2	-1.1	-1.5	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3867	2026-04-25	Chaîne 16	\N	-0.39989861609466	f	7527.360000000001	2108.24	292.47	13893.61	1437.52	1875.54	3630.46	11.166666666666666	\N	\N	-3.2	-0.1	-1	0.4	0.4	2.8	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3868	2026-04-26	Chaîne 16	\N	-0.4554378520279417	f	6454.7	1803.0500000000002	254.72	13629.9	1433.45	1582.64	2974.62	10.903333333333334	\N	\N	-17	-14.6	-13.7	-1.6	0.1	-15.7	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3869	2026-04-27	Chaîne 16	\N	-0.3660785635700936	f	7989.139999999999	2044.52	301.73	13806.579999999998	1424.99	1792.29	3561.58	10.896666666666667	\N	\N	2.8	-3.2	2.2	-0.3	-0.5	0.9	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3870	2026-04-28	Chaîne 16	\N	-0.37509945647313747	f	7889.049999999999	2157.9	289.27	13377.79	1461.9299999999998	1846.42	3486.92	11.07	\N	\N	1.5	2.2	-2	-3.4	2.1	-1.2	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3871	2026-04-29	Chaîne 16	\N	-0.3547673106204848	f	7954.110000000001	2098.2200000000003	300.74	13856.43	1405.5900000000001	1830.36	3392.37	10.993333333333334	\N	\N	2.3	-0.6	1.8	0.1	-1.8	-3.9	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3872	2026-05-01	Chaîne 16	\N	-0.3396662121142597	f	7794.129999999999	2137.8199999999997	292.88	13962.96	1415.3	1849.29	3510.08	10.916666666666666	\N	\N	0.3	1.3	-0.8	0.9	-1.2	-0.6	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3873	2026-05-02	Chaîne 16	\N	-0.35820305613069675	f	7824.61	2115.85	289.96000000000004	14035.89	1443.78	1854.87	3416.79	11.049999999999999	\N	\N	0.7	0.2	-1.8	1.4	0.8	-3.2	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3874	2026-05-03	Chaîne 16	\N	-0.48682975743142065	f	6481.49	1722.4299999999998	255.1	14239.74	1449.25	1560.69	3052.55	10.946666666666667	\N	\N	-16.6	-18.4	-13.6	2.9	1.2	-13.5	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3875	2026-05-04	Chaîne 16	\N	-0.36560702154618785	f	7670.34	2116.35	300.34000000000003	14216.23	1457.8	1809.07	3555.6899999999996	10.99	\N	\N	-1.3	0.2	1.7	2.7	1.8	0.7	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3876	2026-05-05	Chaîne 16	\N	-0.3718592800590352	f	7795.66	2093.79	307.87	14086.130000000001	1424.9	1839.74	3448.0299999999997	10.866666666666667	\N	\N	0.3	-0.8	4.3	1.7	-0.5	-2.3	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3877	2026-05-06	Chaîne 16	\N	-0.3650086120164588	f	7731.71	2153.15	296.07	13753.07	1427.23	1927.04	3523.2799999999997	10.936666666666667	\N	\N	-0.5	2	0.3	-0.7	-0.3	-0.2	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3878	2026-05-08	Chaîne 16	\N	-0.3555879021643393	f	7765.0599999999995	2136.39	303.15999999999997	14066.8	1404.5700000000002	1889.5100000000002	3532.39	10.93	\N	\N	-0.1	1.2	2.7	1.6	-1.9	0.1	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3879	2026-05-09	Chaîne 16	\N	-0.378639293603931	f	7827.67	2066.44	289.62	14159.95	1435.1799999999998	1904.3600000000001	3551.42	10.9	\N	\N	0.7	-2.1	-1.9	2.3	0.2	0.6	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3880	2026-05-10	Chaîne 16	\N	-0.63541862098398	t	6677.71	1870.22	253.39	13670.4	1435.47	1506	2967.02	12.243333333333332	\N	\N	-14.1	-11.4	-14.2	-1.3	0.2	-16	⚠ Anomalie Chaîne 16 — 10/05/2026 : Brix 12.24°Bx (trop élevé, norme 10.5–11.5) → Vérifier dosage et capteur Brix	2026-06-04 22:40:47.827767	11.111111111111109
3881	2026-05-11	Chaîne 16	\N	-0.43259910161851167	f	8011.69	2199.17	304.93	14129.419999999998	1466.77	1847.1599999999999	3383.79	11.103333333333333	\N	\N	3.1	4.2	3.3	2.1	2.4	-4.2	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3882	2026-05-12	Chaîne 16	\N	-0.37289257136187015	f	7741.68	2157.56	302.24	13620.94	1461.2399999999998	1801.65	3379.4700000000003	11.026666666666666	\N	\N	-0.4	2.2	2.4	-1.6	2	-4.3	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3883	2026-05-13	Chaîne 16	\N	-0.4305490196841502	f	7733.3099999999995	2088.24	294.48	13075.24	1473.97	1834.15	3741.9	10.899999999999999	\N	\N	-0.5	-1.1	-0.3	-5.6	2.9	6	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3884	2026-05-15	Chaîne 16	\N	-0.3555537173053161	f	7920.9	2058.29	302.03	13943.97	1401.6399999999999	1874.23	3626.5	11.016666666666666	\N	\N	1.9	-2.5	2.3	0.7	-2.1	2.7	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3885	2026-05-16	Chaîne 16	\N	-0.3737114636704697	f	7700.9400000000005	2114.42	292.7	13871.67	1436.43	1781.24	3709.98	10.94	\N	\N	-0.9	0.1	-0.9	0.2	0.3	5.1	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3886	2026-05-17	Chaîne 16	\N	-0.49365447884667657	t	6504.88	1820.2800000000002	244.68	13813.31	1374.55	1598.92	2931.38	11	\N	\N	-16.3	-13.8	-17.1	-0.2	-4	-17	⚠ Anomalie Chaîne 16 — 17/05/2026 : Combinaison anormale de plusieurs paramètres — inspection générale recommandée	2026-06-04 22:40:47.827767	0
3887	2026-05-18	Chaîne 16	\N	-0.33648051132135104	f	7803.5	2155.21	291.71	13740.23	1410.09	1848.38	3509.49	10.973333333333334	\N	\N	0.4	2.1	-1.2	-0.8	-1.5	-0.6	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3888	2026-05-19	Chaîne 16	\N	-0.3612201722279201	f	7859.1	2127.17	292.15	13902.74	1408.76	1883.0700000000002	3370.79	10.983333333333334	\N	\N	1.1	0.8	-1.1	0.4	-1.6	-4.5	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
3889	2026-05-20	Chaîne 16	\N	-0.3647998708349322	f	7562.9	2166.94	290.01	13663.43	1430.81	1850.37	3503.08	10.946666666666667	\N	\N	-2.7	2.6	-1.8	-1.3	-0.1	-0.8	Fonctionnement normal.	2026-06-04 22:40:47.827767	0
\.


--
-- Data for Name: scores_sante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scores_sante (id, date, atelier, score, niveau, taux_anomalies, ecart_baseline, taux_qualite, created_at) FROM stdin;
1	2026-05-21	Chaîne 8	95	vert	7.7	4	98.7	2026-05-21 07:51:25.505314
2	2026-05-21	Chaîne 14	94.7	vert	8	3.9	100	2026-05-21 07:51:36.483892
3	2026-05-21	Chaîne 15	93.1	vert	12	4.2	100	2026-05-21 07:51:38.071825
4	2026-05-21	Chaîne 16	92.2	vert	11.5	3.7	92.3	2026-05-21 07:51:39.710949
33	2026-05-22	Chaîne 8	92.8	vert	12	4.2	98.7	2026-05-22 14:22:13.965105
34	2026-05-22	Chaîne 14	94.7	vert	8	3.9	100	2026-05-22 14:22:15.477021
35	2026-05-22	Chaîne 15	92.4	vert	12.5	4.2	100	2026-05-22 14:22:17.016013
36	2026-05-22	Chaîne 16	91.4	vert	12	3.7	92	2026-05-22 14:22:18.333222
37	2026-06-01	Chaîne 8	87.9	vert	12.5	4	100	2026-06-01 22:05:11.149647
38	2026-06-01	Chaîne 14	89.7	vert	6.2	4.6	100	2026-06-01 22:05:20.570664
39	2026-06-01	Chaîne 15	85.5	vert	18.8	4.3	100	2026-06-01 22:05:22.395298
40	2026-06-01	Chaîne 16	86.4	vert	11.8	3.7	90.2	2026-06-01 22:05:24.046285
49	2026-06-04	Chaîne 8	86.4	vert	14.3	3.3	100	2026-06-04 22:40:41.25002
50	2026-06-04	Chaîne 14	90.9	vert	0	3.2	100	2026-06-04 22:40:44.737363
51	2026-06-04	Chaîne 15	85.1	vert	15.4	4.1	100	2026-06-04 22:40:46.677069
52	2026-06-04	Chaîne 16	84.2	vert	14.3	3.1	90.5	2026-06-04 22:40:48.650082
\.


--
-- Data for Name: utilisateurs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utilisateurs (id, username, password, role, actif, created_at, last_login) FROM stdin;
19	manager	$2b$12$vZdd7KXD7hvyOivejBEAv./b2L2PWogjslGWVrEd2KbUM4jJF65FG	manager	t	2026-04-21 10:03:24.37118	2026-06-04 22:26:53.255021
20	GUY	$2b$12$MEb3MlQ6HXyUjv.KkhZoVOZ0vLLlTN/9asLxh8VBmtZ3j3t3ihx1y	chef_atelier	t	2026-04-21 10:03:24.37118	\N
21	contremaitre1	$2b$12$j7Ey.oA7utVQ2Qmbn4RqNujCbTFQ/Zom5158Obcv55EIiVc6nGhYa	contremaitre	t	2026-04-21 10:03:24.37118	\N
\.


--
-- Name: alertes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alertes_id_seq', 2, true);


--
-- Name: equipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipes_id_seq', 3, true);


--
-- Name: lean_energie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lean_energie_id_seq', 1252, true);


--
-- Name: lignes_pointage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lignes_pointage_id_seq', 266, true);


--
-- Name: logs_activite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_activite_id_seq', 130, true);


--
-- Name: membres_equipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membres_equipe_id_seq', 26, true);


--
-- Name: oee_journalier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.oee_journalier_id_seq', 1121, true);


--
-- Name: pointages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pointages_id_seq', 18, true);


--
-- Name: previsions_energie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.previsions_energie_id_seq', 175, true);


--
-- Name: qualite_a_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.qualite_a_id_seq', 1, false);


--
-- Name: qualite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.qualite_id_seq', 981, true);


--
-- Name: resultats_anomalies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resultats_anomalies_id_seq', 3889, true);


--
-- Name: scores_sante_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scores_sante_id_seq', 52, true);


--
-- Name: utilisateurs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utilisateurs_id_seq', 21, true);


--
-- Name: alertes alertes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertes
    ADD CONSTRAINT alertes_pkey PRIMARY KEY (id);


--
-- Name: equipes equipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipes
    ADD CONSTRAINT equipes_pkey PRIMARY KEY (id);


--
-- Name: lean_energie_archive lean_energie_archive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lean_energie_archive
    ADD CONSTRAINT lean_energie_archive_pkey PRIMARY KEY (id);


--
-- Name: lean_energie lean_energie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lean_energie
    ADD CONSTRAINT lean_energie_pkey PRIMARY KEY (id);


--
-- Name: lignes_pointage lignes_pointage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lignes_pointage
    ADD CONSTRAINT lignes_pointage_pkey PRIMARY KEY (id);


--
-- Name: logs_activite logs_activite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs_activite
    ADD CONSTRAINT logs_activite_pkey PRIMARY KEY (id);


--
-- Name: membres_equipe membres_equipe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membres_equipe
    ADD CONSTRAINT membres_equipe_pkey PRIMARY KEY (id);


--
-- Name: oee_journalier oee_journalier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oee_journalier
    ADD CONSTRAINT oee_journalier_pkey PRIMARY KEY (id);


--
-- Name: pointages pointages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pointages
    ADD CONSTRAINT pointages_pkey PRIMARY KEY (id);


--
-- Name: previsions_energie previsions_energie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.previsions_energie
    ADD CONSTRAINT previsions_energie_pkey PRIMARY KEY (id);


--
-- Name: qualite_a qualite_a_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualite_a
    ADD CONSTRAINT qualite_a_pkey PRIMARY KEY (id);


--
-- Name: qualite_archive qualite_archive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualite_archive
    ADD CONSTRAINT qualite_archive_pkey PRIMARY KEY (id);


--
-- Name: qualite qualite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualite
    ADD CONSTRAINT qualite_pkey PRIMARY KEY (id);


--
-- Name: resultats_anomalies resultats_anomalies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultats_anomalies
    ADD CONSTRAINT resultats_anomalies_pkey PRIMARY KEY (id);


--
-- Name: scores_sante scores_sante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scores_sante
    ADD CONSTRAINT scores_sante_pkey PRIMARY KEY (id);


--
-- Name: utilisateurs utilisateurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_pkey PRIMARY KEY (id);


--
-- Name: utilisateurs utilisateurs_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_username_key UNIQUE (username);


--
-- Name: ix_alertes_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_alertes_id ON public.alertes USING btree (id);


--
-- Name: ix_equipes_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_equipes_id ON public.equipes USING btree (id);


--
-- Name: ix_lean_energie_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_lean_energie_id ON public.lean_energie USING btree (id);


--
-- Name: ix_lignes_pointage_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_lignes_pointage_id ON public.lignes_pointage USING btree (id);


--
-- Name: ix_logs_activite_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_logs_activite_id ON public.logs_activite USING btree (id);


--
-- Name: ix_membres_equipe_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_membres_equipe_id ON public.membres_equipe USING btree (id);


--
-- Name: ix_oee_journalier_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_oee_journalier_id ON public.oee_journalier USING btree (id);


--
-- Name: ix_pointages_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_pointages_id ON public.pointages USING btree (id);


--
-- Name: ix_previsions_energie_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_previsions_energie_id ON public.previsions_energie USING btree (id);


--
-- Name: ix_qualite_a_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_qualite_a_id ON public.qualite_a USING btree (id);


--
-- Name: ix_qualite_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_qualite_id ON public.qualite USING btree (id);


--
-- Name: ix_resultats_anomalies_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_resultats_anomalies_id ON public.resultats_anomalies USING btree (id);


--
-- Name: ix_scores_sante_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_scores_sante_id ON public.scores_sante USING btree (id);


--
-- Name: ix_utilisateurs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_utilisateurs_id ON public.utilisateurs USING btree (id);


--
-- Name: lignes_pointage lignes_pointage_membre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lignes_pointage
    ADD CONSTRAINT lignes_pointage_membre_id_fkey FOREIGN KEY (membre_id) REFERENCES public.membres_equipe(id);


--
-- Name: lignes_pointage lignes_pointage_pointage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lignes_pointage
    ADD CONSTRAINT lignes_pointage_pointage_id_fkey FOREIGN KEY (pointage_id) REFERENCES public.pointages(id);


--
-- Name: membres_equipe membres_equipe_equipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membres_equipe
    ADD CONSTRAINT membres_equipe_equipe_id_fkey FOREIGN KEY (equipe_id) REFERENCES public.equipes(id);


--
-- Name: pointages pointages_equipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pointages
    ADD CONSTRAINT pointages_equipe_id_fkey FOREIGN KEY (equipe_id) REFERENCES public.equipes(id);


--
-- PostgreSQL database dump complete
--

\unrestrict Z8gc2cY1eBFf063Ik5Zj4klZ5J3cY9T8d2xISmFCLhQwhgaLwIZyZ3hKXTsXmfB

