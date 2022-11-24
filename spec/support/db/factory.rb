require "rom-factory"
require_relative "helpers"

module Test
  Factory = ROM::Factory.configure { |config|
    config.rom = Test::DB::Helpers.rom
  }

  module DB
    class FactoryHelper < Module
      ENTITIES_MODULE_NAME = :Entities

      attr_reader :slice_name

      def initialize(slice_name = nil)
        @slice_name = slice_name

        factory = entity_namespace ? Test::Factory.struct_namespace(entity_namespace) : Factory

        define_method(:factory) do
          factory
        end
      end

      private

      def entity_namespace
        return @entity_namespace if instance_variable_defined?(:@entity_namespace)

        slice = slice_name ? Hanami.app.slices[slice_name] : Hanami.app
        slice_namespace = slice.namespace

        @entity_namespace =
          if slice_namespace.const_defined?(ENTITIES_MODULE_NAME)
            slice_namespace.const_get(ENTITIES_MODULE_NAME)
          end
      end
    end
  end
end

# Patch rom-factory to use our app inflector
#
# TODO(rom-factory): Support a configurable inflector
class ROM::Factory::Factories
  module Fixes
    def infer_factory_name(name)
      Hanami.app["inflector"].singularize(name).to_sym
    end

    def infer_relation(name)
      Hanami.app["inflector"].pluralize(name).to_sym
    end
  end

  prepend Fixes
end

Dir[SPEC_ROOT.join("factories/**/*.rb")].each { require(_1) }
