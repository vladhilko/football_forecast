import { useQuery } from '@tanstack/react-query'
import { CalendarClock, ChevronRight, History, Trophy } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '../lib/api'

export function HistoryPage() {
  const history = useQuery({ queryKey: ['sessions'], queryFn: api.timeTravelSessions })

  return (
    <div className="content-page">
      <header className="content-heading"><span className="eyebrow"><History size={15} /> Timeline archive</span><h1>Your journeys</h1><p>Every confirmed wager and resolved round remains available for review.</p></header>
      <div className="history-list">
        {history.data?.sessions.map((session) => {
          const profit = session.wagers.reduce((sum, wager) => sum + (wager.profit_minor ?? -wager.stake_minor), 0)
          return (
            <Link to={`/rounds/${session.id}`} key={session.id} className="history-card">
              <span className="history-icon">{session.status === 'settled' ? <Trophy /> : <CalendarClock />}</span>
              <div><small>Destination {session.travel_on}</small><strong>{session.league.name}</strong><span>{session.fixtures.length} fixtures · {session.wagers.length} wagers</span></div>
              <div className={`history-profit ${profit >= 0 ? 'positive' : ''}`}><small>{session.status === 'settled' ? 'Net result' : 'Status'}</small><strong>{session.status === 'settled' ? `${profit >= 0 ? '+' : ''}${(profit / 100).toFixed(2)} CR` : session.status}</strong></div>
              <ChevronRight />
            </Link>
          )
        })}
        {history.data?.sessions.length === 0 && <div className="empty-history"><History /><strong>No timelines yet</strong><p>Your first trip into football history will appear here.</p><Link to="/">Open the portal</Link></div>}
      </div>
    </div>
  )
}
