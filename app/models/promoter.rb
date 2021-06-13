# frozen_string_literal: true

require_relative 'account'

module Rewards
  # Models a promoter
  class Promoter < Sequel::Model
    include Account

    one_to_many :promotions
    many_to_many :subscribers, left_key: :promoter_id, right_key: :subscriber_id,
                               join_table: :subscriptions

    plugin :association_dependencies, promotions: :destroy
    plugin :uuid, field: :id
    plugin :validation_helpers
    plugin :whitelist_security
    plugin :timestamps, update_on_create: true

    set_allowed_columns :name, :organization, :email, :password

    def validate
      super
      validates_presence %i[name organization]
      validates_unique %i[organization]
    end

    def to_h
      {
        type: 'promoter',
        attributes: { id: id, name: name, organization: organization, email: email },
        include: { subscribers: subscribers, promotions: promotions }
      }
    end
  end
end
