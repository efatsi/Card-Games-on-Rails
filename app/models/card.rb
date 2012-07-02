class Card < ActiveRecord::Base
  
  attr_accessible :suit, :value
  
  belongs_to :deck
  
end
