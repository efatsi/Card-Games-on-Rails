class PlayerRound < ActiveRecord::Base
  
  attr_accessible :player_id, :round_id, :round_score
  
  belongs_to :player
  belongs_to :round
  
end
