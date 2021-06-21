# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'app'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    route 'promotions' do |routing|
      routing.halt(403, UNAUTH_MSG) unless @auth_account

      routing.on String do |promotion_id|
        # GET api/v1/promotions/[promotion_id]
        routing.get do
          promotion = Promotion.first(id: promotion_id)
          raise('Could not find promotions') unless promotion

          policy = PromotionPolicy.new(@auth_account, promotion)
          raise UnauthorizedRequestError unless policy.can_view?

          promotion
            .full_details
            .merge(policies: policy.summary)
            .to_json
        rescue Sequel::MassAssignmentRestriction
          routing.halt 400, { message: 'Illegal Request' }.to_json
        rescue NotFoundError
          routing.halt 404, { message: 'Promotion not found' }.to_json
        rescue UnauthorizedRequestError => e
          routing.halt 403, { message: e.message }.to_json
        rescue StandardError => e
          routing.halt 404, { message: e.message }.to_json
        end
      end

      # GET api/v1/promotions/
      routing.get do
        JSON.pretty_generate({ data: Promotion.all })
      rescue StandardError
        routing.halt 404, { message: 'Could not find promotions' }.to_json
      end
    end
  end
end
