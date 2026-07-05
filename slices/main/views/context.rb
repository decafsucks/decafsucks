# auto_register: false
# frozen_string_literal: true

module Main
  module Views
    class Context < Hanami::View::Context
      include Deps["repos.user_repo"]

      def signed_in?
        !current_user.nil?
      end

      def current_user
        return @current_user if instance_variable_defined?(:@current_user)

        # Order matters here:
        # - `logged_in?` ensures a session id (`account_from_session` raises otherwise).
        # - `account_from_session` loads the account `account_id` needs, and returns nil for a
        #   since-removed account, avoiding a crash for stale sessions.
        @current_user =
          if rodauth.logged_in? && rodauth.account_from_session
            user_repo.get_for_account(rodauth.account_id)
          end
      end

      def rodauth
        request.env["rodauth"]
      end
    end
  end
end
