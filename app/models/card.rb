class Card < ActiveRecord::Base

  attr_accessible :suit, :value

  has_many :player_cards, :dependent => :destroy
    
  
end
