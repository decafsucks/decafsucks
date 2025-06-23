# frozen_string_literal: true

module Main
  module Relations
    class Cafes < Main::DB::Relation
      schema :cafes, infer: true

      EARTH_RADIUS_KM = 6371.0

      def within_radius(lat:, lng:, radius_km:)
        # Calculate the bounding box
        lat_change = radius_km / 111.0  # 1 degree latitude is approximately 111 km
        lng_change = radius_km / (111.0 * Math.cos(lat * Math::PI / 180.0))

        sw_lat = lat - lat_change
        sw_lng = lng - lng_change
        ne_lat = lat + lat_change
        ne_lng = lng + lng_change

        # Create the distance calculation SQL
        distance_sql = <<~SQL
          #{EARTH_RADIUS_KM} * 2 * ASIN(SQRT(
            POWER(SIN((RADIANS(cafes.lat) - RADIANS(#{lat}))/2), 2) +
            COS(RADIANS(#{lat})) * COS(RADIANS(cafes.lat)) *
            POWER(SIN((RADIANS(cafes.lng) - RADIANS(#{lng}))/2), 2)
          ))
        SQL

        # Build the complete SQL query
        sql = <<~SQL
          SELECT cafes.*,
                 #{distance_sql} AS distance
          FROM cafes
          WHERE cafes.lat >= #{sw_lat} AND cafes.lat <= #{ne_lat}
            AND cafes.lng >= #{sw_lng} AND cafes.lng <= #{ne_lng}
            AND #{distance_sql} <= #{radius_km}
          ORDER BY distance ASC
        SQL

        # Use a wrapped dataset with raw SQL
        rom_sql_relation = ROM::SQL::Relation.new(dataset.class.new(dataset.db).with_sql(sql), schema: schema)
        new(rom_sql_relation.dataset)
      end
    end
  end
end
