# frozen_string_literal: true

RSpec.describe Main::Reviews::Operations::Create, :db, :container_stubs do
  subject(:create_review) { described_class.new }

  let(:author) { factory[:user] }

  let(:geocoder) { instance_double(Geocoding::Search) }
  let(:geocoding_result) {
    Geocoding::Result.new(
      display_name: "123 Smith St, Melbourne VIC 3000, Australia",
      lat: "-37.8136",
      lng: "144.9631"
    )
  }

  let(:cafes) { Main::Slice["relations.cafes"] }

  before do
    Main::Slice.container.stub("geocoding.search", geocoder)
  end

  it "creates a cafe and a review when no nearby cafe match exists" do
    expect(geocoder).to receive(:search).with("123 Smith St, Melbourne").and_return([geocoding_result])

    result = create_review.call(
      {
        cafe_name: "Seven Seeds",
        cafe_address: "123 Smith St, Melbourne",
        rating: 8,
        body: "Excellent single origin pour over."
      },
      author_id: author.id
    )

    expect(result).to be_success { |review|
      expect(review).to have_attributes(
        author_id: author.id,
        rating: 8,
        body: "Excellent single origin pour over."
      )
      expect(cafes.by_pk(review.cafe_id).one!).to include(
        name: "Seven Seeds",
        address: "123 Smith St, Melbourne VIC 3000, Australia"
      )
    }
  end

  it "creates a review attached to an existing nearby cafe" do
    existing = factory[:cafe, name: "Seven Seeds", lat: -37.8136, lng: 144.9631]
    expect(geocoder).to receive(:search).with("123 Smith St, Melbourne").and_return([geocoding_result])

    result = create_review.call(
      {
        cafe_name: "Seven Seeds",
        cafe_address: "123 Smith St, Melbourne",
        rating: 8,
        body: "Excellent single origin pour over."
      },
      author_id: author.id
    )

    expect(result).to be_success { |review|
      expect(review).to have_attributes(
        cafe_id: existing.id,
        author_id: author.id,
        rating: 8,
        body: "Excellent single origin pour over."
      )
    }
    expect(cafes.count).to eq 1
  end

  it "returns a validation failure for incomplete input" do
    result = create_review.call({}, author_id: author.id)

    expect(result).to be_failure { |code, validation|
      expect(code).to eq :validation
      expect(validation).to be_a(Dry::Validation::Result)
    }
  end

  it "returns a geocoding not_found failure when the address cannot be located" do
    expect(geocoder).to receive(:search).with("123 Smith St, Melbourne").and_return([])

    result = create_review.call(
      {
        cafe_name: "Seven Seeds",
        cafe_address: "123 Smith St, Melbourne",
        rating: 8,
        body: "Excellent single origin pour over."
      },
      author_id: author.id
    )

    expect(result).to be_failure([:geocoding, :not_found])
  end
end
