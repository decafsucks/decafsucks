# frozen_string_literal: true

module Main
  module Relations
    class Likes < Main::DB::Relation
      schema :likes, infer: true do
        associations do
          belongs_to :user
          belongs_to :cafe
        end
      end
    end
  end
end
