# frozen_string_literal: true

require "hanami"

module Decafsucks
  class App < Hanami::App
    config.inflections do |i|
      i.acronym "IQ"
      i.plural "cafe", "cafes"
    end
  end
end
