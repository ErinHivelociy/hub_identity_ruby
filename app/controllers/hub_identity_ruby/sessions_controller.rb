require_dependency "hub_identity_ruby/application_controller"

class SessionsController < ApplicationController

  def new
    redirect_to "#{ENV['HUBIDENTITY_URL']}/browser/v1/providers?api_key=#{ENV['HUBIDENTITY_PUBLIC_KEY']}"
  end

  def create
    cookie_id = cookies[:_hub_identity_access]
    current_user = HubIdentity::Server.get_current_user(cookie_id)
    session[:current_user] = current_user if current_user
    redirect_to "/"
  end

  def destroy
    session[:current_user] = nil
    reset_session
    redirect_to "/"
  end
end
