# README

## Football Forecast


### Versions

```rb
ruby 3.1.2
rails 7.0.4
mysql 8.0.31
```

### 1. Install Ruby

```bash
$ rvm install 3.1.2
```

> If the command above doesn't work try the following:

```bash
$ rvm install 3.3.0 --with-openssl-dir=$(brew --prefix openssl)
```

### Bundle

```bash
$ bundle
```

> If you have a problem with mysql2 then you need to specify the path directly

```bash
$ gem install mysql2 -- --with-mysql-dir=/opt/homebrew/opt/mysql
```

### 1.1 Yarn install

```bash
yarn install
```

### 2. Start database and redis

```bash
docker-compose up mysql8 redis7
```
### 3. Start server

```bash
rails s
```

### Check lefthook

```bash
lefthook install
lefthook run pre-commit
```

### Run Sidekiq

```bash
bundle exec sidekiq
```

### OddsportalScraper

[OddsportalScraper README](gems/oddsportal_scraper/README.md)

### Rake Tasks

The following rake task fetch all countries with available football leagues and save them to the database.

```console
foo@bar:~$ rake countries:fetch
```

The following rake task fetch all football leagues from all countries and save them to the database.

```console
foo@bar:~$ rake leagues:fetch_all
```

The following rake task fetch all available football seasons and save them to the database.

```console
foo@bar:~$ rake seasons:fetch_all
```

The following rake task fetch all available football matches for the given season and save them to the database.

```console
foo@bar:~$ rake seasons:fetch_all_matches['England', 'Premier League', '2021/2022']
```

### Development

To create AdminUser:

```console
foo@bar:~$ rails db:seed
```

To visit CRM page:

`http://localhost:3000/admin`


### Docker


- How to restore a DB dump?

```
$ docker ps
$ docker cp /path/to/dump_file.sql container_id:dump_file.sql
$ docker exec -it container_id bash
$ mysql -u root -p football_forecast_development < dump_file.sql
```
