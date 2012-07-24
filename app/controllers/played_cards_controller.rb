class PlayedCardsController < ApplicationController

  before_filter :assign_game

  def create
    round = @game.last_round
    trick = round.last_trick
    player = trick.next_player
    player_choice = PlayerCard.find(params[:card].to_i) if params[:card]
    trick.play_card_from(player, player_choice)

    if trick.reload.is_over?
      round.calculate_round_scores
      if round.is_over?
        round.update_total_scores
        @game.check_for_and_set_winner
      end
    end

    reload_game_page
  end
  
  
  def play_all_but_one_trick  
    round = @game.last_round
    (12 - round.tricks_played).times do
      if round.tricks_played != 13
        trick = Trick.create(:round_id => round.id, :leader_id => round.get_new_leader.id, :position => round.next_trick_position)
        trick.play_trick
      end  
    end  
    round.calculate_round_scores
    round.update_total_scores if round.tricks_played == 13
    
    reload_game_page
  end

end
