# auto_register: false
# frozen_string_literal: true

module Main
  module Views
    class Context < Hanami::View::Context
      include Deps["repos.user_repo"]

      def signed_in?
        rodauth.logged_in?
      end

      def current_user
        return @current_user if instance_variable_defined?(:@current_user)

        @current_user = begin
          # Load the account before attempting to get its ID
          _account = rodauth.account_from_session

          user_repo.get_for_account(rodauth.account_id) if rodauth.account_id
        end
      end

      def rodauth
        request.env["rodauth"]
      end
    end
  end
end
