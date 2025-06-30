# frozen_string_literal: true

RSpec.describe Geocoding::Services::LocationIQ do
  subject(:lookup) { described_class.new(api_key:) }

  let(:api_key) { Geocoding::Slice["settings"].location_iq_api_key }

  it "returns results for a search", :vcr do
    results = lookup.search("sigulda")

    expect(results.length).to eq 8
    expect(results.first).to have_attributes(
      display_name: "Sigulda, Siguldas novads, LV-2150, Latvia",
      lat: "57.1540561",
      lng: "24.8567141"
    )
  end
end
