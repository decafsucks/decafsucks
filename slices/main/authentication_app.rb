# frozen_string_literal: true

require "roda"
require "rodauth"
require "rodauth/hanami" # see lib/rodauth/hanami.rb

module Main
  class AuthenticationApp < Roda
    Hanami.app.start :mail

    plugin :middleware

    plugin :rodauth do
      enable :create_account, :verify_account, :login, :logout, :remember, :reset_password
      enable :hanami

      db Main::Slice["db.gateway"].connection
      use_database_authentication_functions? false
      account_password_hash_column :password_hash

      before_create_account do
        # Validate presence of name
        throw_error_status(422, "name", "must be present") if param("name").empty?
      end

      verify_account_set_password? false

      after_create_account do
        db[:users].insert(
          account_id: account[:id],
          name: param("name")
        )
      end

      after_login do
        remember_login
      end

      login_route "sign-in"
      logout_route "sign-out"
      create_account_route "sign-up"
      reset_password_request_route "forgot-password"
      reset_password_route "reset-password"
      verify_account_resend_route "resend-verify-account"
      remember_route nil # We default to always remembering. Don't expose remember preferences.

      already_logged_in { redirect "/" }

      hanami_base_view_class -> { Main::View }

      # Without this, Roda's render plugin tries to find a "views/layout.erb" in the root of this
      # app (which obviously doesn't exist) and raises an Errno::ENOENT error.
      template_opts layout: nil

      login_label "Email"
    end

    route do |r|
      r.rodauth
      env["rodauth"] = rodauth
    end
  end
end
