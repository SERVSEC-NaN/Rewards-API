# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Tag Handling' do
  include Rack::Test::Methods
  api_root = 'api/v1/tags'

  before do
    wipe_database
    @tag = Rewards::Tag.create name: 'Tag1'
  end

  describe 'Getting Tags' do
    it 'HAPPY: should create a tag' do
      data = { name: 'lol ' }.to_json

      post api_root, data
      assert_equal 201, last_response.status
    end

    it 'HAPPY: should be able to get list of all tags' do
      Rewards::Tag.create name: 'Tag3'
      Rewards::Tag.create name: 'Tag2'

      get api_root
      assert last_response.ok?
      result = JSON.parse last_response.body
      assert_equal 3, result['data'].count
    end

    it 'HAPPY: should be able to get details of a single tag' do
      get "#{api_root}/#{@tag.id}"
      assert last_response.ok?
      result = JSON.parse last_response.body
      assert_equal result['attributes']['name'], @tag.name
    end

    it 'HAPPY: should add a tag to a promotion' do
      promotion =
        Rewards::Promotion
        .create title: 'T', description: 'D'

      data = { id: promotion.id }.to_json
      post "#{api_root}/#{@tag.id}/promotion", data
      assert_equal 201, last_response.status
    end

    it 'SAD: should return error if unknown tag requested' do
      get "#{api_root}/foobar"
      assert_equal last_response.status, 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      get "#{api_root}/2%20or%20id%3E0"

      assert_equal last_response.status, 404
      assert_nil last_response.body['data']
    end
  end
end
