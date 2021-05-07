# frozen_string_literal: true

require 'roda'
require 'json'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    PLUGINS = %i[all_verbs halt json].freeze
    MODELS = %w[subscriber subscription promoter tag].freeze
    API_ROOT = 'api/v1'

    PLUGINS.each { |p| plugin p }

    route do |routing|
      routing.root do
        { message: "Rewards API accessible at /#{API_ROOT}/" }
      end

      routing.on API_ROOT do
        MODELS.each do |model_name|
          @model_name = model_name
          @model = Object.const_get "Rewards::#{model_name.capitalize}"
          routing.on "#{model_name}s" do
            routing.get do
              routing.is String do |model_id|
                handle_get routing, model_id
              end
              handle_get routing
            end

            routing.post do
              handle_post routing
            end
          end
        end
      end
    end

    private

    def handle_get(route, id = nil)
      unless id.nil?
        raise("#{@model_name} not found") if @model[id].nil?

        return @model[id].to_json
      end

      @model.all
    rescue StandardError => e; route.halt 404, { message: e.message }
    end

    def handle_post(route)
      entry = @model.create JSON.parse(route.body.read)
      route.halt 400, "Could not save #{@model_name}" unless entry
      response.status = 201
      { message: "#{@model_name} stored" }
    rescue StandardError; route.halt 500, { message: 'Database error' }
    end
  end
end
