class CardPassingsController < ApplicationController
  
  before_filter :assign_game
  
  def pass_cards
    round = @game.last_round
    round.pass_cards
    
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'shared/game_page'
        else
          redirect_to @game
        end
      }
    end
  end
  
  def choose_card_to_pass
    player_choice = PlayerCard.find(params[:card].to_i)
    current_player.card_passing_set.player_cards << player_choice
  
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'shared/game_page'
        else
          redirect_to @game
        end
      }
    end
  end
  
  def fill_passing_sets
    round = @game.last_round
    round.fill_passing_sets
    
    respond_to do |format|
      format.html {
        if request.xhr?
          assign_variables
          render :partial => 'shared/game_page'
        else
          redirect_to @game
        end
      }
    end
  end
  
end
