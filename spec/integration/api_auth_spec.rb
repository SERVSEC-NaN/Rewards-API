# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Authentication Routes' do
  include Rack::Test::Methods

  before do
    @req_header = { 'CONTENT_TYPE' => 'application/json' }
    wipe_database
  end

  describe 'Account Authentication' do
    before do
      @promoter_data = { name: 'N', organization: 'O', email: 's@email.com',
                           password: 'strongpassword' }
      @promoter =
        Rewards::Promoter.create @promoter_data
    end

    it 'HAPPY: should authenticate valid credentials' do
      post 'api/v1/auth/authenticate', @promoter_data.to_json, @req_header

      auth_account = JSON.parse(last_response.body)
      account = auth_account['attributes']['account']
      assert_equal 200, last_response.status
      assert_equal @promoter_data[:email], account['email']
    end

    it 'BAD: should not authenticate invalid password' do
      @promoter_data[:password] = 'wrongpassword'

      assert_output(/invalid/i, '') do
        post 'api/v1/auth/authenticate', @promoter_data.to_json, @req_header
      end

      result = JSON.parse(last_response.body)
      assert_equal 403, last_response.status
      assert_nil result['attributes']
      refute_nil result['message']
    end
  end
end
