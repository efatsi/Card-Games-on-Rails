class Game < ActiveRecord::Base
  
  attr_accessible :size, :winner_id, :room_id

  after_create :destroy_and_load_new_deck
  before_destroy :clear_users_game_ids

  belongs_to :room
  has_many :decks, :dependent => :destroy
  has_many :players, :class_name => "User"
  has_many :teams, :dependent => :destroy
  has_many :rounds, :dependent => :destroy
  
  def pick_random_player
    players[rand(players.length)]
  end
  
  def game_over?
    winner.present?
  end
  
  def reset_for_new_game
    winner_id = nil
    destroy_and_load_new_deck
    players.each {|p| p.reset_for_new_game }
  end  

  
  private
  def clear_users_game_ids
    self.users.each {|user| update_attributes(:game_id => nil) }
  end
  
  def destroy_and_load_new_deck
    decks.delete_all
    Deck.create(:game_id => self.id)
  end
  
  def deck
    self.decks.first.cards
  end
  
  def winner
    User.find(winner_id) if winner_id.present?
  end

  def get_dealer_id
    rounds_played == 0 ? players.first : last_round.new_dealer_id
  end
  
  def rounds_played
    rounds.length
  end
  
  def last_round
    rounds.last
  end
    


end
