class SessionsController < ApplicationController

  def new
  end

  def create
    if user = User.authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      flash[:notice] = 'Welcome!'
      redirect_to root_path
    else
      flash.now[:error] =  "Couldn't locate a user with those credentials"
      render :action => :new
    end
  end
  
  def destroy
  	session[:user_id] = nil
  	redirect_to root_url
  end
  
end