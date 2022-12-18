module Decafsucks
  module Persistence
    module Relations
      class Reviews < ROM::Relation[:sql]
        schema :reviews, infer: true do
          associations do
            belongs_to :users, as: :author
            belongs_to :cafe
          end
        end
      end
    end
  end
end
