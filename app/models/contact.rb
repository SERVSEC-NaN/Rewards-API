require 'json'
require 'base64'
require 'rbnacl'

module Phonebook
  STORE_DIR = 'app/db/store'.freeze
  # Holds a secret contact informatin
  class Contact
    # Create a new contact by passing in hash of attributes
    def initialize(new_contact)
      @id     = new_contact['id'] || new_id
      @name   = new_contact['name']
      @number = new_contact['number']
    end

    attr_reader :id, :name, :number

    def to_json(options = {})
      {
        type: 'contact',
        id: id,
        name: name,
        number: number
      }.to_json
    end

    # File store must be setup once when application runs
    def self.setup
      Dir.mkdir(Phonebook::STORE_DIR) unless Dir.exist? Phonebook::STORE_DIR
    end

    # Stores contact in file store
    def save
      File.write("#{Phonebook::STORE_DIR}/#{id}.txt", to_json)
    end

    # Query method to find one contact
    def self.find(find_id)
      contact_file = File.read("#{Phonebook::STORE_DIR}/#{find_id}.txt")
      Contact.new JSON.parse(contact_file)
    end

    # Query method to retrieve index of all contacts
    def self.all
      Dir.glob("#{Phonebook::STORE_DIR}/*.txt").map do |file|
        file.match(%r{#{Regexp.quote(Phonebook::STORE_DIR)}/(.*)\.txt})[1]
      end
    end

    private

    def new_id
      timestamp = Time.now.to_f.to_s
      Base64.urlsafe_encode64(RbNaCl::Hash.sha256(timestamp))[0..9]
    end
  end
end
