# frozen_string_literal: true

require 'roda'
require_relative './app'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    route('accounts') do |routing| # rubocop:disable Metrics/BlockLength
      @account_route = "#{@api_root}/accounts"
      routing.on String do |username|
        routing.halt(403, UNAUTH_MSG) unless @auth_account

      # POST api/v1/accounts
      routing.post do
        new_data = JSON.parse(routing.body.read, symbolize_names: true)
        type = new_data.delete(:type)
        new_account =
          case type
          when /subscriber/ then Subscriber.new new_data
          when /promoter/ then Promoter.new new_data

        raise('Could not save account') unless new_account.save

        response.status = 201
        response['Location'] = "#{@account_route}/#{new_account.email}"
        { message: "#{type.capitalize} created", data: new_account }.to_json
      rescue Sequel::MassAssignmentRestriction
        routing.halt 400, { message: 'Illegal Request' }.to_json
      rescue StandardError => e
        puts e.inspect
        routing.halt 500, { message: e.message }.to_json
      end
    end
  end
end
