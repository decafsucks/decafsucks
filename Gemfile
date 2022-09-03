# frozen_string_literal: true

source "https://rubygems.org"

# App framework
gem "hanami", "~> 2.0.0.beta"
gem "hanami-router", "~> 2.0.0.beta"
gem "hanami-controller", "~> 2.0.0.beta"
gem "hanami-cli", github: "hanami/cli", branch: "use-database_url-from-env"

# Framework support
gem "dry-types"
gem "puma"
gem "rake"

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
end

group :test do
  # Database
  gem "database_cleaner-sequel"
  gem "rom-factory"

  # Web integration testing
  gem "rack-test"
end
