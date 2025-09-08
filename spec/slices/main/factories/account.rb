# frozen_string_literal: true

require "bcrypt"

Test::Factories::Main.define(:account) do |f|
  f.email { fake(:internet, :email) }
  f.password_hash { BCrypt::Password.create("password") }
  f.association(:user)

  f.trait :verified do |t|
    t.status_id 2
  end
end
