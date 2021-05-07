# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:subscribers) do
      uuid :id, primary_key: true

      String :phone, unique: true
    end
  end
end
