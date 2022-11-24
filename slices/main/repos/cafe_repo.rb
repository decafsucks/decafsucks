# frozen_string_literal: true

module Main
  module Repos
    class CafeRepo < Main::Repo[:cafes]
      def latest
        cafes.order { created_at.desc }.to_a
      end
    end
  end
end
