# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:subscribers) do
      uuid :id, primary_key: true
      String :phone, unique: true
      String :email, unique: true
      String :password_digest
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
