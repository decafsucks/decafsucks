# frozen_string_literal: true

RSpec.describe Main::Repos::ReviewRepo, :db do
  subject(:review_repo) { Main::Slice["repos.review_repo"] }

  describe "#recent" do
    it "paginates reviews, newest first, with cafe and reviewer loaded" do
      cafe = factory[:cafe, name: "Group Seven"]
      user = factory[:user, name: "Jo"]
      factory[:review, cafe: cafe, user: user, created_at: Time.now - 60]
      newest = factory[:review, cafe: cafe, user: user, created_at: Time.now]

      paginated = review_repo.recent
      expect(paginated).to respond_to(:pager)

      result = paginated.to_a
      expect(result.first.id).to eq newest.id
      expect(result.first.cafe.name).to eq "Group Seven"
      expect(result.first.user.name).to eq "Jo"
    end
  end
end
