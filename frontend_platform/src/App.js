import { useState } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';

// Pages
import SplashScreen    from './pages/SplashScreen';
import Login           from './pages/auth/Login';
import Dashboard       from './pages/dashboard/Dashboard';
import SaisieEnergie   from './pages/saisie/SaisieEnergie';
import SaisieQualite   from './pages/saisie/SaisieQualite';
import Alertes         from './pages/alertes/Alertes';
import EnergieAccueil  from './pages/energie/EnergieAccueil';
import QualiteAccueil  from './pages/qualite/QualiteAccueil';
import AnalyseEnergie  from './pages/energie/AnalyseEnergie';
import Administration  from './pages/admin/Administration';
import SaisiePointage  from './pages/pointage/SaisiePointage';

// Layout
import Layout from './components/layout/Layout';

// Rôles
const TOUS     = ['contremaitre', 'chef_atelier', 'manager'];
const MANAGERS = ['manager'];

function PrivateRoute({ children, roles }) {
  const { user, loading } = useAuth();
  if (loading) return null;
  if (!user) return <Navigate to="/login" replace />;
  if (roles && !roles.includes(user.role)) {
    return <Navigate to="/dashboard" replace />;
  }
  return children;
}

function AppRoutes() {
  const { user, loading }   = useAuth();
  const [splash, setSplash] = useState(true);

  if (loading) return null;
  if (splash) return <SplashScreen onFinish={() => setSplash(false)} />;

  return (
    <Routes>
      <Route
        path="/login"
        element={user ? <Navigate to="/dashboard" replace /> : <Login />}
      />

      <Route path="/" element={
        <PrivateRoute><Layout /></PrivateRoute>
      }>
        <Route index element={<Navigate to="/dashboard" replace />} />

        {/* Dashboard — tous */}
        <Route path="dashboard" element={<Dashboard />} />

        {/* Énergie — tous */}
        <Route path="energie" element={
          <PrivateRoute roles={TOUS}><EnergieAccueil /></PrivateRoute>
        } />
        <Route path="energie/releves" element={
          <PrivateRoute roles={TOUS}><SaisieEnergie /></PrivateRoute>
        } />
        <Route path="energie/analyse" element={
          <PrivateRoute roles={TOUS}><AnalyseEnergie /></PrivateRoute>
        } />

        {/* Qualité — tous */}
        <Route path="qualite" element={
          <PrivateRoute roles={TOUS}><QualiteAccueil /></PrivateRoute>
        } />
        <Route path="qualite/releves" element={
          <PrivateRoute roles={TOUS}><SaisieQualite /></PrivateRoute>
        } />
        <Route path="qualite/analyse" element={
          <PrivateRoute roles={TOUS}>
            <div style={{padding:32}}>Analyse Qualité — bientôt</div>
          </PrivateRoute>
        } />

        {/* Pointage — tous */}
        <Route path="pointage" element={
          <PrivateRoute roles={TOUS}><SaisiePointage /></PrivateRoute>
        } />

        {/* Alertes — tous */}
        <Route path="alertes" element={
          <PrivateRoute roles={TOUS}><Alertes /></PrivateRoute>
        } />

        {/* Administration — manager seulement */}
        <Route path="admin/users" element={
          <PrivateRoute roles={MANAGERS}><Administration /></PrivateRoute>
        } />
      </Route>

      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
  );
}

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <AppRoutes />
      </BrowserRouter>
    </AuthProvider>
  );
}