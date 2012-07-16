class Game < ActiveRecord::Base
  
  attr_accessible :size, :winner_id, :room_id

  after_create :destroy_and_load_new_deck
  before_destroy :clear_players_game_ids

  belongs_to :room
  has_many :decks, :dependent => :destroy
  has_many :players, :class_name => "User"
  has_many :teams, :dependent => :destroy
  has_many :rounds, :dependent => :destroy
  
  def game_over?
    winner.present?
  end
  
  def reset_for_new_game
    self.update_attributes(:winner_id => nil)
    destroy_and_load_new_deck
    players.each {|p| p.reset_for_new_game }
  end  

  def clear_players_game_ids
    self.players.each {|p| p.game_id = nil; p.save }
  end
  
  def destroy_and_load_new_deck
    self.decks.delete_all
    Deck.create(:game_id => self.id)
  end
  
  def deck
    self.decks.last
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
