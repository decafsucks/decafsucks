# frozen_string_literal: true

module Classic
  module Relations
    # Legacy reviews.
    class Reviews < Classic::DB::Relation
      gateway :classic
      schema :reviews, infer: true
    end
  end
end
