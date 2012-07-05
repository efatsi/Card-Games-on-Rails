class RoundsController < ApplicationController
 
  def new
    @round = Round.create
  end
  
end
