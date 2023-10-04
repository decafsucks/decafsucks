# frozen_string_literal: true

source "https://rubygems.org"

# App framework
gem "hanami", github: "hanami/hanami", branch: "main"
gem "hanami-assets", github: "hanami/assets", branch: "main"
gem "hanami-router", github: "hanami/router", branch: "main"
gem "hanami-cli", github: "hanami/cli", branch: "main"
gem "hanami-controller", github: "hanami/controller", branch: "main"
gem "hanami-view", github: "hanami/view", branch: "main"
gem "hanami-webconsole", github: "hanami/webconsole", branch: "main"

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
  gem "hanami-rspec", github: "hanami/rspec", branch: "main"
end

group :development do
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
