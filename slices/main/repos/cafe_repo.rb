# frozen_string_literal: true

module Main
  module Repos
    class CafeRepo < Main::DB::Repo
      # ~0.005 decimal degrees is roughly 500m at most latitudes
      NEARBY_THRESHOLD = 0.005

      def get(id)
        cafes.by_pk(id).one!
      end

      def latest
        cafes.order { created_at.desc }.to_a
      end

      def find_by_dmetaphone_near(name:, lat:, lng:)
        cafes
          .where(name_dmetaphone: Main::Cafes::Dmetaphone.of(name))
          .where(Sequel.lit(
            "ABS(lat - ?) < ? AND ABS(lng - ?) < ?",
            lat, NEARBY_THRESHOLD,
            lng, NEARBY_THRESHOLD
          ))
          .first
      end

      # Atomically returns the existing nearby phonetic match or inserts a new cafe.
      #
      # There's a possible race between the lookup and insert. The unique index on (name_dmetaphone,
      # round(lat, 4), round(lng, 4)) means only one insert wins, and we re-read on conflict.
      def find_or_create_near(name:, address:, lat:, lng:)
        transaction do
          existing = find_by_dmetaphone_near(name:, lat:, lng:)
          return existing if existing

          create(name:, address:, lat:, lng:)
        end
      rescue Sequel::UniqueConstraintViolation
        find_by_dmetaphone_near(name:, lat:, lng:)
      end

      def create(attrs)
        id = cafes.changeset(CreateChangeset, attrs).commit.fetch(:id)
        cafes.by_pk(id).one!
      end
    end
  end
end
