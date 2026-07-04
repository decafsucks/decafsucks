# frozen_string_literal: true

module Classic
  module Relations
    # Legacy cafes. Maps to the new `cafes` table.
    class Houses < Classic::DB::Relation
      gateway :classic
      schema :houses, infer: true
    end
  end
end
