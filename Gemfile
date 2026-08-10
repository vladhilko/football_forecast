# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '4.0.6'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.1.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5.7'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 8.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5.4'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'dotenv-rails'

gem 'activeadmin', '~> 3.5'
gem 'devise', '~> 5.0'

# Use Sass to process CSS
gem 'dartsass-rails', '~> 0.5'

gem 'data_migrate'
gem 'draper'
gem 'dry-auto_inject'
gem 'dry-container'
gem 'dry-struct'
gem 'dry-types'
gem 'dry-validation'
gem 'flipper'
gem 'flipper-active_record'
gem 'flipper-active_support_cache_store'
gem 'flipper-api'
gem 'flipper-ui'
gem 'hairtrigger'
gem 'ostruct'
gem 'sidekiq', '~> 8.1'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# local scraper API; use the ignored Bundler local override for local validation
gem 'oddsportal_scraper', github: 'vladhilko/oddsportal_scraper', branch: 'phase-4-upgrade-ruby-rails'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 8.0'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'selenium-webdriver', '~> 4.27.0'
  gem 'shoulda-matchers'
end

group :test do
  gem 'climate_control'
  gem 'mock_redis'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'lefthook'
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
