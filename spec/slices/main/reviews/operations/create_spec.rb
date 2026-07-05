# frozen_string_literal: true

RSpec.describe Main::Reviews::Operations::Create, :db, :container_stubs do
  subject(:create_review) { described_class.new }

  let(:user) { factory[:user] }

  let(:geocoder) { instance_double(Geocoding::Search) }
  let(:geocoding_result) {
    Geocoding::Result.new(
      display_name: "123 Smith St, Melbourne VIC 3000, Australia",
      lat: "-37.8136",
      lng: "144.9631"
    )
  }

  let(:cafes) { Main::Slice["relations.cafes"] }
  let(:reviews) { Main::Slice["relations.reviews"] }

  before do
    Main::Slice.container.stub("geocoding.search", geocoder)
  end

  it "creates a cafe and posts a review when no nearby cafe match exists" do
    expect(geocoder).to receive(:search).with("123 Smith St, Melbourne").and_return([geocoding_result])

    result = create_review.call(
      {
        cafe_name: "Seven Seeds",
        cafe_address: "123 Smith St, Melbourne",
        body: "Excellent single origin pour over.",
        good_cup: true
      },
      user_id: user.id
    )

    expect(result).to be_success
    expect(cafes.to_a).to contain_exactly(
      a_hash_including(
        name: "Seven Seeds",
        address: "123 Smith St, Melbourne VIC 3000, Australia"
      )
    )
    expect(reviews.to_a).to contain_exactly(
      a_hash_including(
        user_id: user.id,
        body: "Excellent single origin pour over.",
        good_cup: true
      )
    )
  end

  it "posts a review attached to an existing nearby cafe" do
    existing = factory[:cafe, name: "Seven Seeds", lat: -37.8136, lng: 144.9631]
    expect(geocoder).to receive(:search).with("123 Smith St, Melbourne").and_return([geocoding_result])

    result = create_review.call(
      {
        cafe_name: "Seven Seeds",
        cafe_address: "123 Smith St, Melbourne",
        body: "Great coffee."
      },
      user_id: user.id
    )

    expect(result).to be_success
    expect(reviews.to_a).to contain_exactly(
      a_hash_including(
        user_id: user.id,
        cafe_id: existing.id,
        body: "Great coffee."
      )
    )
    expect(cafes.count).to eq 1
  end

  it "returns a geocoding not_found failure when the address cannot be located" do
    expect(geocoder).to receive(:search).with("123 Smith St, Melbourne").and_return([])

    result = create_review.call(
      {cafe_name: "Seven Seeds", cafe_address: "123 Smith St, Melbourne", body: "Wanted to write this up."},
      user_id: user.id
    )

    expect(result).to be_failure([:geocoding, :not_found])
  end
end
