class PlayedCard < ActiveRecord::Base
  
  attr_accessible :player_card_id, :trick_id, :position
  
  belongs_to :player_card
  has_one :player, :through => :player_card
  has_one :card, :through => :player_card
  belongs_to :trick
  
  validates_presence_of :player_card_id
  validates_presence_of :trick_id 
  validates_presence_of :position 
  
  delegate :suit, :value, :is_a_heart, :is_queen_of_spades, :beats?, :value_weight, :in_english, :to => :card

  def get_position(current_player)
    (player.seat - current_player.seat) % 4
  end
  
end
