class CardsController < ApplicationController
  
  def show
    @card = Card.find(params[:id])
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(params[:card])
    @card.save
  end

end
