# frozen_string_literal: true

module Decafsucks
  class Routes < Hanami::Routes
    slice :main, at: "/" do
      root to: "home.show"
    end
  end
end
