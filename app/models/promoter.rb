# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a promoter
  class Promoter < Sequel::Model
    one_to_many :subscriptions

    plugin :uuid, field: :id
    plugin :json_serializer
    plugin :validation_helpers
    plugin :whitelist_security

    set_allowed_columns :name, :organization, :email

    def name
      SecureDB.decrypt(name_secure)
    end

    def name=(plaintext)
      self.name_secure = SecureDB.encrypt plaintext
    end

    def validate
      validates_presence %i[name organization email]
      validates_unique %i[organization email subscriptions]
      super
    end
  end
end
