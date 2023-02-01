# auto_register: false
# frozen_string_literal: true

module Decafsucks
  module Relations
    class Users < ROM::Relation[:sql]
      schema :users, infer: true
    end
  end
end
