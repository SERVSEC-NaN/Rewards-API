# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Subscription Handling' do
  include Rack::Test::Methods

  api_root = 'api/v1/subscriptions'

  before { wipe_database }
  describe 'Getting Subscriptions' do
    it 'HAPPY: should be able to get list of all subscriptions' do
      Rewards::Subscription.create title: 'Subscription Title', description: 'Details about Subscription'
      Rewards::Subscription.create title: 'Another Subscription Title', description: 'Details about Other Subscription'

      get api_root
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result.count).must_equal 2
    end

    it 'HAPPY: should be able to get details of a single subscription' do
      subscription = Rewards::Subscription.create title: 'Subscription Title', description: 'Details about Subscription'
      id = subscription.id

      get "#{api_root}/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['title']).must_equal subscription.title
      _(result['description']).must_equal subscription.description
    end

    it 'SAD: should return error if unknown subscription requested' do
      get "#{api_root}/foobar"
      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      Rewards::Subscription.create title: 'Subscription Title', description: 'Details about Subscription'
      get "#{api_root}/2%20or%20id%3E0"

      # deliberately not reporting error -- don't give attacker information
      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil
    end
  end
end
