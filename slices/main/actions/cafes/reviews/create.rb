# frozen_string_literal: true

module Main
  module Actions
    module Cafes
      module Reviews
        class Create < Authenticated
          include Deps[create_review: "reviews.operations.create_for_cafe"]

          def handle(request, response)
            request.params => {cafe_id:}
            result = create_review.call(
              request.params.to_h,
              user_id: actor(request).user.id,
              cafe_id:
            )

            case result
            in Success(review)
              response.flash[:notice] = "Review posted!"
              response.redirect(routes.path(:cafe, id: review.cafe_id))
            in Failure[:validation, validation]
              response.render(view, cafe_id:, errors: validation.errors.to_h)
            end
          end
        end
      end
    end
  end
end
