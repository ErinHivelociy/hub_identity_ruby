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
      stub_request(:get, "https://stage-identity.hubsynch.com:443/api/v1/current_user/#{cookie_id}").
        to_return(status: 200, body: JSON.fast_generate(test_current_user), headers: {})

       current_user = HubIdentityRuby::Server.get_current_user(cookie_id)

       assert current_user["email"] == "erin@hivelocity.co.jp"
       assert current_user["uid"] == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
    end

    test "get_current_user/1 returns nil if invalid cookie" do
      cookie_id = "invalid_cookie_id"
      stub_request(:get, "https://stage-identity.hubsynch.com:443/api/v1/current_user/#{cookie_id}").
        to_return(status: 400, body: "bad request", headers: {})

      assert_nil HubIdentityRuby::Server.get_current_user(cookie_id)
    end

    test "get_current_user/1 returns nil if cookie is empty" do
      assert_nil HubIdentityRuby::Server.get_current_user("")
      assert_nil HubIdentityRuby::Server.get_current_user(nil)
    end
  end
end
