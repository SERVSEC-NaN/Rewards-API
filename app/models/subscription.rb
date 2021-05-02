# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a subscription
  class Subscription < Sequel::Model
    one_to_many :subscribers
    many_to_many :tags

    plugin :json_serializer
    plugin :validation_helpers

    def validate
      super
      validates_presence %i[title description tags]
    end
  end
end
