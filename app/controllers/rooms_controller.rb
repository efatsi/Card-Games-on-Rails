class RoomsController < ApplicationController

  before_filter :assign_room, :only => [:show, :destroy]
  before_filter :store_location, :only => :show
  before_filter :require_user, :only => :show
  skip_before_filter :occupy_no_room, :only => :show  

  def index
    @rooms = Room.all
  end

  def show
    join_the_room
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(params[:room])
    if @room.save
      redirect_to @room
    else
      render action: "new"
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_url
  end
  
  private
  def assign_room    
    @room = Room.find(params[:id])
  end
  
  def join_the_room
    current_user.update_attributes(:game_id => @room.game.id)
  end
  
end