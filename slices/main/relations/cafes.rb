# frozen_string_literal: true

module Main
  module Relations
    class Cafes < Main::DB::Relation
      schema :cafes, infer: true do
        associations do
          has_many :reviews
          has_many :likes
        end
      end
    end
  end
end
