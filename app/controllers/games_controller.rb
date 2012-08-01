class GamesController < ApplicationController


  before_filter :store_location, :only => :show
  before_filter :require_user, :only => :show
  before_filter :assign_game, :only => [:show, :destroy]

  def index
    @games = Game.all
  end

  def show
    @game.add_player_from_user(current_user)
    
    respond_to do |format|
      format.html
      format.json do
        render :json => {
          :computerShouldPlay => @game.next_player.try(:is_computer?) && @game.mid_trick_time?,
          :shouldStartNewRound => @game.is_ready_for_a_new_round?,
          :shouldStartNewTrick => @game.is_ready_for_a_new_trick?,
          :shouldPassCards => @game.ready_to_pass?,
          :isFirstRound => @game.rounds.empty?,
          :isFirstTrick => current_round.try(:tricks).try(:empty?)
          :currentPlayerIsBystander => current_player.is_a_bystander?
          :isCurrentPlayersTurn => @game.is_current_players_turn?(current_player)
        }
      end
    end
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

end
