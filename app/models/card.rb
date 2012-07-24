class Card < ActiveRecord::Base
  
  VALUE_WEIGHT = Hash[%w(2 3 4 5 6 7 8 9 10 J Q K A).zip((1..13).to_a)]
  SUIT_WEIGHT = Hash[%w(club diamond spade heart).zip((0..3).to_a)]
  
  attr_accessible :suit, :value

  has_many :player_cards, :dependent => :destroy
  
  validates_presence_of :suit
  validates_presence_of :value
  
  def beats?(current_winner)
    suit == current_winner.suit && value_weight > current_winner.value_weight
  end
  
  def value_weight
    VALUE_WEIGHT[value]
  end
  
  def in_english
    value.to_s + " of " + suit.to_s.pluralize
  end
  
end
