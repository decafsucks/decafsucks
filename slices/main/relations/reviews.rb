# frozen_string_literal: true

module Main
  module Relations
    class Reviews < Main::DB::Relation
      schema :reviews, infer: true do
        associations do
          belongs_to :users, as: :author
          belongs_to :cafe
        end
      end
    end
  end
end
