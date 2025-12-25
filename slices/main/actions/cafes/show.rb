# frozen_string_literal: true

module Main
  module Actions
    module Cafes
      class Show < Main::Action
        def handle(request, response)
          request.params => {id:}
          response.render(view, id:)
        end
      end
    end
  end
end
