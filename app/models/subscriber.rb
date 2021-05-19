# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a subscriber
  class Subscriber < Sequel::Model
    many_to_many :promoters, left_key: :subscriber_id, right_key: :promoter_id,
                             join_table: :subscriptions

    plugin :association_dependencies, promoters: :nullify

    plugin :uuid, field: :id
    plugin :json_serializer
    plugin :validation_helpers
    plugin :whitelist_security
    plugin :timestamps, update_on_create: true

    set_allowed_columns :phone

    def validate
      super
      validates_presence :phone
      validates_unique   :phone
    end
  end
end
