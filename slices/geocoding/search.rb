# frozen_string_literal: true

module Geocoding
  class Search
    include Deps[service: "services.location_iq"]

    def search(query) = service.search(query)

    def reverse(lat, lng) = service.reverse(lat, lng)
  end
end
