class RoundsController < ApplicationController
  
  before_filter :assign_game
  
  
  def create    
    @game.create_round

    reload_game_page  
  end
  
end
