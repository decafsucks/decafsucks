# frozen_string_literal: true

require "dry/system"

RSpec.configure do |config|
  Dir[File.join(__dir__, "*.rb")].sort.each do |file|
    options = Dry::System::MagicCommentsParser.call(file)
    tag_name = options[:require_with_metadata]

    next unless tag_name

    tag_name = File.basename(file, File.extname(file)) if tag_name.eql?(true)

    config.when_first_matching_example_defined(tag_name.to_sym) do
      require file
    end
  end
end
