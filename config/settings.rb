# frozen_string_literal: true

module Decafsucks
  class Settings < Hanami::Settings
    setting :location_iq_api_key, constructor: Types::Strict::String.constrained(filled: true)
  end
end
