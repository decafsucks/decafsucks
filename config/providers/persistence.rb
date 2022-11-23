# frozen_string_literal: true

Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom-changeset"
    require "rom/core"
    require "rom/sql"

    rom_config = ROM::Configuration.new(:sql, target["settings"].database_url)

    rom_config.plugin(:sql, relations: :instrumentation) do |plugin_config|
      plugin_config.notifications = target["notifications"]
    end

    rom_config.plugin(:sql, relations: :auto_restrictions)

    register "config", rom_config
    register "db", rom_config.gateways[:default].connection
  end

  start do
    rom_config = target["persistence.config"]
    rom_config.auto_registration target.root.join("lib/decafsucks/persistence")

    register "rom", ROM.container(rom_config)
  end
end
