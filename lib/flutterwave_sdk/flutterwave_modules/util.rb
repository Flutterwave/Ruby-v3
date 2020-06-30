
require "digest"
require "openssl"
require "base64"
require 'json'
require 'securerandom'

module Util

    # method to generate merchants transaction reference
    def self.transaction_reference_generator
      transaction_ref = "MC-" + SecureRandom.hex
      return transaction_ref
    end

    # method for encryption algorithm
    def self.encrypt(key, data)
      cipher = OpenSSL::Cipher.new("des-ede3")
      cipher.encrypt # Call this before setting key
      cipher.key = key
      data = data.to_json
      ciphertext = cipher.update(data)
      ciphertext << cipher.final
      return Base64.encode64(ciphertext)
    end
  end