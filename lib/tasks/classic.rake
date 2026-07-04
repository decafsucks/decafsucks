# frozen_string_literal: true

namespace :classic do
  desc "Import the legacy decafsucks_classic database into the app database"
  task :import do
    # Ensure the `classic` slice loads (excluded from normal boot in config/app.rb).
    ENV["HANAMI_SLICES"] ||= "main,geocoding,classic"

    # Quieten the SQL logging so the import summary isn't buried under thousands of INSERTs.
    ENV["HANAMI_LOG_LEVEL"] ||= "info"

    require "hanami/prepare"

    report = Classic::Slice["import"].call

    puts "Imported the classic database:"
    puts report
  end
end
