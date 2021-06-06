# frozen_string_literal: true

require 'base64'
require 'rbnacl'

module Securable
  class NoDbKeyError < StandardError; end

  # Generate key for Rake tasks (typically not called at runtime)
  def generate_key
    key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
    Base64.strict_encode64 key
  end

  def setup(base_key)
    raise NoKeyError unless base_key

    @base_key = base_key
  end

  def key
    @key ||= Base64.strict_decode64(@base_key)
  end

  # Encrypt or else return nil if data is nil
  def base_encrypt(plaintext)
    RbNaCl::SimpleBox
      .from_secret_key(key)
      .encrypt(plaintext)
  end

  # Decrypt or else return nil if database value is nil already
  def base_decrypt(ciphertext)
    RbNaCl::SimpleBox
      .from_secret_key(key)
      .decrypt(ciphertext)
      .force_encoding(Encoding::UTF_8)
  end
end
