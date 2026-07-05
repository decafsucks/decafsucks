# frozen_string_literal: true

source "https://gem.coop"

# Hanami
gem "hanami", github: "hanami/hanami", branch: "main"
gem "hanami-cli", github: "hanami/hanami-cli", branch: "main"
gem "hanami-utils", github: "hanami/hanami-utils", branch: "main"
gem "hanami-assets", github: "hanami/hanami-assets", branch: "main"
gem "hanami-action", github: "hanami/hanami-action", branch: "main"
gem "hanami-db", github: "hanami/hanami-db", branch: "main"
gem "hanami-router", github: "hanami/hanami-router", branch: "main"
gem "hanami-view", github: "hanami/hanami-view", branch: "main"

# Database
gem "pg"

# Framework support
gem "i18n"
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
  gem "hanami-reloader", github: "hanami/hanami-reloader", branch: "main"

  # Hanami testing helpers
  gem "hanami-rspec", github: "hanami/hanami-rspec", branch: "main"
end

group :development do
  # Friendly developer errors
  gem "hanami-webconsole", github: "hanami/hanami-webconsole", branch: "main"

  gem "standard"
end

group :development, :test do
  # .env file support
  gem "dotenv"

  # SQL syntax highlighting in logs
  gem "rouge"
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
