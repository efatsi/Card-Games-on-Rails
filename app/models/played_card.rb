class PlayedCard < ActiveRecord::Base
  
  attr_accessible :player_card_id, :trick_id, :position
  
  belongs_to :player_card
  belongs_to :trick
  
  validates_presence_of :player_card_id
  validates_presence_of :trick_id  
  
end
