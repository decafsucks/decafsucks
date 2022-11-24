# auto_register: false
# frozen_string_literal: true

module Main
  class View < Decafsucks::View
    # FIXME(Hanami): base slice views should override paths from the base app view
    config.paths = [File.join(File.expand_path(__dir__), "templates")]
  end
end
