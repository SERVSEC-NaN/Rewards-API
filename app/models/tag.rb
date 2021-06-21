# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a tag
  class Tag < Sequel::Model
    many_to_many :promotions, left_key: :tag_id, right_key: :promotion_id,
                              join_table: :promotion_tags

    plugin :association_dependencies, promotions: :nullify

    plugin :validation_helpers
    plugin :whitelist_security
    plugin :timestamps, update_on_create: true

    set_allowed_columns :name

    def validate
      super
      validates_presence :name
      validates_unique   :name
    end

    def to_h
      {
        type: 'tag',
        attributes: { id: id, name: name },
        include: { promotions: promotions }
      }
    end

    def to_json(options = {})
      JSON(to_h, options)
    end
  end
end
