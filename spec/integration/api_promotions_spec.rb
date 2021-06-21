# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Promotion Handling' do
  include Rack::Test::Methods

  api_root = 'api/v1/promotions'

  before do
    wipe_database

    @promoter_data = { name: 'P1', organization: '1', email: '1@m.com', password: 'strongpassword' }
    @promoter = Rewards::Promoter.create @promoter_data

    2.times do |i|
      Rewards::CreatePromotion.call(promoter_id: @promoter.id, promotion_data: { title: "T#{i}", description: "D#{i}" })
    end

    header 'CONTENT_TYPE', 'application/json'
  end

  describe 'Getting Promotions' do
    it 'HAPPY: should be able to get list of all promotions' do
      header 'AUTHORIZATION', auth_header(@promoter_data)
      get api_root
      assert last_response.ok?
      result = JSON.parse last_response.body
      assert_equal result['data'].count, 2
    end

    it 'HAPPY: should be able to get details of a single promotion' do
      header 'AUTHORIZATION', auth_header(@promoter_data)
      promotion = Rewards::Promoter.first.promotions.first
      get "#{api_root}/#{promotion.id}"
      assert_equal 200, last_response.status
      result = JSON.parse last_response.body
      assert_equal result['attributes']['title'], promotion.title
      assert_equal result['attributes']['description'], promotion.description
    end

    it 'SAD: should return error if unknown promotion requested' do
      header 'AUTHORIZATION', auth_header(@promoter_data)
      get "#{api_root}/foobar"
      assert_equal 404, last_response.status
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      header 'AUTHORIZATION', auth_header(@promoter_data)
      get "#{api_root}/2%20or%20id%3E0"
      # deliberately not reporting error -- don't give attacker information
      assert_equal 404, last_response.status
      assert_nil last_response.body['data']
    end
  end
end
