require "test_helper"

module HubIdentityRuby
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
    end

    test "the truth" do
      assert_generates "/hub_identity_ruby/sessions/new", :controller => "hub_identity_ruby/sessions", :action => "new"
    end
  end
end
