# auto_register: false
# frozen_string_literal: true

require "dry/struct"

module Geocoding
  # A place result from a geocoding service.
  class Result < Dry::Struct
    attribute :display_name, Types::String
    attribute :lat, Types::String
    attribute :lng, Types::String
  end
end
