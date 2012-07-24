class PlayerCard < ActiveRecord::Base
  
  SUIT_WEIGHT = Card::SUIT_WEIGHT
  VALUE_WEIGHT = Card::VALUE_WEIGHT
  
  attr_accessible :player_id, :card_id
  
  belongs_to :player
  belongs_to :card
  has_one :played_card, :dependent => :destroy
  
  validates_presence_of :player_id
  validates_presence_of :card_id
  
  delegate :suit, :value, :in_english, :to => :card
  delegate :hearts_broken, :to => :player
  
  
  def is_valid?(lead_suit)
    if player.is_leading?
      self.is_valid_lead?
    else
      suit == lead_suit || player.has_none_of?(lead_suit)
    end
  end
  
  def is_valid_lead?
    if suit == "heart"
      hearts_broken || player.only_has?("heart")
    else
      true
    end
  end
  
  def is_not_chosen?
    card_passing_set_id.nil?
  end
  
  def has_been_chosen?
    card_passing_set_id.present?
  end
  
  def can_be_chosen?
    is_not_chosen? &&  player.cards_to_pass.length != 3
  end
  
  def hand_order
    suit_order = SUIT_WEIGHT[suit]
    value_order = VALUE_WEIGHT[value]
    suit_order*13 + value_order    
  end
end
