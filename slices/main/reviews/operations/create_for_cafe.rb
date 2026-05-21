# frozen_string_literal: true

module Main
  module Reviews
    module Operations
      class CreateForCafe < Main::Operation
        include Deps[
          "reviews.contract",
          "repos.review_repo"
        ]

        def call(input, author_id:, cafe_id:)
          attrs = step validate(input)

          review_repo.create(
            author_id:,
            cafe_id:,
            rating: attrs[:rating],
            body: attrs[:body]
          )
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
