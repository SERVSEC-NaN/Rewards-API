# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Promoter Handling' do
  include Rack::Test::Methods

  api_root = 'api/v1/promoters'

  before do
    wipe_database
    data = { name: 'P1', organization: '1', email: '1@m.com' }
    @promoter = Rewards::Promoter.create data
  end

  describe 'Getting Promoters' do
    it 'HAPPY: should create a promoter' do
      data = { name: 'P2', organization: '2', email: '2@m.com' }
      post api_root, data.to_json
      assert_equal last_response.status, 201
    end

    it 'HAPPY: should be able to get list of all promoters' do
      data = { name: 'P2', organization: 'O2', email: '2@m.com' }
      Rewards::Promoter.create data

      get api_root
      assert last_response.ok?

      result = JSON.parse last_response.body
      assert_equal result['data'].count, 2
    end

    it 'HAPPY: should be able to get details of a single promoter' do
      get "#{api_root}/#{@promoter.id}"
      assert last_response.ok?

      result = JSON.parse last_response.body
      assert_equal result['attributes']['email'], @promoter.email
      assert_equal result['attributes']['organization'], @promoter.organization
    end

    it 'HAPPY: should be able to post promotion for a single promoter' do
      promotion_data = { title: 'Lol', description: 'Dont @ me' }
      post "#{api_root}/#{@promoter.id}/promotions", promotion_data.to_json
      assert_equal last_response.status, 201

      result = JSON.parse last_response.body
      assert_equal result['data']['attributes']['title'], promotion_data[:title]
      assert_equal result['data']['attributes']['description'], promotion_data[:description]
    end

    it 'HAPPY: should get all promotions of a single promoter' do
      Rewards::CreatePromotion
        .call(promoter_id: @promoter.id, promotion_data: { title: '1', description: '1' })

      Rewards::CreatePromotion
        .call(promoter_id: @promoter.id, promotion_data: { title: '2', description: '2' })

      get "#{api_root}/#{@promoter.id}/promotions/"
      assert last_response.ok?

      result = JSON.parse last_response.body
      assert_equal result['data'].count, 2
    end

    it 'HAPPY: should get a single promotion of a promoter' do
      Rewards::CreatePromotion
        .call(promoter_id: @promoter.id, promotion_data: { title: '3', description: '3' })
      promotion = @promoter.promotions.first

      get "#{api_root}/#{@promoter.id}/promotions/#{promotion.id}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      assert result['attributes']['id'], promotion.id
    end

    it 'SAD: should return error if unknown promoter requested' do
      get "#{api_root}/foobar"
      assert last_response.status.eql? 404
    end

    it 'SECURITY: should not use deterministic integers as ID' do
      id = @promoter.id
      assert id.is_a?(Numeric) == false
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      get "#{api_root}/2%20or%20id%3E0"

      # deliberately not reporting error -- don't give attacker information
      assert_equal last_response.status, 404
      assert_nil last_response.body['data']
    end
  end
end
