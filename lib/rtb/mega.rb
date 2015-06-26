#! /usr/bin/ruby  
require "openssl"
require "base64"
require 'securerandom'
require 'open-uri'

module Rtb
  module Mega
    class PriceEncryptInfo
      attr_accessor :bidGuid , :price , :timestamp
    end

    module PriceEncryptHelper
      def getEncryptedPrice(encrypted_info , key)
        id = encrypted_info.bidGuid
        bytes = []
        tmpLong = longToByteArray(most_significant_bits(id))
        bytes += tmpLong
        tmpLong = longToByteArray(least_significant_bits(id));
        bytes += tmpLong
        tmpLong = longToByteArray(encrypted_info.price);
        bytes += tmpLong[0..3]
        tmpLong = longToByteArray(encrypted_info.timestamp);
        bytes += tmpLong[0..3]
        encryptStr = encrypt(bytes.join,key)
      end

      def getDecryptedPrice(encrypt , key)
        decryptStr = decrypt(encrypt , key)
        decrypedPrice = PriceEncryptInfo.new
        tmpLong = [];
        #bid guid
        tmpLong = decryptStr[0...8]
        bigGuidHigh64 = byteArrayToLong(tmpLong)
        tmpLong = decryptStr[8...16]
        bigGuidLow64 = byteArrayToLong(tmpLong) 
        decrypedPrice.bidGuid = get_uuid(bigGuidHigh64, bigGuidLow64)
        #price
        tmpLong =  decryptStr[16...20] + "\0\0\0\0"
        decrypedPrice.price = tmpLong.unpack('L')[0]
        #timestamp
        tmpLong = decryptStr[20..24]+ "\0\0\0\0"
        decrypedPrice.timestamp = tmpLong.unpack('L')[0]
        decrypedPrice 
      end

      def decrypt(encrypt,key)
        raise 'key is null' if !key
        raise 'key length must be whole-number multiple of 8..' if key.length % 8 != 0
        cipher = OpenSSL::Cipher.new("AES-256-ECB")
        cipher.decrypt
        cipher.key = key
        cipher.update(Base64.decode64(encrypt)) + cipher.final
      end

      def encrypt(source,key)
        if (key == '')
         raise("Argument key is null.")
       end
       if (key.size % 8 != 0)
         raise("Argument key length must be whole-number multiple of 8.")
       end

       cipher = OpenSSL::Cipher.new("AES-256-ECB")
       cipher.encrypt
       cipher.key = key
       en_str = cipher.update(source)
       en_str << cipher.final
       Base64.encode64(en_str)
     end

     def get_uuid(mostSigBits,leastSigBits)
       (digits(mostSigBits >> 32, 8) + "-" + digits(mostSigBits >> 16, 4) + "-" + digits(mostSigBits, 4) + "-" + digits(leastSigBits >> 48, 4) + "-" +  digits(leastSigBits, 12))
     end

      def digits(val, digits) 
        hi = 1 << (digits * 4)
        b = (hi | (val & (hi - 1))).to_s(16)
        b[1...b.size]
      end

      def longToByteArray(v)
        bytes = []
        (0..7).each do |i|
          mask = 0xFF << (i * 8);
          x = ((v & mask) >> (i * 8)) & 0xFF;
          bytes[i] = x.chr;
        end
        bytes
      end

      def byteArrayToLong(v)
        ret = 0
        (0..7).each do |i|
          x = v[i].ord & 0xFF
          ret |= (x << (i * 8))
        end
        ret
      end


      def most_significant_bits(str)
        components = str.split("-")
        components = components.map{|i| "0x#{i}".to_i(16)}
        most_significant_bits = components[0]
        most_significant_bits = most_significant_bits << 16
        most_significant_bits |= components[1]
        most_significant_bits = most_significant_bits << 16
        most_significant_bits |= components[2]
        most_significant_bits
      end

      def least_significant_bits(str)
        components = str.split("-")
        components = components.map{|i| "0x#{i}".to_i(16)}
        least_sig_bits = components[3]
        least_sig_bits <<= 48;
        least_sig_bits |= components[4]
      end

      def resetToZero(byteArray)
       (0...byteArray.size).each do |index|
         byteArray[index] = "\0"
       end
      end
    end



    module DecodePrice
      extend PriceEncryptHelper
      KEY = "ar7rig33dwjlijnzwe8324tv6n9e4a9p"

      def self.decode_price(str)
        encryptedPrice = URI::decode(str)
        decrypted = getDecryptedPrice(encryptedPrice, KEY);      
        decrypted.price * 10
      end
    end
  end
end
