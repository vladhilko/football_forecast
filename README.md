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
rvm install 3.1.2
```

### 1.1 Yarn install

```bash
yarn install
```

### 2. Start database

```bash
docker-compose up mysql8
```
### 3. Start server

```bash
rails s
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
