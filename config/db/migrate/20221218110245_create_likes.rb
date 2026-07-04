# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :likes do
      primary_key :id
      foreign_key :user_id, :users, null: false
      foreign_key :cafe_id, :cafes, null: false
      column :created_at, :timestamp, null: false, default: Sequel.lit("(now() at time zone 'utc')")

      index %i[user_id cafe_id], unique: true
    end
  end
end
