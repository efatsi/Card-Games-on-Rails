class UsersController < ApplicationController
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url      
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render action: "edit"
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    yourself = true if current_user == @user
    @user.destroy
    redirect_to (yourself ? logout_url : root_url)
  end
end
