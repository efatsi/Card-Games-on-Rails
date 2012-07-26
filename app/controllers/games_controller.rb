class GamesController < ApplicationController


  before_filter :store_location, :only => :show
  before_filter :require_user, :only => :show
  before_filter :assign_game, :only => [:show, :destroy, :next_player]

  def index
    @games = Game.all
  end

  def show
    join_game
    assign_variables
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
  
  def next_player
    render :json => @game
  end

  private
  def join_game
    unless @game.already_has?(current_user) or @game.is_full?
      Player.create(:user_id => current_user.id, :game_id => @game.id, :seat => @game.next_seat, :is_human => true)
    end
  end
  

end
