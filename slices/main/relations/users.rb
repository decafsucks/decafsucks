# frozen_string_literal: true

module Main
  module Relations
    class Users < Main::DB::Relation
      schema :users, infer: true do
        associations do
          belongs_to :account
        end
      end
    end
  end
end
