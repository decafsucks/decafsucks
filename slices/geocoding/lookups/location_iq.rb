# frozen_string_literal: true

require "faraday"

module Geocoding
  module Lookups
    class LocationIQ
      URL = "https://us1.locationiq.com"

      def initialize(api_key:)
        @api_key = api_key
      end

      def search(query)
        # TODO: can I put /v1 in the faraday connection URL? It wasn't working when I tried
        connection.get("/v1/search") do |request|
          request.params["q"] = query
        end
      end

      def reverse(lat, lng)
        # TODO
      end

      private

      def connection
        @connection ||= Faraday.new(
          url: URL,
          params: {
            :"accept-language" => "en",
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
