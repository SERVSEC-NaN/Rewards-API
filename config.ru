require 'require_all'
require_all 'app/**/*.rb'

run Rewards::Api.freeze.app
