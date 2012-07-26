class PlayedCardsController < ApplicationController

  before_filter :assign_game

  def create
    play_a_card
    update_and_create_if_necessary
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
    player_choice = PlayerCard.find(params[:card].to_i) if (card_was_selected_by?(player))
    @game.last_trick.play_card_from(player, player_choice)
    sleep 1 if player.is_computer?
  end
  
  
  def card_was_selected_by?(player)
    params[:card] && player.is_human?
  end
  
  def update_and_create_if_necessary
    @game.update_scores_if_necessary
    if @game.last_round.is_ready_for_a_new_trick?
      round = @game.last_round
      trick = Trick.create(:round_id => round.id, :leader_id => round.get_new_leader.id, :position => round.next_trick_position)
    elsif @game.is_ready_for_a_new_round?
      round = Round.create(:game_id => @game.id, :dealer_id => @game.get_new_dealer.id, :position => @game.next_round_position)
      round.deal_cards
    end
  end
  
end
