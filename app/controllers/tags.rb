# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'app'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    route('tags') do |routing|
      @tag_route = "#{@api_root}/tags"
      routing.on String do |tag_id|
        routing.on 'promotion' do
          # POST api/v1/tags/[tag_id]/promotion
          routing.post do
            promotion = JSON.parse(routing.body.read, symbolize_names: true)
            AddTagtoPromotion
              .call promotion_id: promotion[:id], tag_id: tag_id

            response.status = 201
            location = "#{@tag_route}/#{tag_id}/promotion/#{promotion[:id]}"
            response['Location'] = location
            { message: 'Promotion tagged', data: promotion[:id] }
          rescue Sequel::MassAssignmentRestriction
            routing.halt 400, { message: 'Illegal Request' }
          rescue StandardError
            routing.halt 500, { message: 'Database Error' }
          end
        end

        # GET api/v1/tags/[tag_id]
        routing.get do
          tag = Tag.first(id: tag_id)
          tag ? tag.to_json : raise('Could not find tags')
        rescue StandardError => e
          routing.halt(404, { message: e.message })
        end
      end

      # GET api/v1/tags/
      routing.get do
        JSON.pretty_generate({ data: Tag.all })
      rescue StandardError
        routing.halt(404, { message: 'Could not find tags' })
      end

      # POST api/v1/tags
      routing.post do
        tag = Tag.new JSON.parse(routing.body.read, seralized_names: true)
        raise('Could not save tag') unless tag.save

        response.status = 201
        response['Location'] = "#{@tag_route}/#{tag.id}"
        { message: 'Tag saved', data: tag }
      rescue Sequel::MassAssignmentRestriction
        routing.halt 400, { message: 'Illegal Request' }
      rescue StandardError => e
        routing.halt 500, { message: e.message }
      end
    end
  end
end
