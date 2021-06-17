# frozen_string_literal: true

require 'roda'
require 'json'
require_relative './app'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    route('auth') do |routing|
      routing.is 'register' do
        # POST /api/v1/auth/register
        routing.post do
          reg_data = JSON.parse(request.body.read, symbolize_names: true)
          VerifyRegistration.new(reg_data).call
          response.status = 202
          { message: 'Verification email sent' }.to_json
        rescue VerifyRegistration::InvalidRegistration => e
          puts [e.class, e.message].join ': '
          routing.halt '403', { message: 'Invalid credentials' }.to_json
        end
      end

      routing.is 'authenticate' do
        # POST /api/v1/auth/authenticate
        routing.post do
          credentials  = JSON.parse(request.body.read, symbolize_names: true)
          auth_account = AuthenticateAccount.call(credentials)
          auth_account.to_json
        rescue AuthenticateAccount::UnauthorizedError => e
          puts [e.class, e.message].join ': '
          routing.halt '403', { message: 'Invalid credentials' }.to_json
        end
      end
    end
  end
end
