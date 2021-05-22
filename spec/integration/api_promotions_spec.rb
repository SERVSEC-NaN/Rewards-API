# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Promotion Handling' do
  include Rack::Test::Methods

  api_root = 'api/v1/promotions'

  before do
    wipe_database
    promoter_data = { name: 'P1', organization: '1', email: '1@m.com' }
    @promoter = Rewards::Promoter.create promoter_data
  end

  describe 'Getting Promotions' do
    it 'HAPPY: should be able to get list of all promotions' do
      Rewards::CreatePromotion
        .call(promoter_id: @promoter.id, promotion_data: { title: 'T1', description: 'D1' })

      Rewards::CreatePromotion
        .call(promoter_id: @promoter.id, promotion_data: { title: 'T1', description: 'D1' })

      get api_root
      assert last_response.ok?

      result = JSON.parse last_response.body
      assert_equal result['data'].count, 2
    end

    it 'HAPPY: should be able to get details of a single promotion' do
      promotion = Rewards::CreatePromotion
                  .call(promoter_id: @promoter.id, promotion_data: { title: 'T1', description: 'D1' })

      get "#{api_root}/#{promotion.id}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      assert_equal result['attributes']['title'], promotion.title
      assert_equal result['attributes']['description'], promotion.description
    end

    it 'SAD: should return error if unknown promotion requested' do
      get "#{api_root}/foobar"
      assert_equal last_response.status, 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      get "#{api_root}/2%20or%20id%3E0"

      # deliberately not reporting error -- don't give attacker information
      assert last_response.status.eql? 404
      assert_nil last_response.body['data']
    end
  end
end
