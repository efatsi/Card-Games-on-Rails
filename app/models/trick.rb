class Trick < ActiveRecord::Base
  
  attr_accessible :lead_suit, :leader_id, :round_id
  
  belongs_to :round
  
  def determine_trick_winner(trick)
    max = trick.first
    leader_index = @players.index(@leader)
    4.times do |i|
      card = trick[(leader_index+i)%4]
      max = card if card.beats?(max)
    end
    @players[trick.index(max)] 
  end

end
