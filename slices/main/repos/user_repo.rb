# frozen_string_literal: true

module Main
  module Repos
    class UserRepo < Main::DB::Repo
      def get_for_account(account_id)
        users
          .where(account_id:)
          .left_join(:account)
          .select_append(accounts[:email])
          .one!
      end
    end
  end
end
