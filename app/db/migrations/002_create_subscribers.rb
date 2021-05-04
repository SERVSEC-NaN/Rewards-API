# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:subscribers) do
      primary_key :id

      String :phone, unique: true
    end
  end
end
