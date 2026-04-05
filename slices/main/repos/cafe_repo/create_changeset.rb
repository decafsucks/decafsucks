# frozen_string_literal: true

module Main
  module Repos
    class CafeRepo < Main::DB::Repo
      class CreateChangeset < ROM::Changeset::Create
        map do |tuple|
          tuple.merge(name_dmetaphone: Main::Cafes::Dmetaphone.of(tuple[:name]))
        end
      end
    end
  end
end
