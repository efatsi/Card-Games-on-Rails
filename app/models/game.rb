class Game < ActiveRecord::Base
  
  attr_accessible :size, :winner_id

  has_many :players, :dependent => :destroy
  has_many :rounds, :dependent => :destroy


  def game_over?
    winner_id.present?
  end
  
  def seated_at(seat)
    self.players.where("seat = ?", seat).first
  end
  
end
