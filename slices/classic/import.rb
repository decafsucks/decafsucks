# frozen_string_literal: true

module Classic
  # Loads the classic decafsucks content into the app database.
  #
  # Preserves primary keys from the classic rows. After loading these into each destination table,
  # its ID sequence is restarted at NEW_ID_START so newly created records never collide with
  # imported ones.
  #
  # The load is idempotent, so re-running is safe.
  #
  # Rows that can't satisfy the new database schema are skipped and tallied on the returned Report.
  class Import
    include Deps[
      classic_houses: "relations.houses",
      classic_users: "relations.users",
      classic_reviews: "relations.reviews",
      classic_login_accounts: "relations.login_accounts",
      gateway: "db.gateway",
      destination_cafes: "main.relations.cafes",
      destination_users: "main.relations.users",
      destination_reviews: "main.relations.reviews"
    ]

    # New app records start here; all imported classic IDs are lower.
    NEW_ID_START = 10_000

    # Destination tables whose identity sequences are pushed above the classic id range.
    RESET_TABLES = %i[cafes users reviews].freeze

    def call
      report = Report.new

      gateway.connection.transaction do
        import_cafes(report)
        import_users(report)
        import_reviews(report)
      end

      reset_sequences

      report
    end

    private

    def import_cafes(report)
      existing = id_set(destination_cafes)

      classic_houses.dataset.each do |house|
        id = house[:id]
        next report.already(:cafes) if existing.include?(id)

        if house[:lat].nil? || house[:lng].nil?
          next report.skip(:cafes, id, "missing lat/lng")
        end
        if house[:address].nil?
          next report.skip(:cafes, id, "missing address")
        end

        record(report, :cafes, id) { destination_cafes.upsert(cafe_tuple(house)) }
      end
    end

    def import_users(report)
      existing = id_set(destination_users)
      login_names = classic_login_accounts.dataset.select_hash(:user_id, :name)

      classic_users.dataset.each do |user|
        id = user[:id]
        next report.already(:users) if existing.include?(id)

        name = login_names[id] || "User #{id}"
        record(report, :users, id) { destination_users.upsert(user_tuple(user, name)) }
      end
    end

    def import_reviews(report)
      existing = id_set(destination_reviews)
      cafe_ids = id_set(destination_cafes)
      user_ids = id_set(destination_users)

      classic_reviews.dataset.each do |review|
        id = review[:id]
        next report.already(:reviews) if existing.include?(id)

        unless cafe_ids.include?(review[:house_id])
          next report.skip(:reviews, id, "cafe not imported")
        end
        unless user_ids.include?(review[:user_id])
          next report.skip(:reviews, id, "author not imported")
        end
        if review[:body].nil? || review[:rating].nil?
          next report.skip(:reviews, id, "missing body/rating")
        end

        record(report, :reviews, id) { destination_reviews.upsert(review_tuple(review)) }
      end
    end

    # Runs an upsert and records the outcome: a returned primary key means an insert happened; nil
    # means ON CONFLICT DO NOTHING swallowed a unique-constraint collision.
    def record(report, entity, id)
      if yield
        report.imported(entity)
      else
        report.skip(entity, id, "duplicate of an already-imported record")
      end
    end

    def cafe_tuple(house)
      {
        id: house[:id],
        name: house[:name],
        name_dmetaphone: Main::Cafes::Dmetaphone.of(house[:name]),
        address: house[:address],
        lat: house[:lat],
        lng: house[:lng],
        rating: house[:rating],
        reviews_count: house[:reviews_count] || 0,
        created_at: house[:created_at],
        last_reviewed_at: house[:last_reviewed_at],
        closed_at: house[:closed_at]
      }
    end

    def user_tuple(user, name)
      {
        id: user[:id],
        account_id: nil,
        name: name,
        reviews_count: user[:reviews_count] || 0,
        created_at: user[:created_at]
      }
    end

    def review_tuple(review)
      {
        id: review[:id],
        author_id: review[:user_id],
        cafe_id: review[:house_id],
        body: review[:body],
        rating: review[:rating],
        created_at: review[:created_at]
      }
    end

    def id_set(relation)
      relation.dataset.select_map(:id).to_set
    end

    # Pushes each destination sequence above the classic id range, so app-created records never
    # collide with imported ones.
    def reset_sequences
      connection = gateway.connection

      RESET_TABLES.each do |table|
        next_id = [NEW_ID_START, (connection[table].max(:id) || 0) + 1].max
        connection.run("ALTER TABLE #{table} ALTER COLUMN id RESTART WITH #{next_id}")
      end
    end

    # Tallies the outcome of an import run for a human-readable summary.
    class Report
      SAMPLE_LIMIT = 5

      def initialize
        @entities = Hash.new { |hash, entity| hash[entity] = new_entity }
      end

      def imported(entity)
        @entities[entity][:imported] += 1
      end

      def already(entity)
        @entities[entity][:already] += 1
      end

      def skip(entity, id, reason)
        @entities[entity][:skips][reason] << id
      end

      def to_s
        return "Nothing imported." if @entities.empty?

        @entities.map { |entity, data| entity_line(entity, data) }.join("\n")
      end

      private

      def new_entity
        {imported: 0, already: 0, skips: Hash.new { |hash, reason| hash[reason] = [] }}
      end

      def entity_line(entity, data)
        skipped = data[:skips].values.sum(&:size)

        parts = ["#{data[:imported]} imported"]
        parts << "#{data[:already]} already present" if data[:already].positive?
        parts << "#{skipped} skipped"

        line = "#{entity}: #{parts.join(", ")}"
        line += "\n#{skip_breakdown(data[:skips])}" unless data[:skips].empty?
        line
      end

      def skip_breakdown(skips)
        skips.map { |reason, ids|
          sample = ids.first(SAMPLE_LIMIT).join(", ")
          ellipsis = (ids.size > SAMPLE_LIMIT) ? ", …" : ""
          "    - #{reason}: #{ids.size} (ids: #{sample}#{ellipsis})"
        }.join("\n")
      end
    end
  end
end
