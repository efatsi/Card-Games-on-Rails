class PlayerRound < ActiveRecord::Base
  
  attr_accessible :player_id, :round_id, :round_score
  
  belongs_to :player
  belongs_to :round
  
  validates_presence_of :player_id
  validates_presence_of :round_id
  validates_presence_of :round_score
  
  delegate :hearts_broken, :to => :round
  delegate :leader, :to => :round
  
end
