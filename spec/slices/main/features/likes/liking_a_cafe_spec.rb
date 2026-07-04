# frozen_string_literal: true

RSpec.describe "Likes / Liking a cafe", :web, :db do
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

  it "likes and unlikes a cafe" do
    cafe = factory[:cafe, name: "Seven Seeds"]

    visit "/cafes/#{cafe.id}"

    click_on "♡ Like"
    expect(page).to have_content("1 like")
    expect(page).to have_button("♥ Liked")

    click_on "♥ Liked"
    expect(page).to have_content("0 likes")
    expect(page).to have_button("♡ Like")
  end
end
