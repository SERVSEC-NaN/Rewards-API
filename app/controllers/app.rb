# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'helpers'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    plugin :halt
    plugin :all_verbs
    plugin :multi_route
    plugin :request_headers

    include SecureRequestHelpers

    UNAUTH_MSG = { message: 'Unauthorized Request' }.to_json

    def secure_request?(routing)
      routing.scheme.casecmp(Api.config.secure_scheme).zero?
    end

    route do |routing|
      response['Content-Type'] = 'application/json'
      @api_root = 'api/v1'
      secure_request?(routing) || routing.halt(403, { message: 'TLS/SSL Required' })

      begin
        @auth = authorization routing.headers
        @auth_account = @auth[:account] if @auth
      rescue AuthToken::InvalidTokenError
        routing.halt 403, { message: 'Invalid auth token' }.to_json
      rescue AuthToken::ExpiredTokenError
        routing.halt 403, { message: 'Expired auth token' }.to_json
      end

      routing.on @api_root do
        routing.multi_route
      end

      routing.root do
        { message: "Rewards API accessible at /#{@api_root}/" }.to_json
      end
    end
  end
end
