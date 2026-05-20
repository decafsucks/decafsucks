# frozen_string_literal: true

module Main
  module Views
    module Reviews
      class New < Main::View
        expose :errors, default: {}
      end
    end
  end
end
