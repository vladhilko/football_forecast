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
```

## Rake tasks

```bash
bin/rails countries:fetch
bin/rails leagues:fetch_all
bin/rails seasons:fetch_all
bin/rails seasons:fetch_all_matches['England', 'Premier League', '2021/2022']
```

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
