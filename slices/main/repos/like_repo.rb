# frozen_string_literal: true

module Main
  module Repos
    class LikeRepo < Main::DB::Repo
      # Records a like for the cafe.
      #
      # This is idempotent: a second like from the same user is a no-op.
      def like(user_id:, cafe_id:)
        likes.upsert(user_id:, cafe_id:)
      end

      def unlike(user_id:, cafe_id:)
        likes.where(user_id:, cafe_id:).delete
      end

      def liked?(user_id:, cafe_id:)
        likes.where(user_id:, cafe_id:).count.positive?
      end

      def count_for_cafe(cafe_id)
        likes.where(cafe_id:).count
      end
    end
  end
end
