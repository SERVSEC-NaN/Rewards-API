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
    end
  end
end
