class TricksController < ApplicationController

  before_filter :assign_game

  def create
    current_round.create_trick
    
    reload_partial
  end

end
