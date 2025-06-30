# frozen_string_literal: true

module Geocoding
  # Searches for a place using a geocoding service.
  #
  # This is intended to be the main interface to the `Geocoding` slice; all other components in the
  # slice are considered "private".
  #
  # Eventually this will handle caching of results as well as rotation searches among a number of
  # geocoding services, if required.
  class Search
    include Deps[service: "services.location_iq"]

    def search(query) = service.search(query)

    def reverse(lat, lng) = service.reverse(lat, lng)
  end
end
