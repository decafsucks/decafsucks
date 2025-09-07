# frozen_string_literal: true

module Main
  module Relations
    class Accounts < Main::DB::Relation
      # Define schema explicitly so we don't needlessly expose password_hash to the app; this is
      # managed by Rodauth.
      schema :accounts do
        attribute :id, Types::Serial
        attribute :email, Types::String
      end
    end
  end
end
