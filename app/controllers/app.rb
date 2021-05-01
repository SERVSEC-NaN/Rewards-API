# frozen_string_literal: true

require 'roda'
require 'json'
require_relative '../models/subscriber'

module Rewards
  # Web controller for Rewards api
  class Api < Roda
    plugin :all_verbs, :halt, :json
    plugin classes: [Array, Hash, Sequel::Model]

    MODELS = %w[Subscriber Subscription Promoter Tag].freeze

    @api_root = 'api/v1'
    route do |routing|
      routing.root do
        response.status = 200
        { message: "Rewards API accessible at /#{@api_root}/" }
      end

      routing.on @api_root do
        MODELS.each do |model_route|
          handle_endpoint routing, model_route
        end
      end
    end

    private

    def handle_get_id(id, name, model)
      model[id]
    rescue StandardError
      routing.halt 404, { message: "#{name} not found" }
    end

    def handle_get(model)
      response.status = 200
      model.all
    end

    def handle_post(id, name, model)
      message = "#{name} stored"
      unless model.create routing.params
        message = "could not create #{name}"
        routing.halt 400, { message: message }
      end

      response.status = 201
      { message: message, id: id }
    end

    def handle_endpoint(routing, model_name)
      name  = model_name.downcase
      model = Object.const_get model_name

      routing.on "#{name}s" do
        routing.is Integer do |id|
          routing.get   { handle_get_id id, name, model }
          routing.post  { handle_post id, name, model }
          routing.get   { handle_get model }
        end
      end
    end
  end
end