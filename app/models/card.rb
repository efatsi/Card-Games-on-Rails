class Card < ActiveRecord::Base
  
  attr_accessible :suit, :value

  has_many :player_cards, :dependent => :destroy
  
  validates_presence_of :suit
  validates_presence_of :value
  
  POINT_VALUE = Hash[%w(1 2 3 4 5 6 7 8 9 10 J Q K A).zip((1..14).to_a)]
  
  def beats?(current_winner)
    suit == current_winner.suit && point_value > current_winner.point_value
  end
  
  def point_value
    POINT_VALUE[value]
  end
  
  def in_english
    value.to_s + " of " + suit.to_s.pluralize
  end
    
  
end
