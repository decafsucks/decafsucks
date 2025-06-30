# require_with_metadata: true
# frozen_string_literal: true

require "vcr"

# Finds any `:vcr`-tagged example and configures it with a `cassette_name` that puts the casette
# alongside the related spec file.
#
# For example, for `spec/slices/main/foo_spec.rb` containing `it "returns true", :vcr`, the cassette
# will be located at `spec/slices/main/foo_spec/returns_true.yml`.
RSpec.configure do |config|
  config.before(:each, {vcr: ->(v) { !!v }}) do |example|
    metadata = example.metadata
    vcr_options = metadata[:vcr].is_a?(Hash) ? metadata[:vcr] : {}

    # Do not override an explicitly configured cassette name.
    next if vcr_options.key?(:cassette_name)

    # Strip "./spec/" from the beginning of the example's file_path.
    #
    # This isn't needed since we assign "spec" to VCR's `cassette_library_dir` below.
    relative_file_path = metadata[:file_path].sub(%r{^.?/?spec/}, "")

    vcr_options[:cassette_name] = [
      File.dirname(relative_file_path),
      File.basename(relative_file_path, File.extname(relative_file_path)),
      example.metadata[:description].downcase
    ].join("/")

    example.metadata[:vcr] = vcr_options
  end
end

# Activates VCR when the `:vcr` example metadata is given.
#
# It's important that this comes _after_ the RSpec configuration above, so that our `cassette_name`
# logic can apply first.
VCR.configure do |config|
  config.cassette_library_dir = "spec"
  config.hook_into :faraday
  config.configure_rspec_metadata!
end
