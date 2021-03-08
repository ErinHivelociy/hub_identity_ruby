module HubIdentityRuby
  class CurrentUser

    def initialize(json_params)
      user_params = parse(json_params)
      @email = user_params["email"]
      @owner_type = user_params["owner_type"]
      @owner_uid = user_params["owner_uid"]
      @user_type = user_params["user_type"]
      @uid = user_params["uid"]
    end

    def hash
      hash_values if valid?
    end

    private

    def hash_values
      {
        "email" => @email,
        "owner_type" => @owner_type,
        "owner_uid" => @owner_uid,
        "user_type" => @user_type,
        "uid" => @uid
      }
    end

    def parse(json_params)
      begin
        JSON.parse(json_params)
      rescue
        {}
      end
    end

    def valid?
      @email.present? && @uid.present? && @user_type.present?
    end
  end
end
