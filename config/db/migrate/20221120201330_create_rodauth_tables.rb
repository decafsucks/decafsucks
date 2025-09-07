# frozen_string_literal: true

# Adapted from https://rodauth.jeremyevans.net/rdoc/files/README_rdoc.html
ROM::SQL.migration do
  up do
    extension :date_arithmetic

    # Used by the account verification and close account features
    create_table :account_statuses do
      Integer :id, primary_key: true
      String :name, null: false, unique: true
    end
    from(:account_statuses).import([:id, :name], [[1, "Unverified"], [2, "Verified"], [3, "Closed"]])

    create_table :accounts do
      primary_key :id, type: :Bignum
      foreign_key :status_id, :account_statuses, null: false, default: 1
      citext :email, null: false
      String :password_hash, null: false
      constraint :valid_email, email: /^[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+$/
      index :email, unique: true, where: {status_id: [1, 2]}
    end

    deadline_opts = proc do |days|
      {null: false, default: Sequel.date_add(Sequel::CURRENT_TIMESTAMP, days: days)}
    end

    # Used by the password reset feature
    create_table :account_password_reset_keys do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      String :key, null: false
      DateTime :deadline, deadline_opts[1]
      DateTime :email_last_sent, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    # Used by the account verification feature
    create_table :account_verification_keys do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      String :key, null: false
      DateTime :requested_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :email_last_sent, null: false, default: Sequel::CURRENT_TIMESTAMP
    end

    # Used by the remember me feature
    create_table :account_remember_keys do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      String :key, null: false
      DateTime :deadline, deadline_opts[14]
    end

    # Used by the email auth feature
    create_table :account_email_auth_keys do
      foreign_key :id, :accounts, primary_key: true, type: :Bignum
      String :key, null: false
      DateTime :deadline, deadline_opts[1]
      DateTime :email_last_sent, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(
      :account_email_auth_keys,
      :account_remember_keys,
      :account_verification_keys,
      :account_password_reset_keys,
      :accounts,
      :account_statuses
    )
  end
end
