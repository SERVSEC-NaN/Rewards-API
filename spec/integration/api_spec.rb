# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Rewards Web API' do
  describe 'Root route' do
    it 'should find the root route' do
      get '/'
      assert_equal 200, last_response.status
    end
  end
end
