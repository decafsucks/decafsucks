# frozen_string_literal: true

module Main
  module Repos
    class ReviewRepo < Main::DB::Repo
      def create(attrs)
        id = reviews.changeset(:create, attrs).commit.fetch(:id)
        reviews.by_pk(id).one!
      end
    end
  end
end
