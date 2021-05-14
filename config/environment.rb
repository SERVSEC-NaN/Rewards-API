# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'
require 'sequel'
require_relative '../app/lib/secure_db'

module Rewards
  # Configuration for the API
  class Api < Roda
    plugin :environments

    Figaro.application = Figaro::Application.new(
      environment: environment,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    # Logger setup
    def self.logger = Logger.new($stderr)

    DB = Sequel.connect(ENV.delete('DATABASE_URL'))
    def self.DB = DB # rubocop:disable Naming/MethodName

    configure :development, :test do
      require 'pry'
      logger.level = Logger::ERROR
    end
  end
end
