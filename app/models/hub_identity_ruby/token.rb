require 'jwt'

module HubIdentityRuby
  class Token

    def initialize(jwt_token)
      token_array = jwt_token.split(".")
      @headers = token_array[0]
      @claims = token_array[1]
      @signature = Base64.urlsafe_decode64(token_array[2])
    end

    def current_user
      if valid? && type == "access"
        user_params
      else
        nil
      end
    end

    def decoded_claims
      decode_and_parse(@claims)
    end

    def decoded_headers
      decode_and_parse(@headers)
    end

    def expired?
      Time.now > expiration_time
    end

    def expiration_time
      Time.at(decoded_claims[:exp])
    end

    def issuer
      decoded_claims[:iss]
    end

    def type
      decoded_claims[:typ]
    end

    def valid?
      valid_signature? && !expired? && issuer == "HubIdentity"
    end

    def valid_signature?
      begin
        rsa_public_key.verify(OpenSSL::Digest.new('sha256'), @signature,  @headers + "." + @claims)
      rescue
        false
      end
    end

    private

    def decode_and_parse(string)
      decoded = Base64.urlsafe_decode64(string)
      JSON.parse(decoded, symbolize_names: true)
    end

    def rsa_public_key
      key = Server.get_cert(decoded_headers[:kid])
      JWT::JWK.import(key).public_key if key
    end

    def user_params
      {
        email: decoded_claims[:email],
        owner_type: decoded_claims[:owner_type],
        owner_uid: decoded_claims[:owner_uid],
        uid: decoded_claims[:uid],
        user_type: user_type
      }
    end

    def user_type
      decoded_claims[:sub].split(":").first
    end
  end
end
