# frozen_string_literal: true

require 'rake/testtask'
require_relative 'require_app'

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
  sh 'ruby spec/integration/api_spec.rb'
  %w[subscriber promotion promoter tag].each do |model|
    sh "ruby spec/integration/api_#{model}s_spec.rb"
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

namespace :newkey do
  desc 'Create sample cryptographic key for database'
  task :db do
    require_app 'lib'
    p "DB_KEY: \'#{SecureDB.generate_key}\'"
  end
end

namespace :db do
  require 'sequel'
  require_relative 'config/environment'

  Sequel.extension :migration
  app = Rewards::Api

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
    (p 'Cannot wipe production database!' && return) if app.environment == :production
    db_filename = "app/db/store/#{Rewards::Api.environment}.db"
    FileUtils.rm db_filename
    puts "Deleted #{db_filename}"
  end

  desc 'Delete and migrate again'
  task reset: %i[drop migrate]
end
