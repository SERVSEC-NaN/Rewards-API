# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:promotion_tags) do
      foreign_key :tag_id, :tags, null: false
      foreign_key :promotion_id, :promotions, null: false
      DateTime :created_at
      DateTime :updated_at
      primary_key %i[promotion_id tag_id]
      index %i[promotion_id tag_id]
    end
  end
end
