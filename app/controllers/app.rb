# frozen_string_literal: true

require 'roda'
require 'json'

module Rewards
  # Web controller for Rewards API
  class Api < Roda
    PLUGINS = %i[halt json multi_route].freeze
    PLUGINS.each { |p| plugin p }

    def secure_request?(routing)
      routing.scheme.casecmp(Api.config.secure_scheme).zero?
    end

    route do |routing|
      @api_root = 'api/v1'
      secure_request?(routing) || routing.halt(403, { message: 'TLS/SSL Required' })

      routing.root do
        { message: "Rewards API accessible at /#{@api_root}/" }
      end

      routing.on @api_root do
        routing.multi_route
      end
    end
  end
end
