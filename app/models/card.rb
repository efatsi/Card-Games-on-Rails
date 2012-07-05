class Card < ActiveRecord::Base
  
  attr_accessible :suit, :value, :deck_id, :card_owner_type, :card_owner_id
  
  belongs_to :card_owner, :polymorphic => true
  
end
