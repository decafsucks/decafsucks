# frozen_string_literal: true

RSpec.describe Main::Repos::LikeRepo, :db do
  subject(:like_repo) { Main::Slice["repos.like_repo"] }

  let(:user) { factory[:user] }
  let(:cafe) { factory[:cafe] }

  describe "#like" do
    it "records a like" do
      like_repo.like(user_id: user.id, cafe_id: cafe.id)

      expect(like_repo.liked?(user_id: user.id, cafe_id: cafe.id)).to be true
      expect(like_repo.count_for_cafe(cafe.id)).to eq 1
    end

    it "is idempotent" do
      like_repo.like(user_id: user.id, cafe_id: cafe.id)
      like_repo.like(user_id: user.id, cafe_id: cafe.id)

      expect(like_repo.count_for_cafe(cafe.id)).to eq 1
    end
  end

  describe "#unlike" do
    it "removes the like" do
      like_repo.like(user_id: user.id, cafe_id: cafe.id)
      like_repo.unlike(user_id: user.id, cafe_id: cafe.id)

      expect(like_repo.liked?(user_id: user.id, cafe_id: cafe.id)).to be false
      expect(like_repo.count_for_cafe(cafe.id)).to eq 0
    end
  end
end
