# frozen_string_literal: true

RSpec.describe "Reviews / Creating a review", :web, :db, :container_stubs do
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

  it "creates a review for a new cafe" do
    visit "/reviews/new"

    fill_in "Cafe name", with: "Seven Seeds"
    fill_in "Cafe address", with: "123 Smith St, Melbourne"
    fill_in "Rating", with: "8"
    fill_in "Review", with: "Excellent single origin pour over."

    click_on "Submit review"

    expect(page).to have_flash_message "Review created!", type: :notice
    expect(page).to have_content("Seven Seeds")
  end

  it "attaches a review to an existing matching cafe" do
    factory[:cafe, name: "Seven Seeds", lat: -37.8136, lng: 144.9631]

    visit "/reviews/new"

    fill_in "Cafe name", with: "Seven Seeds"
    fill_in "Cafe address", with: "123 Smith St, Melbourne"
    fill_in "Rating", with: "7"
    fill_in "Review", with: "Great coffee."

    click_on "Submit review"

    expect(page).to have_flash_message "Review created!", type: :notice
    expect(page).to have_content("Seven Seeds")
  end

  it "re-renders the form with errors for invalid input" do
    visit "/reviews/new"

    fill_in "Cafe name", with: "Seven Seeds"
    fill_in "Cafe address", with: "123 Smith St"
    # Leave rating and review body blank
    click_on "Submit review"

    expect(page).to have_field("Cafe name", with: "Seven Seeds")
    within page.find_field("Cafe name").ancestor("div") do
      expect(page).to have_no_content("must be filled")
    end

    expect(page).to have_field("Cafe address", with: "123 Smith St")
    within page.find_field("Cafe address").ancestor("div") do
      expect(page).to have_no_content("must be filled")
    end

    within page.find_field("Rating (1-10)").ancestor("div") do
      expect(page).to have_content("must be filled")
    end

    within page.find_field("Review").ancestor("div") do
      expect(page).to have_content("must be filled")
    end
  end
end
