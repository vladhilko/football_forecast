import { motion, useReducedMotion } from 'motion/react'
import { CalendarDays, ChevronRight, RotateCcw } from 'lucide-react'

interface Props {
  date: string
  minimum?: string
  maximum?: string
  loading?: boolean
  onDateChange: (date: string) => void
  onTravel: () => void
}

export function TimePortal({ date, minimum, maximum, loading, onDateChange, onTravel }: Props) {
  const reducedMotion = useReducedMotion()

  return (
    <section className="portal-card">
      <div className="portal-copy">
        <span className="eyebrow"><RotateCcw size={15} /> Temporal sportsbook</span>
        <h1>Return back<br />in <em>time.</em></h1>
        <p>Choose a day from football history. We’ll open the next untouched Premier League round—with every result sealed.</p>
        <label className="date-control">
          <CalendarDays size={19} />
          <span>
            <small>Target date</small>
            <input type="date" value={date} min={minimum} max={maximum} onChange={(event) => onDateChange(event.target.value)} />
          </span>
        </label>
        <button className="primary-cta" onClick={onTravel} disabled={!date || loading}>
          {loading ? 'Opening the portal…' : 'Enter this timeline'} <ChevronRight size={20} />
        </button>
      </div>

      <motion.div
        className="portal-stage"
        initial={{ opacity: 0, scale: 0.86 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: reducedMotion ? 0 : 0.8 }}
        aria-hidden="true"
      >
        <div className="portal-glow" />
        <div className="portal-ring ring-one" />
        <div className="portal-ring ring-two" />
        <div className="portal-ring ring-three" />
        <div className="portal-core">
          <span>{date ? new Date(`${date}T12:00:00`).getFullYear() : '—'}</span>
          <small>DESTINATION</small>
        </div>
        <div className="portal-tick tick-a" />
        <div className="portal-tick tick-b" />
        <div className="portal-tick tick-c" />
      </motion.div>
    </section>
  )
}
