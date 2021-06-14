# frozen_string_literal: true

require_relative '../config/require_app'
require_app

def app
  Rewards::Api
end

unless app.environment == :production
  require 'rack/test'
  include Rack::Test::Methods # rubocop:disable Style/MixinUsage
end
