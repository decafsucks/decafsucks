# frozen_string_literal: true

RSpec.describe "Account / Signing up", :web, :db, :mail do
  specify do
    visit "/sign-up"

    fill_in "Name", with: "Jane"
    fill_in "Email", with: "jane@example.com"
    fill_in "Password", with: "princess-of-power"
    fill_in "Confirm Password", with: "princess-of-power"
    click_on "Create Account"

    expect(page).to have_flash_message "An email has been sent to you with a link to verify your account", type: :notice

    expect(last_mail).to be_delivered_to("jane@example.com").with_subject "Verify Account"

    visit extract_mail_link
    click_on "Verify Account"

    expect(page).to have_flash_message "Your account has been verified", type: :notice
  end
end
