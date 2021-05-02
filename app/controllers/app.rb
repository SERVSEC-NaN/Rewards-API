# frozen_string_literal: true

require 'roda'
require 'json'
require_relative '../models/subscriber'

module Rewards
  # Web controller for Rewards api
  class Api < Roda
    plugin :all_verbs
    plugin :halt
    plugin :json

    MODELS = %w[Subscriber Subscription Promoter Tag].freeze

    api_root = 'api/v1'
    route do |routing|
      routing.root do
        { message: "Rewards API accessible at /#{api_root}/" }
      end

      routing.on "#{api_root}" do
        MODELS.each do |model_route|
          handle_endpoint routing, model_route
        end
      end
    end

    private

    def handle_get(model, id = nil)
      return model[id] || raise("#{model.to_s.downcase} not found") if id

      response.status = 200
      model.all
    rescue StandardError => e
      routing.halt 404, { message: e.message }
    end

    def handle_post(id, model)
      name = model.to_s.downcase
      model.create routing.params || raise("could not create #{name}")
      response.status = 201
      { message: "#{name} stored", id: id }
    rescue StandardError => e
      routing.halt 400, { message: e.message }
    end

    def handle_endpoint(routing, model_name)
      model = Object.const_get model_name

      routing.on "#{model_name.downcase}s" do
        routing.is Integer do |id|
          routing.get   { handle_get model }
          routing.get   { handle_get id, model }
          routing.post  { handle_post id, model }
        end
      end
    end
  end
end
