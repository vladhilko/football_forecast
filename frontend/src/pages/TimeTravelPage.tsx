import { useMutation, useQuery } from '@tanstack/react-query'
import { Activity, BadgeCheck, LockKeyhole, Trophy } from 'lucide-react'
import { useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { TimePortal } from '../components/TimePortal'
import { ApiError, api } from '../lib/api'

export function TimeTravelPage() {
  const navigate = useNavigate()
  const bootstrap = useQuery({ queryKey: ['bootstrap'], queryFn: api.bootstrap })
  const fallbackDate = useMemo(() => {
    const preferredDate = '2021-12-01'
    const availableDates = bootstrap.data?.available_dates

    if (!availableDates) return preferredDate
    if (preferredDate < availableDates.from) return availableDates.from
    if (preferredDate > availableDates.to) return availableDates.to

    return preferredDate
  }, [bootstrap.data])
  const [chosenDate, setChosenDate] = useState<string | null>(null)
  const date = chosenDate ?? fallbackDate
  const travel = useMutation({
    mutationFn: () => api.createTimeTravelSession(date),
    onSuccess: ({ session }) => navigate(`/rounds/${session.id}`),
  })

  return (
    <div className="page-wrap">
      <div className="league-strip">
        <div className="league-crest">PL</div>
        <div><small>Default competition</small><strong>England · Premier League</strong></div>
        <span className="data-seal"><LockKeyhole size={15} /> Historical outcomes sealed</span>
      </div>

      <TimePortal
        date={date}
        minimum={bootstrap.data?.available_dates.from}
        maximum={bootstrap.data?.available_dates.to}
        loading={travel.isPending}
        onDateChange={setChosenDate}
        onTravel={() => travel.mutate()}
      />
      {travel.error && <div className="inline-error" role="alert">{travel.error instanceof ApiError ? travel.error.message : 'The portal could not open.'}</div>}

      <section className="trust-grid">
        <article><Activity /><span><strong>Original 1X2 odds</strong><small>Every price is frozen when your round opens.</small></span></article>
        <article><BadgeCheck /><span><strong>Server-sealed results</strong><small>No outcome reaches the browser before reveal.</small></span></article>
        <article><Trophy /><span><strong>Exact settlement</strong><small>Stake, return, and profit stay auditable in your ledger.</small></span></article>
      </section>
    </div>
  )
}
