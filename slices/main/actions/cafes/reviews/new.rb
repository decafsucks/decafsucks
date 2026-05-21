# frozen_string_literal: true

module Main
  module Actions
    module Cafes
      module Reviews
        class New < Authenticated
          def handle(request, response)
            request.params => {cafe_id:}
            response.render(view, cafe_id:)
          end
        end
      end
    end
  end
end
