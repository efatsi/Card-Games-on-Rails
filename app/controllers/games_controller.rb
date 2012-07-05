class GamesController < ApplicationController

  def new
    @game = Game.create
  end

end
