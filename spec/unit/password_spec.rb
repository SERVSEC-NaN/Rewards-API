# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Password Digestion' do
  before do
    wipe_database
    @password1 = 'ediblesofunusualsizecolorandtexture'
    @password2 = 'myuncannylittlepremonitionaboutlife'
  end

  it 'SECURITY: create password digests safely, hiding raw password' do
    digest = Rewards::Password.digest(@password1)
    refute digest.to_s.match?(@password1)
  end

  it 'SECURITY: successfully checks correct password from stored digest' do
    digest_s = Rewards::Password.digest(@password1).to_s
    digest   = Rewards::Password.from_digest(digest_s)
    assert digest.correct?(@password1)
  end

  it 'SECURITY: successfully detects incorrect password from stored digest' do
    digest_s1 = Rewards::Password.digest(@password1).to_s
    digest1   = Rewards::Password.from_digest(digest_s1)
    refute digest1.correct?(@password2)
  end
end
