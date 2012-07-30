class RoundsController < ApplicationController
  
  before_filter :assign_game
  
  
  def create
    
    # to be removed when I figure out how to sleep in javascript
    if @game.rounds.empty?
      sleep 1
    else
      sleep 3
    end
    
    @game.create_round

    reload_game_page  
  end
  
end
