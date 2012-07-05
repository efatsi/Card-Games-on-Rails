class Team < ActiveRecord::Base
  
  attr_accessible :bags, :bid, :round_score, :total_score, :game_id
  
  has_many :players, :class_name => "User"
  belongs_to :game
  
  before_destroy
  
end
