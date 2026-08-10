import { useQuery } from '@tanstack/react-query'
import { Navigate, Route, Routes, useLocation } from 'react-router-dom'
import { ApiError, api } from './lib/api'
import { AppShell } from './components/AppShell'
import { AuthPage } from './pages/AuthPage'
import { HistoryPage } from './pages/HistoryPage'
import { RoundPage } from './pages/RoundPage'
import { SettingsPage } from './pages/SettingsPage'
import { TimeTravelPage } from './pages/TimeTravelPage'

function ProtectedApp() {
  const location = useLocation()
  const me = useQuery({ queryKey: ['me'], queryFn: api.me, retry: false })

  if (me.isLoading) return <div className="app-loader"><span className="loader-orbit" />Synchronizing timeline…</div>
  if (me.error instanceof ApiError && me.error.status === 401) {
    return <Navigate to="/login" state={{ from: location }} replace />
  }
  if (me.isError || !me.data) return <div className="fatal-panel">The timeline is unavailable. Refresh to try again.</div>

  return (
    <AppShell player={me.data.user} wallet={me.data.wallet}>
      <Routes>
        <Route index element={<TimeTravelPage />} />
        <Route path="rounds/:id" element={<RoundPage />} />
        <Route path="history" element={<HistoryPage />} />
        <Route path="settings" element={<SettingsPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </AppShell>
  )
}

export function App() {
  return (
    <Routes>
      <Route path="/login" element={<AuthPage />} />
      <Route path="/*" element={<ProtectedApp />} />
    </Routes>
  )
}
