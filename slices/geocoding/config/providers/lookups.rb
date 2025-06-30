# frozen_string_literal: true

Geocoding::Slice.register_provider :lookups, namespace: true do
  start do
    settings = slice["settings"]

    location_iq = Geocoding::Lookups::LocationIQ.new(api_key: settings.location_iq_api_key)
    register "location_iq", location_iq
  end
end
