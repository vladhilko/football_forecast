# Football Forecast

Football Forecast is a Rails application for collecting football league,
season, match, and betting-odds data from the external
[oddsportal_scraper gem](https://github.com/vladhilko/oddsportal_scraper).

## Versions

| Component | Version |
| --- | --- |
| Ruby | 4.0.6 |
| Rails | 8.1.3.1 |
| MySQL Docker image | 26.7.0 |
| Redis Docker image | 8.8.1 |

## Setup

Install Ruby 4.0.6 and activate it with RVM:

```bash
rvm install 4.0.6
rvm use 4.0.6
```

Install the Ruby and JavaScript dependencies:

```bash
bin/bundle install
yarn install
```

The application resolves `oddsportal_scraper` from the Git branch
`phase-4-upgrade-ruby-rails`. For local development with a sibling checkout,
set an ignored Bundler override using that checkout's current path:

```bash
bin/bundle config set --local local.oddsportal_scraper /path/to/oddsportal_scraper
bin/bundle install
```

Remove the override after moving the checkout:

```bash
bin/bundle config unset local.oddsportal_scraper
```

If Bundler needs to compile `mysql2` from source on Apple Silicon with Ruby
4.0, configure the C standard and Homebrew's zstd library before installing:

```bash
bin/bundle config set --local build.mysql2 \
  "--with-cflags=-std=gnu17 --with-ldflags=-L/opt/homebrew/opt/zstd/lib"
bin/bundle install
```

Start the development services. The new MySQL volume is intentionally named
`mysql26`; existing MySQL 8 volumes are left untouched because major-version
upgrades should use a backup/dump-and-restore workflow.

```bash
docker compose up -d mysql26 redis8
docker compose ps
bin/rails db:prepare
```

The application uses MySQL on port `3307` and Redis on port `6380`.
Set `REDIS_URL=redis://127.0.0.1:6380/0` when running a production-like
environment.

Start the Rails server and background worker in separate terminals:

```bash
bin/rails server
bin/bundle exec sidekiq
```

Visit the admin interface at <http://localhost:3000/admin>. Create the first
admin user with:

```bash
bin/rails db:seed
```

## Time-travel sportsbook

Phase 5 adds a separate React and TypeScript player application in `frontend/`.
It uses virtual PLAY credits only: there are no deposits, withdrawals, or cash
redemption. Rails provides the versioned JSON API and continues to serve the
existing admin application.

For a fresh development database without imported matches, create an
idempotent ten-match Premier League demonstration round:

```bash
bin/rails sportsbook:seed_demo
```

Run Rails on port 3000 and Vite on port 5173 together:

```bash
bin/dev-sportsbook
```

Run Sidekiq in another terminal so reveal settlement continues even when the
browser closes:

```bash
bin/bundle exec sidekiq
```

Open <http://127.0.0.1:5173>. Vite proxies `/api` to Rails so the encrypted
player session cookie remains same-origin. Architecture decisions are recorded
in `docs/architecture/decisions/`.

Install Git hooks and run the pre-commit checks with:

```bash
bin/bundle exec lefthook install
bin/bundle exec lefthook run pre-commit
```

## Tests and checks

```bash
bin/bundle exec rspec
bin/bundle exec rubocop
bin/rails zeitwerk:check
bin/rails assets:precompile
npm --prefix frontend run lint
npm --prefix frontend run typecheck
npm --prefix frontend test
npm --prefix frontend run build
```

## Rake tasks

```bash
bin/rails countries:fetch
bin/rails leagues:fetch_all
bin/rails seasons:fetch_all
bin/rails 'seasons:fetch_all_matches[England,Premier League,2021/2022]'
```

Quote the complete task name so the shell passes the country, league, and
season as one Rake argument. The scraper returns an empty list for seasons
that OddsPortal explicitly reports as having no available odds. It also
retries a fresh season page when the current-season archive token transiently
returns that empty response.

The scraper uses HTTP and Nokogiri by default. If a live response requires
JavaScript rendering for a match import, enable the optional Selenium fallback
explicitly:

```bash
ODDSPORTAL_SCRAPER_BROWSER_FALLBACK=1 bin/rails \
  'seasons:fetch_all_matches[England,Premier League,2021/2022]'
```

Successful empty catalog responses are reported by the tasks. Transport and
protocol failures raise `OddsportalScraper::TransportError` or
`OddsportalScraper::ProtocolError` so imports do not silently create incomplete
data. Matches without all three required odds are skipped at persistence time;
cancelled matches keep the existing cancellation behavior. Leave the fallback
variable unset for normal imports; otherwise Selenium will try to start a
separate headless Chrome process.

## API

The countries endpoint is available at:

```text
GET    /api/countries
POST   /api/countries
PUT    /api/countries
DELETE /api/countries
```

## Restoring a database dump

Copy a dump into the new MySQL container and restore it into the development
database:

```bash
docker compose exec -T mysql26 \
  mysql -u root football_forecast_development < /path/to/dump_file.sql
```
