# auto_register: false
# frozen_string_literal: true

require "text"

module Main
  module Cafes
    # Phonetic key for matching cafe names across spelling variations. The find and insert
    # paths must agree on the calculation.
    module Dmetaphone
      module_function

      def of(name)
        Text::Metaphone.double_metaphone(name).first
      end
    end
  end
end
