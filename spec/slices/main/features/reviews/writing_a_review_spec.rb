# frozen_string_literal: true

RSpec.describe "Reviews / Writing a review of a cafe", :web, :db do
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

  it "posts a review, records the visit details, and likes the cafe" do
    cafe = factory[:cafe, name: "Seven Seeds"]

    visit "/cafes/#{cafe.id}"
    click_on "Write a review"

    expect(page).to have_content("Write a review of Seven Seeds")

    fill_in "Review", with: "Excellent single origin pour over."
    check "♥ Like this cafe"
    choose "Good cup"

    click_on "Post review"

    expect(page).to have_flash_message "Review posted!", type: :notice
    expect(page).to have_content("Excellent single origin pour over.")
    expect(page).to have_content("👍 good cup")
    expect(page).to have_content("1 like")
  end

  it "posts an undated review with just a comment" do
    cafe = factory[:cafe, name: "Seven Seeds"]

    visit "/cafes/#{cafe.id}/reviews/new"
    fill_in "Review", with: "Been meaning to write this place up."
    click_on "Post review"

    expect(page).to have_flash_message "Review posted!", type: :notice
    expect(page).to have_content("Been meaning to write this place up.")
  end

  it "re-renders the form with errors when the review body is blank" do
    cafe = factory[:cafe, name: "Seven Seeds"]

    visit "/cafes/#{cafe.id}/reviews/new"
    click_on "Post review"

    expect(page).to have_content("Write a review of Seven Seeds")
    within page.find_field("Review").ancestor("div") do
      expect(page).to have_content("must be filled")
    end
  end
end
