# require_with_metadata: true
# frozen_string_literal: true

require "dry/system/stubs"

RSpec.configure do |config|
  config.when_first_matching_example_defined(:container_stubs) do
    ([Hanami.app] + Hanami.app.slices.with_nested).each do |slice|
      slice.container.enable_stubs!
    end
  end

  config.after(:each, :container_stubs) do
    ([Hanami.app] + Hanami.app.slices.with_nested).each do |slice|
      slice.container.unstub
    end
  end
end
