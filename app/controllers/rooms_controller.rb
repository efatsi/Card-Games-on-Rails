class RoomsController < ApplicationController

  before_filter :assign_room, :only => [:show, :destroy]

  def index
    @rooms = Room.all
  end

  def show
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
  
end
