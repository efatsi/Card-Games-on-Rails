class CardPassingsController < ApplicationController

  before_filter :assign_game

  def pass_cards
    round = @game.last_round
    round.pass_cards

    reload_game_page
  end

  def choose_card_to_pass
    player_choice = PlayerCard.find(params[:card].to_i)
    current_player.card_passing_set.player_cards << player_choice

    reload_game_page
  end

end
