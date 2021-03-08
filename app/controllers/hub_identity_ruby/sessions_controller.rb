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
        redirect_to "/"
      else
        flash[:alert] = "authentication failure"
        redirect_to sessions_new_path
      end
    end

    def destroy
      session.destroy
      flash[:notice] = "logged out sucessfully"
      redirect_to "/"
    end

    private

    def get_current_user
      HubIdentityRuby::Server.get_current_user(cookies[:_hub_identity_access])
    end
  end
end
