# frozen_string_literal: true

require "hanami"

module Decafsucks
  class App < Hanami::App
    config.inflections do |i|
      i.plural "cafe", "cafes"
    end
  end
end
