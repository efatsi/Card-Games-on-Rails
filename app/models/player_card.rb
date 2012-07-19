class PlayerCard < ActiveRecord::Base
  
  attr_accessible :player_id, :card_id
  
  belongs_to :player
  belongs_to :card
  has_one :played_card, :dependent => :destroy
  
  validates_presence_of :player_id
  validates_presence_of :card_id
  
  delegate :suit, :value, :in_english, :to => :card
  
  
  def is_valid?(lead_suit)
    player.has_none_of?(lead_suit) || suit == lead_suit
  end
  
end
