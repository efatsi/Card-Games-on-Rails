class PlayedCard < ActiveRecord::Base
  
  attr_accessible :player_card_id, :trick_id, :position
  
  belongs_to :player_card
  has_one :player, :through => :player_card
  has_one :card, :through => :player_card
  belongs_to :trick
  
  validates_presence_of :player_card_id
  validates_presence_of :trick_id 
  validates_presence_of :position 
  
  delegate :suit, :value, :to => :player_card
  delegate :beats?, :point_value, :to => :card
  
  
  def is_a_heart
    suit == "heart"
  end
  
  def is_queen_of_spades
    value == "Q" && suit == "spade"
  end
  
end
