# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a promoter
  class Promoter < Sequel::Model
    one_to_many  :subscriptions

    plugin :json_serializer
    plugin :validation_helpers

    def validate
      super
      validates_presence %i[name organization email]
      validates_unique %i[organization email subscriptions]
    end
  end
end
