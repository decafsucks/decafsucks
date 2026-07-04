# frozen_string_literal: true

module Main
  module Actions
    module Cafes
      module Like
        class Create < Authenticated
          include Deps["repos.like_repo"]

          def handle(request, response)
            request.params => {cafe_id:}
            like_repo.like(user_id: actor(request).user.id, cafe_id:)
            response.redirect(routes.path(:cafe, id: cafe_id))
          end
        end
      end
    end
  end
end
