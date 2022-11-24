# frozen_string_literal: true

require "pathname"
SPEC_ROOT = Pathname(__dir__).realpath.freeze

ENV["HANAMI_ENV"] ||= "test"
require "hanami/prepare"

require_relative "support/rspec"
require_relative "support/feature_loader"
Dir[SPEC_ROOT.join("support", "**", "global_config.rb")].each { require _1 }
