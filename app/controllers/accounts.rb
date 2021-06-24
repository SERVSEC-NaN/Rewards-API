# frozen_string_literal: true

require 'roda'
require_relative './app'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    route('accounts') do |routing|
      @account_route = "#{@api_root}/accounts"
      # POST api/v1/accounts
      routing.post do
        new_data = JSON.parse(routing.body.read, symbolize_names: true)
        type = new_data.delete(:type)
        new_account =
          case type
          when /subscriber/ then Subscriber.new new_data
          when /promoter/ then Promoter.new new_data
          end

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
