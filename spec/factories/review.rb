# frozen_string_literal: true

Test::Factory.define(:review) do |f|
  f.association :author
  f.association :cafe
  f.body { fake(:hipster, :paragraph) }
  f.rating { 1.upto(10).to_a.sample }
  f.created_at { Time.now }
end
