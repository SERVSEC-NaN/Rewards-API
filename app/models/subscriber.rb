# frozen_string_literal: true

require_relative 'account'

module Rewards
  # Models a subscriber
  class Subscriber < Sequel::Model
    include Account
    many_to_many :promoters, left_key: :subscriber_id, right_key: :promoter_id,
                             join_table: :subscriptions

    plugin :uuid, field: :id
    plugin :validation_helpers
    plugin :whitelist_security
    plugin :timestamps, update_on_create: true
    plugin :association_dependencies, promoters: :nullify

    set_allowed_columns :email, :password

    def to_h
      {
        type: 'subscriber',
        attributes: { id: id, email: email },
        include: { promoters: promoters }
      }
    end
  end
end
