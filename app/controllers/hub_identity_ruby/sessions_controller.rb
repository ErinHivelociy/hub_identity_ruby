require_dependency "hub_identity_ruby/application_controller"

module HubIdentityRuby
  class SessionsController < ApplicationController

    def new
      redirect_to "#{HubIdentityRuby::Server.hostname}/browser/v1/providers?api_key=#{public_key}"
    end

    def create
      current_user = get_current_user
      if current_user.present?
        session[:current_user] = current_user
        flash[:notice] = "logged in sucessfully through HubIdentity"
        redirect_to "/"
      else
        flash[:alert] = "authentication failure"
        redirect_to "/"
      end
    end

    def destroy
      session.destroy
      flash[:notice] = "logged out sucessfully"
      redirect_to "/"
    end

    private

    def get_current_user
      HubIdentityRuby::Server.get_current_user(params["user_token"])
    end

    def public_key
      ENV['HUBIDENTITY_PUBLIC_KEY']
    end
  end
end
