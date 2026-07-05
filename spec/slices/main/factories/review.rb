# frozen_string_literal: true

Test::Factories::Main.define(:review) do |f|
  f.association :user
  f.association :cafe
  f.body { fake(:hipster, :paragraph) }
  f.visited_on { Date.today }
  f.good_cup { [true, false, nil].sample }
  f.created_at { Time.now }
end
