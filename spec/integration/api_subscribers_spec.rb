# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Subscriber Handling' do
  include Rack::Test::Methods

  api_root = 'api/v1/subscribers'

  before do
    wipe_database
    @data = { email: 'me@email.com', password: 'strongpassword' }
    @subscriber = Rewards::Subscriber.create @data
  end

  describe 'Getting subscribers' do
    it 'HAPPY: should create a subscriber' do
      data = { email: 'e@mail.com', password: 'pass' }
      post api_root, data.to_json
      assert_equal 201, last_response.status
    end

    it 'HAPPY: should be able to get list of all subscribers' do
      Rewards::Subscriber.create(email: 'w@mail.com', password: 'wordpass')

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
      assert_equal result['attributes']['email'], @subscriber.email
    end

    it 'HAPPY: should be able to make a subscription (subscriber + promoter)' do
      details = { name: 'P1', organization: '1', email: '1@m.com' }
      promoter = Rewards::Promoter.create details

      data = { id: promoter.id }.to_json
      post "#{api_root}/#{@subscriber.id}/subscribe", data
      assert_equal 201, last_response.status
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
      assert_equal 404, last_response.status
      assert_nil last_response.body['data']
    end
  end
end
