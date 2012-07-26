class RoundsController < ApplicationController
  
  before_filter :assign_game
  
  def create
    sleep 3 unless @game.rounds.empty?
    round = Round.create(:game_id => @game.id, :dealer_id => @game.get_new_dealer.id, :position => @game.next_round_position)
    round.deal_cards
    round.fill_computer_passing_sets
    
    reload_game_page  
  end
  
end
