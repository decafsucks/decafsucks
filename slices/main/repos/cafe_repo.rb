# frozen_string_literal: true

module Main
  module Repos
    class CafeRepo < Main::DB::Repo
      def latest
        cafes.order { created_at.desc }.to_a
      end
    end
  end
end
