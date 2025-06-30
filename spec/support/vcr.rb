# require_with_metadata: true
# frozen_string_literal: true

require "vcr"

RSpec.configure do |config|
  config.before(:each, {vcr: ->(v) { !!v }}) do |example|
    metadata = example.metadata

    vcr_options = metadata[:vcr].is_a?(Hash) ? metadata[:vcr] : {}
    next if vcr_options.key?(:cassette_name)

    # Only work on files located inside the "spec/" directory
    relative_file_path_re = %r{^.?/?spec/}
    next unless metadata[:file_path].match?(relative_file_path_re)

    # Strip "./spec/" from beginning file_path (a file path looks like
    # "./spec/slices/geocoding/lookups/location_iq_spec.rb")
    relative_file_path = metadata[:file_path]
      .sub(relative_file_path_re, "")

    vcr_options[:cassette_name] = [
      File.dirname(relative_file_path),
      File.basename(relative_file_path, File.extname(relative_file_path)),
      example.metadata[:description].downcase # TODO make robust
    ].join("/")

    example.metadata[:vcr] = vcr_options
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec"
  config.hook_into :faraday
  config.configure_rspec_metadata!
end
