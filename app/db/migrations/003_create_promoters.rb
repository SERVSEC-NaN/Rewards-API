# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:promoters) do
      uuid :id, primary_key: true
      String :email, unique: true, null: false
      String :name_secure, null: false
      String :organization, unique: true, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
