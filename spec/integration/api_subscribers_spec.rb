# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Subscriber Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
  end

  @api_root = 'api/v1/subscribers'

  describe 'Getting subscribers' do
    it 'HAPPY: should be able to get list of all subscribers' do
      Rewards::Subscriber.create(phone: '1123456')
      Rewards::Subscriber.create(phone: '1234561')

      get "#{@api_root}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result.all.count).must_equal 2
    end

    it 'HAPPY: should be able to get details of a single subscriber' do
      Rewards::Subscriber.create(phone: '1234561')
      id = Rewards::Subscriber.first.id

      get "#{@api_root}/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['data']['attributes']['id']).must_equal id
      _(result['data']['attributes']['phone']).must_equal existing_subscriber['phone']
    end

    it 'SAD: should return error if unknown subscriber requested' do
      get "#{@api_root}/foobar"
      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      Rewards::Subscriber.create(phone: '08123456432')
      Rewards::Subscriber.create(phone: '088765432')
      get "#{@api_root}/2%20or%20id%3E0"

      # deliberately not reporting error -- don't give attacker information
      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil
    end
  end

  describe 'Creating New Subscribers' do
    before do
      @req_header = { 'CONTENT_TYPE' => 'application/json' }
      @subscriber_data = DATA[:subscribers][1]
    end

    it 'HAPPY: should be able to create new subscribers' do
      post @api_root, @subscriber_data.to_json, @req_header
      _(last_response.status).must_equal 201
      _(last_response.header['Location'].size).must_be :>, 0

      created = JSON.parse(last_response.body)['data']['data']['attributes']
      subscriber = Rewards::Subscriber.first

      _(created['id']).must_equal subscriber.id
      _(created['phone']).must_equal @subscriber_data['phone']
    end
  end
end
