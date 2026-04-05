# frozen_string_literal: true

RSpec.describe Main::Repos::CafeRepo, :db do
  subject(:cafe_repo) { Main::Slice["repos.cafe_repo"] }

  describe "#find_by_dmetaphone_near" do
    let(:lat) { -37.8136 }
    let(:lng) { 144.9631 }

    it "matches a cafe with the same phonetic name within the proximity bound" do
      factory[:cafe, name: "Seven Seeds", lat:, lng:]

      found = cafe_repo.find_by_dmetaphone_near(name: "Seven Seed", lat: lat + 0.004, lng:)

      expect(found).to have_attributes(name: "Seven Seeds")
    end

    it "matches a case variation of the name" do
      factory[:cafe, name: "Seven Seeds", lat:, lng:]

      found = cafe_repo.find_by_dmetaphone_near(name: "SEVEN SEEDS", lat:, lng:)

      expect(found).to have_attributes(name: "Seven Seeds")
    end

    it "does not match a cafe outside the proximity threshold" do
      factory[:cafe, name: "Seven Seeds", lat:, lng:]

      found = cafe_repo.find_by_dmetaphone_near(name: "Seven Seeds", lat: lat + 0.01, lng:)

      expect(found).to be_nil
    end

    it "does not match a cafe with a different phonetic name even when nearby" do
      factory[:cafe, name: "Seven Seeds", lat:, lng:]

      found = cafe_repo.find_by_dmetaphone_near(name: "Single Origin", lat:, lng:)

      expect(found).to be_nil
    end
  end
end
