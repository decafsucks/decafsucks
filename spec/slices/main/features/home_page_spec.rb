# frozen_string_literal: true

RSpec.describe "Home page", :web, :db do
  specify "Visiting the home page shows recent reviews" do
    cafe = factory[:cafe, name: "Group Seven"]
    user = factory[:user, name: "Jo"]
    factory[:review, cafe: cafe, user: user, body: "Great flat white", good_cup: true]

    visit "/"

    expect(page).to have_content("Group Seven")
    expect(page).to have_content("Great flat white")
    expect(page).to have_content("Jo")
  end
end
