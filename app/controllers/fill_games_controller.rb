class FillGamesController < ApplicationController
  
  before_filter :assign_game

  def fill
    @game.fill_empty_seats
    reload_partial
  end
  
end
