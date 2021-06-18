# frozen_string_literal: true

require_relative '../models/account'

module Rewards
  # Find account and check password
  class AuthenticateAccount
    # Error for invalid credentials
    class UnauthorizedError < StandardError
      def initialize(msg = nil)
        super
        @credentials = msg
      end

      def message
        "Invalid Credentials for: #{@credentials[:email]}"
      end
    end

    def self.call(credentials)
      account = Account.find(email: credentials[:email])
      raise unless account.password?(credentials[:password])

      account_and_token(account)
    rescue StandardError
      raise UnauthorizedError, credentials
    end

    def self.account_and_token(account)
      {
        type: "authenticated_#{account.to_h[:type]}",
        attributes: {
          account: account.to_h[:attributes],
          auth_token: AuthToken.create(account.to_h[:attributes])
        }
      }
    end
  end
end
