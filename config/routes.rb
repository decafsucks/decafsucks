# frozen_string_literal: true

module Decafsucks
  class Routes < Hanami::Routes
    slice :main, at: "/" do
      use Main::AuthenticationApp

      root to: "home.show"

      resources :cafes, only: %i[show]
      resources :reviews, only: %i[new]
      resource :account, only: %i[show]
    end
  end
end
