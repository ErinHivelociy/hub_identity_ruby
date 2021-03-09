require "test_helper"

module HubIdentityRuby
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "authenticated route should redirect to /" do
      get "/page_1"
      assert_redirected_to hub_identity_ruby.sessions_new_path
    end

    test "non-authenticated route should allow to continue" do
      get "/open"
      assert_equal "open", @controller.action_name
    end

    test "when authenticated user allows them to continue" do
      stub_request(:get, "https://stage-identity.hubsynch.com:443/api/v1/current_user/test_cookie_id").
        to_return(status: 200, body: JSON.fast_generate(test_current_user), headers: {})

      get hub_identity_ruby.sessions_create_path(user_token: "test_cookie_id")

      get "/page_1"
      assert_response :success
    end

    test "when authenticated assigns the current_user" do
      stub_request(:get, "https://stage-identity.hubsynch.com:443/api/v1/current_user/test_cookie_id").
        to_return(status: 200, body: JSON.fast_generate(test_current_user), headers: {})

      get hub_identity_ruby.sessions_create_path(user_token: "test_cookie_id")

      get "/page_1"
      assert_response :success

      current_user = assigns(:current_user)

      assert current_user["email"] == "erin@hivelocity.co.jp"
      assert current_user["uid"] == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
      assert current_user["user_type"] == "Identities.User"
    end
  end
end
