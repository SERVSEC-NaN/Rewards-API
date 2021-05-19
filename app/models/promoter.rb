# frozen_string_literal: true

require 'json'
require 'sequel'

module Rewards
  # Models a promoter
  class Promoter < Sequel::Model
    many_to_many :subscribers, left_key: :promoter_id, right_key: :subscriber_id,
                               join_table: :subscriptions

    one_to_many :promotions

    plugin :association_dependencies
    add_association_dependencies promotions: :destroy

    plugin :uuid, field: :id
    plugin :json_serializer
    plugin :validation_helpers
    plugin :whitelist_security
    plugin :timestamps, update_on_create: true

    set_allowed_columns :name, :organization, :email

    def name
      SecureDB.decrypt(name_secure)
    end

    def name=(plaintext)
      self.name_secure = SecureDB.encrypt plaintext
    end

    def validate
      validates_presence %i[name organization email]
      validates_unique %i[organization email]
      super
    end
  end
end
