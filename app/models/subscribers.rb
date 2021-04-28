# frozen_string_literal: true

require 'json'
require 'base64'
require 'rbnacl'

module Rewards
  STORE_DIR = 'app/db/store'
  # Holds a secret contact information

  # Create a new contact by passing in hash of attributes
  class Account
    def initialize(account)
      @id     = account['id'] || new_id
      @email  = account['email']
      @number = account['number']
    end

    attr_reader :id, :email, :number

    def to_json(_ = {})
      {
        type: 'subscriber',
        id: id,
        email: email,
        number: number
      }.to_json
    end

    # File store must be setup once when application runs
    def self.setup
      Dir.mkdir(Rewards::STORE_DIR) unless Dir.exist? Rewards::STORE_DIR
    end

    # Stores contact in file store
    def save
      File.write("#{Rewards::STORE_DIR}/#{id}.json", to_json)
    end

    # Query method to find one contact
    def self.find(find_id)
      contact_file = File.read("#{Rewards::STORE_DIR}/#{find_id}.json")
      Account.new JSON.parse(contact_file)
    end

    # Query method to retrieve index of all contacts
    def self.all
      Dir.glob("#{Rewards::STORE_DIR}/*.json").map do |file|
        file.match(%r{#{Regexp.quote(Rewards::STORE_DIR)}/(.*)\.json})[1]
      end
    end

    private

    def new_id
      timestamp = Time.now.to_f.to_s
      Base64.urlsafe_encode64(RbNaCl::Hash.sha256(timestamp))[0..9]
    end
  end
end
