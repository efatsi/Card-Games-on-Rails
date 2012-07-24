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
    
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'shared/game_page'
        else
            assign_variables
            render :partial => 'shared/game_page'
        end
      }
    end
  end

end
