import { useMutation } from '@tanstack/react-query'
import { Clock3, LockKeyhole, Mail, Sparkles, UserRound } from 'lucide-react'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ApiError, api } from '../lib/api'
import { queryClient } from '../lib/query'

export function AuthPage() {
  const navigate = useNavigate()
  const [mode, setMode] = useState<'register' | 'login'>('register')
  const [displayName, setDisplayName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  const authenticate = useMutation({
    mutationFn: () => mode === 'register'
      ? api.register({ display_name: displayName, email, password, password_confirmation: password })
      : api.login(email, password),
    onSuccess: (data) => {
      queryClient.setQueryData(['me'], data)
      navigate('/')
    },
  })

  return (
    <main className="auth-page">
      <section className="auth-story">
        <div className="brand auth-brand"><span className="brand-mark"><Clock3 /></span><span><strong>CHRONO</strong>BET</span></div>
        <div>
          <span className="eyebrow"><Sparkles size={15} /> History is the house</span>
          <h1>Bet before<br />you <em>remember.</em></h1>
          <p>Step into a sealed Premier League timeline. Place virtual-credit wagers at the original odds, then let time reveal what happened.</p>
        </div>
        <div className="auth-credit"><strong>10,000</strong><span>PLAY CREDITS<br />ON ARRIVAL</span></div>
      </section>

      <section className="auth-panel">
        <div className="auth-form-wrap">
          <span className="eyebrow">Player access</span>
          <h2>{mode === 'register' ? 'Create your timeline' : 'Welcome back'}</h2>
          <p>Virtual credits only. No deposits. No cash redemption.</p>
          <div className="mode-switch">
            <button className={mode === 'register' ? 'active' : ''} onClick={() => setMode('register')}>Register</button>
            <button className={mode === 'login' ? 'active' : ''} onClick={() => setMode('login')}>Sign in</button>
          </div>
          <form onSubmit={(event) => { event.preventDefault(); authenticate.mutate() }}>
            {mode === 'register' && (
              <label><UserRound /><span><small>Display name</small><input required value={displayName} onChange={(event) => setDisplayName(event.target.value)} autoComplete="nickname" /></span></label>
            )}
            <label><Mail /><span><small>Email</small><input required type="email" value={email} onChange={(event) => setEmail(event.target.value)} autoComplete="email" /></span></label>
            <label><LockKeyhole /><span><small>Password</small><input required minLength={6} type="password" value={password} onChange={(event) => setPassword(event.target.value)} autoComplete={mode === 'login' ? 'current-password' : 'new-password'} /></span></label>
            {authenticate.error && <div className="form-error" role="alert">{authenticate.error instanceof ApiError ? authenticate.error.message : 'Could not continue'}</div>}
            <button className="primary-cta" disabled={authenticate.isPending}>{authenticate.isPending ? 'Synchronizing…' : mode === 'register' ? 'Create player account' : 'Enter sportsbook'}</button>
          </form>
        </div>
      </section>
    </main>
  )
}
