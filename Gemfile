# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web API
gem 'json'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'roda'

# Configuration
gem 'erb'
gem 'figaro'
gem 'rake'
gem 'rbnacl'
gem 'require_all'

# Database
gem 'hirb', '~>0'
gem 'sequel', '~>5'

# External Services
gem 'http'

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'rerun'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-rake'
  gem 'rubocop-sequel'
  gem 'sqlite3'
end

# Debugging
gem 'pry' # necessary for rake console

# Testing
group :test do
  gem 'minitest'
  gem 'minitest-documentation'
  gem 'minitest-rg'
  gem 'rack-test'
  gem 'simplecov', require: false
end

# Security
gem 'bundler-audit'
