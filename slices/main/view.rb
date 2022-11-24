# auto_register: false
# frozen_string_literal: true

module Main
  class View < Decafsucks::View
    # TODO: fix this upstream
    config.paths = [File.join(File.expand_path(__dir__), "templates")]
  end
end
