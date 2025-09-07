# frozen_string_literal: true

RSpec.describe "Account / Signing up", :web, :db do
  specify do
    visit "/sign-up"

    fill_in "Name", with: "Jane"
    fill_in "Email", with: "jane@example.com"
    fill_in "Password", with: "princess-of-power"
    fill_in "Confirm Password", with: "princess-of-power"
    click_on "Create Account"

    # TODO: flash message selector
    expect(page).to have_content("An email has been sent to you with a link to verify your account")

    verify_account_path = Mail::TestMailer.deliveries.last.body.to_s
      .scan(%r{https?://[^\s]+})
      .first
      .then { URI(_1) }
      .then { "#{_1.path}?#{_1.query}" }

    visit verify_account_path
    click_on "Verify Account"

    expect(page).to have_content("Your account has been verified")
  end
end
