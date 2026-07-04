# frozen_string_literal: true

module Classic
  module Relations
    # Legacy social (Twitter/Facebook) OAuth accounts. Source of user display names.
    class LoginAccounts < Classic::DB::Relation
      gateway :classic
      schema :login_accounts, infer: true
    end
  end
end
