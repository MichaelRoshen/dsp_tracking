# encoding: utf-8
require 'net/http'
require 'base64'
require 'uri'
require "openssl"

module Rtb
  module Gdt
    class DecodePrice
      def self.decode_price(origin_code="")
        # token = "iclick1234567890"
        token = "LDE0MjE2NDAzNjcsZGQ0NzFmNDFjZmQ2OTlkMWE5ZDlhMDI4NWI1NmZmOWY="

        # origin_code = "x3LUvwmLEdPI0zKNCZ_DcQ=="
        decode64_str = Base64.urlsafe_decode64(origin_code)
        price = aes128_encrypt(token, decode64_str)
        return price.to_i
      end

      def self.aes128_encrypt(password,content)
        decipher = OpenSSL::Cipher.new('AES-128-CBC')
        decipher.padding = 0
        decipher.decrypt

        en_key = password[0..15].bytes.to_a.pack("c*")
        decipher.key = en_key
        (decipher.update(content) << decipher.final)
      end
    end
  end
end

# p Rtb::Gdt::DecodePrice.decode_price
