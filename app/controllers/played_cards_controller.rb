class PlayedCardsController < ApplicationController

  before_filter :assign_game

  def create
    player = @game.last_trick.next_player
    player_choice = PlayerCard.find(params[:card].to_i) if params[:card]
    @game.last_trick.play_card_from(player, player_choice)
    @game.update_scores_if_necessary
    if @game.last_trick.next_player.username.include?("cp") && @game.last_trick.is_not_over?
      create
    else
      reload_game_page
    end
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

end
