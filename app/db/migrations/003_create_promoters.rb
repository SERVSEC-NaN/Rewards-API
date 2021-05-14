# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:promoters) do
      uuid :id, primary_key: true
      String :name_secure, null: false
      String :organization, unique: true, null: false
      String :email, unique: true, null: false
    end
  end
end
