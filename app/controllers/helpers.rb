# frozen_string_literal: true

require_relative '../models/account'

module Rewards
  # Methods for controllers to mixin
  module SecureRequestHelpers
    class UnauthorizedRequestError < StandardError; end

    class NotFoundError < StandardError; end

    def secure_request?(routing) = routing.scheme.casecmp(Api.config.secure_scheme).zero?

    def authorization(headers)
      return nil unless headers['AUTHORIZATION']

      scheme, auth_token = headers['AUTHORIZATION'].split
      return nil unless scheme.match?(/^Bearer$/i)

      scoped_auth(auth_token)
    end

    def scoped_auth(auth_token)
      contents     = AuthToken.contents(auth_token)
      account_data = contents['payload']

      { account: Account.find(email: account_data['email']),
        scope: AuthScope.new(contents['scope']) }
    end
  end
end
