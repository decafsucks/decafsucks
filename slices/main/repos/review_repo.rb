# frozen_string_literal: true

module Main
  module Repos
    class ReviewRepo < Main::DB::Repo
      PER_PAGE = 20

      def create(attrs)
        id = reviews.changeset(:create, attrs).commit.fetch(:id)
        reviews.by_pk(id).one!
      end

      # Returns a page of recent reviews.
      #
      # Returns newest reviews first, by `created_at`. Includes each review's cafe and reviewer.
      def recent(page: 1)
        reviews
          .combine(:cafe, :user)
          .order { created_at.desc }
          .per_page(PER_PAGE)
          .page(page)
      end

      # Returns the reviews for a cafe.
      #
      # Returns newest reviews first, by `visited_on` then `created_at`.
      def for_cafe(cafe_id)
        reviews
          .where(cafe_id:)
          .order { coalesce(visited_on, created_at.cast(:date)).desc }
          .to_a
      end
    end
  end
end
