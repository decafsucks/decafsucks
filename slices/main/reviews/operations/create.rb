# frozen_string_literal: true

module Main
  module Reviews
    module Operations
      class Create < Main::Operation
        include Deps[
          "reviews.contract",
          "repos.review_repo",
          "repos.like_repo",
          resolve_cafe: "cafes.operations.resolve"
        ]

        def call(input, user_id:)
          attrs = step validate(input)
          cafe = step resolve_cafe.call(name: attrs[:cafe_name], address: attrs[:cafe_address])

          review = review_repo.create(
            user_id:,
            cafe_id: cafe.id,
            body: attrs[:body],
            visited_on: attrs[:visited_on],
            good_cup: attrs[:good_cup]
          )

          like_repo.like(user_id:, cafe_id: cafe.id) if attrs[:like]

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
