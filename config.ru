# frozen_string_literal: true

require_relative './config/require_app'
require_app

run Rewards::Api.freeze.app

unless Rewards::Api.app.environment == :production
  require 'rack/cors'
  use Rack::Cors do
    # allow all origins in development
    allow do
      origins '*'
      resource '*', headers: :any, methods: %i[get post delete put options]
    end
  end
end
