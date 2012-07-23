class CardsToPass < ActiveRecord::Base
  attr_accessible :card1_id, :card2_id, :card3_id, :from_player_id, :round_id, :to_player_id
end
