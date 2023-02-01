# auto_register: false
# frozen_string_literal: true

module Decafsucks
  module Relations
    class Cafes < ROM::Relation[:sql]
      schema :cafes, infer: true
    end
  end
end
