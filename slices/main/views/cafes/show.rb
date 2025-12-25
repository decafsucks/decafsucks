# frozen_string_literal: true

module Main
  module Views
    module Cafes
      class Show < Main::View
        include Deps["repos.cafe_repo"]

        expose :cafe do |id:|
          cafe_repo.get(id)
        end
      end
    end
  end
end
