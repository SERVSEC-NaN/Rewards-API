# frozen_string_literal: true

require_relative 'account'

module Rewards
  # Models User Admin
  class Admin < Sequel::Model
    include Account

    plugin :uuid, field: :id
    plugin :validation_helpers
    plugin :whitelist_security
    plugin :timestamps, update_on_create: true

    set_allowed_columns :email, :password

    def to_h
      {
        type: 'admin',
        attributes: { id: id, email: email }
      }
    end
  end
end
