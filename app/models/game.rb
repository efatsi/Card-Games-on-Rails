class Game < ActiveRecord::Base
  
  attr_accessible :size, :winner_id, :room_id

  before_destroy :clear_players_game_ids

  belongs_to :room
  has_many :players, :class_name => "User"
  has_many :teams, :dependent => :destroy
  has_many :rounds, :dependent => :destroy
  
  def game_over?
    winner.present?
  end

  def clear_players_game_ids
    self.players.each {|p| p.game_id = nil; p.save }
  end
  
  def winner
    User.find(winner_id) if winner_id.present?
  end

  def get_dealer_seat
    rounds_played == 0 ? 0 : last_round.new_dealer_seat
  end
  
  def rounds_played
    rounds.length
  end
  
  def last_round
    rounds.last
  end
  
  def seated_at(seat)
    User.where("game_id = ? and seat = ?", self.id, seat).first
  end
  
  def next_seat
    self.players(true).length
  end

end
