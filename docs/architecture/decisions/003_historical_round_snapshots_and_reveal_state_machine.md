# 003 — Historical round snapshots and reveal state machine

- Status: Accepted
- Date: 2026-08-10

## Context

Imported matches have dates, final scores, and 1X2 odds but no official gameweek identifier. A player experience must not change if source imports are corrected after a wager is confirmed, and results must not leak before betting closes.

## Decision

From a selected date, scan forward for the first block of ten completed Premier League matches within one season and 21 days whose teams are all unique. Snapshot teams, UK-local kickoff, odds, and sealed final scores into a player-owned `time_travel_session`.

Sessions move through `betting`, `revealing`, and `settled`. Starting reveal closes betting and records a server timestamp. Sidekiq settles after 45 seconds; reads perform the same idempotent settlement as recovery. API serializers omit every result field until its authorized reveal point.

## Alternatives

- Treating calendar weeks as rounds mishandles Monday fixtures and postponements.
- Importing official round metadata would improve historical fidelity but creates a new data-source dependency.
- Client-owned timers cannot guarantee settlement when a tab closes.

## Consequences

Snapshots provide a durable audit trail and stable UX. The round heuristic is deliberately documented and replaceable when official round metadata becomes available.
