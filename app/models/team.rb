class Team < ActiveRecord::Base
  
  attr_accessible :bags, :bid, :round_score, :total_score, :tricks_won
  
  has_many :players, :class_name => "Users"
  belongs_to :game
  
  before_destroy
  
end
