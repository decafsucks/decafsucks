# frozen_string_literal: true

require "hanami"
require "ext/hanami/providers/rack"

module Decafsucks
  class App < Hanami::App
    config.inflections do |i|
      i.plural "cafe", "cafes"
    end

    config.views.paths = ["templates"]
  end
end
