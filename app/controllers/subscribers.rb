# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'app'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    route('subscribers') do |routing|
      @subscriber_route = "#{@api_root}/subscribers"
      routing.on String do |subscriber_id|
        routing.on 'subscribe' do
          # POST api/v1/subscribers/[subscriber_id]/subscribe
          routing.post do
            promoter_id = JSON.parse(routing.body.read, symbolize_names: true)
            promoter =
              CreateSubscription
              .call subscriber_id: subscriber_id, promoter_id: promoter_id

            response.status = 201
            location = "#{@subscriber_route}/#{subscriber_id}/subscribe/#{promoter.id}"
            response['Location'] = location
            { message: 'Subscription Created', data: promoter }
          rescue Sequel::MassAssignmentRestriction
            routing.halt 400, { message: 'Illegal Request' }
          rescue StandardError
            routing.halt 500, { message: 'Database error' }
          end
        end

        # GET api/v1/subscribers/[subscriber_id]
        routing.get do
          subscriber = Subscriber.first(id: subscriber_id)
          subscriber ? subscriber.to_json : raise('Could not find subscribers')
        rescue StandardError => e
          routing.halt(404, { message: e.message })
        end
      end

      # GET api/v1/subscribers/
      routing.get do
        JSON.pretty_generate({ data: Subscriber.all })
      rescue StandardError
        routing.halt(404, { message: 'Could not find subscribers' })
      end

      # POST api/v1/subscribers
      routing.post do
        subscriber = Subscriber.new JSON.parse(routing.body.read, seralized_names: true)
        raise('Could not save subscriber') unless subscriber.save

        response.status = 201
        response['Location'] = "#{@subscriber_route}/#{subscriber.id}"
        { message: 'Subscriber saved', data: subscriber }
      rescue Sequel::MassAssignmentRestriction
        routing.halt 400, { message: 'Illegal Request' }
      rescue StandardError => e
        routing.halt 500, { message: e.message }
      end
    end
  end
end
