module Geocoding
  class Search
    include Deps["client"]

    # TODO: map these into our own "Result" objects
    def by_string(str, ...) = client.search(str, ...)
    def by_coords(lat, lng, ...) = client.search([lat, lng], ...)
  end
end
