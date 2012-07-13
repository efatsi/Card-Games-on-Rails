class RoomsController < ApplicationController

  before_filter :assign_room, :only => [:show, :destroy, :fill, :deal_cards, :play_trick]
  before_filter :store_location, :only => :show
  before_filter :require_user, :only => :show
  skip_before_filter :occupy_no_room, :only => [:show, :fill, :deal_cards, :play_trick]

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
  
  # UNRESTFUL ACTIONS
  
  def fill
    (4 - @room.players.length).times do
      User.create(:username => "cp#{User.all.length+10}", :game_id => @room.game.id)
    end
    redirect_to @room
  end
  
  def deal_cards
    @game = @room.game
    @round = @game.last_round
    @round ||= HeartsRound.create(:game_id => @game.id, :dealer_index => 0)
    @round.deal_cards
    redirect_to @room
  end

  def play_trick
    @round = @room.game.last_round
    new_trick = HeartsTrick.create(:round_id => @room.game.rounds.last.id, :leader_index => @round.get_leader_index)
    new_trick.play_trick
    redirect_to @room
  end
  
  
  private
  def assign_room    
    @room = Room.find(params[:id])
  end
  
  def join_the_room
    current_user.update_attributes(:game_id => @room.game.id) if current_user.game_id != @room.game.id
  end
  
  
end