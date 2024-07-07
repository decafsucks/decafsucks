# frozen_string_literal: true

Test::Factories::Main.define(:user) do |f|
  f.email { fake(:internet, :email) }
  f.name { fake(:name, :name) }
  f.created_at { Time.now }
end
