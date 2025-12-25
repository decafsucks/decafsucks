# frozen_string_literal: true

module Main
  module Repos
    class CafeRepo < Main::DB::Repo
      def get(id)
        cafes.by_pk(id).one!
      end

      def latest
        cafes.order { created_at.desc }.to_a
      end
    end
  end
end
