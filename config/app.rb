# frozen_string_literal: true

require "hanami"

module Decafsucks
  class App < Hanami::App
    config.actions.sessions = :cookie, {secret: settings.session_secret}

    config.inflections do |i|
      i.acronym "IQ"
      i.plural "cafe", "cafes"
    end
  end
end
