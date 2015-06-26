require "openssl"
module Rtb
  module Gadx
    class DecodePrice
      def self.decode_price(str_decrypted_message)
        encryption_key = "1usin5bwZLBY8OZt/dtLUMTYa+JO+JtbuPwPYatkfh4=".unpack("m")[0].freeze
        integrity_key = "XAx4S9G7P/lE6PkqTjll+la/06BagHnLeu7Bm6+wtlE=".unpack("m")[0].freeze

        #### THIS IS THE WINNING_PRICE !!! ###
        # message_to_decode = "T0ypIgALCQQK4qYHWmBPUjOzcMHUuumeVIPa8Q"
        message_to_decode = str_decrypted_message

        # decoded = Base64 urlunsafe decode WINNING_PRICE
        # e_key = Base64 decode encryption key
        # i_key = Base64 decode integrity key
        decoded = message_to_decode.tr("-_", "+/").unpack("m")[0]

        # split message into 3 parts: initialization vector, encrypted price and signature
        iv, p, sig = decoded[0, 16], decoded[16, 8], decoded[24, 4]

        # generate padding (use first 8 bytes only)
        pad = OpenSSL::HMAC.digest("SHA1", encryption_key, iv)[0, 8]

        # p XOR pad, then convert to 64-bit integer
        price = price_from_pads(p, pad)

        # iv = 4-byte second and 4-byte microsecond
        timestamp = timestamp_from_iv(iv)
        ts = Time.at(timestamp)

        # Print final message
        #puts "Final price: #{price}, timestamp: #{ts}"

        # check integrity
        temp_p = temp_pack_p(p, pad)
        config_sig = OpenSSL::HMAC.digest("SHA1", integrity_key, temp_p.to_s + iv.to_s)[0, 3]
        #p "decoded #{decoded}"
        #p "config_sig -> #{config_sig}"
        #p "sig=> #{sig}"
        #p "ts => #{ts}"
        if config_sig == sig && check_correct_time(ts)
          return price
        else
          return 0
        end
      rescue Exception => e
        raise e
        0
      end

      def self.check_correct_time(ts)
        time_now_to_i = Time.now.to_i
        #p "Time now #{time_now_to_i}"
        return true if (time_now_to_i - ts.to_i) <= 300
        return false
      end

      def self.temp_pack_p(p1, p2)
        p1s = p1.unpack("NN")
        p2s = p2.unpack("NN")
        [(p1s[0] ^ p2s[0])].pack("N") + [(p1s[1] ^ p2s[1])].pack("N")
      end

      def self.price_from_pads(p1, p2)
        p1s = p1.unpack("NN")
        p2s = p2.unpack("NN")
        (p1s[0] ^ p2s[0]) * 4294967296 + (p1s[1] ^ p2s[1])
      end

      def self.timestamp_from_iv(iv)
        seconds, micros = iv.unpack("NN")
        seconds + micros / 1000000
      end

    end
  end
end
#p Rtb::Gadx::DecodePrice.decode_price("T3BalwAK2FcK4qcGBl9Pos54cFVVnYZA-20YcQ")
