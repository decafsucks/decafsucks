# frozen_string_literal: true

RSpec.describe "Home page", :web, :db do
  specify "Visiting the home page" do
    factory[:cafe, name: "Group Seven"]
    factory[:cafe, name: "Harvest"]

    visit "/"

    expect(page).to have_content("Group Seven")
    expect(page).to have_content("Harvest")
  end
end
