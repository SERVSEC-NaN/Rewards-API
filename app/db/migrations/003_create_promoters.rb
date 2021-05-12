# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:promoters) do
      uuid :id, primary_key: true
      foreign_key :subscription_id, table: :subscriptions

      String :name, null: false
      String :organization, unique: true, null: false
      String :email, unique: true, null: false
    end
  end
end
