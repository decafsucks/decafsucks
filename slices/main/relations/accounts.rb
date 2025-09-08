# frozen_string_literal: true

module Main
  module Relations
    class Accounts < Main::DB::Relation
      schema :accounts, infer: true do
        associations do
          has_one :user
        end
      end
    end
  end
end
