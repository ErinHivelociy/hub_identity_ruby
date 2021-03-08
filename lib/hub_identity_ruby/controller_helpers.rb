module HubIdentityRuby
  module ControllerHelpers

    def authenticate_user!
      redirect_to hub_identity_ruby.sessions_new_path unless current_user?
    end

    def current_user?
      session[:current_user]
    end

    def set_current_user
      @current_user = session[:current_user]
    end
  end
end
