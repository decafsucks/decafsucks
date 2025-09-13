# frozen_string_literal: true

require "rodauth"

# The Hanami integration feature for Rodauth.
#
# Allows Rodauth templates to be copied into your app and be rendered through a Hanami::View class.
# Templates are searched for under `templates/authentication_app/` (this may later become
# configurable).
#
# Must be configured with a `hanami_view_class`, containing a proc that returns the view class.
#
# @example
#   # Inside a `plugin :rodauth` block
#   enable :hanami
#   hanami_view_class -> { MyApp::View }
Rodauth::Feature.define(:hanami) do
  auth_value_method :hanami_view_class, nil

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
      context: view_context
    )
  end

  def view_context
    @view_context ||= begin
      action_request = Hanami::Action::Request.new(
        env: request.env,
        params: request.params,
        session_enabled: true
      )

      base_view.config.default_context.class.new(request: action_request)
    end
  end

  def base_view
    @base_view ||= Class.new(hanami_view_class.call).new
  end
end
