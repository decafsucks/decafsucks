# require_with_metadata: true
# frozen_string_literal: true

require_relative "db/helpers"
require_relative "db/database_cleaner"
require_relative "db/factory"

RSpec.configure do |config|
  config.before :suite do
    Hanami.app.start :persistence
  end

  config.include Test::DB::Helpers, :db

  # Configure per-slice factory helpers
  Dir[SPEC_ROOT.join("slices", "*")].each do |slice_dir|
    slice_name = File.basename(slice_dir).to_sym

    config.define_derived_metadata(db: true) do |metadata|
      if (metadata[:absolute_file_path]).match?(Regexp.escape(slice_dir))
        metadata[:factory] = slice_name
      end
    end

    config.include(Test::DB::FactoryHelper.new(slice_name), factory: slice_name)
  end
  config.include(Test::DB::FactoryHelper.new, factory: nil)
end
