# frozen_string_literal: true

require_relative '../models/account'

module Rewards
  # Methods for controllers to mixin
  module SecureRequestHelpers
    class UnauthorizedRequestError < StandardError; end

    class NotFoundError < StandardError; end

    def secure_request?(routing)
      routing.scheme.casecmp(Api.config.secure_scheme).zero?
    end

    def authenticated_account(headers)
      return nil unless headers['AUTHORIZATION']

      scheme, auth_token = headers['AUTHORIZATION'].split
      return nil unless scheme.match?(/^Bearer$/i)

      email = (AuthToken.payload(auth_token))['attributes']['email']
      Rewards::Account.find(email: email)
    end
  end
end
