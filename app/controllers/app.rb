# frozen_string_literal: true

require 'roda'
require 'json'
require_relative '../models/subscribers'

module Rewards
  # Web controller for Rewards api
  class Api < Roda
    plugin :environments
    plugin :halt

    configure { Account.setup }

    route do |routing| # rubocop:disable Metrics/BlockLength
      response['Content-Type'] = 'application/json'

      routing.root do
        response.status = 200
        { message: 'Accounts accessible at /api/v1' }.to_json
      end

      routing.on 'api' do
        routing.on 'v1' do
          routing.on 'accounts' do
            routing.get String do |id|
              response.status = 200
              Account.find(id).to_json
            rescue StandardError
              routing.halt 404, { message: 'Account Not Found' }.to_json
            end

            routing.get do
              response.status = 200
              JSON.pretty_generate({ account_ids: Account.all })
            end

            routing.post do
              doc = Account.new(JSON.parse(routing.body.read))
              doc.save || routing.halt(400, { message: 'Could Not Store Account' }.to_json)
              response.status = 201
              { message: 'Account Stored', id: doc.id }.to_json
            end
          end
        end
      end
    end
  end
end
