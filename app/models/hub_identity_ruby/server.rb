require 'net/http'

module HubIdentityRuby
  class Server
    HUBIDENTITY_BASE_URL = "https://stage-identity.hubsynch.com"

    def self.certs
      uri = URI("#{hostname}/api/v1/oauth/certs")
      certs = Net::HTTP.get(uri)
      JSON.parse(certs, symbolize_names: true)
    end

    def self.get_cert(key_id)
      certs.find {|key| key[:kid] == key_id}
    end

    def self.get_current_user(cookie_id)
      if cookie_id.present?
        uri = URI("#{hostname}/api/v1/current_user/#{cookie_id}")
        request = build_private_key_request(uri)
        response = Net::HTTP.start(uri.hostname, uri.port) {|http|
          http.request(request)
        }
        if response.code == "200"
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

      def build_private_key_request(uri)
        request = Net::HTTP::Get.new(uri)
        request["x-api-key"] = ENV['HUBIDENTITY_PRIVATE_KEY']
        request
      end
    end
  end
end
