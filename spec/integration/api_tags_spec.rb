# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Tag Handling' do
  include Rack::Test::Methods
  api_root = 'api/v1/tags'

  before { wipe_database }
  describe 'Getting Tags' do
    it 'HAPPY: should be able to get list of all tags' do
      Rewards::Tag.create name: 'Tag1'
      Rewards::Tag.create name: 'Tag2'

      get api_root
      _(last_response.status).must_equal 200
      result = JSON.parse last_response.body
      _(result.count).must_equal 2
    end

    it 'HAPPY: should be able to get details of a single tag' do
      tag = Rewards::Tag.create name: 'Tag1'
      id  = tag.id

      get "#{api_root}/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['id']).must_equal tag.id
      _(result['name']).must_equal tag.name
    end

    it 'SAD: should return error if unknown tag requested' do
      get "#{api_root}/foobar"
      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      Rewards::Tag.create name: 'Tag1'
      Rewards::Tag.create name: 'Tag2'
      get "#{api_root}/2%20or%20id%3E0"

      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil
    end
  end
end
