# frozen_string_literal: true

module Main
  module Relations
    class Cafes < Main::DB::Relation
      schema :cafes, infer: true
    end
  end
end
