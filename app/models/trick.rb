class Trick < ActiveRecord::Base
  
  attr_accessible :round_id, :leader_id, :winner_id, :lead_suit, :position
  
  belongs_to :round
  has_many :played_cards, :dependent => :destroy
  
  validates_presence_of :round_id
  validates_presence_of :leader_id
  
end
