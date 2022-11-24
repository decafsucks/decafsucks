require "rom-factory"
require_relative "helpers"

class ROM::Factory::Factories
  # @api private
  def infer_factory_name(name)
    Hanami.app["inflector"].singularize(name).to_sym
  end

  # @api private
  def infer_relation(name)
    Hanami.app["inflector"].pluralize(name).to_sym
  end
end

module Test
  Factory = ROM::Factory.configure { |config|
    config.rom = Test::DB::Helpers.rom
  }

  module DB
    class FactoryHelper < Module
      attr_reader :type

      def initialize(type = nil)
        @type = type

        # factory = entity_namespace ? Factory.struct_namespace(entity_namespace) : Factory
        factory = Test::Factory

        define_method(:factory) do
          factory
        end
      end

      # TODO: reenable later
      #
      # def entity_namespace
      #   @entity_namespace ||=
      #     begin
      #       case type
      #       when :main
      #         Main::Entities
      #       else
      #         AppPrototype::Entities
      #       end
      #     end
      # end
    end
  end
end

Dir[SPEC_ROOT.join("factories/**/*.rb")].each { require(_1) }
