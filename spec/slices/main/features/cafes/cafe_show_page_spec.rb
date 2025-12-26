# frozen_string_literal: true

RSpec.describe "Cafes / Show page", :web, :db do
  specify "Visiting the cafe show page" do
    cafe = factory[:cafe, name: "Group Seven"]

    visit "/cafes/#{cafe.id}"

    expect(page).to have_content("Group Seven")
  end
end
