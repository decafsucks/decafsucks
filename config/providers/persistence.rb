# frozen_string_literal: true

Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require "rom-changeset"
    require "rom/core"
    require "rom/sql"

    @config = ROM::Configuration.new(:sql, target["settings"].database_url)

    config.plugin(:sql, relations: :instrumentation) do |plugin_config|
      plugin_config.notifications = target["notifications"]
    end

    config.plugin(:sql, relations: :auto_restrictions)

    register "config", config
    register "db", config.gateways[:default].connection
  end

  start do
    @config.auto_registration target.root.join("lib/decafsucks/persistence")

    register "rom", ROM.container(@config)
  end
end
