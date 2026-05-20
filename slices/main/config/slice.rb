# frozen_string_literal: true

module Main
  class Slice < Hanami::Slice
    import keys: ["search"], from: :geocoding
  end
end
