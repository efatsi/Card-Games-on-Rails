class TricksController < ApplicationController

  before_filter :assign_game

  def create
    current_round.create_trick
    
    reload_game_page
  end

end
