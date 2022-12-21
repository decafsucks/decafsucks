# frozen_string_literal: true

module Decafsucks
  module Persistence
    module Relations
      class Cafes < ROM::Relation[:sql]
        schema :cafes, infer: true
      end
    end
  end
end
