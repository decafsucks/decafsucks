# frozen_string_literal: true

Test::Factories::Main.define(:like) do |f|
  f.association :user
  f.association :cafe
  f.created_at { Time.now }
end
