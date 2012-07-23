class CardsToPass < ActiveRecord::Base
  
  belongs_to :player_round
  
  attr_accessible :player_round_id
  
end
