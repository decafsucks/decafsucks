module Main
  module Actions
    module Home
      class Show < Main::Action
        def handle(*, response)
          response.render(view)
        end
      end
    end
  end
end
