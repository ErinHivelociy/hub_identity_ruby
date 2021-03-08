module Authentication

  def authenticate_user!
    redirect_to "/" unless current_user?
  end

  def current_user?
    session[:current_user]
  end

  def set_current_user
    @current_user = session[:current_user]
  end
end
