class DecksController < ApplicationController

  def new
    @deck = Deck.new
  end

  def create
    @deck = Deck.new(params[:deck])
    @deck.save
  end

  def destroy
    @deck = Deck.find(params[:id])
    @deck.destroy
    redirect_to rooms_url
  end
end
