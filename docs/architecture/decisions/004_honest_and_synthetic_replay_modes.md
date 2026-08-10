# 004 — Honest and synthetic replay modes

- Status: Accepted
- Date: 2026-08-10

## Context

The source contains final scores but not historical goal minutes. Presenting invented goal timing as fact would undermine trust, while a purely instant result would miss the product’s time-travel experience.

## Decision

Default to an honest 45-second staged reveal: advance a theatrical match clock and unlock verified final scores sequentially near full time without claiming goal events. Offer an opt-in synthetic mode that deterministically distributes the correct number of goals across the compressed clock and permanently labels those events as simulated.

Both modes use the same server settlement deadline and final scores. Reduced-motion presentation changes movement, not timing or financial behavior.

## Alternatives

- Importing genuine event timelines is deferred until a reliable licensed data source is selected.
- Always generating goal minutes would be more dramatic but less trustworthy.
- Instant settlement would remove the core reveal loop.

## Consequences

The product remains honest about available data while supporting a more theatrical preference. Synthetic events must never be reused as historical analytics.
