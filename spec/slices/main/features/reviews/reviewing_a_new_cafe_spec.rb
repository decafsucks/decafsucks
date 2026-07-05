# frozen_string_literal: true

RSpec.describe "Reviews / Writing a review of a new cafe", :web, :db, :container_stubs do
  let(:geocoding_result) do
    Geocoding::Result.new(display_name: "123 Smith St, Melbourne VIC 3000, Australia", lat: "-37.8136", lng: "144.9631")
  end

  let(:fake_search) { instance_double(Geocoding::Search, search: [geocoding_result]) }

  before do
    Main::Slice.container.stub("geocoding.search", fake_search)

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

  it "posts a review for a new cafe" do
    visit "/reviews/new"

    fill_in "Cafe name", with: "Seven Seeds"
    fill_in "Cafe address", with: "123 Smith St, Melbourne"
    fill_in "Review", with: "Excellent single origin pour over."

    click_on "Post review"

    expect(page).to have_flash_message "Review posted!", type: :notice
    expect(page).to have_content("Seven Seeds")
  end

  it "attaches a review to an existing matching cafe" do
    factory[:cafe, name: "Seven Seeds", lat: -37.8136, lng: 144.9631]

    visit "/reviews/new"

    fill_in "Cafe name", with: "Seven Seeds"
    fill_in "Cafe address", with: "123 Smith St, Melbourne"
    fill_in "Review", with: "Great coffee."

    click_on "Post review"

    expect(page).to have_flash_message "Review posted!", type: :notice
    expect(page).to have_content("Seven Seeds")
  end

  it "re-renders the form with an error when the address cannot be located" do
    Main::Slice.container.stub("geocoding.search", instance_double(Geocoding::Search, search: []))

    visit "/reviews/new"

    fill_in "Cafe name", with: "Seven Seeds"
    fill_in "Cafe address", with: "Nowhere at all"
    fill_in "Review", with: "Trying to write this up."
    click_on "Post review"

    expect(page).to have_content("could not be located")
  end
end
