# frozen_string_literal: true

module Main
  module Actions
    module Reviews
      class New < Authenticated
        def handle(request, response)
          response.render(view)
        end
      end
    end
  end
end
