# frozen_string_literal: true

RSpec::Matchers.define :have_flash_message do |expected_text, type: nil|
  match do |page|
    selector = ".flash"
    selector += "-#{type}" if type

    page.has_css?(selector, text: expected_text)
  end

  failure_message do |page|
    "expected that the page would have a flash message#{type_failure_message(type)} with text: #{expected_text}"
  end

  failure_message_when_negated do |page|
    "expected that the page would not have a flash message#{type_failure_message(type)} with text: #{expected_text}"
  end

  def type_failure_message(type)
    type ? " of type #{type}" : ""
  end
end
