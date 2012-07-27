class PlayerCardsController < ApplicationController

  def select_for_play
    card_to_select = PlayerCard.find(params[:card].to_i)
    current_player.select_card(card_to_select)
    
    reload_game_page("shared/my_hand")
  end

end
