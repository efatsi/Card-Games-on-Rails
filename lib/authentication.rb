module Authentication

  extend ActiveSupport::Concern 

  private      
  def require_user
    unless current_user
      redirect_to login_path, alert: "Sorry, gotta login really quick"
      return false
    end
  end

  def store_location
    if request.get? and !request.xhr?
      session[:return_to] = request.url
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end