class RoundsController < ApplicationController
  
  def create
    @game = Game.find(params[:game_id])
    round = Round.create(:game_id => @game.id, :dealer_id => @game.get_new_dealer.id, :position => @game.next_round_position)
    round.deal_cards
    
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
