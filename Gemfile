# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.4'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5.6'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'dotenv-rails'

gem 'activeadmin', '~> 2.13.1'
gem 'devise', '~> 4.8.1'

# Use Sass to process CSS
gem 'sassc-rails'

gem 'draper'
gem 'dry-auto_inject'
gem 'dry-container'
gem 'dry-struct', '~> 1.4'
gem 'dry-types', '~> 1.5', '>= 1.5.1'
gem 'dry-validation', '~> 1.10.0'
gem 'flipper'
gem 'flipper-active_record'
gem 'flipper-active_support_cache_store'
gem 'flipper-api'
gem 'flipper-ui'
gem 'sidekiq'
gem 'data_migrate'
gem 'hairtrigger'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# local gems
gem 'kimurai', github: 'baka-san/kimuraframework', branch: 'master'
gem 'oddsportal_scraper', path: 'gems/oddsportal_scraper'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'shoulda-matchers', '~> 5.0'
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
