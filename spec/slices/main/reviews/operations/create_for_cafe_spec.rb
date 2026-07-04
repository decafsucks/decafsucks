# frozen_string_literal: true

RSpec.describe Main::Reviews::Operations::CreateForCafe, :db do
  subject(:create_review) { described_class.new }

  let(:user) { factory[:user] }
  let(:cafe) { factory[:cafe, name: "Seven Seeds"] }

  let(:reviews) { Main::Slice["relations.reviews"] }
  let(:likes) { Main::Slice["relations.likes"] }

  it "posts a review for the given cafe" do
    result = create_review.call(
      {body: "Excellent single origin pour over.", visited_on: "2024-01-15", good_cup: true},
      user_id: user.id,
      cafe_id: cafe.id
    )

    expect(result).to be_success
    expect(reviews.to_a).to contain_exactly(
      a_hash_including(
        user_id: user.id,
        cafe_id: cafe.id,
        body: "Excellent single origin pour over.",
        good_cup: true
      )
    )
  end

  it "posts an undated review with just a comment" do
    result = create_review.call({body: "Great spot, been meaning to write it up."}, user_id: user.id, cafe_id: cafe.id)

    expect(result).to be_success
    expect(reviews.to_a).to contain_exactly(
      a_hash_including(user_id: user.id, cafe_id: cafe.id, visited_on: nil, good_cup: nil)
    )
  end

  it "likes the cafe when asked" do
    create_review.call({body: "Love this place.", like: true}, user_id: user.id, cafe_id: cafe.id)

    expect(likes.to_a).to contain_exactly(a_hash_including(user_id: user.id, cafe_id: cafe.id))
  end

  it "returns a validation failure when the body is blank" do
    result = create_review.call({body: ""}, user_id: user.id, cafe_id: cafe.id)

    expect(result).to be_failure { |code, validation|
      expect(code).to eq :validation
      expect(validation).to be_a(Dry::Validation::Result)
    }
  end
end
