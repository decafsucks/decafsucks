# frozen_string_literal: true

RSpec.describe "Reviews / Reviewing a cafe", :web, :db do
  before do
    factory[
      :account,
      :verified,
      email: "jane@example.com",
      password_hash: BCrypt::Password.create("password123")
    ]

    visit "/sign-in"
    fill_in "Email", with: "jane@example.com"
    fill_in "Password", with: "password123"
    within("main") { click_on "Sign in" }
  end

  it "creates a review for the cafe" do
    cafe = factory[:cafe, name: "Seven Seeds"]

    visit "/cafes/#{cafe.id}"
    click_on "Write a review"

    expect(page).to have_content("Write a Review for Seven Seeds")

    fill_in "Rating", with: "8"
    fill_in "Review", with: "Excellent single origin pour over."

    click_on "Submit review"

    expect(page).to have_flash_message "Review created!", type: :notice
    expect(page).to have_content("Seven Seeds")
  end

  it "re-renders the form with errors for invalid input" do
    cafe = factory[:cafe, name: "Seven Seeds"]

    visit "/cafes/#{cafe.id}/reviews/new"

    # Leave rating and review body blank
    click_on "Submit review"

    expect(page).to have_content("Write a Review for Seven Seeds")

    within page.find_field("Rating (1-10)").ancestor("div") do
      expect(page).to have_content("must be filled")
    end

    within page.find_field("Review").ancestor("div") do
      expect(page).to have_content("must be filled")
    end
  end
end
