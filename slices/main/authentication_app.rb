# frozen_string_literal: true

require "roda"
require "rodauth"
require "rodauth/hanami" # see lib/rodauth/hanami.rb

module Main
  class AuthenticationApp < Roda
    Hanami.app.start :mail

    plugin :middleware

    plugin :rodauth do
      enable :create_account,
        :verify_account,
        :login,
        :logout,
        :remember,
        :reset_password,
        :change_login,
        :verify_login_change,
        :change_password,
        :change_password_notify

      enable :hanami

      db Main::Slice["db.gateway"].connection
      use_database_authentication_functions? false
      account_password_hash_column :password_hash

      require_password_confirmation? false
      verify_account_set_password? false

      before_create_account do
        # Validate presence of name
        throw_error_status(422, "name", "must be present") if param("name").empty?
      end

      after_create_account do
        db[:users].insert(
          account_id: account[:id],
          name: param("name")
        )
      end

      login_return_to_requested_location? true

      after_login do
        remember_login
      end

      logout_redirect "/"

      # Customize routes
      login_route "sign-in"
      logout_route "sign-out"
      create_account_route "sign-up"
      reset_password_request_route "forgot-password"
      reset_password_route "reset-password"
      verify_account_resend_route "resend-verify-account"
      remember_route nil # We remember always. Don't expose user preferences route.
      change_login_route "account/change-email"
      verify_login_change_route "verify-email-change"
      change_password_route "account/change-password"

      flash_error_key :alert

      already_logged_in { redirect "/" }

      hanami_base_view_class -> { Main::View }

      # Without this, Roda's render plugin tries to find a "views/layout.erb" in the root of this
      # app (which obviously doesn't exist) and raises an Errno::ENOENT error.
      template_opts layout: nil

      # Customize UI copy

      # Base
      unverified_account_message "unverified account, please verify before signing in"

      # Require login
      require_login_error_flash "Please sign in to continue"

      # Login
      login_button "Sign in"
      login_error_flash "There was an error signing in"
      login_form_footer_links_heading %(<h2 class="rodauth-login-form-footer-links-heading">Other options</h2>)
      login_label "Email"
      login_notice_flash "You have been signed in"
      no_matching_login_message "no matching account"

      # Logout
      logout_notice_flash "You have been signed out"
      logout_button "Sign out"

      # Create account
      create_account_link_text "Sign up"

      # Verify account
      verify_account_resend_link_text "Resend my account verification"

      # Reset password
      reset_password_button "Reset password"
      reset_password_request_button "Send me a reset link"
      reset_password_request_link_text "Forgot password?"
    end

    route do |r|
      r.rodauth
      env["rodauth"] = rodauth
    end
  end
end
