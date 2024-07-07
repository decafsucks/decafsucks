# frozen_string_literal: true

module Main
  module Relations
    class Users < Main::DB::Relation
      schema :users, infer: true
    end
  end
end
