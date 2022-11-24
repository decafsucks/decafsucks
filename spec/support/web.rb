# frozen_string_literal: true

require "capybara/rspec"
require_relative "web/helpers"

Capybara.app = Hanami.app
Capybara.server = :puma, {Silent: true}

RSpec.configure do |config|
  config.include Capybara::DSL, Capybara::RSpecMatchers, :web
  config.include Test::Web::Helpers, :web
end
