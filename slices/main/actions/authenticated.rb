# auto_register: false
# frozen_string_literal: true

module Main
  module Actions
    # Action class that requires a signed in user.
    class Authenticated < Main::Action
      # Key for authentication context in the current request.
      #
      # @see #actor
      ACTOR_REQUEST_KEY = "decafsucks.main.actor"

      # Authentication context for the current request.
      #
      # @example
      #   actor(request).user         # current user
      #   actor(request).account_id   # rodauth account id
      #
      # @see #actor
      Actor = Data.define(:user, :account_id)

      include Deps["repos.user_repo"]

      before :require_authentication

      private

      def require_authentication(request, response)
        rodauth = request.env["rodauth"]

        handle_rodauth_redirect(rodauth, response) { rodauth.require_account }

        request.env[ACTOR_REQUEST_KEY] = Actor.new(
          account_id: rodauth.account_id,
          user: user_repo.get_for_account(rodauth.account_id)
        )
      end

      # Returns the {Actor} representing the current user. Use this to get the current user.
      #
      # @example
      #   actor(request).user
      #
      # @see #require_authentication
      def actor(request)
        request.env[ACTOR_REQUEST_KEY]
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
      def handle_rodauth_redirect(rodauth, response)
        halted = catch :halt do
          yield
        end

        if halted
          code, headers, body = *halted

          # Because we're catching Roda's halt and not allowing it to finalize its own request, we
          # need to take any flash messages it created and put them in our own flash object, so they
          # can become available for displaying on the next request.
          rodauth.flash.next.each { |k, v| response.flash[k] = v }

          # Handle the redirect ourselves
          if (redirect_to = headers["Location"])
            response.redirect(redirect_to, code)
          end

          throw :halt, [code, body]
        end
      end
    end
  end
end
