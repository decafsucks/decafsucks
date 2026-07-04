# frozen_string_literal: true

module Main
  module Repos
    class ReviewRepo < Main::DB::Repo
      def create(attrs)
        id = reviews.changeset(:create, attrs).commit.fetch(:id)
        reviews.by_pk(id).one!
      end

      # Newest first. Undated reviews fall back to when they were written, so a backfilled review
      # sorts by its created_at while a review recording a visit sorts by the visit date.
      def for_cafe(cafe_id)
        reviews
          .where(cafe_id:)
          .order { coalesce(visited_on, created_at.cast(:date)).desc }
          .to_a
      end
    end
  end
end
