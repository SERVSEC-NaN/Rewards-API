# frozen_string_literal: true

require 'passphrase'

Sequel.seed(:development, :test, :producton) do
  def run() = create_admin
end

def create_admin
  p 'Seeding admin account'
  name = "admin-#{Passphrase::Passphrase.new(number_of_words: 1).passphrase}"
  pass = Passphrase::Passphrase.new.passphrase
  Rewards::Account.create(username: name, password: pass)
  p name
  p pass
end
