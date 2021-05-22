# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'app'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    route 'promotions' do |routing|
      # @promotion_route = "#{@api_root}/promotions"
      routing.on String do |promotion_id|
        #   routing.get do
        #     output = { data: Promotion.first(id: promotion_id).promotions }
        #     JSON.pretty_generate output
        #   rescue StandardError
        #     routing.halt(404, { message: 'Could not find promotions' })
        #   end

        # GET api/v1/promotions/[promotion_id]/promoter/

        #   # POST api/v1/promotions/[promotion_id]/promotions
        #   routing.post do
        #     data = {
        #       project_id: promotion_id,
        #       document_data: JSON.parse(routing.body.read)
        #     }
        #     promotion = CreatePromotion.call(data)
        #     response.status = 201
        #     response['Location'] = "#{@promotion_route}/#{promotion.id}"
        #     { message: 'Promotion Saved', data: promotion }
        #   rescue Sequel::MassAssignmentRestriction
        #     routing.halt 400, { message: 'Illegal Request' }
        #   rescue StandardError
        #     routing.halt 500, { message: 'Database error' }
        #   end

        # GET api/v1/promotions/[promotion_id]
        routing.get do
          promotion = Promotion.first(id: promotion_id)
          promotion ? promotion.to_json : raise('Could not find promotions')
        rescue StandardError => e
          routing.halt(404, { message: e.message })
        rescue Sequel::MassAssignmentRestriction
          routing.halt 400, { message: 'Illegal Request' }
        end
      end

      # GET api/v1/promotions/
      routing.get do
        JSON.pretty_generate({ data: Promotion.all })
      rescue StandardError
        routing.halt(404, { message: 'Could not find promotions' })
      end

      # # POST api/v1/promotions
      # routing.post do
      #   promotion = Promotion.new JSON.parse(routing.body.read)
      #   raise('Could not save promotion') unless promotion.save

      #   response.status = 201
      #   response['Location'] = "#{@promotion_route}/#{promotion.id}"
      #   { message: 'Promotion saved', data: promotion }
      # rescue Sequel::MassAssignmentRestriction
      #   routing.halt 400, { message: 'Illegal Request' }
      # rescue StandardError => e
      #   routing.halt 500, { message: e.message }
      # end
    end
  end
end
