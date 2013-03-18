require 'hmac'
require 'hmac-sha2'
require 'base64'

class HmacSignature
  def initialize(key)
    @key = key
  end

  def sign(verb, host, path, query_params)
    sorted_params = query_params.sort.map do |param|
      param.join("=")
    end

    canonicalized_params = sorted_params.join("&")
    string_to_sign = verb + host + path + canonicalized_params

    # construct an hmac signer using our secrey key
    hmac = HMAC::SHA256.new(@key)
    hmac.update(string_to_sign)
    Base64.encode64(hmac.digest).chomp
  end
end
