# require_with_metadata: true
# frozen_string_literal: true

require_relative "db/cleaning"
require_relative "db/factories"

RSpec.configure do |config|
  # Configure per-slice factory helpers
  Dir[SPEC_ROOT.join("slices", "*")].each do |slice_dir|
    slice_name = File.basename(slice_dir).to_sym
    slice = Hanami.app.slices[slice_name.to_sym] # fixme, naive

    config.define_derived_metadata(db: true) do |metadata|
      if metadata[:absolute_file_path].match?(Regexp.escape(slice_dir))
        metadata[:factory] = slice_name
      end
    end

    config.include(Test::DB::FactoryHelper.new(slice), factory: slice_name)
  end

  # Mark feature specs as requiring db setup
  config.define_derived_metadata(type: :feature) do |metadata|
    metadata[:db] = true
  end
end
