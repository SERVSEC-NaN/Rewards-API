# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:tags) do
      uuid :id, primary_key: true
      String :name, unique: true, null: false
    end
  end
end
