# frozen_string_literal: true

source "https://rubygems.org"

# App framework
gem "hanami", "~> 2.2.0"
gem "hanami-assets", "~> 2.2.0"
gem "hanami-cli", "~> 2.2.0"
gem "hanami-controller", "~> 2.2.0"
gem "hanami-db", "~> 2.2.0"
gem "hanami-router", "~> 2.2.0"
gem "hanami-view", "~> 2.2.0"

# Framework support
gem "dry-types"
gem "puma"
gem "rake"

# Database
gem "pg"

group :cli, :development, :test do
  # Hanami web server reloading on file changes
  gem "hanami-reloader", "~> 2.2.0"

  # Hanami testing helpers
  gem "hanami-rspec", "~> 2.2.0"
end

group :development do
  # Friendly developer errors
  gem "hanami-webconsole", "~> 2.2.0"

  gem "standard"
end

group :development, :test do
  # .env file support
  gem "dotenv"
end

group :test do
  # Database
  gem "database_cleaner-sequel"
  gem "rom-factory"

  # Web integration testing
  gem "capybara"
  gem "launchy"
  gem "rack-test"
end
