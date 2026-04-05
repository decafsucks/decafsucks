# frozen_string_literal: true

RSpec.describe Main::Cafes::Operations::Resolve, :db, :container_stubs do
  subject(:resolve) { Main::Slice["cafes.operations.resolve"] }

  let(:cafe_repo) { Main::Slice["repos.cafe_repo"] }

  before { Main::Slice.container.stub("geocoding.search", fake_search) }

  context "when geocoding finds the address" do
    let(:fake_search) { instance_double(Geocoding::Search, search: [geocoding_result]) }
    let(:geocoding_result) do
      Geocoding::Result.new(
        display_name: "123 Smith St, Melbourne VIC 3000, Australia",
        lat: "-37.8136",
        lng: "144.9631"
      )
    end

    it "returns the existing cafe when a phonetic match exists nearby" do
      existing = factory[:cafe, name: "Seven Seeds", lat: -37.8136, lng: 144.9631]

      result = resolve.call(name: "Seven Seeds", address: "123 Smith St, Melbourne")

      expect(result).to be_success
      expect(result.value!.id).to eq existing.id
      expect(cafe_repo.latest.size).to eq 1
    end

    it "creates a cafe with the geocoder's display_name as the address" do
      result = resolve.call(name: "Seven Seeds", address: "anything the user typed")

      expect(result).to be_success
      expect(result.value!).to have_attributes(
        name: "Seven Seeds",
        address: "123 Smith St, Melbourne VIC 3000, Australia",
        lat: -37.8136,
        lng: 144.9631
      )
    end
  end

  context "when geocoding finds no results" do
    let(:fake_search) { instance_double(Geocoding::Search, search: []) }

    it "returns a geocoding not_found failure and does not create a cafe" do
      result = resolve.call(name: "Nowhere", address: "atlantis")

      expect(result).to be_failure
      expect(result.failure).to eq [:geocoding, :not_found]
      expect(cafe_repo.latest).to be_empty
    end
  end
end
