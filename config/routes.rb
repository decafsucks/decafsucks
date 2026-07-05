# frozen_string_literal: true

module Decafsucks
  class Routes < Hanami::Routes
    slice :main, at: "/" do
      use Main::AuthenticationApp

      root to: "home.show"

      resources :cafes, only: %i[show] do
        resources :reviews, only: %i[new create]
        resource :like, only: %i[create destroy]
      end
      resources :reviews, only: %i[index new create]
      resource :account, only: %i[show]
    end
  end
end
