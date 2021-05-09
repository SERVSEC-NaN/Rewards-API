# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a subscriber
  class Subscriber < Sequel::Model
    many_to_many :subscriptions, left_key: :subscription_id, right_key: :subscriber_id,
                                 join_table: :subscriptions_subscribers

    plugin :uuid, field: :id
    plugin :json_serializer
    plugin :validation_helpers

    def validate
      super
      validates_presence :phone
      validates_unique   :phone
    end
  end
end
