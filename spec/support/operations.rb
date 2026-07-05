# frozen_string_literal: true

require "dry/monads"

# Load Dry Monads' RSpec extension.
#
# This provides `be_success` and `be_failure` matchers for operation results, along with `Success`
# and `Failure` constructors for use within your examples.
Dry::Monads.load_extensions(:rspec)
