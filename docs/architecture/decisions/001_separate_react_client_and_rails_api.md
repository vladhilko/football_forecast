# 001 — Separate React client and Rails API

- Status: Accepted
- Date: 2026-08-10

## Context

Football Forecast already serves an ActiveAdmin application and a small Rails API. The player sportsbook needs a modern, independently deployable interface without coupling its release cycle to Rails views.

## Decision

Keep `frontend/` as an autonomous Vite/React/TypeScript application with its own manifest, lockfile, tests, and build. Player operations use `/api/v1`; Rails continues to serve admin functionality. Development uses Vite on port 5173 with `/api` proxied to Rails on port 3000.

Authentication uses a Rails-managed HttpOnly session cookie and CSRF token. Keeping `/api` same-origin through a proxy provides a safer browser default than persistent bearer tokens.

## Alternatives

- Rails views/Hotwire would reduce infrastructure but bind the player UI to the backend deployment.
- A separate repository now would add coordination before the API contract is mature.
- Browser-stored bearer tokens would simplify cross-origin requests but enlarge the impact of an XSS vulnerability.

## Consequences

The two applications run and test separately. A future repository split can move `frontend/` unchanged as long as `/api/v1` remains compatible; deployment must continue presenting a same-origin API proxy or revisit the authentication decision.
