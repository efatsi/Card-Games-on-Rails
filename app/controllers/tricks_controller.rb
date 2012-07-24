class TricksController < ApplicationController

  before_filter :assign_game

  def create
    round = @game.last_round
    trick = Trick.create(:round_id => round.id, :leader_id => round.get_new_leader.id, :position => round.next_trick_position)
    
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
