# frozen_string_literal: true

module Classic
  class Slice < Hanami::Slice
    # Destination relations for the import. They live in `main` and run on this slice's default
    # gateway (the app database); the source relations below run on the separate `:classic` gateway.
    import keys: %w[
      relations.cafes
      relations.users
      relations.reviews
    ], from: :main
  end
end
