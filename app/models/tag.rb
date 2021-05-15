# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a tag
  class Tag < Sequel::Model
    many_to_many :subscriptions, left_key: :tag_id, right_key: :subscription_id,
                                 join_table: :subscriptions_tags

    plugin :json_serializer
    plugin :validation_helpers
    plugin :whitelist_security

    set_allowed_columns :name

    def validate
      super
      validates_presence :name
      validates_unique   :name
    end
  end
end
