# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Subscriber Handling' do
  include Rack::Test::Methods

  api_root = 'api/v1/subscribers'

  before { wipe_database }
  describe 'Getting subscribers' do
    it 'HAPPY: should be able to get list of all subscribers' do
      Rewards::Subscriber.create(phone: '1123456')
      Rewards::Subscriber.create(phone: '1234561')

      get api_root
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result.count).must_equal 2
    end

    it 'HAPPY: should be able to get details of a single subscriber' do
      subscriber = Rewards::Subscriber.create(phone: '1234561')
      id = subscriber.id

      get "#{api_root}/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['id']).must_equal subscriber.id
      _(result['phone']).must_equal subscriber.phone
    end

    it 'SAD: should return error if unknown subscriber requested' do
      get "#{api_root}/foobar"
      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      Rewards::Subscriber.create(phone: '08123456432')
      Rewards::Subscriber.create(phone: '088765432')
      get "#{api_root}/2%20or%20id%3E0"

      # deliberately not reporting error -- don't give attacker information
      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil
    end
  end
end
