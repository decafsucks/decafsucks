# frozen_string_literal: true

module Geocoding
  class Search
    include Deps[lookup: "lookups.location_iq"]

    def search(query) = lookup.search(query)

    def reverse(lat, lng) = lookup.search(lat, lng)
  end
end
