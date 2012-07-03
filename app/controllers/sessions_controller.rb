class SessionsController < ApplicationController

  def new
  end

  def create
    if user = User.authenticate(params[:username], params[:password])
      self.current_user = user
      flash[:notice] = 'Welcome!'
      redirect_to root_path
    else
      flash.now[:error] =  "Couldn't locate a user with those credentials"
      render :action => :new
    end
  end
  
end