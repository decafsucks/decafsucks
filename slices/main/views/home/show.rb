# frozen_string_literal: true

module Main
  module Views
    module Home
      class Show < Main::View
        include Deps["repos.cafe_repo"]

        expose :cafes do
          cafe_repo.latest
        end
      end
    end
  end
end
