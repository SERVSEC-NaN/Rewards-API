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

def authenticate(account_data)
  Rewards::AuthenticateAccount.call(
    email: account_data[:email],
    password: account_data[:password]
  )
end

def auth_header(account_data)
  auth = authenticate(account_data)

  "Bearer #{auth[:attributes][:auth_token]}"
end

def authorization(account_data)
  auth     = authenticate(account_data)
  contents = AuthToken.contents(auth[:attributes][:auth_token])
  account  = contents['payload']['attributes']
  { account: Rewards::Account.first(email: account['email']),
    scope: AuthScope.new(contents['scope']) }
end
