# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:subscriptions) do
      foreign_key :subscriber_id, :subscribers, null: false, type: 'uuid'
      foreign_key :promoter_id, :promoters, null: false, type: 'uuid'
      DateTime :created_at
      DateTime :updated_at
      primary_key %i[subscriber_id promoter_id]
      index %i[subscriber_id promoter_id]
    end
  end
end
