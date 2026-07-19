# frozen_string_literal: true

module Main
  module Views
    module Home
      class Show < Main::View
        include Deps["repos.review_repo"]

        expose :reviews do
          review_repo.recent.to_a
        end
      end
    end
  end
end
