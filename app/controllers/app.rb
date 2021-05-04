# frozen_string_literal: true

require 'roda'
require 'json'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    @plugins = %i[all_verbs halt json].freeze
    @models = %w[subscriber subscription promoter tag].freeze
    @api_root = 'api/v1'

    @plugins.each { |p| plugin p }

    route do |r|
      r.root do
        { message: "Rewards API accessible at /#{@api_root}/" }
      end

      r.on @api_root do
        @models.each do |model_name|
          model = Object.const_get model_name.capitalize

          r.on "#{model_name}s" do
            r.get { handle_get model }
            r.is Integer do |model_id|
              r.get  { handle_get model_id, model }
              r.post { handle_post model_id, model }
            end
          end
        end
      end
    end

    private

    def handle_get(model, id = nil)
      return model[id] || raise("#{model.to_s.downcase}s/#{id} not found") if id

      response.status = 200
      model.all
    rescue StandardError => e; routing.halt 404, { message: e.message }
    end

    def handle_post(id, model)
      name = model.to_s.downcase
      model.create routing.params || raise("could not create #{name}")
      response.status = 201
      { message: "#{name} stored", id: id }
    rescue StandardError => e; routing.halt 400, { message: e.message }
    end
  end
end
