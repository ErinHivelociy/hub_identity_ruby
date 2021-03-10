module HubIdentityRuby
  class Server
    HUBIDENTITY_BASE_URL = "https://stage-identity.hubsynch.com"

    def self.certs
      # response = Faraday.get "#{hostname}/api/v1/oauth/certs"
      response = Excon.get("#{hostname}/api/v1/oauth/certs")
      JSON.parse(response.body, symbolize_names: true)
    end

    def self.get_cert(key_id)
      certs.find {|key| key[:kid] == key_id}
    end

    def self.get_current_user(user_token)
      if user_token.present?
        url = "#{hostname}/api/v1/current_user/#{user_token}"
        response = Excon.get(url, :headers => {'x-api-key' => private_api_key})
        # response = Faraday.get(url) do |req|
        #   req.headers['x-api-key'] = private_api_key
        # end

        if response.status == 200
          CurrentUser.new(response.body).hash
        else
          nil
        end
      end
    end

    def self.hostname
      ENV['HUBIDENTITY_URL'] || HUBIDENTITY_BASE_URL
    end

    class << self
      private

      def private_api_key
        ENV['HUBIDENTITY_PRIVATE_KEY']
      end
    end
  end
end

