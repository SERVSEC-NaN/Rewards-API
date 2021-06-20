# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a promotion
  class Promotion < Sequel::Model
    many_to_many :tags, left_key: :promotion_id, right_key: :tag_id,
                        join_table: :promotion_tags

    plugin :association_dependencies, tags: :nullify

    many_to_one :promoters

    plugin :validation_helpers
    plugin :whitelist_security
    plugin :timestamps, update_on_create: true

    set_allowed_columns :title, :description

    def validate
      super
      validates_presence %i[title description]
    end

    def to_json(options = {})
      JSON(to_h, options)
    end

    def to_h
      {
        type: 'promotion',
        attributes: { id: id, title: title, description: description },
        include: { promoter_id: promoter_id, tags: tags }
      }
    end
  end
end
