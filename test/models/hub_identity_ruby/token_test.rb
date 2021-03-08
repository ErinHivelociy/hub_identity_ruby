require 'test_helper'

module HubIdentityRuby
  class TokenTest < ActiveSupport::TestCase

    test "current_user/0 returns current_user when valid signature and not exired" do
      token_hash = generate_valid_token
      stub_request(:get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs").
       to_return(status: 200, body: JSON.fast_generate([token_hash[:cert]]), headers: {})

      current_user = HubIdentityRuby::Token.new(token_hash[:token]).current_user

      assert current_user[:email] == "erin@hivelocity.co.jp"
      assert current_user[:uid] == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
      assert current_user[:user_type] == "Identities.User"
    end

    test "current_user/0 returns nil when token expired" do
      stub_request(:get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs").
       to_return(status: 200, body: JSON.fast_generate(test_certs), headers: {})

      token = HubIdentityRuby::Token.new(test_tokens["access_token"])

      refute token.valid?
      assert_nil token.current_user
    end

    test "current_user/0 returns nil when the token is a refresh_token" do
      stub_request(:get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs").
       to_return(status: 200, body: JSON.fast_generate(test_certs), headers: {})

      token = HubIdentityRuby::Token.new(test_tokens["refresh_token"])

      assert_nil token.current_user
    end

    test "current_user/0 returns nil when invalid token" do
      stub_request(:get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs").
       to_return(status: 200, body: JSON.fast_generate(test_certs), headers: {})

      bad_token = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodWJfaWRlbnRpdHkiLCJleHAiOjE2MDk4MjY0NjMsImlhdCI6MTYwOTc0MDA2MywiaXNzIjoiaHViX2lkZW50aXR5IiwianRpIjoiNjRhNjM1MDItYTE1Ni00MDhlLTk2MmYtOWZiODgxMmVmNzliIiwibmJmIjoxNjA5NzQwMDYyLCJzdWIiOiJVc2Vycy5Vc2VyOjJjODUyYjNhLTM3MDktNGY4MS04NjA3LWU3NGFhZTQyNmM1NCIsInR5cCI6ImFjY2VzcyJ9.YkG-4ZXEzCZCGmRL0VPI-Bu1DY8_6shXfeNEnSAx0M77gpZHUZyO4E30JtLoiN_PdRdzBDf6JSaQRZr3xtaEmQ"

      token = HubIdentityRuby::Token.new(bad_token)
      assert_nil token.current_user
    end

    test "decoded_claims/0 returns the claims from the access token" do
      stub_request(:get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs").
       to_return(status: 200, body: JSON.fast_generate(test_certs), headers: {})

      claims = {
        :aud=>"https://stage-identity.hubsynch.com",
        :email=>"erin@hivelocity.co.jp",
        :exp=>1614655435,
        :iat=>1614651835,
        :iss=>"HubIdentity",
        :jti=>"945fb894-2ca6-4d86-a163-8de7a93d163a",
        :nbf=>1614651834,
        :owner_type=>nil,
        :owner_uid=>nil,
        :sub=>"Identities.User:380549d1-cf9a-4bcb-b671-a2667e8d2301",
        :typ=>"access",
        :uid=>"380549d1-cf9a-4bcb-b671-a2667e8d2301"
      }

      token = HubIdentityRuby::Token.new(test_tokens["access_token"])
      assert token.decoded_claims == claims
    end

    test "returns the claims from the refresh token" do
      stub_request(:get, "https://stage-identity.hubsynch.com/api/v1/oauth/certs").
       to_return(status: 200, body: JSON.fast_generate(test_certs), headers: {})

       claims = {
         :aud=>"https://stage-identity.hubsynch.com",
         :exp=>1614695035,
         :iat=>1614651835,
         :iss=>"HubIdentity",
         :jti=>"e4ed6dfc-05b4-4ee5-bbee-65607bc87a04",
         :nbf=>1614651834,
         :sub=>"Identities.User:380549d1-cf9a-4bcb-b671-a2667e8d2301",
         :typ=>"refresh"
       }

       token = HubIdentityRuby::Token.new(test_tokens["refresh_token"])
       assert token.decoded_claims == claims
    end
  end
end
