class CardsController < ApplicationController
  
  def show
    @card = Card.find(params[:id])
  end

end
