# frozen_string_literal: true

module Main
  module Cafes
    module Operations
      # Returns the cafe corresponding to a given name and address, geocoding the address and
      # creating the cafe if no nearby phonetic match exists.
      class Resolve < Main::Operation
        include Deps[
          "repos.cafe_repo",
          geocoder: "geocoding.search"
        ]

        def call(name:, address:)
          location = step geocode(address)

          cafe_repo.find_or_create_near(
            name:,
            address: location.display_name,
            lat: location.lat,
            lng: location.lng
          )
        end

        private

        def geocode(address)
          results = geocoder.search(address)

          if results.any?
            Success(results.first)
          else
            Failure[:geocoding, :not_found]
          end
        end
      end
    end
  end
end
