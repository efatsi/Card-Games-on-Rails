class Team < ActiveRecord::Base
  
  attr_accessible :bags, :bid, :round_score, :total_score, :game_id
  
  has_many :players, :class_name => "User"
  belongs_to :game
  
  before_destroy
  
  def tricks_won
    total_won = 0
    players.each do |player|
      total_won += player.tricks_won
    end
    total_won
  end
  
end
