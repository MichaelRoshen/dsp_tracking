# encoding: utf-8
require 'net/http'
require 'base64'
require 'uri'
require 'digest/md5'

module Rtb
  module Tanx
    class DecodePrice
      TANX_CODE = "2c12f693072c30a571f5c14dacd061e6"
      #TANX_CODE = "f7dbeb735b7a07f1cfca79cc1dfe4fa4"

      def self.decode_price(origin_code="")

        #origin_code = "AbuI6wqbQlBm2UUAAAEAAADaQPIFMFCbeQ%3D%3D"
        encry_str = enc_to_src(origin_code)
        bid = encry_str[1..16]
        p_encry = encry_str[17..20]
        #  print_str("encry_str:" , encry_str)
        #  print_str("BID:",bid)
        #  print_str("P_encrypt:" , p_encry)

        key = ""
        tmp = ""
        TANX_CODE.split("").each_with_index do |c , i |
          if i % 2 == 1
            tmp += c
            key << tmp.hex.chr
          else
            tmp = c
          end
        end
        #print_str("Key:", key)
        p_settle = bid + key
        #print_str("P_settle:" , p_settle)
        md5 = Digest::MD5.hexdigest(p_settle)
        #puts "MD5:#{md5}"
        h4 = ""
        md5.split("").each_with_index do |c , i |
          if i % 2 == 1
            tmp += c
            h4 << tmp.hex.chr
          else
            tmp = c
          end
        end

        price = p_encry.unpack("b*").first.to_i(2) ^ h4[0..3].unpack("b*").first.to_i(2)

        ver = encry_str[0..0]
        p = ("%032d" % price.to_s(2))
        price_char = "#{p[0..7].reverse.to_i(2).chr}#{p[8..15].reverse.to_i(2).chr}#{p[16..23].reverse.to_i(2).chr}#{p[24..31].reverse.to_i(2).chr}"
        str = ver + bid + price_char + key
        #print "input:"
        #str.each_byte{|b| print "#{b},"}
        crc = Digest::MD5.hexdigest(str)
        c_crc = crc[0..1].hex.chr + crc[2..3].hex.chr + crc[4..5].hex.chr + crc[6..7].hex.chr

        # check crc if true return winning price else return null
        if c_crc == encry_str[21..24]
          to_int("%032d" % price.to_s(2))
          # puts true
        else
          nil
          # puts false
        end
        # encry_str[21..24].each_byte{|b| puts b}
      rescue Exception
        0
      end

      def self.to_int(bit_32)
        bit_32 = bit_32.reverse
        #  puts bit_32
        bit_32.to_i(2)
      end

      def self.enc_to_src(origin_code)
        base_str = URI.unescape(origin_code)
        return Base64.decode64(base_str)
      end

    end
  end
end
#Rtb::Tanx::DecodePrice.decode_price("AbuI6wqbQlBm2UUAAAEAAADaQPIFMFCbeQ%3D%3D")
