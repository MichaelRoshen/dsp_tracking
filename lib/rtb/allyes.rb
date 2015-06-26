module Rtb
  module Allyes
    class DecodePrice
      ENCRYPTION_KEY = "faf1d00cfc63af352cf368a5f4381710" 
      class << self
        def decode_price(final_message)

              dec_message  = enc_to_src(final_message)
              
              enc_price,signature,impression_id = split_src dec_message

              price_pad = price_padding(impression_id)

              price  = price_xor_pads(enc_price,price_pad)

              price.to_f  
        end

        def split_src(src)
            enc_price = src[0,8]
            signature = src[8,4]
            impression_id = src[12..-1]
            [enc_price,signature,impression_id]
        end


        def price_xor_pads(p1, p2)
            p1.unpack('C*').zip(p2.unpack('C*')).map { |a,b| a^b }.pack('C*')
        end

        def enc_to_src(origin_code)
          base_str = CGI::unescape(origin_code).to_s.gsub(/-/,"+")
          base_str = base_str.gsub(/_/,"/")

          fill_bit  = base_str.length % 4
          return Base64.decode64 base_str+("="*fill_bit)
        end

        def price_padding(vector)
          OpenSSL::HMAC.digest("SHA1", ENCRYPTION_KEY, vector)[0, 8]
        end

      end
    end
  end
end