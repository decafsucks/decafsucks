# frozen_string_literal: true

source "https://gem.coop"

# Hanami
gem "hanami", github: "hanami/hanami", branch: "main"
gem "hanami-cli", github: "hanami/cli", branch: "main"
gem "hanami-utils", github: "hanami/utils", branch: "main"
gem "hanami-assets", github: "hanami/assets", branch: "main"
gem "hanami-controller", github: "hanami/controller", branch: "main"
gem "hanami-db", github: "hanami/db", branch: "main"
gem "hanami-router", github: "hanami/router", branch: "main"
gem "hanami-view", github: "hanami/view", branch: "main"

# Database
gem "pg"

# Framework support
gem "puma"
gem "rake"

# Core tools
gem "dry-operation"
gem "dry-struct"
gem "dry-types"
gem "dry-validation"

# Text algorithms (for cafe name matching)
gem "text"

# Authentication
gem "rodauth"
gem "bcrypt"

# HTTP
gem "faraday"

# Mail
gem "mail"

group :cli, :development, :test do
  # Hanami web server reloading on file changes
  gem "hanami-reloader", github: "hanami/reloader", branch: "main"

  # Hanami testing helpers
  gem "hanami-rspec", github: "hanami/rspec", branch: "main"
end

group :development do
  # Friendly developer errors
  gem "hanami-webconsole", github: "hanami/webconsole", branch: "main"

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

  # Web testing
  gem "capybara"
  gem "launchy"
  gem "rack-test"

  # Integration testing
  gem "vcr"
end
