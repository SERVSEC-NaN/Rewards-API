# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a tag
  class Tag < Sequel::Model
    many_to_many :subscriptions

    plugin :json_serializer
    plugin :validation_helpers

    def validate
      super
      validates_presence :name
      validates_unique   :name
    end
  end
end
