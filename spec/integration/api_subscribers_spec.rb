# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Subscriber Handling' do
  include Rack::Test::Methods

  api_root = 'api/v1/subscribers'

  before do
    wipe_database
    phone = '0900000000'
    @subscriber = Rewards::Subscriber.create(phone: phone)
  end

  describe 'Getting subscribers' do
    it 'HAPPY: should create a subscriber' do
      phone = '0922299'
      post api_root, phone.to_json
      assert_equal 201, last_response.status
    end

    it 'HAPPY: should be able to get list of all subscribers' do
      Rewards::Subscriber.create(phone: '1234561')

      get api_root
      assert last_response.ok?

      result = JSON.parse last_response.body
      assert_equal result['data'].count, 2
    end

    it 'HAPPY: should be able to get details of a single subscriber' do
      get "#{api_root}/#{@subscriber.id}"
      assert last_response.ok?

      result = JSON.parse last_response.body
      assert_equal result['attributes']['id'], @subscriber.id
      assert_equal result['attributes']['phone'], @subscriber.phone
    end

    it 'HAPPY: should be able to make a subscription (subscriber + promoter)' do
      data = { name: 'P1', organization: '1', email: '1@m.com' }
      promoter = Rewards::Promoter.create data

      post "#{api_root}/#{@subscriber.id}/subscribe", promoter.id.to_json
      assert_equal last_response.status, 201
    end

    it 'SAD: should return error if unknown subscriber requested' do
      get "#{api_root}/foobar"
      assert_equal last_response.status, 404
    end

    it 'SECURITY: should not use deterministic integers as ID' do
      id = @subscriber.id
      assert_equal id.is_a?(Numeric), false
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      get "#{api_root}/2%20or%20id%3E0"

      # deliberately not reporting error don't give attacker
      # information
      assert_equal last_response.status, 404
      assert_nil last_response.body['data']
    end
  end
end
