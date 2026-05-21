# frozen_string_literal: true

RSpec.describe Main::Reviews::Operations::CreateForCafe, :db do
  subject(:create_review) { described_class.new }

  let(:author) { factory[:user] }
  let(:cafe) { factory[:cafe, name: "Seven Seeds"] }

  let(:reviews) { Main::Slice["relations.reviews"] }

  it "creates a review for the given cafe" do
    result = create_review.call(
      {rating: 8, body: "Excellent single origin pour over."},
      author_id: author.id,
      cafe_id: cafe.id
    )

    expect(result).to be_success
    expect(reviews.to_a).to contain_exactly(
      a_hash_including(
        author_id: author.id,
        cafe_id: cafe.id,
        rating: 8,
        body: "Excellent single origin pour over."
      )
    )
  end

  it "returns a validation failure for incomplete input" do
    result = create_review.call({}, author_id: author.id, cafe_id: cafe.id)

    expect(result).to be_failure { |code, validation|
      expect(code).to eq :validation
      expect(validation).to be_a(Dry::Validation::Result)
    }
  end
end
