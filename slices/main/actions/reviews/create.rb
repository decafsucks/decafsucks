# frozen_string_literal: true

module Main
  module Actions
    module Reviews
      class Create < Authenticated
        include Deps[create_review: "reviews.operations.create"]

        def handle(request, response)
          result = create_review.call(request.params.to_h, author_id: actor(request).user.id)

          case result
          in Success(review)
            response.flash[:notice] = "Review created!"
            response.redirect(routes.path(:cafe, id: review.cafe_id))
          in Failure[:validation, validation]
            response.render(view, errors: validation.errors.to_h)
          in Failure[:geocoding, :not_found]
            response.render(view, errors: {cafe_address: ["could not be located — please check the address"]})
          in Failure
            response.render(view, errors: {base: ["Something went wrong creating your review. Please try again."]})
          end
        end
      end
    end
  end
end
