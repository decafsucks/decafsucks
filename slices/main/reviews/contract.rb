# frozen_string_literal: true

require "dry/validation"

module Main
  module Reviews
    class Contract < Dry::Validation::Contract
      params do
        optional(:cafe_name).filled(:string)
        optional(:cafe_address).filled(:string)
        required(:rating).filled(:integer, gteq?: 1, lteq?: 10)
        required(:body).filled(:string)
      end
    end
  end
end
