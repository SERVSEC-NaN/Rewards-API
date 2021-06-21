# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test AuthScope' do
  include Rack::Test::Methods

  it 'AUTH SCOPE: should validate default full scope' do
    scope = AuthScope.new
    assert scope.can_read?('*')
    assert scope.can_write?('*')
    assert scope.can_read?('promotion')
    assert scope.can_write?('promotion')
  end

  it 'AUTH SCOPE: should evalutate read-only scope' do
    scope = AuthScope.new(AuthScope::READ_ONLY)
    assert scope.can_read?('promotions')
    refute scope.can_write?('promotions')
  end

  it 'AUTH SCOPE: should validate single limited scope' do
    scope = AuthScope.new('promotions:read')
    refute scope.can_read?('*')
    refute scope.can_write?('*')
    assert scope.can_read?('promotions')
    refute scope.can_write?('promotions')
  end

  it 'AUTH SCOPE: should validate list of limited scopes' do
    scope = AuthScope.new('projects:read promotions:write')
    refute scope.can_read?('*')
    refute scope.can_write?('*')
    assert scope.can_read?('promotions')
    assert scope.can_write?('promotions')
  end
end
