# frozen_string_literal: true

Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom-changeset"
    require "rom/core"
    require "rom/sql"

    # TODO(Hanami): As part of built-in rom setup, configure ROM with app inflector
    silence_warnings { ROM::Inflector = Hanami.app["inflector"] }

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
    rom_config.auto_registration(
      target.root.join("lib/decafsucks/persistence"),
      namespace: "Decafsucks::Persistence"
    )

    register "rom", ROM.container(rom_config)
  end

  define_method(:silence_warnings) do |&block|
    orig_verbose = $VERBOSE
    $VERBOSE = nil
    result = block.call
    $VERBOSE = orig_verbose
    result
  end
end
