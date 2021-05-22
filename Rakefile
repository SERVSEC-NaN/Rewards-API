# frozen_string_literal: true

require 'rake/testtask'
require_relative 'config/require_app'

task default: :spec

desc 'Test all the specs'
task :spec do
  Rake::TestTask.new(:spec) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.warning = false
  end
end

desc 'Tests API specs only'
task :api_spec do
  Rake::TestTask.new(:api_spec) do |t|
    t.pattern = 'spec/integration/**/*_spec.rb'
    t.warning = false
  end
end

desc 'Runs rubocop on tested code'
task style: %i[spec audit] do
  sh 'rubocop .'
end

desc 'Start server'
task :server do
  sh 'bundle exec rackup'
end

desc 'Update vulnerabilities lit and audit gems'
task :audit do
  sh 'bundle audit check --update'
end

desc 'Checks for release'
task release: %i[spec style audit] do
  puts "\nReady for release!"
end

task :print_env do
  puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
end

desc 'Run application console (pry)'
task console: :print_env do
  sh 'pry -r ./spec/test_load_all'
end

namespace :db do
  require 'sequel'
  require_relative 'config/environment'

  Sequel.extension :migration
  app = Rewards::Api.freeze

  desc 'Run migrations'
  task migrate: :print_env do
    puts 'Migrating database to latest'
    Sequel::Migrator.run app.DB, 'app/db/migrations'
  end

  desc 'Delete database'
  task :delete do
    %i[subscribers subscriptions promoters tags].each do |table|
      app.DB[table].delete
    end
  end

  desc 'Delete dev or test database file'
  task :drop do
    if app.environment == :production
      p 'Cannot wipe production database!'
    else
      db_filename = "app/db/store/#{app.environment}.db"
      unless File.exist? db_filename
        FileUtils.rm db_filename
        puts "Deleted #{db_filename}"
      end
    end
  end

  desc 'Delete and migrate again'
  task reset: %i[drop migrate]
end
