module Test
  module DB
    module Helpers
      module_function

      def relations
        rom.relations
      end

      def rom
        Hanami.app["persistence.rom"]
      end

      def db
        Hanami.app["persistence.db"]
      end
    end
  end
end
