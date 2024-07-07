require "rom-factory"

# Patch rom-factory to use the app inflector
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

module Test
  # Module to contain factory builders for each slice
  module Factories
    def self.factories
      @factories ||= {}
    end

    def self.[](slice)
      factories.fetch(slice)
    end

    def self.[]=(slice, factory)
      const_set(slice.slice_name.namespace_name, factory)

      factories[slice] = factory
    end

    def self.build_factories
      Dir[SPEC_ROOT.join("slices", "*")].each do |slice_dir|
        slice_name = File.basename(slice_dir).to_sym
        slice = Hanami.app.slices[slice_name]

        factory = ROM::Factory.configure { |config|
          config.rom = slice["db.rom"]
        }

        self[slice] = factory

        Dir[File.join(slice_dir, "factories", "**", "*.rb")].each { require(_1) }
      end
    end

    build_factories
  end

  module DB
    class FactoryHelper < Module
      STRUCT_MODULE_NAME = :Structs

      attr_reader :slice

      def initialize(slice = nil)
        @slice = slice || Hanami.app

        struct_namespace = self.struct_namespace
        define_method(:factory) do
          factory = Test::Factories[slice]

          if struct_namespace
            factory = factory.struct_namespace(struct_namespace)
          end

          factory
        end
      end

      private

      def struct_namespace
        return @struct_namespace if instance_variable_defined?(:@struct_namespace)

        @struct_namespace =
          if slice.namespace.const_defined?(STRUCT_MODULE_NAME)
            slice.namespace.const_get(STRUCT_MODULE_NAME)
          end
      end
    end
  end
end
