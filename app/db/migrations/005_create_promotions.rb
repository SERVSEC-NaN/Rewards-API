# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:promotions) do
      primary_key :id
      # Table that foreign key references needs to be set explicitly
      # for a database foreign key reference to be created.
      foreign_key :promoter_id, table: :promoters, type: 'uuid'

      String :title, null: false
      String :description, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
