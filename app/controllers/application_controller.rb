class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  include SimplestAuth::Controller
  include CardGames::Authentication
  
  def current_player
    current_user.try(:current_player)
  end
  
  def assign_game
    @game = current_game
  end
  
  def current_game
    Game.find(params[:id] || params[:game_id])
  end
  
  def current_round
    current_game.last_round
  end
  
  def reload_game_page(partial = "shared/game_page")
    assign_game #don't know why I need this here, but if it's not here card passing isn't requested when it should be
    respond_to do |format|
      format.html {
        if request.xhr?
          render :partial => partial
        else
          redirect_to @game
        end
      }
    end
  end
  
end
