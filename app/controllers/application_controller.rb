class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  include SimplestAuth::Controller
  include CardGames::Authentication
  
  def current_player
    current_user.try(:current_player)
  end
  
  def assign_variables    
    @game = Game.find(params[:id])
    #my_hand
    @hand = current_player.try(:hand)
    @lead_suit = @game.get_lead_suit
    @my_turn = @game.is_current_player_next?(current_player)
    #game_progress
    @last_trick = @game.last_trick
    @played_cards = @game.played_cards
    @trick_over = @game.trick_over?
  end
  
end
