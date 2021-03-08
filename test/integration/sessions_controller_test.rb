require "test_helper"

module HubIdentityRuby
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
    end

    test "routes are included into the application" do
      assert_generates "/hub_identity_ruby/sessions/new", :controller => "hub_identity_ruby/sessions", :action => "new"
      assert_generates "/hub_identity_ruby/sessions/create", :controller => "hub_identity_ruby/sessions", :action => "create"
      assert_generates "/hub_identity_ruby/sessions/destroy", :controller => "hub_identity_ruby/sessions", :action => "destroy"
    end

    test "new/0 redirects to HubIdentity server" do
      get hub_identity_ruby.sessions_new_path
      assert_redirected_to "/browser/v1/providers?api_key="
    end

    test "create/0 calls HubIdentity with the cookie" do
      stub_request(:get, "http://stage-identity.hubsynch.com:443/api/v1/current_user/test_cookie_id").
        to_return(status: 200, body: JSON.fast_generate(test_current_user), headers: {})

      get hub_identity_ruby.sessions_create_path, headers: {"HTTP_COOKIE" => "_hub_identity_access=test_cookie_id;"}

      current_user = @controller.session[:current_user]
      assert current_user["email"] == "erin@hivelocity.co.jp"
      assert current_user["uid"] == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
      assert current_user["user_type"] == "Identities.User"
    end

    test "create/0 does not assign the current_user if the user is nil" do
      stub_request(:get, "http://stage-identity.hubsynch.com:443/api/v1/current_user/test_cookie_id").
        to_return(status: 200, body: "", headers: {})

      get hub_identity_ruby.sessions_create_path, headers: {"HTTP_COOKIE" => "_hub_identity_access=test_cookie_id;"}

      assert_nil @controller.session[:current_user]
    end

    test "create/0 redirects to / when successful" do
      stub_request(:get, "http://stage-identity.hubsynch.com:443/api/v1/current_user/test_cookie_id").
        to_return(status: 200, body: JSON.fast_generate(test_current_user), headers: {})

      get hub_identity_ruby.sessions_create_path, headers: {"HTTP_COOKIE" => "_hub_identity_access=test_cookie_id;"}

      assert_redirected_to "/"
    end

    test "create/0 redirects to new session path if no current_user" do
      stub_request(:get, "http://stage-identity.hubsynch.com:443/api/v1/current_user/test_cookie_id").
        to_return(status: 200, body: "", headers: {})

      get hub_identity_ruby.sessions_create_path, headers: {"HTTP_COOKIE" => "_hub_identity_access=test_cookie_id;"}

      assert_nil @controller.session[:current_user]
      assert @controller.flash.alert == "authentication failure"
      assert_redirected_to sessions_new_path
    end

    test "create/0 redirects to new session path if no cookie" do
      get hub_identity_ruby.sessions_create_path
      assert_nil @controller.session[:current_user]
      assert @controller.flash.alert == "authentication failure"
      assert_redirected_to sessions_new_path
    end

    test "destroy/0 removes the user from the session" do
      stub_request(:get, "http://stage-identity.hubsynch.com:443/api/v1/current_user/test_cookie_id").
        to_return(status: 200, body: JSON.fast_generate(test_current_user), headers: {})

      get hub_identity_ruby.sessions_create_path, headers: {"HTTP_COOKIE" => "_hub_identity_access=test_cookie_id;"}

      refute_nil @controller.session[:current_user]

      delete hub_identity_ruby.sessions_destroy_path

      assert_nil @controller.session[:current_user]
    end

    test "destroy/0 redirects to the / path" do
      delete hub_identity_ruby.sessions_destroy_path
      assert_redirected_to "/"
    end

    test "destroy/0 puts a flash notice" do
      delete hub_identity_ruby.sessions_destroy_path

      assert @controller.flash.notice == "logged out sucessfully"
    end
  end
end
