# frozen_string_literal: true

RSpec.describe "Account / Reset password", :web, :db, :mail do
  specify do
    factory[
      :account,
      :verified,
      email: "jane@example.com",
      password_hash: BCrypt::Password.create("original-password")
    ]

    visit "/forgot-password"
    fill_in "Email", with: "jane@example.com"
    click_on "Send me a reset link"

    expect(last_mail).to be_delivered_to("jane@example.com").with_subject "Reset Password"

    visit extract_mail_link
    fill_in "Password", with: "new-password"
    click_on "Reset password"

    expect(page).to have_flash_message "Your password has been reset", type: :notice

    visit "/sign-out"
    click_on "Sign out"

    visit "/sign-in"
    fill_in "Email", with: "jane@example.com"
    fill_in "Password", with: "new-password"
    click_on "Sign in"

    expect(page).to have_flash_message "You have been signed in", type: :notice
  end
end
