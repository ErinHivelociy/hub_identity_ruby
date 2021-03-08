require 'test_helper'

module HubIdentityRuby
  class ServerTest < ActiveSupport::TestCase

    test "certs/0 retreives the certs from HubIdentity" do
      stub_request(:get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs").
       to_return(status: 200, body: JSON.fast_generate(test_certs), headers: {})

      assert HubIdentityRuby::Server.certs == test_certs

      assert_requested :get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs", times: 1
    end


    test "certs/1 returns the cert with the key_id given" do
      stub_request(:get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs").
       to_return(status: 200, body: JSON.fast_generate(test_certs), headers: {})

      cert = test_certs[0]

      assert HubIdentityRuby::Server.get_cert(cert[:kid]) == cert

      assert_requested :get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs", times: 1
    end

    test "certs/1 returns nil if the cert is not found" do
      stub_request(:get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs").
       to_return(status: 200, body: JSON.fast_generate(test_certs), headers: {})

      assert_nil HubIdentityRuby::Server.get_cert("not_there")

      assert_requested :get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs", times: 1
    end

    test "get_current_user/1 returns a current_user with valid cookie" do
      cookie_id = "test_cookie_id"
      stub_request(:get, "http://stage-identity.hubsynch.com:443/api/v1/current_user/#{cookie_id}").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'Host'=>'stage-identity.hubsynch.com',
         'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: JSON.fast_generate(test_current_user), headers: {})

       current_user = HubIdentityRuby::Server.get_current_user(cookie_id)

       assert current_user[:email] == test_current_user[:emal]
       assert current_user[:uid] == test_current_user[:uid]
    end

    test "get_current_user/1returns nil if invalid cookie" do
      cookie_id = "invalid_cookie_id"
      stub_request(:get, "http://stage-identity.hubsynch.com:443/api/v1/current_user/#{cookie_id}").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'Host'=>'stage-identity.hubsynch.com',
         'User-Agent'=>'Ruby'
          }).
        to_return(status: 400, body: "bad request", headers: {})

      assert_nil HubIdentityRuby::Server.get_current_user(cookie_id)
    end
  end
end
