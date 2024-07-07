# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :cafes do
      primary_key :id
      column :name, :text, null: false
      column :name_dmetaphone, :text, null: false
      column :address, :text, null: false
      column :lat, :decimal, null: false
      column :lng, :decimal, null: false
      column :rating, :integer
      column :reviews_count, :integer, null: false, default: 0
      column :created_at, :timestamp, null: false, default: Sequel.lit("(now() at time zone 'utc')")
      column :last_reviewed_at, :timestamp
      column :closed_at, :timestamp
    end
  end
end
