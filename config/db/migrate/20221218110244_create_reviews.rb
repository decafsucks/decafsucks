# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :reviews do
      primary_key :id
      foreign_key :author_id, :users, null: false
      foreign_key :cafe_id, :cafes, null: false
      column :body, :text, null: false
      column :rating, :integer, null: false
      column :created_at, :timestamp, null: false, default: Sequel.lit("(now() at time zone 'utc')")
    end
  end
end
