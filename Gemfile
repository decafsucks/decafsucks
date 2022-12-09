# frozen_string_literal: true

source "https://rubygems.org"

# App framework
gem "hanami", "~> 2.0"
gem "hanami-router", "~> 2.0"
gem "hanami-controller", "~> 2.0"
gem "hanami-view", github: "hanami/view", branch: "main"

# Framework support
gem "dry-types"
gem "puma"
gem "rake"
gem "slim"

# Database
gem "pg"
gem "rom"
gem "rom-sql"
gem "sequel"

group :cli, :development, :test do
  # Hanami testing helpers
  gem "hanami-rspec"
end

group :development, :test do
  # .env file support
  gem "dotenv"
  gem "standard"
end

group :test do
  # Database
  gem "database_cleaner-sequel"
  gem "rom-factory"

  # Web integration testing
  gem "capybara"
  gem "rack-test"
end
