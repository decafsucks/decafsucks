require "dry/system"
require "hanami/providers/rack"

# FIXME(Hanami): this needs to be upstreamed
module Hanami
  module Providers
    class Rack < Dry::System::Provider::Source
      module Fixes
        def start
          notifications = target[:notifications]

          notifications.register_event(Dry::Monitor::Rack::Middleware::REQUEST_START)
          notifications.register_event(Dry::Monitor::Rack::Middleware::REQUEST_STOP)
          notifications.register_event(Dry::Monitor::Rack::Middleware::REQUEST_ERROR)

          super
        end
      end

      prepend Fixes
    end
  end
end
