import { z } from 'zod'

export type RevealMode = 'honest' | 'synthetic'
export type SessionStatus = 'betting' | 'revealing' | 'settled'
export type Selection = 'home' | 'draw' | 'away'

export interface Player {
  id: string
  display_name: string
  email: string
  status: string
  preferred_reveal_mode: RevealMode
}

export interface Wallet {
  currency: 'PLAY'
  balance_minor: number
  balance: string
}

export interface Fixture {
  id: string
  position: number
  home_team: string
  away_team: string
  kickoff_at: string
  kickoff_timezone: string
  odds: Record<Selection, string>
  final_score?: { home: number; away: number; result: Selection }
}

export interface Wager {
  id: string
  fixture_id: string
  selection: Selection
  stake_minor: number
  stake: string
  decimal_odds: string
  potential_payout_minor: number
  potential_payout: string
  placed_at: string
  status: 'pending' | 'won' | 'lost' | 'refunded'
  payout_minor?: number
  payout?: string
  profit_minor?: number
  profit?: string
}

export interface TimeTravelSession {
  id: string
  status: SessionStatus
  travel_on: string
  reveal_mode: RevealMode
  reveal_started_at: string | null
  league: { id: number; name: string; country: string }
  fixtures: Fixture[]
  wagers: Wager[]
}

export interface RevealFixture {
  id: string
  position: number
  revealed: boolean
  home_score?: number
  away_score?: number
  result?: Selection
  events?: Array<{ minute: number; side: 'home' | 'away' }>
}

export interface RevealSnapshot {
  status: SessionStatus
  phase: 'betting' | 'portal' | 'accelerating' | 'final_whistle' | 'settled'
  elapsed_seconds: number
  duration_seconds: number
  match_minute: number
  reveal_mode: RevealMode
  fixtures: RevealFixture[]
  wagers: Wager[]
  wallet: Wallet
}

export interface Bootstrap {
  user: Player
  wallet: Wallet
  default_league: { id: number; name: string; country: string }
  available_dates: { from: string; to: string }
}

const errorSchema = z.object({
  error: z.object({
    code: z.string(),
    message: z.string(),
    fields: z.record(z.string(), z.unknown()).optional(),
  }),
})

export class ApiError extends Error {
  constructor(
    public status: number,
    public code: string,
    message: string,
    public fields?: Record<string, unknown>,
  ) {
    super(message)
  }
}

let csrfToken: string | null = null

async function loadCsrfToken(): Promise<string> {
  if (csrfToken) return csrfToken
  const response = await fetch('/api/v1/auth/csrf', { credentials: 'same-origin' })
  if (!response.ok) throw new ApiError(response.status, 'csrf_unavailable', 'Could not establish a secure session')
  const body = (await response.json()) as { csrf_token: string }
  csrfToken = body.csrf_token
  return csrfToken
}

async function request<T>(path: string, init: RequestInit = {}): Promise<T> {
  const method = (init.method ?? 'GET').toUpperCase()
  const headers = new Headers(init.headers)
  headers.set('Accept', 'application/json')
  if (init.body) headers.set('Content-Type', 'application/json')
  if (!['GET', 'HEAD'].includes(method)) headers.set('X-CSRF-Token', await loadCsrfToken())

  const response = await fetch(path, { ...init, headers, credentials: 'same-origin' })
  if (response.status === 204) return undefined as T
  const body: unknown = await response.json().catch(() => null)
  if (!response.ok) {
    const parsed = errorSchema.safeParse(body)
    if (parsed.success) {
      throw new ApiError(response.status, parsed.data.error.code, parsed.data.error.message, parsed.data.error.fields)
    }
    throw new ApiError(response.status, 'request_failed', 'The server could not complete the request')
  }
  return body as T
}

export const api = {
  register: (input: { display_name: string; email: string; password: string; password_confirmation: string }) =>
    request<{ user: Player; wallet: Wallet }>('/api/v1/users', {
      method: 'POST',
      body: JSON.stringify({ user: input }),
    }),
  login: (email: string, password: string) =>
    request<{ user: Player; wallet: Wallet }>('/api/v1/session', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    }),
  logout: () => request<void>('/api/v1/session', { method: 'DELETE' }),
  me: () => request<{ user: Player; wallet: Wallet }>('/api/v1/me'),
  updateSettings: (preferred_reveal_mode: RevealMode) =>
    request<{ user: Player; wallet: Wallet }>('/api/v1/me', {
      method: 'PATCH',
      body: JSON.stringify({ user: { preferred_reveal_mode } }),
    }),
  bootstrap: () => request<Bootstrap>('/api/v1/sportsbook/bootstrap'),
  createTimeTravelSession: (travel_on: string) =>
    request<{ session: TimeTravelSession; wallet: Wallet }>('/api/v1/time_travel_sessions', {
      method: 'POST',
      body: JSON.stringify({ travel_on }),
    }),
  timeTravelSessions: () => request<{ sessions: TimeTravelSession[] }>('/api/v1/time_travel_sessions'),
  timeTravelSession: (id: string) =>
    request<{ session: TimeTravelSession; wallet: Wallet }>(`/api/v1/time_travel_sessions/${id}`),
  placeWagers: (
    sessionId: string,
    selections: Array<{ fixture_id: string; selection: Selection; stake_minor: number }>,
    idempotencyKey: string,
  ) =>
    request<{ wagers: Wager[]; wallet: Wallet }>(`/api/v1/time_travel_sessions/${sessionId}/wagers`, {
      method: 'POST',
      headers: { 'Idempotency-Key': idempotencyKey },
      body: JSON.stringify({ selections }),
    }),
  startReveal: (sessionId: string) =>
    request<{ reveal: RevealSnapshot }>(`/api/v1/time_travel_sessions/${sessionId}/reveal`, { method: 'POST' }),
  reveal: (sessionId: string) =>
    request<{ reveal: RevealSnapshot }>(`/api/v1/time_travel_sessions/${sessionId}/reveal`),
  wagers: () => request<{ wagers: Wager[] }>('/api/v1/wagers'),
}
