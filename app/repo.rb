# auto_register: false
# frozen_string_literal: true

require "rom-repository"

module Decafsucks
  class Repo < ROM::Repository::Root
    # TODO(Hanami): this line will not be needed once Hanami's persistence layer is released
    include Deps[container: "persistence.rom"]
  end
end
