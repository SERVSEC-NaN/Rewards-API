# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Subscriber Handling' do
  include Rack::Test::Methods

  api_root = 'api/v1/subscribers'

  before do
    wipe_database
    @subscriber = Rewards::Subscriber
                  .create(phone: '0900000000')
  end

  describe 'Getting subscribers' do
    it 'HAPPY: should be able to get list of all subscribers' do
      Rewards::Subscriber.create(phone: '1234561')

      get api_root
      assert last_response.ok?

      result = JSON.parse last_response.body
      assert result.count.eql? 2
    end

    it 'HAPPY: should be able to get details of a single subscriber' do
      id = @subscriber.id

      get "#{api_root}/#{id}"
      assert last_response.ok?

      result = JSON.parse last_response.body
      assert result['attributes']['id'].eql? @subscriber.id
      assert result['attributes']['phone'].eql? @subscriber.phone
    end

    it 'HAPPY: should be able to make a subscription (subscriber + promoter)' do
      id = @subscriber.id
      data = { name: 'P1', organization: '1', email: '1@m.com' }
      promoter = Rewards::Promoter.create data

      post "#{api_root}/#{id}", promoter_id.to_json
      assert last_response.ok?

      result = JSON.parse last_response.body
      assert result['attributes']['id'].eql? @subscriber.id
      assert result['attributes']['phone'].eql? @subscriber.phone
    end

    it 'SAD: should return error if unknown subscriber requested' do
      get "#{api_root}/foobar"
      assert last_response.status.eql? 404
    end

    it 'SECURITY: should not use deterministic integers as ID' do
      id = @subscriber.id
      assert id.is_a?(Numeric) == false
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      get "#{api_root}/2%20or%20id%3E0"

      # deliberately not reporting error -- don't give attacker information
      assert last_response.status.eql? 404
      assert_nil last_response.body['data']
    end
  end
end
