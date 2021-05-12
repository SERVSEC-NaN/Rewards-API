# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Promoter Handling' do
  include Rack::Test::Methods

  api_root = 'api/v1/promoters'

  before { wipe_database }
  describe 'Getting Promoters' do
    it 'HAPPY: should be able to get list of all promoters' do
      Rewards::Promoter.create name: 'Promoter1', organization: 'Org1', email: '1@mail.com'
      Rewards::Promoter.create name: 'Promoter2', organization: 'Org2', email: '2@mail.com'

      get api_root
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result.count).must_equal 2
    end

    it 'HAPPY: should be able to get details of a single promoter' do
      promoter = Rewards::Promoter.create name: 'Promoter2', organization: 'Org2', email: '2@mail.com'
      id = promoter.id

      get "#{api_root}/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['name']).must_equal promoter.name
      _(result['organization']).must_equal promoter.organization
      _(result['email']).must_equal promoter.email
    end

    it 'SAD: should return error if unknown promoter requested' do
      get "#{api_root}/foobar"
      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      Rewards::Promoter.create name: 'Promoter2', organization: 'Org2', email: '2@mail.com'
      get "#{api_root}/2%20or%20id%3E0"

      # deliberately not reporting error -- don't give attacker information
      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil
    end
  end
end
