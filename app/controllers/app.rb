# frozen_string_literal: true

require 'roda'
require 'json'
require_relative '../models/subscriber'

module Rewards
  # Web controller for Rewards api
  class Api < Roda
    plugin :all_verbs, :halt, :json
    plugin classes: [Array, Hash, Sequel::Model]

    @api_root = 'api/v1'
    route do |routing|
      routing.root do
        response.status = 200
        { message: "Rewards API accessible at /#{@api_root}/" }
      end

      routing.on @api_root do
        %w[Subscriber Subscription Promoter Tag].each do |model_route|
          handle_endpoint routing, model_route
        end
      end
    end

    private

    def handle_get_id(id, name, model)
      model[id]
    rescue StandardError
      routing.halt 404, { message: "#{name} Not Found" }
    end

    def handle_get(model)
      response.status = 200
      model.all
    end

    def handle_post(id, name, model)
      message = "#{name} Stored"
      unless model.create routing.params
        message = "Could Not Create #{name}"
        routing.halt 400, { message: message }
      end

      response.status = 201
      response['Location'] = "#{@api_root}/#{name}/#{id}"
      { message: message, id: id }
    end

    def handle_endpoint(routing, model_name)
      model_class = Object.const_get model_name

      routing.on "#{model_name.downcase}s" do
        routing.is Integer do |id|
          routing.get   { handle_get_id id, model_name, model_class }
          routing.post  { handle_post id, model_name, model_class }
          routing.get   { handle_get model_class }
        end
      end
    end
  end
end
