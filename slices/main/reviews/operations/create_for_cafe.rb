# frozen_string_literal: true

module Main
  module Reviews
    module Operations
      class CreateForCafe < Main::Operation
        include Deps[
          "reviews.contract",
          "repos.review_repo",
          "repos.like_repo"
        ]

        def call(input, user_id:, cafe_id:)
          attrs = step validate(input)

          review = review_repo.create(
            user_id:,
            cafe_id:,
            body: attrs[:body],
            visited_on: attrs[:visited_on],
            good_cup: attrs[:good_cup]
          )

          like_repo.like(user_id:, cafe_id:) if attrs[:like]

          review
        end

        private

        def validate(input)
          validation = contract.call(input)

          if validation.success?
            Success(validation.to_h)
          else
            Failure[:validation, validation]
          end
        end
      end
    end
  end
end
