import { useMutation, useQuery } from '@tanstack/react-query'
import { AnimatePresence, motion } from 'motion/react'
import { ArrowLeft, Check, ChevronRight, Clock3, LockKeyhole, Radio, ShieldCheck, Sparkles, TimerReset, Trophy, X } from 'lucide-react'
import { useEffect, useReducer, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import type { Fixture, RevealSnapshot, Selection, TimeTravelSession } from '../lib/api'
import { ApiError, api } from '../lib/api'
import { creditsFromMinor, minorFromCredits } from '../lib/money'
import { queryClient } from '../lib/query'

type SlipItem = { selection: Selection; stake: string }
type Slip = Record<string, SlipItem>
type SlipAction =
  | { type: 'select'; fixtureId: string; selection: Selection }
  | { type: 'stake'; fixtureId: string; stake: string }
  | { type: 'remove'; fixtureId: string }
  | { type: 'clear' }

function slipReducer(state: Slip, action: SlipAction): Slip {
  if (action.type === 'clear') return {}
  if (action.type === 'remove') {
    const next = { ...state }
    delete next[action.fixtureId]
    return next
  }
  if (action.type === 'stake') return { ...state, [action.fixtureId]: { ...state[action.fixtureId], stake: action.stake } }
  return { ...state, [action.fixtureId]: { selection: action.selection, stake: state[action.fixtureId]?.stake ?? '100.00' } }
}

const labels: Record<Selection, string> = { home: '1', draw: 'X', away: '2' }

function OddsButton({ fixture, selection, active, disabled, onSelect }: {
  fixture: Fixture; selection: Selection; active: boolean; disabled: boolean; onSelect: () => void
}) {
  return (
    <button className={`odds-button ${active ? 'active' : ''}`} disabled={disabled} onClick={onSelect} aria-pressed={active}>
      <span>{labels[selection]}</span><strong>{fixture.odds[selection]}</strong>{active && <Check size={14} />}
    </button>
  )
}

function RevealOverlay({ session, reveal }: { session: TimeTravelSession; reveal: RevealSnapshot }) {
  const fixtureById = new Map(session.fixtures.map((fixture) => [fixture.id, fixture]))
  const progress = Math.min(100, (reveal.elapsed_seconds / reveal.duration_seconds) * 100)
  const totalStake = reveal.wagers.reduce((sum, wager) => sum + wager.stake_minor, 0)
  const totalPayout = reveal.wagers.reduce((sum, wager) => sum + (wager.payout_minor ?? 0), 0)
  const netProfit = totalPayout - totalStake

  return (
    <motion.section className="reveal-overlay" initial={{ opacity: 0 }} animate={{ opacity: 1 }} aria-live="polite">
      <div className="reveal-sky"><span /><span /><span /></div>
      <div className="reveal-header">
        <div><span className="live-dot" /> TIME STREAM ACTIVE</div>
        <strong>{reveal.match_minute}<small>′</small></strong>
        <div>{reveal.reveal_mode === 'synthetic' ? 'SIMULATED EVENT SEQUENCE' : 'VERIFIED FINAL-SCORE REVEAL'}</div>
      </div>
      <div className="reveal-progress"><span style={{ width: `${progress}%` }} /></div>
      <div className="reveal-title">
        <small>{reveal.phase.replace('_', ' ')}</small>
        <h2>{reveal.status === 'settled' ? 'Timeline resolved' : 'Time is moving forward'}</h2>
        <p>{reveal.reveal_mode === 'synthetic' ? 'Goal minutes are a clearly labeled dramatic simulation; final scores remain historical.' : 'No goal timeline is invented. Verified results unlock one fixture at a time.'}</p>
      </div>
      <div className="reveal-fixtures">
        {reveal.fixtures.map((result) => {
          const fixture = fixtureById.get(result.id)!
          return (
            <motion.article key={result.id} animate={result.revealed ? { borderColor: '#49d99a', y: -3 } : {}}>
              <span className="reveal-position">{String(result.position + 1).padStart(2, '0')}</span>
              <div><strong>{fixture.home_team}</strong><strong>{fixture.away_team}</strong></div>
              <div className={`score-capsule ${result.revealed ? 'revealed' : ''}`}>
                {result.revealed ? <><b>{result.home_score}</b><i>:</i><b>{result.away_score}</b></> : <><LockKeyhole size={15} /><span>SEALED</span></>}
              </div>
            </motion.article>
          )
        })}
      </div>
      {reveal.status === 'settled' && <>
        <div className="settlement-summary" aria-label="Settlement summary">
          <span><small>Total stake</small><strong>{creditsFromMinor(totalStake)} CR</strong></span>
          <span><small>Payout</small><strong>{creditsFromMinor(totalPayout)} CR</strong></span>
          <span className={netProfit >= 0 ? 'positive' : 'negative'}><small>Net profit / loss</small><strong>{netProfit >= 0 ? '+' : ''}{creditsFromMinor(netProfit)} CR</strong></span>
          <span><small>Wallet balance</small><strong>{creditsFromMinor(reveal.wallet.balance_minor)} CR</strong></span>
        </div>
        <Link className="primary-cta reveal-done" to="/history">View settled wagers <ChevronRight /></Link>
      </>}
    </motion.section>
  )
}

export function RoundPage() {
  const { id = '' } = useParams()
  const [slip, dispatch] = useReducer(slipReducer, {})
  const [mobileSlipOpen, setMobileSlipOpen] = useState(false)
  const sessionQuery = useQuery({ queryKey: ['session', id], queryFn: () => api.timeTravelSession(id) })
  const session = sessionQuery.data?.session
  const confirmedFixtureIds = new Set(session?.wagers.map((wager) => wager.fixture_id) ?? [])

  const place = useMutation({
    mutationFn: async () => {
      const selections = Object.entries(slip).map(([fixture_id, item]) => ({
        fixture_id,
        selection: item.selection,
        stake_minor: minorFromCredits(item.stake) ?? 0,
      }))
      return api.placeWagers(id, selections, crypto.randomUUID())
    },
    onSuccess: async () => {
      dispatch({ type: 'clear' })
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ['session', id] }),
        queryClient.invalidateQueries({ queryKey: ['me'] }),
        queryClient.invalidateQueries({ queryKey: ['bootstrap'] }),
      ])
    },
  })
  const startReveal = useMutation({
    mutationFn: () => api.startReveal(id),
    onSuccess: (data) => {
      queryClient.setQueryData(['reveal', id], data)
      queryClient.invalidateQueries({ queryKey: ['session', id] })
    },
  })
  const revealQuery = useQuery({
    queryKey: ['reveal', id],
    queryFn: () => api.reveal(id),
    enabled: session?.status === 'revealing',
    refetchInterval: (query) => query.state.data?.reveal.status === 'settled' ? false : 1_000,
  })
  const reveal = revealQuery.data?.reveal ?? startReveal.data?.reveal

  useEffect(() => {
    if (reveal?.status !== 'settled') return

    queryClient.setQueryData<{ user: unknown; wallet: RevealSnapshot['wallet'] }>(['me'], (current) => (
      current ? { ...current, wallet: reveal.wallet } : current
    ))
    void queryClient.invalidateQueries({ queryKey: ['session', id] })
    void queryClient.invalidateQueries({ queryKey: ['sessions'] })
  }, [id, reveal?.status, reveal?.wallet])

  if (sessionQuery.isLoading) return <div className="app-loader"><span className="loader-orbit" />Retrieving sealed round…</div>
  if (!session) return <div className="fatal-panel">This timeline could not be found.</div>

  const slipEntries = Object.entries(slip)
  const totalStake = slipEntries.reduce((sum, [, item]) => sum + (minorFromCredits(item.stake) ?? 0), 0)
  const isOpen = session.status === 'betting'
  const settledStake = session.wagers.reduce((sum, wager) => sum + wager.stake_minor, 0)
  const settledPayout = session.wagers.reduce((sum, wager) => sum + (wager.payout_minor ?? 0), 0)
  const settledProfit = settledPayout - settledStake

  return (
    <div className="sportsbook-page">
      <header className="round-header">
        <Link to="/" className="back-link"><ArrowLeft size={17} /> New timeline</Link>
        <div className="round-title"><div className="league-crest">PL</div><span><small>Historical round · destination {session.travel_on}</small><strong>Premier League</strong></span></div>
        <div className={`market-status ${isOpen ? 'open' : ''}`}><span />{isOpen ? 'BETTING OPEN' : session.status.toUpperCase()}</div>
      </header>

      <div className="sportsbook-grid">
        <aside className="league-sidebar">
          <span className="eyebrow">Competition</span>
          <button className="league-active"><span className="mini-crest">PL</span><span>Premier League<small>10 fixtures</small></span></button>
          <div className="security-note"><ShieldCheck /><strong>Outcome firewall</strong><p>Final scores remain outside this API response until time moves forward.</p></div>
        </aside>

        <section className="fixtures-panel">
          <div className="panel-heading"><div><span className="eyebrow"><Radio size={14} /> Historical market</span><h1>Next available round</h1></div><div className="odds-legend"><span>1 Home</span><span>X Draw</span><span>2 Away</span></div></div>
          <div className="fixture-list">
            {session.fixtures.map((fixture) => {
              const item = slip[fixture.id]
              const confirmed = confirmedFixtureIds.has(fixture.id)
              const final = fixture.final_score
              return (
                <article className={`fixture-row ${confirmed ? 'confirmed' : ''}`} key={fixture.id}>
                  <time><strong>{new Date(fixture.kickoff_at).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', timeZone: 'Europe/London' })}</strong><span>{new Date(fixture.kickoff_at).toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit', timeZone: 'Europe/London', timeZoneName: 'short' })}</span></time>
                  <div className="teams"><span><i>{fixture.home_team.slice(0, 2).toUpperCase()}</i><strong>{fixture.home_team}</strong></span><span><i>{fixture.away_team.slice(0, 2).toUpperCase()}</i><strong>{fixture.away_team}</strong></span></div>
                  {final ? <div className="final-score"><b>{final.home}</b><span>FT</span><b>{final.away}</b></div> : (
                    <div className="odds-group">
                      {(['home', 'draw', 'away'] as Selection[]).map((selection) => <OddsButton key={selection} fixture={fixture} selection={selection} active={item?.selection === selection} disabled={!isOpen || confirmed} onSelect={() => { dispatch({ type: 'select', fixtureId: fixture.id, selection }); setMobileSlipOpen(true) }} />)}
                    </div>
                  )}
                  {confirmed && <span className="confirmed-mark"><Check size={14} /> Locked</span>}
                </article>
              )
            })}
          </div>
        </section>

        <button className="mobile-slip-trigger" onClick={() => setMobileSlipOpen(true)}><Sparkles size={16} /><span>Bet slip</span><b>{slipEntries.length}</b></button>
        <aside className={`betslip-panel ${mobileSlipOpen ? 'mobile-open' : ''}`}>
          <div className="betslip-heading"><span><Sparkles size={16} /> Bet slip</span><b>{slipEntries.length}</b><button className="mobile-slip-close" onClick={() => setMobileSlipOpen(false)} aria-label="Close bet slip"><X size={17} /></button></div>
          {slipEntries.length === 0 ? (
            <div className="empty-slip"><TimerReset /><strong>{session.wagers.length ? `${session.wagers.length} wager${session.wagers.length === 1 ? '' : 's'} locked` : 'Your timeline is empty'}</strong><p>{session.wagers.length ? 'When ready, move time forward to reveal the round.' : 'Choose one 1X2 price from any fixture.'}</p></div>
          ) : slipEntries.map(([fixtureId, item]) => {
            const fixture = session.fixtures.find((candidate) => candidate.id === fixtureId)!
            const potential = (minorFromCredits(item.stake) ?? 0) * Number(fixture.odds[item.selection])
            return (
              <article className="slip-item" key={fixtureId}>
                <button onClick={() => dispatch({ type: 'remove', fixtureId })} aria-label={`Remove ${fixture.home_team} versus ${fixture.away_team}`}><X size={14} /></button>
                <small>{fixture.home_team} · {fixture.away_team}</small>
                <strong>{item.selection === 'home' ? fixture.home_team : item.selection === 'away' ? fixture.away_team : 'Draw'} <em>@ {fixture.odds[item.selection]}</em></strong>
                <label><span>Stake</span><div><input inputMode="decimal" value={item.stake} onChange={(event) => dispatch({ type: 'stake', fixtureId, stake: event.target.value })} /><i>CR</i></div></label>
                <footer><span>Potential return</span><strong>{creditsFromMinor(Math.round(potential))} CR</strong></footer>
              </article>
            )
          })}
          {slipEntries.length > 0 && <><div className="slip-total"><span>Total stake</span><strong>{creditsFromMinor(totalStake)} CR</strong></div><button className="place-button" disabled={place.isPending || totalStake < 100} onClick={() => place.mutate()}>{place.isPending ? 'Locking wagers…' : `Place ${slipEntries.length} single${slipEntries.length === 1 ? '' : 's'}`} <LockKeyhole size={17} /></button></>}
          {(place.error || startReveal.error) && <div className="form-error" role="alert">{(place.error ?? startReveal.error) instanceof ApiError ? (place.error ?? startReveal.error as ApiError)?.message : 'The timeline rejected this action.'}</div>}
          {session.wagers.length > 0 && isOpen && slipEntries.length === 0 && <button className="time-forward-button" disabled={startReveal.isPending} onClick={() => startReveal.mutate()}><Clock3 /> <span><small>Wagers locked</small>Move time forward</span><ChevronRight /></button>}
          <p className="slip-disclaimer">Virtual play credits only · Stakes cannot be cancelled after confirmation</p>
        </aside>
      </div>

      <AnimatePresence>{reveal && reveal.status !== 'betting' && <RevealOverlay session={session} reveal={reveal} />}</AnimatePresence>
      {session.status === 'settled' && !reveal && <section className="settled-panel">
        <div className="settled-banner"><Trophy /><span><strong>Timeline settled</strong>All final scores and returns are now visible.</span><Link to="/history">Review history</Link></div>
        <div className="settlement-summary" aria-label="Settlement summary">
          <span><small>Total stake</small><strong>{creditsFromMinor(settledStake)} CR</strong></span>
          <span><small>Payout</small><strong>{creditsFromMinor(settledPayout)} CR</strong></span>
          <span className={settledProfit >= 0 ? 'positive' : 'negative'}><small>Net profit / loss</small><strong>{settledProfit >= 0 ? '+' : ''}{creditsFromMinor(settledProfit)} CR</strong></span>
          <span><small>Wallet balance</small><strong>{creditsFromMinor(sessionQuery.data?.wallet.balance_minor ?? 0)} CR</strong></span>
        </div>
      </section>}
    </div>
  )
}
