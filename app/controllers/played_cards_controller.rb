class PlayedCardsController < ApplicationController

  before_filter :assign_game

  def create
    play_a_card
    @game.update_scores_if_necessary
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
    
    reload_game_page
  end
  
  private
  def play_a_card
    player = @game.next_player
    # sleep 1 if player.is_computer?
    player_choice = PlayerCard.find(params[:card].to_i) if (card_was_selected_by?(player))
    @game.last_trick.play_card_from(player, player_choice)
  end
  
  
  def card_was_selected_by?(player)
    params[:card] && player.is_human?
  end
  
end
