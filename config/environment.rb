# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'
require 'sequel'
require 'erb'
require_app 'lib'

module Rewards
  # Configuration for the API
  class Api < Roda
    plugin :environments

    Figaro.application =
      Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )

    Figaro.load
    def self.config = Figaro.env

    def self.logger = Logger.new($stderr)

    DB = Sequel.connect(ENV['DATABASE_URL']))
    def self.DB = DB # rubocop:disable Naming/MethodName

    configure :development, :test do
      require 'pry'
      logger.level = Logger::ERROR
    end

    configure do
      SecureDB.setup(ENV.delete('DB_KEY'))
      AuthToken.setup(ENV.delete('MSG_KEY'))
    end
  end
end
