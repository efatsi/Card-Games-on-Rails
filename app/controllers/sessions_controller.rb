class SessionsController < ApplicationController

  def new
  end

  def create
    if user = User.authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      flash[:notice] = 'Welcome!'
      redirect_back_or_default(root_path)
    else
      flash.now[:error] =  "Username or password was incorrect"
      render :action => :new
    end
  end
  
  def destroy
  	session[:user_id] = nil
  	redirect_to root_url
  end
  
end