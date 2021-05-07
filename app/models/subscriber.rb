# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a subscriber
  class Subscriber < Sequel::Model
    one_to_many :subscriptions

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
