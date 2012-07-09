class Card < ActiveRecord::Base
  
  attr_accessible :suit, :value, :card_owner_type, :card_owner_id, :card_owner
  
  belongs_to :card_owner, :polymorphic => true
  
end
