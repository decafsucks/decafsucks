# frozen_string_literal: true

ROM::SQL.migration do
  up do
    run "CREATE EXTENSION IF NOT EXISTS citext"
  end

  down do
    run "DROP EXTENSION IF EXISTS citext"
  end
end
