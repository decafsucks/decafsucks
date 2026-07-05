# frozen_string_literal: true

module Main
  module Views
    module Reviews
      class Index < Main::View
        include Deps["repos.review_repo"]

        expose :reviews do |paginated|
          paginated.to_a
        end

        expose :pager do |paginated|
          paginated.pager
        end

        private_expose :paginated do |page:|
          review_repo.recent(page:)
        end
      end
    end
  end
end
