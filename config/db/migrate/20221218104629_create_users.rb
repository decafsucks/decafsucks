# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :users do
      primary_key :id
      column :email, :text, null: false
      column :name, :text, null: false

      column :password_hash, :text

      column :reviews_count, :integer, null: false, default: 0
      column :created_at, :timestamp, null: false, default: Sequel.lit("(now() at time zone 'utc')")
    end
  end
end
