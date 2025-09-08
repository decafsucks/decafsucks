# frozen_string_literal: true

RSpec.describe "Account / Change email", :web, :db, :mail do
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
    click_on "Login"

    visit "/account/change-email"
    fill_in "Email", with: "jane-new@example.com"
    fill_in "Password", with: "password123"
    click_on "Change Login" # FIXME fix label

    expect(page).to have_flash_message(
      "An email has been sent to you with a link to verify your login change",
      type: :notice
    )

    expect(last_mail).to be_delivered_to("jane-new@example.com").with_subject "Verify Login Change"

    visit extract_mail_link
    click_on "Verify Login Change"

    expect(page).to have_flash_message "Your login change has been verified", type: :notice

    visit "/sign-out"
    click_on "Logout"

    # Old email does not work
    visit "/sign-in"
    fill_in "Email", with: "jane@example.com"
    fill_in "Password", with: "password123"
    click_on "Login"
    expect(page).to have_content "no matching login"

    # New email does work
    fill_in "Email", with: "jane-new@example.com"
    fill_in "Password", with: "password123"
    click_on "Login"

    expect(page).to have_flash_message "You have been logged in", type: :notice
  end
end
