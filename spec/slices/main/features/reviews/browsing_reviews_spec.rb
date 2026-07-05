# frozen_string_literal: true

RSpec.describe "Reviews / Browsing reviews", :web, :db do
  specify "Following 'see more' from the home page to the paginated reviews" do
    stub_const("Main::Repos::ReviewRepo::PER_PAGE", 2)

    cafe = factory[:cafe, name: "Group Seven"]
    user = factory[:user, name: "Jo"]
    3.times do |i|
      factory[:review, cafe: cafe, user: user, body: "Review #{i}", created_at: Time.now - i]
    end

    visit "/"
    click_on "See more reviews"

    expect(page).to have_current_path("/reviews")
    expect(page).to have_content("Group Seven")
    expect(page).to have_content("Jo")
    expect(page).to have_content("Review 0")
    expect(page).not_to have_content("Review 2")
    expect(page).not_to have_link("← Newer")

    click_on "Older →"

    expect(page).to have_content("Review 2")
    expect(page).to have_link("← Newer")
    expect(page).not_to have_link("Older →") # Only 3 reviews, so no third page
  end
end
