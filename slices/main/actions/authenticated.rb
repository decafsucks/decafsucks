# auto_register: false
# frozen_string_literal: true

module Main
  module Actions
    class Authenticated < Main::Action
      before :require_authentication

      private

      def require_authentication(request, response)
        rodauth = request.env["rodauth"]

        handle_rodauth_redirects(response) { rodauth.require_account }

        response[:current_account_id] = rodauth.account_id
      end

      # Converts a Rodauth-initiated redirect into one that works for Hanami actions.
      #
      # When natively redirecting within Hanami actions, it will internally throw a `:halt` with a
      # value of `[status_code, body]`.
      #
      # When Rodauth redirects, it throws a `:halt` from within Roda, which gives a value of
      # `[status_code, response_headers_as_json, body]`.
      #
      # Account for this difference by catching a Roda-thrown halt here, converting it into the
      # expected structure for Hanami actions, and then re-throwing it.
      #
      # (Later on we'll shift this code into a rodauth-hanami gem or similar.)
      def handle_rodauth_redirects(response)
        halted = catch :halt do
          yield
        end

        if halted
          code, headers, body = *halted

          if (redirect_to = headers["Location"])
            response.redirect(redirect_to, code)
          end

          throw :halt, [code, body]
        end
      end
    end
  end
end
