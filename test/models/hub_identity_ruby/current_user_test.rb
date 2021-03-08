require 'test_helper'

module HubIdentityRuby
  class CurrentUserTest < ActiveSupport::TestCase

    test "returns the user params if valid" do
      current_user = HubIdentityRuby::CurrentUser.new(JSON.fast_generate(test_current_user)).hash

      assert current_user["email"] == "erin@hivelocity.co.jp"
      assert current_user["uid"] == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
      assert current_user["user_type"] == "Identities.User"
    end

    test "returns nil if invalid data" do
      assert_nil HubIdentityRuby::CurrentUser.new("test_current_user").hash
      assert_nil HubIdentityRuby::CurrentUser.new("").hash
      assert_nil HubIdentityRuby::CurrentUser.new(test_current_user.delete("email")).hash
      assert_nil HubIdentityRuby::CurrentUser.new(test_current_user.delete("uid")).hash
      assert_nil HubIdentityRuby::CurrentUser.new(test_current_user.delete("user_type")).hash
    end
  end
end
