# frozen_string_literal: true

require "roda"
require "rodauth"
require "rodauth/hanami" # see lib/rodauth/hanami.rb

module Main
  # Provides a Roda app to be used for Rodauth-based authentication.
  #
  # This app is used as a middleware in our routes.
  #
  # @see config/routes.rb
  # @see https://rodauth.jeremyevans.net
  class AuthenticationApp < Roda
    # Start the mail provider for Rodauth's email deliveries.
    Hanami.app.start :mail

    # Activate this Roda app (which includes the Rodauth features configured below) as a middleware,
    # so we can include it in Hanami's routes.
    #
    # @see config/routes.rb
    plugin :middleware

    plugin :rodauth do
      # Enable standard Rodauth features
      enable(
        :change_login,
        :change_password,
        :change_password_notify,
        :create_account,
        :login,
        :logout,
        :remember,
        :reset_password,
        :verify_account,
        :verify_login_change
      )

      # Enable and configure our own Rodauth/Hanami integration feature
      #
      # @see lib/rodauth/hanami.rb
      enable :hanami
      hanami_view_class -> { Main::View }

      # Use our own database connection, and simplify database operation: keep the password hash
      # column directly in the accounts table, and skip using database-level functions.
      db Main::Slice["db.gateway"].connection
      account_password_hash_column :password_hash
      use_database_authentication_functions? false

      require_password_confirmation? false
      verify_account_set_password? false

      # Configure redirects for signing in and out
      login_return_to_requested_location? true
      logout_redirect "/"

      # When signing up, save a user `name` into a new `users` record and associate it with the new
      # account.
      before_create_account do
        throw_error_status(422, "name", "must be present") if param("name").empty?
      end
      after_create_account do
        db[:users].insert(
          account_id: account[:id],
          name: param("name")
        )
      end

      # Always remember logins across sessions (aka "Remember me").
      after_login do
        remember_login
      end

      # Customize routes for Rodauth screens
      change_login_route "account/change-email"
      change_password_route "account/change-password"
      create_account_route "sign-up"
      login_route "sign-in"
      logout_route "sign-out"
      remember_route nil # We remember always. Don't expose user preferences route.
      reset_password_request_route "forgot-password"
      reset_password_route "reset-password"
      verify_account_resend_route "resend-verify-account"
      verify_login_change_route "verify-email-change"

      flash_error_key :alert

      already_logged_in { redirect "/" }

      # Without this, Roda's render plugin tries to find a "views/layout.erb" in the root of this
      # app (which obviously doesn't exist) and raises an Errno::ENOENT error.
      template_opts layout: nil

      # Customize UI copy. Prefer "sign in/out" phrasing, and sentence case over title case.
      #
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
      # Save the Rodauth instance in the Rack request environment, so we can access it from a Hanami
      # Action and require authentication from there.
      #
      # @see slices/main/actions/authenticated.rb
      env["rodauth"] = rodauth

      # Enable the routes for the Rodauth features configured above.
      r.rodauth
    end
  end
end
