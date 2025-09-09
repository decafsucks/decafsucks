# frozen_string_literal: true

require "roda"
require "rodauth"

Rodauth::Feature.define(:hanami_view) do
  # Renders templates with layout.
  def view(template, title)
    return super unless view_template?(template)

    view_rendering.template(
      base_view.class.layout_path(base_view.config.layout),
      view_rendering.scope(rodauth: self)
    ) { render(template) }
  end

  # Renders templates without layout.
  def render(template)
    return super unless view_template?(template)

    view_rendering.template(
      view_template_name(template),
      view_rendering.scope(rodauth: self)
    )
  end

  private

  def view_template?(template_name)
    view_rendering.renderer.send(
      :lookup,
      view_template_name(template_name),
      base_view.config.default_format
    )
  end

  def view_template_name(template_name)
    "authentication_app/#{template_name.tr("-", "_")}"
  end

  def view_rendering
    @view_rendering ||= base_view.rendering(
      format: base_view.config.default_format,
      context: base_view.config.default_context
    )
  end

  def base_view
    @base_view ||= Class.new(Main::View).new
  end
end

module Main
  class AuthenticationApp < Roda
    plugin :middleware

    plugin :rodauth do
      enable :create_account, :login, :logout
      enable :hanami_view

      db Main::Slice["db.gateway"].connection
      use_database_authentication_functions? false
      account_password_hash_column :password_hash

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

      login_route "sign-in"
      logout_route "sign-out"
      create_account_route "sign-up"

      already_logged_in { redirect "/" }

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
