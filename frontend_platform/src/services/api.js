import axios from 'axios';

// URL de base de notre API FastAPI
const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000/api';

// Instance axios configurée
const api = axios.create({
  baseURL: API_URL,
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  },
});

// ── INTERCEPTEUR ──────────────────────────────────────────
// Ajoute automatiquement le token JWT à chaque requête
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Si le token est expiré → redirige vers login
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// ── AUTH ──────────────────────────────────────────────────
export const authAPI = {
  login: (username, password) =>
    api.post('/auth/login', { username, password }),
  me: () =>
    api.get('/auth/me'),
};

// ── LEAN ÉNERGIE ──────────────────────────────────────────
export const energieAPI = {
  creer: (data) =>
    api.post('/energie/', data),
  lister: (params) =>
    api.get('/energie/', { params }),
  detail: (id) =>
    api.get(`/energie/${id}`),
  supprimer: (id) =>
    api.delete(`/energie/${id}`),
};

// ── QUALITÉ ───────────────────────────────────────────────
export const qualiteAPI = {
  creer: (data) =>
    api.post('/qualite/', data),
  lister: (params) =>
    api.get('/qualite/', { params }),
  detail: (id) =>
    api.get(`/qualite/${id}`),
  supprimer: (id) =>
    api.delete(`/qualite/${id}`),
  creerVoletA:  (data)   => 
    api.post('/qualite/volet-a', data),
  listerVoletA: (params) => 
    api.get('/qualite/volet-a',  { params }),
};

// ── ALERTES ───────────────────────────────────────────────
export const alertesAPI = {
  lister: (params) =>
    api.get('/alertes/', { params }),
  marquerLu: (id) =>
    api.put(`/alertes/${id}/lire`),
  compter: () =>
    api.get('/alertes/count'),
  supprimer: (id) =>
    api.delete(`/alertes/${id}`),
};

// ── ÉQUIPES ───────────────────────────────────────────────
export const equipesAPI = {
  lister:         (params) => api.get('/equipes/', { params }),
  fonctions:      ()       => api.get('/equipes/fonctions'),
  creer:          (data)   => api.post('/equipes/', data),
  modifier:       (id, data) => api.put(`/equipes/${id}`, data),
  supprimer:      (id)     => api.delete(`/equipes/${id}`),
  ajouterMembre:  (equipeId, data) => api.post(`/equipes/${equipeId}/membres`, data),
  modifierMembre: (equipeId, membreId, data) => api.put(`/equipes/${equipeId}/membres/${membreId}`, data),
  supprimerMembre:(equipeId, membreId) => api.delete(`/equipes/${equipeId}/membres/${membreId}`),
};

// ── POINTAGES ─────────────────────────────────────────────
export const pointagesAPI = {
  creer:        (data)    => api.post('/pointages/', data),
  lister:       (params)  => api.get('/pointages/', { params }),
  verifier:     (params)  => api.get('/pointages/verifier', { params }),
  exportExcel: (params) => api.get('/pointages/export-excel', {
    params,
    responseType: 'blob',
  }),
  rapportAB:    (params)  => api.get('/pointages/rapport-ab', { params }),
  exportExcelAM: (params) => api.get('/pointages/export-excel-am', {
    params,
    responseType: 'blob',
  }),
  exportExcelPrestataire: (params) => api.get('/pointages/export-excel-prestataire', { params, responseType: 'blob' }),
  exportExcelPepiniere:   (params) => api.get('/pointages/export-excel-pepiniere',   { params, responseType: 'blob' }),
  exportExcelOccasionnel: (params) => api.get('/pointages/export-excel-occasionnel', { params, responseType: 'blob' }),
};

// ── MAINTENANCE PRÉDICTIVE IA ─────────────────────────────
export const maintenanceAPI = {
  lancerAnalyseTous: () =>
    api.post('/maintenance/analyser-tous', {}, { timeout: 180000 }), // 3 min
  lancerAnalyse: (atelier) =>
    api.post(`/maintenance/analyser/${encodeURIComponent(atelier)}`, {}, { timeout: 120000 }),
  getScoresSante: ()       => api.get('/maintenance/scores-sante'),
  getAnomalies:  (params)  => api.get('/maintenance/anomalies',       { params }),
  getOEE:        (params)  => api.get('/maintenance/oee',             { params }),
  getPrevisions: (params)  => api.get('/maintenance/previsions',      { params }),
  getResume:     ()        => api.get('/maintenance/dashboard-resume'),
};

export default api;