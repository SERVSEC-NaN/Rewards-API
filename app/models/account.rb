# frozen_string_literal: true

require 'json'
require 'sequel'
require_relative 'password'

module Rewards
  # This a wrapper model for Accounts' commonly used methods.
  module Account
    def validate
      super
      validates_presence %i[email]
      validates_unique %i[email]
    end

    def self.find(email:)
      Rewards::Admin.first(email: email) || Rewards::Subscriber.first(email: email) ||
        Rewards::Promoter.first(email: email)
    end

    def name
      SecureDB.decrypt(name_secure)
    end

    def name=(plaintext)
      self.name_secure = SecureDB.encrypt plaintext
    end

    def password=(new_password)
      self.password_digest = Password.digest new_password
    end

    def password?(try_password)
      digest = Rewards::Password.from_digest password_digest
      digest.correct? try_password
    end

    def to_json(options = {})
      JSON(to_h, options)
    end
  end
end
