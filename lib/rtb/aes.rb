require 'openssl'
require 'base64'

# usage: 

# KEY = "***************************************"

# puts AesEncryptDecrypt.encryption(KEY, "gurudath", "AES-128-ECB")
# puts AesEncryptDecrypt.decryption(KEY, "mCwOIMl+EG2DFUkIaOHCpQ==", "AES-128-ECB")
# mCwOIMl+EG2DFUkIaOHCpQ==
# gurudath

# puts AesEncryptDecrypt.encryption(KEY, "gurudath", "AES-256-CBC")
# puts AesEncryptDecrypt.decryption(KEY, "jbhZh7fl0oUAM1xU+kQyAw==", "AES-256-CBC")
# jbhZh7fl0oUAM1xU+kQyAw==
# gurudath


module Rtb
  module Aes
    class DecodePrice
      class << self
        def decode_price(msg)
          # key = '1b070a4bfce948b7a42b6ca0a7dabfcb'
          key = 'c2de1527874d4780a1544cfc80c0a27b'
          algorithm = "AES-128-ECB"
          begin
            msg = Base64.urlsafe_decode64(msg.to_s+'=')
            cipher = OpenSSL::Cipher.new(algorithm)
            cipher.decrypt()
            cipher.key = [key].pack 'H*'
            crypt = cipher.update(msg) + cipher.final()
            return crypt
          rescue Exception => exc
            puts ("Message for the decryption log file for message #{msg} = #{exc.message}")
          end
        end
      end
    end
  end
end

# class AesEncryptDecrypt
#   def self.encryption(key, msg, algorithm)
#     begin
#       cipher = OpenSSL::Cipher.new(algorithm)
#       cipher.encrypt()
#       cipher.key = [key].pack 'H*'
#       crypt = cipher.update(msg) + cipher.final()
#       crypt_string = (Base64.urlsafe_encode64(crypt))
#       return crypt_string[0..-2]
#     rescue Exception => exc
#       puts ("Message for the encryption log file for message #{msg} = #{exc.message}")
#     end
#   end
  
#   def self.decryption(key, msg, algorithm)
#     begin
#       msg = Base64.urlsafe_decode64(msg.to_s+'=')
#       cipher = OpenSSL::Cipher.new(algorithm)
#       cipher.decrypt()
#       cipher.key = [key].pack 'H*'
#       crypt = cipher.update(msg) + cipher.final()
#       return crypt
#     rescue Exception => exc
#       puts ("Message for the decryption log file for message #{msg} = #{exc.message}")
#     end
#   end
# end

# # value = '110_1421917080756'
# # KEY = 'c2de1527874d4780a1544cfc80c0a27b'
# # result = '9O0evHnIYsMSHRwYe5Bq5li6bQ0d2PWfPmyrPW60jvo'
# # puts AesEncryptDecrypt.encryption(KEY, value, "AES-128-ECB")



# value = "130_1421917080759"
# KEY =  "c2de1527874d4780a1544cfc80c0a27b"
# puts AesEncryptDecrypt.encryption(KEY, value, "AES-128-ECB")
# # FmGi6BLUp4ZrW0xxgCPUbcwRi0IrAFhknmHnQuMGneM
# # FmGi6BLUp4ZrW0xxgCPUbcwRi0IrAFhknmHnQuMGneM

# result = 'FmGi6BLUp4ZrW0xxgCPUbcwRi0IrAFhknmHnQuMGneM'
# puts AesEncryptDecrypt.decryption(KEY, result, "AES-128-ECB")


