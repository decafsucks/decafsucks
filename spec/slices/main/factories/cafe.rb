# frozen_string_literal: true

Test::Factories::Main.define(:cafe) do |f|
  f.name { "#{fake(:coffee, :blend_name)} Cafe" }
  f.name_dmetaphone { |name| "cafe" } # TODO: add real double metaphone support
  f.address { fake(:address, :full_address) }
  f.lat { fake(:address, :latitude) }
  f.lng { fake(:address, :longitude) }
  f.rating { 1.upto(10).to_a.sample }
  f.created_at { Time.now }
end
