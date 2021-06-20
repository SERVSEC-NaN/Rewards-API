# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'

require_relative 'test_load_all'

# Should first remove dependencies
def wipe_database
  (app.DB.tables.reverse - [:schema_info]).each do |table|
    app.DB[table].delete
  end
end
