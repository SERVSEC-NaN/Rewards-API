# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'app'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    route('promoters') do |routing|
      @promoter_route = "#{@api_root}/promoters"
      routing.on String do |promoter_id|
        routing.on 'promotions' do
          # GET api/v1/promoters/[promoter_id]/promotions/[promotion_id]
          routing.get String do |promo_id|
            promo = Promotion.where(promoter_id: promoter_id, id: promo_id).first
            promo ? promo.to_json : raise('Promotion not found')
          rescue StandardError => e; routing.halt 404, { message: e.message }.to_json
          end

          # GET api/v1/promoters/[promoter_id]/promotions/
          routing.get do
            output = { data: Promoter.first(id: promoter_id).promotions }
            JSON.pretty_generate output
          rescue StandardError
            routing.halt 404, { message: 'Could not find promotions' }.to_json
          end

          # POST api/v1/promoters/[promoter_id]/promotions
          routing.post do
            data = JSON.parse(routing.body.read, symbolize_names: true)
            promotion =
              CreatePromotion.call promoter_id: promoter_id, promotion_data: data
            response.status = 201
            location = "#{@promoter_route}/#{promoter_id}/promotions/#{promotion.id}"
            response['Location'] = location
            { message: 'Promotion Saved', data: promotion }.to_json
          rescue Sequel::MassAssignmentRestriction
            routing.halt 400, { message: 'Illegal Request' }.to_json
          rescue StandardError
            routing.halt 500, { message: 'Database error' }.to_json
          end
        end

        # GET api/v1/promoters/[promoter_id]
        routing.get do
          promoter = Promoter.first(id: promoter_id)
          promoter ? promoter.to_json : raise('Could not find promoters')
        rescue StandardError => e
          routing.halt 404, { message: e.message }.to_json
        end
      end

      # GET api/v1/promoters/
      routing.get do
        JSON.pretty_generate({ data: Promoter.all })
      rescue StandardError
        routing.halt 404, { message: 'Could not find promoters' }.to_json
      end

      # POST api/v1/promoters/[promoter_data]
      routing.post do
        promoter = Promoter.new JSON.parse(routing.body.read, seralized_names: true)
        raise('Could not save promoter') unless promoter.save

        response.status = 201
        response['Location'] = "#{@promoter_route}/#{promoter.id}"
        { message: 'Promoter saved', data: promoter }.to_json
      rescue Sequel::MassAssignmentRestriction
        routing.halt 400, { message: 'Illegal Request' }.to_json
      rescue StandardError => e
        routing.halt 500, { message: e.message }.to_json
      end
    end
  end
end
