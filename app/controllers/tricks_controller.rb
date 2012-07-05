class TricksController < ApplicationController
  
  def new
    @trick = Trick.create
  end
  
end
