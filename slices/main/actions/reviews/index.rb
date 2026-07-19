# frozen_string_literal: true

module Main
  module Actions
    module Reviews
      class Index < Main::Action
        def handle(request, response)
          page = request.params[:page].to_i
          page = 1 if page < 1

          response.render(view, page:)
        end
      end
    end
  end
end
