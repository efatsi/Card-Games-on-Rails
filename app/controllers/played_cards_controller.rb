class PlayedCardsController < ApplicationController

  before_filter :assign_game

  def create
    card = PlayerCard.find(params[:card].to_i) if params[:card]
    @game.play_card(card)
    @game.update_scores_if_necessary
    reload_partial
  end
  
end
