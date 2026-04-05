# frozen_string_literal: true

module Main
  module Reviews
    module Operations
      class Create < Main::Operation
        include Deps[
          "reviews.contract",
          "repos.review_repo",
          resolve_cafe: "cafes.operations.resolve"
        ]

        def call(input, author_id:)
          attrs = step validate(input)
          cafe = step resolve_cafe.call(name: attrs[:cafe_name], address: attrs[:cafe_address])

          review_repo.create(
            author_id:,
            cafe_id: cafe.id,
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
