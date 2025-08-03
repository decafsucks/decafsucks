# frozen_string_literal: true

module Decafsucks
  class Routes < Hanami::Routes
    slice :main, at: "/" do
      use Main::AuthenticationApp

      root to: "home.show"
      get "/reviews/new", to: "reviews.new"
    end
  end
end
