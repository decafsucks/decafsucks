# frozen_string_literal: true

require "dry/validation"

module Main
  module Reviews
    class Contract < Dry::Validation::Contract
      params do
        optional(:cafe_name).filled(:string)
        optional(:cafe_address).filled(:string)
        required(:body).filled(:string)
        optional(:visited_on).maybe(:date)
        optional(:good_cup).maybe(:bool)
        optional(:like).maybe(:bool)
      end
    end
  end
end
