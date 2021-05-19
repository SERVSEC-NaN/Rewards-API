# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Promotion Handling' do
  include Rack::Test::Methods

  api_root = 'api/v1/promotions'

  before do
    wipe_database
  end

  describe 'Getting Promotions' do
    it 'HAPPY: should be able to get list of all promotions' do
      Rewards::Promotion
        .create title: 'T1', description: 'D1'

      Rewards::Promotion
        .create title: 'T2', description: 'D2'

      get api_root
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result.count).must_equal 2
    end

    it 'HAPPY: should be able to get details of a single promotion' do
      promotion = Rewards::Promotion
                  .create title: 'T3', description: 'D1'

      id = promotion.id

      get "#{api_root}/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['title']).must_equal promotion.title
      _(result['description']).must_equal promotion.description
    end

    it 'SAD: should return error if unknown promotion requested' do
      get "#{api_root}/foobar"
      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      Rewards::Promotion
        .create title: 'T3', description: 'D1'

      get "#{api_root}/2%20or%20id%3E0"

      # deliberately not reporting error -- don't give attacker information
      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil
    end
  end
end
