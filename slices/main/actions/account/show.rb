# frozen_string_literal: true

module Main
  module Actions
    module Account
      class Show < Authenticated
        def handle(request, response)
          response.render(
            view,
            account_id: response[:current_account_id]
          )
        end
      end
    end
  end
end
