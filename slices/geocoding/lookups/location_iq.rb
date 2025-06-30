# frozen_string_literal: true

require "faraday"

module Geocoding
  module Lookups
    class LocationIQ
      URL = "https://us1.locationiq.com/v1"

      def initialize(api_key:)
        @api_key = api_key
      end

      def search(query)
        response = connection.get("search") { |request|
          request.params["q"] = query
        }

        response.body.map { |result|
          Result.new(
            display_name: result["display_name"],
            lat: result["lat"],
            lng: result["lon"]
          )
        }
      end

      def reverse(lat, lng)
        # TODO
      end

      private

      def connection
        @connection ||= Faraday.new(
          url: URL,
          params: {
            "accept-language": "en",
            format: "json",
            key: @api_key
          }
        ) { |f|
          f.response :json
        }
      end
    end
  end
end
