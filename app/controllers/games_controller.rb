class GamesController < ApplicationController


  before_filter :assign_game, :only => [:show, :destroy, :fill, :deal_cards, :play_trick]
  before_filter :store_location, :only => :show
  before_filter :require_user, :only => :show
  skip_before_filter :occupy_no_game, :only => [:show, :fill, :deal_cards, :play_trick]

  def index
    @games = Game.all
  end

  def show
    join_the_game
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])
    if @game.save
      redirect_to @game
    else
      render action: "new"
    end
  end

  def destroy
    @game.destroy
    redirect_to games_url
  end
  
  # UNRESTFUL ACTIONS
  
  def fill
    (4 - @game.players.length).times do |i|
      User.create(:username => "cp#{12+i}", :game_id => @game.game.id, :seat => @game.game.reload.next_seat)
    end
    redirect_to @game
  end
  
  def deal_cards
    @round = @game.last_round
    @round ||= HeartsRound.create(:game_id => @game.id, :dealer_seat => 0)
    @round.deal_cards
    redirect_to @game
  end

  def play_trick
    @round = @game.game.last_round
    new_trick = HeartsTrick.create(:round_id => @game.game.rounds.last.id, :leader_seat => @round.get_leader_seat)
    new_trick.play_trick
    redirect_to @game
  end
  
  
  private
  def assign_game    
    @game = Game.find(params[:id])
  end
  

end
