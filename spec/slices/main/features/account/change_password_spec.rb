# frozen_string_literal: true

RSpec.describe "Account / Change password", :web, :db, :mail do
  specify do
    factory[
      :account,
      :verified,
      email: "jane@example.com",
      password_hash: BCrypt::Password.create("password123")
    ]

    # TODO: Replace with helper to have user already signed in
    visit "/sign-in"
    fill_in "Email", with: "jane@example.com"
    fill_in "Password", with: "password123"
    click_on "Sign in"

    visit "/account/change-password"
    fill_in "Password", with: "password123"
    fill_in "New Password", with: "new-password"
    click_on "Change Password"

    expect(page).to have_flash_message "Your password has been changed", type: :notice

    visit "/sign-out"
    click_on "Sign out"

    # Old password does not work
    visit "/sign-in"
    fill_in "Email", with: "jane@example.com"
    fill_in "Password", with: "password123"
    click_on "Sign in"
    expect(page).to have_content "invalid password"

    fill_in "Password", with: "new-password"
    click_on "Sign in"

    expect(page).to have_flash_message "You have been signed in", type: :notice
  end
end
