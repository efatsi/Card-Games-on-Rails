class PlayerCard < ActiveRecord::Base
  
  attr_accessible :player_id, :card_id
  
  belongs_to :player
  belongs_to :card
  has_one :played_card, :dependent => :destroy
  
  validates_presence_of :player_id
  validates_presence_of :card_id
  
  delegate :suit, :value, :to => :card
  
end
