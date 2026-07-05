# frozen_string_literal: true

module Main
  module Views
    module Cafes
      class Show < Main::View
        include Deps[
          "repos.cafe_repo",
          "repos.review_repo",
          "repos.like_repo"
        ]

        expose :cafe do |id:|
          cafe_repo.get(id)
        end

        expose :reviews do |id:|
          review_repo.for_cafe(id)
        end

        expose :likes_count do |id:|
          like_repo.count_for_cafe(id)
        end

        expose :liked do |id:, context:|
          next false unless context.signed_in?

          like_repo.liked?(user_id: context.current_user.id, cafe_id: id)
        end
      end
    end
  end
end
