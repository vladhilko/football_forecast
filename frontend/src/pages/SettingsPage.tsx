import { useMutation, useQuery } from '@tanstack/react-query'
import { BadgeCheck, Film, Sparkles } from 'lucide-react'
import type { RevealMode } from '../lib/api'
import { api } from '../lib/api'
import { queryClient } from '../lib/query'

export function SettingsPage() {
  const me = useQuery({ queryKey: ['me'], queryFn: api.me })
  const update = useMutation({
    mutationFn: (mode: RevealMode) => api.updateSettings(mode),
    onSuccess: (data) => queryClient.setQueryData(['me'], data),
  })
  const selected = me.data?.user.preferred_reveal_mode ?? 'honest'

  return (
    <div className="content-page settings-page">
      <header className="content-heading"><span className="eyebrow"><Sparkles size={15} /> Player preferences</span><h1>Replay settings</h1><p>Choose how future rounds move forward. An open round keeps the mode it started with.</p></header>
      <div className="setting-grid">
        <button className={selected === 'honest' ? 'selected' : ''} onClick={() => update.mutate('honest')}>
          <span className="setting-icon"><BadgeCheck /></span><div><small>Default · verified</small><strong>Honest staged reveal</strong><p>Advance through a cinematic clock, then uncover verified final scores one by one. No goal times are invented.</p></div>{selected === 'honest' && <span className="selected-pill">ACTIVE</span>}
        </button>
        <button className={selected === 'synthetic' ? 'selected' : ''} onClick={() => update.mutate('synthetic')}>
          <span className="setting-icon"><Film /></span><div><small>Optional · dramatized</small><strong>Synthetic timeline</strong><p>Watch goals distributed across a compressed match. The sequence is visibly labeled simulated; final scores remain real.</p></div>{selected === 'synthetic' && <span className="selected-pill">ACTIVE</span>}
        </button>
      </div>
      <div className="responsible-note"><BadgeCheck /><div><strong>Play-credit environment</strong><p>ChronoBet has no deposits, withdrawals, cash value, or real-money redemption.</p></div></div>
    </div>
  )
}
