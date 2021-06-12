# frozen_string_literal: true

require 'sequel'
require 'json'
require_relative './password'

module Rewards
  # Models User Accounts
  class Account < Sequel::Model
    plugin :uuid, field: :id
    plugin :whitelist_security
    plugin :timestamps, update_on_create: true

    set_allowed_columns :email, :password

    def password=(new_password)
      self.password_digest = Password.digest new_password
    end

    def password?(try_password)
      digest = Rewards::Password.from_digest password_digest
      digest.correct? try_password
    end

    def to_json(options = {})
      JSON(
        {
          type: 'admin',
          attributes: {
            id: id,
            email: email
          }
        }, options
      )
    end
  end
end
