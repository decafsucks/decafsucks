# frozen_string_literal: true

RSpec.describe Geocoding::Lookups::LocationIQ do
  subject(:lookup) { described_class.new(api_key:) }

  let(:api_key) { Geocoding::Slice["settings"].location_iq_api_key }

  it "works", :vcr do
    results = lookup.search("sigulda")

    p results
  end
end
