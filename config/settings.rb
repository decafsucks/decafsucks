# frozen_string_literal: true

module Decafsucks
  class Settings < Hanami::Settings
    setting :location_iq_api_key, constructor: Types::Strict::String #.constrained(gt?: 1)
  end
end
