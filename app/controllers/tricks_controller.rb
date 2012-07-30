class TricksController < ApplicationController

  before_filter :assign_game

  def create
    sleep 2 unless @game.last_round.tricks.empty?
    current_round.create_trick
    
    reload_game_page
  end

end
