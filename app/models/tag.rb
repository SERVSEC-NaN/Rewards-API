# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a tag
  class Tag < Sequel::Model
    many_to_many :promotions, left_key: :tag_id, right_key: :promotion_id,
                              join_table: :promotion_tags

    plugin :association_dependencies, promotions: :nullify

    plugin :json_serializer
    plugin :validation_helpers
    plugin :whitelist_security
    plugin :timestamps, update_on_create: true

    set_allowed_columns :name

    def validate
      super
      validates_presence :name
      validates_unique   :name
    end
  end
end
