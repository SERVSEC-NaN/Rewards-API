# frozen_string_literal: true
require 'roda'
require 'json'
require_relative '../models/contact'

module Phonebook
  # Web controller for Phonebook API
  class Api < Roda
    plugin :environments
    plugin :halt

    configure { Contact.setup }

    route do |routing| # rubocop:disable Metrics/BlockLength
      response['Content-Type'] = 'application/json'
      routing.root do
        response.status = 200
        { message: 'Contacts accessible at /api/v1' }.to_json
      end

      routing.on 'api' do
        routing.on 'v1' do
          routing.on 'contact' do
            routing.get String do |id|
              response.status = 200
              Contact.find(id).to_json
            rescue StandardError
              routing.halt 404, { message: 'Contact Not Found' }.to_json
            end

            routing.get do
              response.status = 200
              JSON.pretty_generate({ contact_ids: Contact.all })
            end

            routing.post do
              doc = Contact.new(JSON.parse(routing.body.read))
              doc.save || routing.halt(400, { message: 'Could Not Store Contact' }.to_json)
              response.status = 201
              { message: 'Contact Stored', id: doc.id }.to_json
            end
          end
        end
      end
    end
  end
end
