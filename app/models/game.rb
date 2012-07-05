class Game < ActiveRecord::Base
  
  attr_accessible :size, :winner_id, :room_id

  after_create :load_deck
  before_destroy :clear_users_game_ids


  belongs_to :room
  has_many :decks, :dependent => :destroy
  has_many :players, :class_name => "User"
  has_many :teams, :dependent => :destroy
  has_many :rounds, :dependent => :destroy
  
  def deck
    self.decks.first.cards
  end
  
  def pick_random_player
    players[rand(players.length)]
  end
  
  def game_over?
    winner.present?
  end
  
  def reset
    @winner = nil
    @players = []
    @deck = []
  end
  
  def load_deck
    Deck.create(:game_id => self.id)
  end
  
  def determine_trick_winner(trick)
    max = trick.first
    leader_index = @players.index(@leader)
    4.times do |i|
      card = trick[(leader_index+i)%4]
      max = card if card.beats?(max)
    end
    @players[trick.index(max)] 
  end
  
  
  private
  def clear_users_game_ids
    self.users.each {|user| update_attributes(:game_id => nil)}
  end
  
  def winner
    User.find(winner_id) if winner_id.present?
  end

end
