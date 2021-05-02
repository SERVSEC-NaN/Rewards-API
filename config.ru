require_relative './require_app'
require_app

run Rewards::Api.freeze.app
