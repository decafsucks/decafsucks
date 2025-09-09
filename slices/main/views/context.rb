# auto_register: false
# frozen_string_literal: true

module Main
  module Views
    class Context < Hanami::View::Context
      include Deps["repos.user_repo"]

      def signed_in?
        request.env["rodauth"]&.logged_in?
      end

      def current_user
        return @current_user if instance_variable_defined?(:@current_user)

        @current_user = begin
          _account = request.env["rodauth"].account_from_session
          account_id = request.env["rodauth"].account_id
          user_repo.get_for_account(account_id) if account_id
        end
      end
    end
  end
end
