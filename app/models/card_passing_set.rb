class CardPassingSet < ActiveRecord::Base
  
  has_many :player_cards
  belongs_to :player_round
  has_one :player, :through => :player_round
  
  attr_accessible :player_round_id
  
end
