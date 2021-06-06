# frozen_string_literal: true

require_relative 'securable'

# Encrypt and Decrypt from Database
class SecureDB
  extend Securable

  def self.encrypt(plaintext)
    return nil unless plaintext

    Base64.strict_encode64 base_encrypt(plaintext)
  end

  def self.decrypt(ciphertext64)
    return nil unless ciphertext64

    base_decrypt Base64.strict_decode64(ciphertext64)
  end
end
