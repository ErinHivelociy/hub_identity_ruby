require_dependency "hub_identity_ruby/application_controller"

module HubIdentityRuby
  class SessionsController < ApplicationController

    def new
      redirect_to "#{ENV['HUBIDENTITY_URL']}/browser/v1/providers?api_key=#{ENV['HUBIDENTITY_PUBLIC_KEY']}"
    end

    def create
      current_user = get_current_user
      if current_user
        session[:current_user] = current_user
        flash[:notice] = "logged in sucessfully through HubIdentity"
        redirect_to "/"
      else
        flash[:alert] = "authentication failure"
        redirect_to sessions_new_path
      end
    end

    def destroy
      if params[:hub_identity] == "true"
        flash[:notice] = "logged out of HubIdentity sucessfully"
        cookies.delete :_hub_identity_access
        logout_user
      else
        flash[:notice] = "logged out sucessfully"
        logout_user
      end
    end

    private

    def get_current_user
      HubIdentityRuby::Server.get_current_user(cookies[:_hub_identity_access])
    end

    def logout_user
      session.destroy
      redirect_to "/"
    end
  end
end
