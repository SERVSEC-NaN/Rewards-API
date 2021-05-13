# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a promoter
  class Promoter < Sequel::Model
    one_to_many :subscriptions, left_key: :promoter_id, right_key: :subscription_id,
                                join_table: :subscriptions_promoters

    plugin :uuid, field: :id
    plugin :json_serializer
    plugin :validation_helpers
    plugin :whitelist_security

    set_allowed_columns :name, :organization, :email

    def validate
      super
      validates_presence %i[name organization email]
      validates_unique %i[organization email subscriptions]
    end
  end
end
