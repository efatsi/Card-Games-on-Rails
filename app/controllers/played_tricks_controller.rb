class PlayedTricksController < ApplicationController
  
  def new
    @played_trick = PlayedTrick.create
  end

end
