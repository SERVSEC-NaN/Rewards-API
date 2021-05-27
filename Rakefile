# frozen_string_literal: true

require 'rake/testtask'
require_relative 'config/require_app'

ENV['RACK_ENV'] ||= 'development'

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

desc 'Rerun tests on live code changes'
task :respec do
  sh 'rerun -c rake spec'
end

desc 'Runs rubocop on tested code'
task style: %i[spec audit] do
  sh 'rubocop .'
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
  puts "Environment: #{ENV['RACK_ENV']}"
end

desc 'Run application console (pry)'
task console: :print_env do
  sh 'pry -r ./spec/test_load_all'
end

namespace :db do
  require 'sequel'
  require_relative 'config/environment'

  task :load do
    require_app(nil) # loads config code files only
    require 'sequel'

    Sequel.extension :migration
    @app = Rewards::Api
  end

  task load_models: :load do
    require_app(%w[lib models services])
  end

  desc 'Run migrations'
  task migrate: %i[load print_env] do
    puts 'Migrating database to latest'
    Sequel::Migrator.run @app.DB, 'app/db/migrations'
  end

  desc 'Delete database'
  task :delete do
    TABLES.each do |table|
      @app.DB[table].delete
    end
  end

  desc 'Delete dev or test database file'
  task drop: :load do
    if @app.environment == :production
      p 'Cannot wipe production database!'
    else
      db_filename = "app/db/store/#{@app.environment}.db"
      if File.exist? db_filename
        FileUtils.rm db_filename
        puts "Deleted #{db_filename}"
      end
    end
  end

  desc 'Seeds the development database'
  task seed: %i[load_models] do
    require 'sequel/extensions/seed'
    Sequel::Seed.setup(@app.environment)
    Sequel.extension :seed
    Sequel::Seeder.apply(@app.DB, 'app/db/seeds')
  end
end

namespace :newkey do
  desc 'Create sample cryptographic key for database'
  task :db do
    require_app('lib')
    puts "DB_KEY: #{SecureDB.generate_key}"
  end
end

namespace :run do
  # Run in development mode
  task :dev do
    sh 'rackup -p 3000'
  end
end

namespace :run do
  # Run in development mode
  task :dev do
    sh 'rackup -p 3000'
  end
end
