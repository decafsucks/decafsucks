# frozen_string_literal: true

module Main
  module Views
    module Cafes
      module Reviews
        class New < Main::View
          include Deps["repos.cafe_repo"]

          expose :cafe do |cafe_id:|
            cafe_repo.get(cafe_id)
          end

          expose :errors, default: {}
        end
      end
    end
  end
end
