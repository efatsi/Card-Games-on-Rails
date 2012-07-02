class RoomsController < ApplicationController

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
    format.html
  end
  
  def new
    @room = Room.new
    format.html
  end

  def create
    @room = Room.new(params[:room])

    if @room.save
      redirect_to @room, notice: 'Room was successfully created.'
    else
      render action: "new"
    end
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    format.html { redirect_to rooms_url }
    end
  end
end
