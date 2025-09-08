# frozen_string_literal: true

RSpec.describe "Account / Signing in and out", :web, :db do
  specify do
    factory[
      :account,
      :verified,
      email: "jane@example.com",
      password_hash: BCrypt::Password.create("password123")
    ]

    visit "/sign-in"
    fill_in "Email", with: "jane@example.com"
    fill_in "Password", with: "password123"
    click_on "Sign in"

    expect(page).to have_flash_message "You have been signed in", type: :notice
    expect(current_path).to eq "/"

    visit "/sign-in"
    expect(current_path).to eq "/"

    visit "/sign-out"
    click_on "Sign out"

    expect(page).to have_flash_message "You have been signed out", type: :notice
    expect(current_path).to eq "/"
  end
end
