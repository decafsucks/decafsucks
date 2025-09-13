# frozen_string_literal: true

module Main
  module Views
    module Account
      class Show < Main::View
        include Deps["repos.user_repo"]

        expose :user do |account_id:|
          user_repo.get_for_account(account_id)
        end
      end
    end
  end
end
