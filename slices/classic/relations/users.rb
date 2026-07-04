# frozen_string_literal: true

module Classic
  module Relations
    # Legacy users.
    #
    # Note there is no name column here; a user's display name lives on their `login_accounts`
    # record (see {Classic::Import}'s name derivation).
    class Users < Classic::DB::Relation
      gateway :classic
      schema :users, infer: true
    end
  end
end
