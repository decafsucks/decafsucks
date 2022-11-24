module Main
  module Actions
    module Home
      class Show < Main::Action
        include Deps[view: "views.cafes.index"]

        def handle(*, response)
          response.render(view)
        end
      end
    end
  end
end
