# auto_register: false
# frozen_string_literal: true

require "hanami/action"

module Decafsucks
  class Action < Hanami::Action
    include Dry::Monads[:result]
  end
end
