class Card < ActiveRecord::Base
  
  attr_accessible :suit, :value, :deck_id
  
  belongs_to :deck
  
end
