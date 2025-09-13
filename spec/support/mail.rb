# require_with_metadata: true
# frozen_string_literal: true

require "mail"

module Test
  module Mail
    module Helpers
      def last_mail
        ::Mail::TestMailer.deliveries.last
      end

      def extract_mail_link(mail = last_mail, match: nil)
        body = mail.body.to_s
        urls = body.scan(%r{https?://[^\s]+})
        urls = urls.select { |url| url.match?(match) } if match
        urls.first
      end
    end
  end
end

RSpec.configure do |config|
  config.include Test::Mail::Helpers, :mail

  config.before :each, :mail do
    Mail::TestMailer.deliveries.clear
  end
end

RSpec::Matchers.define :be_delivered_to do |expected_address|
  chain :with_subject do |expected_subject|
    @expected_subject = expected_subject
  end

  match do |mail|
    delivered = mail&.to&.include?(expected_address)
    subject_matches = @expected_subject.nil? || mail.subject == @expected_subject
    delivered && subject_matches
  end

  failure_message do |mail|
    msg = "expected mail to be delivered to #{expected_address}"
    msg += " with subject '#{@expected_subject}'" if @expected_subject
    msg += ", but got to #{mail&.to.inspect} with subject #{mail&.subject.inspect}"
    msg
  end
end
