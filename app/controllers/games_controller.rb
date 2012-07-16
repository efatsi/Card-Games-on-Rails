class GamesController < ApplicationController


  before_filter :assign_game, :only => [:show, :destroy]
  before_filter :store_location, :only => :show
  before_filter :require_user, :only => :show

  def index
    @games = Game.all
  end

  def show
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
  
  
  private
  def assign_game    
    @game = Game.find(params[:id])
  end
  

end
