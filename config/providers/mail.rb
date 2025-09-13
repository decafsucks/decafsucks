Hanami.app.register_provider :mail do
  prepare do
    require "mail"
  end

  start do
    Mail.defaults do
      if Hanami.env == :development
        # Deliver to Mailpit
        delivery_method :smtp, address: "127.0.0.1", port: 1025
      elsif Hanami.env == :test
        # Deliver to Mail::TestMailer.deliveries
        delivery_method :test
      end
    end
  end
end
