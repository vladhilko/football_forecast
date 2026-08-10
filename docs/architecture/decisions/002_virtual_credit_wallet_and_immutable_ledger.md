# 002 — Virtual-credit wallet and immutable ledger

- Status: Accepted
- Date: 2026-08-10

## Context

Phase 5 needs sportsbook-quality accounting without real-money funding, redemption, or jurisdiction-specific compliance. The existing `Bet` records are analytical simulations and have no player or wallet ownership.

## Decision

Use a separate `Wager` domain. Store PLAY credits as integer minor units, snapshot decimal odds on confirmation, debit stakes atomically, and credit payouts only during settlement. Keep a cached wallet balance protected by database locks and an append-only `wallet_entries` ledger containing the balance after every entry.

One player may confirm at most one wager for a source fixture. Requests and settlement use unique idempotency keys. Winning return is `stake_minor × decimal_odds`, rounded half-up once to an integer minor unit.

## Alternatives

- Extending the legacy `bets` table would mix player money movement with season-profit experiments.
- Decimal balance columns are readable but make application rounding boundaries less explicit.
- Recomputing balance only from ledger entries provides purity at a higher read cost.

## Consequences

Wallet changes are auditable and concurrency-safe. The cached balance must only change in the same transaction as its ledger entries. Real-money funding, KYC, withdrawal, chargeback, tax, and currency conversion remain intentionally out of scope.
