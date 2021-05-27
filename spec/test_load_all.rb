# frozen_string_literal: true

require 'rack/test'
require_relative '../config/require_app'

require_app

include Rack::Test::Methods # rubocop:disable Style/MixinUsage

def @app = Rewards::Api
